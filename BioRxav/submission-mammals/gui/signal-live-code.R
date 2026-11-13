# Guane phylogenetic signal: open in RStudio and Source.
# Prepared inputs and plotting functions are embedded. Edit plot_settings below.
# Install once if needed: install.packages(c("ape", "phytools"))
# R 4.6.0; ape 5.8.1; phytools 2.5.2
guane_task_setting <- function (option, env, default, lower = -Inf, upper = Inf) 
{
    value <- getOption(option)
    if (is.null(value)) {
        value <- Sys.getenv(env, "")
        if (!nzchar(value)) 
            return(default)
    }
    if (is.logical(default)) {
        if (is.logical(value) && length(value) == 1 && !is.na(value)) 
            return(value)
        key <- tolower(trimws(as.character(value)[1]))
        if (key %in% c("true", "t", "yes", "y", "1", "on")) 
            return(TRUE)
        if (key %in% c("false", "f", "no", "n", "0", "off")) 
            return(FALSE)
        message("Guane: ignoring invalid value for ", env, "; using ", 
            default, ".")
        return(default)
    }
    number <- suppressWarnings(as.numeric(value)[1])
    if (!is.finite(number)) {
        message("Guane: ignoring invalid value for ", env, "; using ", 
            default, ".")
        return(default)
    }
    min(max(number, lower), upper)
}
guane_limits <- function () 
{
    list(tips = guane_task_setting("guane.max_tips", "GUANE_MAX_TIPS", 
        5000, 4, 1e+06), rows = guane_task_setting("guane.max_rows", 
        "GUANE_MAX_ROWS", 50000, 4, 1e+07), columns = guane_task_setting("guane.max_columns", 
        "GUANE_MAX_COLUMNS", 500, 2, 1e+05))
}
guane_validate <- function (tree, traits, taxon, trait) 
{
    issues <- data.frame(level = character(), message = character())
    add <- function(level, message) issues[nrow(issues) + 1L, 
        ] <<- c(level, message)
    if (is.null(tree)) 
        add("Required", "Load a phylogenetic tree.")
    if (is.null(traits)) 
        add("Required", "Load a CSV trait table.")
    if (!is.null(tree)) {
        if (length(tree$tip.label) > guane_limits()$tips) 
            add("Error", "This tree exceeds the maximum number of tips supported on this server. Run the exported R script locally for larger trees.")
        if (anyDuplicated(tree$tip.label)) 
            add("Error", "Tree tip labels must be unique.")
        if (anyNA(tree$tip.label) || any(!nzchar(trimws(tree$tip.label)))) 
            add("Error", "Tree contains empty taxon labels.")
        if (is.null(tree$edge.length) || any(!is.finite(tree$edge.length)) || 
            any(tree$edge.length <= 0)) 
            add("Error", "Signal analysis requires finite, positive branch lengths.")
        if (!ape::is.rooted(tree)) 
            add("Error", "Root the tree before signal analysis.")
        if (!ape::is.binary(tree)) 
            add("Warning", "Tree contains polytomies; inspect their biological meaning.")
        if (!is.null(tree$edge.length) && !ape::is.ultrametric(tree)) 
            add("Note", "Tree is not ultrametric. Signal analysis can use it; verify branch-length units.")
    }
    if (!is.null(traits)) {
        if (is.null(taxon) || !taxon %in% names(traits)) 
            add("Required", "Select the taxon column.")
        else {
            ids <- as.character(traits[[taxon]])
            if (anyNA(ids) || any(!nzchar(trimws(ids)))) 
                add("Error", "Trait table contains empty taxon labels.")
            if (anyDuplicated(ids)) 
                add("Error", "Trait taxon labels must be unique.")
            if (!is.null(tree) && !setequal(ids, tree$tip.label)) 
                add("Error", paste0("Taxon mismatch: ", length(setdiff(tree$tip.label, 
                  ids)), " tree tips without traits; ", length(setdiff(ids, 
                  tree$tip.label)), " table taxa outside tree. Use matched taxa only after reviewing this report."))
        }
        if (is.null(trait) || !trait %in% names(traits)) 
            add("Required", "Select a numeric trait.")
        else {
            x <- traits[[trait]]
            if (!is.numeric(x) || any(!is.finite(x))) 
                add("Error", "Selected trait must contain only finite numeric values; correct missing values before running.")
            else if (length(unique(x)) < 2) 
                add("Error", "Selected trait has no variation.")
        }
    }
    if (!is.null(tree) && length(tree$tip.label) < 4) 
        add("Error", "At least four matched taxa are required.")
    issues
}
guane_signal <- function (tree, traits, taxon, trait, seed = 999, nsim = 999) 
{
    if (length(nsim) != 1 || !is.finite(nsim) || nsim < 99 || 
        nsim > 9999 || nsim != floor(nsim)) 
        stop("Choose 99–9999 integer randomizations.")
    if (length(seed) != 1 || !is.finite(seed) || seed < 0 || 
        seed > 2147483647 || seed != floor(seed)) 
        stop("Choose a nonnegative integer seed up to 2147483647.")
    issues <- guane_validate(tree, traits, taxon, trait)
    if (any(issues$level %in% c("Error", "Required"))) 
        stop("Resolve data issues before running.")
    x <- setNames(traits[[trait]], as.character(traits[[taxon]]))[tree$tip.label]
    had <- exists(".Random.seed", envir = .GlobalEnv, inherits = FALSE)
    oldkind <- RNGkind()
    if (had) 
        oldseed <- get(".Random.seed", envir = .GlobalEnv)
    on.exit({
        do.call(RNGkind, as.list(oldkind))
        if (had) assign(".Random.seed", oldseed, envir = .GlobalEnv) else if (exists(".Random.seed", 
            envir = .GlobalEnv, inherits = FALSE)) rm(".Random.seed", 
            envir = .GlobalEnv)
    }, add = TRUE)
    set.seed(seed, kind = "Mersenne-Twister", normal.kind = "Inversion", 
        sample.kind = "Rejection")
    k <- phytools::phylosig(tree, x, method = "K", test = TRUE, 
        nsim = nsim)
    lambda <- phytools::phylosig(tree, x, method = "lambda", 
        test = TRUE)
    if (any(!is.finite(c(k$K, k$P, lambda$lambda, lambda$P, lambda$logL, 
        lambda$logL0)))) 
        stop("Signal analysis returned nonfinite estimates. Inspect the inputs.")
    answer <- data.frame(Metric = c("Blomberg's K", "Pagel's lambda"), 
        Estimate = c(k$K, lambda$lambda), P_value = c(k$P, lambda$P), 
        Test = c(paste(nsim, "test draws (including observed)"), 
            "Likelihood ratio: lambda = 0"))
    attr(answer, "snapshot") <- list(tree = tree, traits = traits[match(tree$tip.label, 
        as.character(traits[[taxon]])), c(taxon, trait), drop = FALSE], 
        taxon = taxon, trait = trait, seed = seed, nsim = nsim, 
        x = x)
    attr(answer, "randomized_K") <- k$sim.K[-1]
    answer
}
guane_text <- function (text, lang = "en") 
{
    i <- match(lang, c("es", "pt"))
    if (length(i) != 1 || is.na(i) || !is.character(text) || 
        length(text) != 1) 
        return(text)
    entry <- guane_dictionary()[[text]]
    if (is.null(entry)) 
        text
    else entry[[i]]
}
guane_signal_plot <- function (result, type = "tree", palette = "Guane", font = 0.8, 
    lang = "en") 
{
    snapshot <- attr(result, "snapshot")
    x <- snapshot$x
    tree <- snapshot$tree
    colors <- (grDevices::colorRampPalette(if (palette == "Grayscale") 
        c("#eeeeee", "#222222")
    else c("#e4f1cf", "#54a37a", "#0d5368")))(256)
    old <- graphics::par(no.readonly = TRUE)
    on.exit(graphics::par(old))
    if (type == "null") {
        values <- attr(result, "randomized_K")
        graphics::par(mar = c(5, 5, 3, 1))
        graphics::hist(values, breaks = "FD", xlim = range(c(values, 
            result$Estimate[1])), main = guane_text("Randomized K values", 
            lang), xlab = "Blomberg's K", ylab = guane_text("Frequency", 
            lang), col = colors[150], border = "white")
        graphics::abline(v = result$Estimate[1], lwd = 2, lty = 2, 
            col = colors[256])
        graphics::legend("topright", legend = paste(guane_text("Observed K", 
            lang), formatC(result$Estimate[1], digits = 4, format = "fg")), 
            lty = 2, lwd = 2, col = colors[256], bty = "n")
    }
    else {
        limits <- range(x)
        indices <- pmax(1, pmin(256, 1 + floor((x - limits[1])/diff(limits) * 
            255)))
        reserve <- max(3, length(x) * 0.15)
        graphics::par(mar = c(1, 1, 2, 1))
        ape::plot.phylo(tree, tip.color = "#345747", cex = font, 
            edge.color = "#607369", edge.width = 1.5, no.margin = FALSE, 
            y.lim = c(-reserve, length(x) + 1), label.offset = max(ape::node.depth.edgelength(tree)) * 
                0.02)
        ape::tiplabels(pch = 21, bg = colors[indices], col = "#345747", 
            cex = 1)
        graphics::title(main = guane_text("Observed tip values", 
            lang), cex.main = 1)
        bounds <- graphics::par("usr")[1:2]
        width <- diff(bounds)
        positions <- seq(bounds[1] + width * 0.08, bounds[2] - 
            width * 0.08, length.out = 257)
        graphics::rect(positions[-257], -reserve * 0.35, positions[-1], 
            -reserve * 0.15, col = colors, border = NA)
        anchors <- seq(1, 257, length.out = 5)
        graphics::text(positions[anchors], -reserve * 0.53, labels = format(signif(seq(limits[1], 
            limits[2], length.out = 5), 3)), cex = 0.8)
        graphics::text(mean(positions), -reserve * 0.83, labels = snapshot$trait, 
            cex = 0.85)
    }
    invisible(x)
}
inputs <- structure(list(structure(list(structure(c(50L, 51L, 52L, 53L, 
54L, 55L, 55L, 54L, 53L, 56L, 57L, 57L, 56L, 58L, 58L, 52L, 59L, 
60L, 61L, 62L, 63L, 63L, 62L, 61L, 60L, 59L, 51L, 64L, 65L, 65L, 
64L, 66L, 66L, 67L, 67L, 68L, 68L, 50L, 69L, 70L, 71L, 71L, 72L, 
72L, 70L, 73L, 73L, 74L, 74L, 69L, 75L, 76L, 76L, 75L, 77L, 77L, 
78L, 79L, 80L, 81L, 81L, 80L, 79L, 82L, 83L, 84L, 85L, 85L, 84L, 
83L, 82L, 86L, 87L, 87L, 86L, 88L, 88L, 89L, 89L, 90L, 90L, 91L, 
91L, 78L, 92L, 92L, 93L, 94L, 94L, 93L, 95L, 95L, 96L, 96L, 97L, 
97L, 51L, 52L, 53L, 54L, 55L, 1L, 2L, 3L, 56L, 57L, 4L, 5L, 58L, 
6L, 7L, 59L, 60L, 61L, 62L, 63L, 8L, 9L, 10L, 11L, 12L, 13L, 
64L, 65L, 14L, 15L, 66L, 16L, 67L, 17L, 68L, 18L, 19L, 69L, 70L, 
71L, 20L, 72L, 21L, 22L, 73L, 23L, 74L, 24L, 25L, 75L, 76L, 26L, 
27L, 77L, 28L, 78L, 79L, 80L, 81L, 29L, 30L, 31L, 82L, 83L, 84L, 
85L, 32L, 33L, 34L, 35L, 86L, 87L, 36L, 37L, 88L, 38L, 89L, 39L, 
90L, 40L, 91L, 41L, 42L, 92L, 43L, 93L, 94L, 44L, 45L, 95L, 46L, 
96L, 47L, 97L, 48L, 49L), dim = c(96L, 2L)), c(0x1.8p+3, 0x1.8p+2, 
0x1p+3, 0x1.38p+5, 0x1.8p+1, 0x1p+1, 0x1p+1, 0x1.4p+2, 0x1.ap+3, 
0x1.ap+4, 0x1.4p+2, 0x1.4p+2, 0x1.6p+3, 0x1.4p+4, 0x1.4p+4, 0x1.54p+5, 
0x1p-1, 0x1.8p+1, 0x1.8p+1, 0x1p-1, 0x1.4p+1, 0x1.4p+1, 0x1.8p+1, 
0x1.8p+2, 0x1.2p+3, 0x1.3p+3, 0x1p+5, 0x1.5p+4, 0x1.4p+2, 0x1.4p+2, 
0x1.1p+4, 0x1.2p+3, 0x1.ap+2, 0x1.4p+1, 0x1p-1, 0x1p+1, 0x1p+1, 
0x1p+2, 0x1.4p+3, 0x1.8p+2, 0x1.9p+5, 0x1.28p+5, 0x1.ap+3, 0x1.ap+3, 
0x1.88p+5, 0x1.cp+2, 0x1p+0, 0x1.8p+2, 0x1.8p+2, 0x1.7p+4, 0x1.98p+4, 
0x1.18p+4, 0x1.18p+4, 0x1.68p+4, 0x1.48p+4, 0x1p-1, 0x1p-1, 0x1p-1, 
0x1.2p+3, 0x1.4p+3, 0x1.4p+3, 0x1.3p+4, 0x1.cp+1, 0x1.4p+2, 0x1p+2, 
0x1.2p+2, 0x1.4p+1, 0x1.4p+1, 0x1.cp+2, 0x1.6p+3, 0x1p-1, 0x1.7p+3, 
0x1p+2, 0x1p+2, 0x1.ap+2, 0x1.2p+3, 0x1.4p+1, 0x1.ap+2, 0x1p+0, 
0x1.6p+2, 0x1p+1, 0x1.cp+1, 0x1.cp+1, 0x1p-1, 0x1.38p+4, 0x1.1p+3, 
0x1.cp+2, 0x1p+2, 0x1p+2, 0x1.6p+2, 0x1.6p+2, 0x1p-1, 0x1.4p+2, 
0x1p+2, 0x1p+0, 0x1p+0), 48L, c("U._maritimus", "U._arctos", 
"U._americanus", "N._narica", "P._lotor", "M._mephitis", "M._meles", 
"C._lupus", "C._latrans", "L._pictus", "C._aureus", "U._cinereoargenteus", 
"V._fulva", "H._hyaena", "C._crocuta", "A._jubatus", "P._pardus", 
"P._tigris", "P._leo", "T._bairdii", "C._simum", "D._bicornis", 
"E._hemionus", "E._caballus", "E._burchelli", "L._guanicoe", 
"C._dromedarius", "G._camelopardalis", "S._caffer", "B._bison", 
"T._oryx", "G._granti", "G._thomsonii", "A._cervicapra", "M._kirki", 
"O._americanus", "O._canadensis", "H._equinus", "A._melampus", 
"C._taurinus", "D._lunatus", "A._buselaphus", "A._americana", 
"C._canadensis", "D._dama", "A._alces", "R._tarandus", "O._virginianus", 
"O._hemionus"), 0x0p+0), names = c("edge", "edge.length", "Nnode", 
"tip.label", "root.edge"), class = "phylo", order = "cladewise"), 
    structure(list(c("U._maritimus", "U._arctos", "U._americanus", 
    "N._narica", "P._lotor", "M._mephitis", "M._meles", "C._lupus", 
    "C._latrans", "L._pictus", "C._aureus", "U._cinereoargenteus", 
    "V._fulva", "H._hyaena", "C._crocuta", "A._jubatus", "P._pardus", 
    "P._tigris", "P._leo", "T._bairdii", "C._simum", "D._bicornis", 
    "E._hemionus", "E._caballus", "E._burchelli", "L._guanicoe", 
    "C._dromedarius", "G._camelopardalis", "S._caffer", "B._bison", 
    "T._oryx", "G._granti", "G._thomsonii", "A._cervicapra", 
    "M._kirki", "O._americanus", "O._canadensis", "H._equinus", 
    "A._melampus", "C._taurinus", "D._lunatus", "A._buselaphus", 
    "A._americana", "C._canadensis", "D._dama", "A._alces", "R._tarandus", 
    "O._virginianus", "O._hemionus"), c(0x1.30023a3de636ep+2, 
    0x1.1aa6c1e2b8c1cp+2, 0x1.0287c35f41b2ep+2, 0x1.8fb063ef2c7e9p-5, 
    0x1.0c588baf19025p-3, 0x1.d5240f0e0e077p-1, -0x1.1d356e1eac128p-3, 
    0x1.53fb6abd1a256p+2, 0x1.e740b76b30efbp+1, 0x1.44cfa5d62844dp+2, 
    0x1.1aa8bc695645dp+1, 0x1.8663f793c46c9p-4, 0x1.5a6ee32ae89dfp+0, 
    0x1.41dd438e45d9cp+2, 0x1.9c041f8090a12p+1, 0x1.083d5fd07a50bp+2, 
    0x1.927394f6323ebp+1, 0x1.0f89746556afdp+2, 0x1.5daf6b985b7f4p+2, 
    0x1.62e42fefa39ecp-1, 0x1.e5059c353f981p+0, 0x1.5fa692c39cf3dp+1, 
    0x1.c715a52f28041p+1, 0x1.8e87ab6d5f5c9p+1, 0x1.46c7cf85bd63ap+2, 
    -0x1.62e42fefa39ecp-1, 0x1.26bb1bbb55514p+2, 0x1.1c071d7218eb2p+2, 
    0x1.3b581fd66eefep+2, 0x1.38fb7ae8ef028p+2, 0x1.1e2f547a415f3p+2, 
    0x1.7f7427b963fa7p+1, 0x1.aaeed58d9cf3cp+0, 0x1.df2e6d6db6942p+0, 
    -0x1.92c251d0b1325p+1, 0x1.8ff1c02cd9c86p+1, 0x1.54c80e7985228p+1, 
    0x1.18731fd788043p+2, 0x1.55c2a141bd925p+0, 0x1.1451b9aa2075cp+2, 
    0x1.93b0aee21c2c7p-1, 0x1.9c041f7ed8d32p+0, 0x1.26bb1bbb5551fp+1, 
    0x1.479f57393d076p+1, 0x1.0ca937be1b9dbp-2, 0x1.63b0599358c0cp+1, 
    0x1.b35a6f922bea6p+1, 0x1.588c2d9133491p-1, 0x1.0c1d18fcea245p+0
    )), names = c("taxon", "ln_home_range_km2"), row.names = c(NA, 
    49L), class = "data.frame"), "taxon", "ln_home_range_km2", 
    20261201L, 999L), names = c("tree", "traits", "taxon", "trait", 
"seed", "nsim"))
result <- do.call(guane_signal, inputs)
print(result)
plot_settings <- structure(list("tree", "Guane", 0x1.999999999999ap-1, "en"), names = c("type", 
"palette", "font", "lang"))
figure_height <- 0x1.cp+2
do.call(guane_signal_plot, c(list(result=result), plot_settings))
# Optional PDF using the same settings:
# pdf("guane-signal.pdf", width=9, height=figure_height)
# do.call(guane_signal_plot, c(list(result=result), plot_settings)); dev.off()
sessionInfo()