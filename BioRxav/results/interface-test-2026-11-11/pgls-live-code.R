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
tree <- structure(list(structure(c(14L, 15L, 16L, 17L, 18L, 19L, 20L, 
21L, 22L, 22L, 21L, 20L, 19L, 18L, 17L, 23L, 23L, 24L, 25L, 25L, 
24L, 16L, 15L, 14L, 15L, 16L, 17L, 18L, 19L, 20L, 21L, 22L, 1L, 
2L, 3L, 4L, 5L, 6L, 23L, 7L, 24L, 25L, 8L, 9L, 10L, 11L, 12L, 
13L), dim = c(24L, 2L)), c(0x1.935fc3b4f6167p-5, 0x1.18f1d3ed527e5p-4, 
0x1.12839042d8c2ap-3, 0x1.a7c5ac471b478p-4, 0x1.22d0e56041893p-5, 
0x1.2c7b890d5a5b9p-7, 0x1.2c5c13fd0d068p-4, 0x1.c28f5c28f5c29p-5, 
0x1.c28f5c28f5c29p-5, 0x1.c28f5c28f5c29p-5, 0x1.c28f5c28f5c29p-4, 
0x1.7775b81301648p-3, 0x1.8a3d70a3d70a4p-3, 0x1.d2f1a9fbe76c9p-3, 
0x1.f55475a31a4bep-3, 0x1.630014f8b588ep-4, 0x1.a747d805e5f31p-5, 
0x1.eb851eb851eb8p-7, 0x1.47ae147ae147bp-6, 0x1.47ae147ae147bp-6, 
0x1.1eb851eb851ecp-5, 0x1.dcac083126e98p-2, 0x1.11743e963dc48p-1, 
0x1.2aaa3ad18d25fp-1), 12L, c("fuliginosa", "fortis", "magnirostris", 
"conirostris", "scandens", "difficilis", "pallida", "parvulus", 
"psittacula", "pauper", "Platyspiza", "fusca", "Pinaroloxias"
)), names = c("edge", "edge.length", "Nnode", "tip.label"), class = "phylo", order = "cladewise")
traits <- structure(list(c("fuliginosa", "fortis", "magnirostris", "conirostris", 
"scandens", "difficilis", "pallida", "parvulus", "psittacula", 
"pauper", "Platyspiza", "fusca", "Pinaroloxias"), c(0x1.08825e13b18dbp+2, 
0x1.0f9dd3bafd977p+2, 0x1.19de69ad42c3dp+2, 0x1.1664388ebcc6cp+2, 
0x1.10b7dc7abfb9cp+2, 0x1.0e571d1d4738ap+2, 0x1.10fcb923a29c7p+2, 
0x1.086c226809d49p+2, 0x1.0f0a915379fa9p+2, 0x1.0ee147ae147aep+2, 
0x1.1adc22ab25b31p+2, 0x1.fcd9ad85dfa87p+1, 0x1.0c1205bc01a37p+2
), c(0x1.673bd9cae211p+1, 0x1.7286162f166ep+1, 0x1.84fc504816fp+1, 
0x1.7dfa43fe5c91dp+1, 0x1.76ea8da7f3cf7p+1, 0x1.730fb65668c26p+1, 
0x1.8b7318fc50481p+1, 0x1.7c8d3ae685db7p+1, 0x1.8649906cca2dbp+1, 
0x1.84985f06f6944p+1, 0x1.a2a1272c94b38p+1, 0x1.77e06961c3697p+1, 
0x1.7d77318fc5048p+1), c(0x1.0c28027d88c1ep+1, 0x1.3419652bd3c36p+1, 
0x1.5cc1e364bec68p+1, 0x1.53c36113404eap+1, 0x1.4f96c82e019b1p+1, 
0x1.237abb8800eaep+1, 0x1.37126e978d4fep+1, 0x1.f97396d0917d7p+0, 
0x1.213be22e5de16p+1, 0x1.17ef9db22d0e5p+1, 0x1.2a6da4484944fp+1, 
0x1.06a2ca9ac3654p+1, 0x1.27d21ff2e48e9p+1), c(0x1.f0efaa4766c6ep+0, 
0x1.2e6b93ccd0fe9p+1, 0x1.6971327243138p+1, 0x1.41c432ca57a78p+1, 
0x1.12858793dd97fp+1, 0x1.016bb98c7e282p+1, 0x1.0217c1bda511ap+1, 
0x1.dfa05143bf727p+0, 0x1.1d71f36262cbap+1, 0x1.09652bd3c3611p+1, 
0x1.2c79ee02a77a3p+1, 0x1.30f6ad70e6f2fp+0, 0x1.8c28f5c28f5c3p+0
), c(0x1.d86ac215b9a5bp+0, 0x1.1c66234a87e39p+1, 0x1.56869c66d373bp+1, 
0x1.2e19f3c70c997p+1, 0x1.04ba94bbe4474p+1, 0x1.ee135daad602p+0, 
0x1.f2f9db22d0e56p+0, 0x1.d0370cdc8754fp+0, 0x1.0976ddaceee0fp+1, 
0x1.f64c2f837b4a2p+0, 0x1.2427179bfdf7fp+1, 0x1.66b4202d9cf14p+0, 
0x1.a14e3bcd35a86p+0)), names = c("taxon", "wingL", "tarsusL", 
"culmenL", "beakD", "gonysW"), row.names = c(6L, 5L, 1L, 2L, 
4L, 3L, 7L, 9L, 13L, 10L, 12L, 8L, 11L), class = "data.frame")
settings <- structure(list("taxon", "beakD", "wingL", "BM", 0x1p-1, FALSE, 
    "REML"), names = c("taxon", "response", "predictors", "model", 
"value", "fixed", "method"))
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