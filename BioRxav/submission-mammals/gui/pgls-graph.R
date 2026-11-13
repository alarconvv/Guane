# Guane PGLS: self-contained analysis and editable base R graphics.
# Open in RStudio and Source. Edit plot_type, plot_color, show_taxa and plot_text below.
# These are prepared species-level inputs; no PIC or additional covariance correction is applied.
# Install once if needed: install.packages(c("ape", "nlme"))
# Export environment: R 4.6.0; ape 5.8.1; nlme 3.1.171
guane_pgls <- function (tree, traits, taxon, response, predictors, model = "BM", 
    value = 0.5, fixed = FALSE, method = "REML") 
{
    if (!inherits(tree, "phylo") || !ape::is.rooted(tree) || 
        !ape::is.binary(tree)) 
        stop("PGLS requires a rooted, bifurcating tree.")
    if (is.null(tree$edge.length) || any(!is.finite(tree$edge.length)) || 
        any(tree$edge.length <= 0)) 
        stop("PGLS requires finite, positive branch lengths.")
    if (!ape::is.ultrametric(tree)) 
        stop("This PGLS implementation requires an ultrametric tree.")
    if (!is.data.frame(traits) || anyDuplicated(names(traits)) || 
        length(taxon) != 1 || !taxon %in% names(traits)) 
        stop("Select a unique taxon column in the trait table.")
    ids <- as.character(traits[[taxon]])
    if (anyNA(ids) || any(!nzchar(trimws(ids))) || anyDuplicated(ids) || 
        anyNA(tree$tip.label) || anyDuplicated(tree$tip.label) || 
        !setequal(ids, tree$tip.label)) 
        stop("Match unique, nonempty taxon labels explicitly in Data before PGLS.")
    if (length(response) != 1 || !length(predictors) || anyDuplicated(predictors) || 
        response %in% predictors || taxon %in% c(response, predictors) || 
        !all(c(response, predictors) %in% names(traits))) 
        stop("Select a response and distinct numeric predictors.")
    traits <- traits[match(tree$tip.label, ids), , drop = FALSE]
    columns <- traits[c(response, predictors)]
    if (!all(vapply(columns, function(x) is.numeric(x) && all(is.finite(x)) && 
        length(unique(x)) > 1, logical(1)))) 
        stop("PGLS variables must be finite, numeric and nonconstant. No rows are removed automatically.")
    if (nrow(traits) < 4 || nrow(traits) <= length(predictors) + 
        2) 
        stop("PGLS needs at least four taxa and at least two residual degrees of freedom.")
    model <- match.arg(model, c("BM", "Grafen", "Pagel", "Blomberg"))
    method <- match.arg(method, c("ML", "REML"))
    if (length(value) != 1 || !is.finite(value) || (model == 
        "Pagel" && (value < 0 || value > 1)) || (model %in% c("Grafen", 
        "Blomberg") && value <= 0)) 
        stop("Use lambda between 0 and 1, or a positive rho or g.")
    frame <- data.frame(.taxon = tree$tip.label, .response = traits[[response]])
    for (i in seq_along(predictors)) frame[[paste0(".x", i)]] <- traits[[predictors[i]]]
    formula <- stats::reformulate(paste0(".x", seq_along(predictors)), 
        response = ".response")
    design <- stats::model.matrix(formula, frame)
    if (qr(design)$rank < ncol(design)) 
        stop("Predictors are collinear. Choose an independent set of predictors.")
    correlation <- switch(model, BM = ape::corBrownian(phy = tree, 
        form = ~.taxon), Grafen = ape::corGrafen(value, phy = tree, 
        form = ~.taxon, fixed = fixed), Pagel = ape::corPagel(value, 
        phy = tree, form = ~.taxon, fixed = fixed), Blomberg = ape::corBlomberg(value, 
        phy = tree, form = ~.taxon, fixed = fixed))
    warnings <- character()
    fit <- withCallingHandlers(nlme::gls(formula, data = frame, 
        correlation = correlation, method = method, na.action = stats::na.fail), 
        warning = function(w) {
            warnings <<- c(warnings, conditionMessage(w))
            invokeRestart("muffleWarning")
        })
    if (!is.finite(as.numeric(stats::logLik(fit))) || !is.finite(fit$sigma) || 
        fit$sigma <= 0 || any(!is.finite(stats::coef(fit)))) 
        stop("PGLS returned an invalid fit; inspect inputs and correlation settings.")
    parameter <- stats::coef(fit$modelStruct$corStruct, unconstrained = FALSE)
    if (model == "Pagel" && (parameter < 0 || parameter > 1)) 
        stop("Estimated lambda is outside the supported interval [0, 1]. Try a fixed value or another structure.")
    if (is.character(fit$apVar)) 
        warnings <- c(warnings, fit$apVar)
    tab <- summary(fit)$tTable
    interval <- stats::qt(0.975, nrow(frame) - ncol(design)) * 
        tab[, "Std.Error"]
    coefficients <- data.frame(Term = c("(Intercept)", predictors), 
        Estimate = tab[, "Value"], SE = tab[, "Std.Error"], Lower = tab[, 
            "Value"] - interval, Upper = tab[, "Value"] + interval, 
        P = tab[, "p-value"], row.names = NULL)
    points <- data.frame(Taxon = frame$.taxon, Observed = frame$.response, 
        Fitted = as.numeric(stats::fitted(fit)), Residual = as.numeric(stats::residuals(fit, 
            type = "normalized")))
    list(fit = fit, tree = tree, traits = traits, taxon = taxon, 
        response = response, predictors = predictors, model = model, 
        value = value, fixed = fixed, method = method, parameter = parameter, 
        coefficients = coefficients, points = points, warnings = unique(warnings))
}
guane_pgls_plot <- function (result, type = "fit", color = "#34765b", labels = FALSE, 
    text = list(fitted = "Fitted values", observed = "Observed values", 
        estimate = "Coefficient estimate", interval = "95% coefficient intervals", 
        residual = "Normalized residuals", quantiles = "Theoretical quantiles")) 
{
    old <- graphics::par(no.readonly = TRUE)
    on.exit(graphics::par(old))
    d <- result$points
    if (type == "coefficients") {
        z <- result$coefficients
        y <- rev(seq_len(nrow(z)))
        graphics::par(mar = c(5, min(18, max(5, max(nchar(z$Term)) * 
            0.45)), 3, 1))
        graphics::plot(z$Estimate, y, xlim = range(c(z$Lower, 
            z$Upper, 0)), ylim = c(0.5, nrow(z) + 0.5), yaxt = "n", 
            ylab = "", xlab = text$estimate, main = text$interval, 
            pch = 19, col = color)
        graphics::axis(2, at = y, labels = z$Term, las = 1, cex.axis = 0.85)
        graphics::abline(v = 0, lty = 2, col = "grey65")
        graphics::segments(z$Lower, y, z$Upper, y, col = color, 
            lwd = 2)
    }
    else if (type == "diagnostics") {
        graphics::par(mfrow = c(1, 2), mar = c(5, 5, 2, 1))
        graphics::plot(d$Fitted, d$Residual, xlab = text$fitted, 
            ylab = text$residual, pch = 19, col = color)
        graphics::abline(h = 0, lty = 2, col = "grey65")
        stats::qqnorm(d$Residual, main = "", xlab = text$quantiles, 
            ylab = text$residual, pch = 19, col = color)
        stats::qqline(d$Residual, col = "grey40", lty = 2)
    }
    else {
        graphics::par(mar = c(5, 5, 2, 2))
        limits <- range(c(d$Observed, d$Fitted))
        graphics::plot(d$Fitted, d$Observed, xlim = limits, ylim = limits, 
            xlab = paste(text$fitted, result$response, sep = ": "), 
            ylab = paste(text$observed, result$response, sep = ": "), 
            pch = 19, col = color)
        graphics::abline(a = 0, b = 1, lty = 2, col = "grey50")
        if (labels) 
            graphics::text(d$Fitted, d$Observed, labels = d$Taxon, 
                pos = 3, cex = 0.7, col = color)
    }
    invisible(result$points)
}
tree <- structure(list(structure(c(50L, 51L, 52L, 53L, 54L, 55L, 55L, 
54L, 53L, 56L, 57L, 57L, 56L, 58L, 58L, 52L, 59L, 60L, 61L, 62L, 
63L, 63L, 62L, 61L, 60L, 59L, 51L, 64L, 65L, 65L, 64L, 66L, 66L, 
67L, 67L, 68L, 68L, 50L, 69L, 70L, 71L, 71L, 72L, 72L, 70L, 73L, 
73L, 74L, 74L, 69L, 75L, 76L, 76L, 75L, 77L, 77L, 78L, 79L, 80L, 
81L, 81L, 80L, 79L, 82L, 83L, 84L, 85L, 85L, 84L, 83L, 82L, 86L, 
87L, 87L, 86L, 88L, 88L, 89L, 89L, 90L, 90L, 91L, 91L, 78L, 92L, 
92L, 93L, 94L, 94L, 93L, 95L, 95L, 96L, 96L, 97L, 97L, 51L, 52L, 
53L, 54L, 55L, 1L, 2L, 3L, 56L, 57L, 4L, 5L, 58L, 6L, 7L, 59L, 
60L, 61L, 62L, 63L, 8L, 9L, 10L, 11L, 12L, 13L, 64L, 65L, 14L, 
15L, 66L, 16L, 67L, 17L, 68L, 18L, 19L, 69L, 70L, 71L, 20L, 72L, 
21L, 22L, 73L, 23L, 74L, 24L, 25L, 75L, 76L, 26L, 27L, 77L, 28L, 
78L, 79L, 80L, 81L, 29L, 30L, 31L, 82L, 83L, 84L, 85L, 32L, 33L, 
34L, 35L, 86L, 87L, 36L, 37L, 88L, 38L, 89L, 39L, 90L, 40L, 91L, 
41L, 42L, 92L, 43L, 93L, 94L, 44L, 45L, 95L, 46L, 96L, 47L, 97L, 
48L, 49L), dim = c(96L, 2L)), c(0x1.8p+3, 0x1.8p+2, 0x1p+3, 0x1.38p+5, 
0x1.8p+1, 0x1p+1, 0x1p+1, 0x1.4p+2, 0x1.ap+3, 0x1.ap+4, 0x1.4p+2, 
0x1.4p+2, 0x1.6p+3, 0x1.4p+4, 0x1.4p+4, 0x1.54p+5, 0x1p-1, 0x1.8p+1, 
0x1.8p+1, 0x1p-1, 0x1.4p+1, 0x1.4p+1, 0x1.8p+1, 0x1.8p+2, 0x1.2p+3, 
0x1.3p+3, 0x1p+5, 0x1.5p+4, 0x1.4p+2, 0x1.4p+2, 0x1.1p+4, 0x1.2p+3, 
0x1.ap+2, 0x1.4p+1, 0x1p-1, 0x1p+1, 0x1p+1, 0x1p+2, 0x1.4p+3, 
0x1.8p+2, 0x1.9p+5, 0x1.28p+5, 0x1.ap+3, 0x1.ap+3, 0x1.88p+5, 
0x1.cp+2, 0x1p+0, 0x1.8p+2, 0x1.8p+2, 0x1.7p+4, 0x1.98p+4, 0x1.18p+4, 
0x1.18p+4, 0x1.68p+4, 0x1.48p+4, 0x1p-1, 0x1p-1, 0x1p-1, 0x1.2p+3, 
0x1.4p+3, 0x1.4p+3, 0x1.3p+4, 0x1.cp+1, 0x1.4p+2, 0x1p+2, 0x1.2p+2, 
0x1.4p+1, 0x1.4p+1, 0x1.cp+2, 0x1.6p+3, 0x1p-1, 0x1.7p+3, 0x1p+2, 
0x1p+2, 0x1.ap+2, 0x1.2p+3, 0x1.4p+1, 0x1.ap+2, 0x1p+0, 0x1.6p+2, 
0x1p+1, 0x1.cp+1, 0x1.cp+1, 0x1p-1, 0x1.38p+4, 0x1.1p+3, 0x1.cp+2, 
0x1p+2, 0x1p+2, 0x1.6p+2, 0x1.6p+2, 0x1p-1, 0x1.4p+2, 0x1p+2, 
0x1p+0, 0x1p+0), 48L, c("U._maritimus", "U._arctos", "U._americanus", 
"N._narica", "P._lotor", "M._mephitis", "M._meles", "C._lupus", 
"C._latrans", "L._pictus", "C._aureus", "U._cinereoargenteus", 
"V._fulva", "H._hyaena", "C._crocuta", "A._jubatus", "P._pardus", 
"P._tigris", "P._leo", "T._bairdii", "C._simum", "D._bicornis", 
"E._hemionus", "E._caballus", "E._burchelli", "L._guanicoe", 
"C._dromedarius", "G._camelopardalis", "S._caffer", "B._bison", 
"T._oryx", "G._granti", "G._thomsonii", "A._cervicapra", "M._kirki", 
"O._americanus", "O._canadensis", "H._equinus", "A._melampus", 
"C._taurinus", "D._lunatus", "A._buselaphus", "A._americana", 
"C._canadensis", "D._dama", "A._alces", "R._tarandus", "O._virginianus", 
"O._hemionus"), 0x0p+0), names = c("edge", "edge.length", "Nnode", 
"tip.label", "root.edge"), class = "phylo", order = "cladewise")
traits <- structure(list(c("U._maritimus", "U._arctos", "U._americanus", 
"N._narica", "P._lotor", "M._mephitis", "M._meles", "C._lupus", 
"C._latrans", "L._pictus", "C._aureus", "U._cinereoargenteus", 
"V._fulva", "H._hyaena", "C._crocuta", "A._jubatus", "P._pardus", 
"P._tigris", "P._leo", "T._bairdii", "C._simum", "D._bicornis", 
"E._hemionus", "E._caballus", "E._burchelli", "L._guanicoe", 
"C._dromedarius", "G._camelopardalis", "S._caffer", "B._bison", 
"T._oryx", "G._granti", "G._thomsonii", "A._cervicapra", "M._kirki", 
"O._americanus", "O._canadensis", "H._equinus", "A._melampus", 
"C._taurinus", "D._lunatus", "A._buselaphus", "A._americana", 
"C._canadensis", "D._dama", "A._alces", "R._tarandus", "O._virginianus", 
"O._hemionus"), c(0x1.09p+8, 0x1.f69999a04f964p+7, 0x1.759999963e9b4p+6, 
0x1.199999999999ap+2, 0x1.cp+2, 0x1.4p+1, 0x1.7333332dd4cf8p+3, 
0x1.1a6666625f9bap+5, 0x1.a99999999999ap+3, 0x1.400000055e63cp+4, 
0x1.1999999a230ap+3, 0x1.d99999999999ap+1, 0x1.3333333333333p+2, 
0x1.acccccccccccdp+4, 0x1.a00000055e63cp+5, 0x1.d66666650ecd8p+5, 
0x1.a333333333333p+5, 0x1.42p+7, 0x1.379999963e9b4p+7, 0x1.f4000006b5fcap+7, 
0x1.f4000008637bdp+10, 0x1.2cp+10, 0x1.90000006b5fcap+7, 0x1.5dfffffaf7828p+8, 
0x1.d5fffffca501bp+7, 0x1.7cp+6, 0x1.13p+9, 0x1.0cbffffbce421p+10, 
0x1.36p+9, 0x1.b08p+9, 0x1.fefffffca501bp+8, 0x1.f3fffff94a036p+5, 
0x1.48p+4, 0x1.2c000002af31ep+5, 0x1.4p+2, 0x1.c6000006b5fcap+6, 
0x1.54p+6, 0x1.c4fffff94a036p+7, 0x1.a9fffffea8671p+5, 0x1.affffffca501bp+7, 
0x1.03fffffca501bp+7, 0x1.0ffffffca501bp+7, 0x1.8ffffffaa19c4p+5, 
0x1.2c0000035afe5p+8, 0x1.b8p+5, 0x1.7ffffffaf7828p+8, 0x1.9p+6, 
0x1.c80000055e63cp+5, 0x1.280000035afe5p+6), c(0x1.ce66666666666p+6, 
0x1.4b333335e2651p+6, 0x1.c666666bc4ca2p+5, 0x1.0cccccccccccdp+0, 
0x1.23d70a3d70a3dp+0, 0x1.4p+1, 0x1.bd70a3dfa1436p-1, 0x1.959999a04f964p+7, 
0x1.68000002af31ep+5, 0x1.400000035afe5p+7, 0x1.2333333333333p+3, 
0x1.199999999999ap+0, 0x1.ef5c28f5c28f6p+1, 0x1.319999963e9b4p+7, 
0x1.900000055e63cp+4, 0x1.f0ccccc8c602p+5, 0x1.73333335e2651p+4, 
0x1.1666666666666p+6, 0x1.d8p+7, 0x1p+1, 0x1.a99999999999ap+2, 
0x1.f333332dd4cf8p+3, 0x1.17fffffbf9353p+5, 0x1.67fffffd50ce2p+4, 
0x1.49fffffca501bp+7, 0x1p-1, 0x1.9p+6, 0x1.52666665ba99fp+6, 
0x1.13fffffca501bp+7, 0x1.0ap+7, 0x1.5ep+6, 0x1.400000055e63cp+4, 
0x1.5333333333333p+2, 0x1.9ffffffeed1f4p+2, 0x1.604189374bc6ap-5, 
0x1.6cp+4, 0x1.ca8f5c23975edp+3, 0x1.4p+6, 0x1.e666666666666p+1, 
0x1.2cp+6, 0x1.199999999999ap+1, 0x1.4p+2, 0x1.4p+3, 0x1.9dc28f5c28f5cp+3, 
0x1.4cccccccccccdp+0, 0x1.019999999999ap+4, 0x1.e00000055e63cp+4, 
0x1.f5c28f5c28f5cp+0, 0x1.6cccccccccccdp+1), c(0x1.651a4b20c81ap+2, 
0x1.61b4977c91f37p+2, 0x1.225c6d83bf57p+2, 0x1.7b4a6f68dfe7p+0, 
0x1.f2272ae325a48p+0, 0x1.d5240f0e0e077p-1, 0x1.39ba88f78272ap+1, 
0x1.c82d51229ec8ep+1, 0x1.4b3bda1688b47p+1, 0x1.7f7427b963fa7p+1, 
0x1.165e43b09753ep+1, 0x1.4eeee650ae555p+0, 0x1.9190d0136ccd3p+0, 
0x1.a4ea5a617ea3bp+1, 0x1.f9c25aac91787p+1, 0x1.04bebd7a565e4p+2, 
0x1.fabd7380d58afp+1, 0x1.4535baa75708ap+2, 0x1.431bd27c3459p+2, 
0x1.615f9d9df2f98p+2, 0x1.e6752f98074e7p+2, 0x1.c5c3d1a1f2452p+2, 
0x1.5317a1ba5ca63p+2, 0x1.76e860753eabp+2, 0x1.5d69d95bc8c29p+2, 
0x1.2372b80fdbce2p+2, 0x1.93d5b3795a981p+2, 0x1.beb9906f1416dp+2, 
0x1.9b80862028779p+2, 0x1.b0d08f6bfddd4p+2, 0x1.8f20adea80d28p+2, 
0x1.08a691a05243dp+2, 0x1.829d485d01dccp+1, 0x1.cfea67597d38p+1, 
0x1.9c041f7ed8d32p+0, 0x1.2ed5db91ded56p+2, 0x1.1c5465ef8a30ep+2, 
0x1.5b0e40cf4ce6p+2, 0x1.fcccba61c9e44p+1, 0x1.58048fb97a3ddp+2, 
0x1.3785af3663995p+2, 0x1.3a68f008e739dp+2, 0x1.f4bd2b7909ed8p+1, 
0x1.6d0ac5a6c09e3p+2, 0x1.0078259bafef2p+2, 0x1.7cd753db8c77ep+2, 
0x1.26bb1bbb55514p+2, 0x1.02c15a1b9a8adp+2, 0x1.1375cd70846c9p+2
), c(0x1.30023a3de636ep+2, 0x1.1aa6c1e2b8c1cp+2, 0x1.0287c35f41b2ep+2, 
0x1.8fb063ef2c7e9p-5, 0x1.0c588baf19025p-3, 0x1.d5240f0e0e077p-1, 
-0x1.1d356e1eac128p-3, 0x1.53fb6abd1a256p+2, 0x1.e740b76b30efbp+1, 
0x1.44cfa5d62844dp+2, 0x1.1aa8bc695645dp+1, 0x1.8663f793c46c9p-4, 
0x1.5a6ee32ae89dfp+0, 0x1.41dd438e45d9cp+2, 0x1.9c041f8090a12p+1, 
0x1.083d5fd07a50bp+2, 0x1.927394f6323ebp+1, 0x1.0f89746556afdp+2, 
0x1.5daf6b985b7f4p+2, 0x1.62e42fefa39ecp-1, 0x1.e5059c353f981p+0, 
0x1.5fa692c39cf3dp+1, 0x1.c715a52f28041p+1, 0x1.8e87ab6d5f5c9p+1, 
0x1.46c7cf85bd63ap+2, -0x1.62e42fefa39ecp-1, 0x1.26bb1bbb55514p+2, 
0x1.1c071d7218eb2p+2, 0x1.3b581fd66eefep+2, 0x1.38fb7ae8ef028p+2, 
0x1.1e2f547a415f3p+2, 0x1.7f7427b963fa7p+1, 0x1.aaeed58d9cf3cp+0, 
0x1.df2e6d6db6942p+0, -0x1.92c251d0b1325p+1, 0x1.8ff1c02cd9c86p+1, 
0x1.54c80e7985228p+1, 0x1.18731fd788043p+2, 0x1.55c2a141bd925p+0, 
0x1.1451b9aa2075cp+2, 0x1.93b0aee21c2c7p-1, 0x1.9c041f7ed8d32p+0, 
0x1.26bb1bbb5551fp+1, 0x1.479f57393d076p+1, 0x1.0ca937be1b9dbp-2, 
0x1.63b0599358c0cp+1, 0x1.b35a6f922bea6p+1, 0x1.588c2d9133491p-1, 
0x1.0c1d18fcea245p+0)), names = c("taxon", "body_mass_kg", "home_range_km2", 
"ln_body_mass_kg", "ln_home_range_km2"), row.names = c(NA, 49L
), class = "data.frame")
settings <- structure(list("taxon", "ln_home_range_km2", "ln_body_mass_kg", 
    "BM", 0x1p-1, FALSE, "REML"), names = c("taxon", "response", 
"predictors", "model", "value", "fixed", "method"))
result <- do.call(guane_pgls, c(list(tree=tree, traits=traits), settings))
print(result$coefficients)
print(result$warnings)
plot_type <- "fit"
plot_color <- "#34765b"
show_taxa <- FALSE
plot_text <- structure(list("Fitted values", "Observed values", "Coefficient estimate", 
    "95% coefficient intervals", "Normalized residuals", "Theoretical quantiles"), names = c("fitted", 
"observed", "estimate", "interval", "residual", "quantiles"))
guane_pgls_plot(result, type=plot_type, color=plot_color, labels=show_taxa, text=plot_text)
# Optional: pdf("guane-pgls.pdf", width=9, height=6); guane_pgls_plot(result, plot_type, plot_color, show_taxa, plot_text); dev.off()
sessionInfo()
