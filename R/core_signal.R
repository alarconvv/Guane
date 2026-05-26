# R/core_signal.R

guane_signal_required_packages <- function() {
  required <- c("ape", "phytools", "geiger", "nlme")
  missing <- required[
    !vapply(required, requireNamespace, logical(1), quietly = TRUE)
  ]

  if (length(missing) > 0) {
    stop(
      "Missing required package(s): ",
      paste(missing, collapse = ", "),
      ". Install them with renv::install().",
      call. = FALSE
    )
  }

  invisible(TRUE)
}

guane_as_numeric <- function(x, column_name) {
  if (is.numeric(x)) {
    return(x)
  }

  out <- suppressWarnings(as.numeric(as.character(x)))
  failed <- is.na(out) & !is.na(x)

  if (any(failed)) {
    stop(
      "Column `", column_name, "` contains non-numeric values. ",
      "Choose a numeric trait column.",
      call. = FALSE
    )
  }

  out
}

guane_transform_numeric <- function(x, method = "none") {
  method <- match.arg(
    method,
    c("none", "log", "log10", "log1p", "sqrt", "exp", "inverse", "standardize")
  )

  if (method == "none") {
    return(x)
  }

  if (method == "log") {
    if (any(x <= 0, na.rm = TRUE)) {
      stop("Log transformation requires all values to be > 0.", call. = FALSE)
    }
    return(log(x))
  }

  if (method == "log10") {
    if (any(x <= 0, na.rm = TRUE)) {
      stop("Log10 transformation requires all values to be > 0.", call. = FALSE)
    }
    return(log10(x))
  }

  if (method == "log1p") {
    if (any(x <= -1, na.rm = TRUE)) {
      stop("log1p transformation requires all values to be > -1.", call. = FALSE)
    }
    return(log1p(x))
  }

  if (method == "sqrt") {
    if (any(x < 0, na.rm = TRUE)) {
      stop("Square-root transformation requires all values to be >= 0.", call. = FALSE)
    }
    return(sqrt(x))
  }

  if (method == "exp") {
    if (any(x > 700, na.rm = TRUE)) {
      stop("Exponential transformation would overflow for values > 700.", call. = FALSE)
    }
    return(exp(x))
  }

  if (method == "inverse") {
    if (any(x == 0, na.rm = TRUE)) {
      stop("Inverse transformation requires no zero values.", call. = FALSE)
    }
    return(1 / x)
  }

  if (method == "standardize") {
    return(as.numeric(scale(x)))
  }
}

guane_normality_check <- function(x, label = "trait") {
  x <- x[is.finite(x)]
  n <- length(x)

  if (n < 3) {
    return(data.frame(
      trait = label,
      n = n,
      statistic = NA_real_,
      p_value = NA_real_,
      interpretation = "Not enough observations for a Shapiro-Wilk test.",
      stringsAsFactors = FALSE
    ))
  }

  if (n > 5000) {
    return(data.frame(
      trait = label,
      n = n,
      statistic = NA_real_,
      p_value = NA_real_,
      interpretation = "More than 5000 observations; Shapiro-Wilk test not run.",
      stringsAsFactors = FALSE
    ))
  }

  test <- stats::shapiro.test(x)

  interpretation <- if (test$p.value < 0.05) {
    "Normality concern: the distribution differs from normal expectation."
  } else {
    "No strong evidence against normality."
  }

  data.frame(
    trait = label,
    n = n,
    statistic = unname(test$statistic),
    p_value = test$p.value,
    interpretation = interpretation,
    stringsAsFactors = FALSE
  )
}

guane_prepare_signal_data <- function(tree,
                                      data,
                                      taxon_col,
                                      response_col,
                                      predictor_col = NULL,
                                      response_transform = "none",
                                      predictor_transform = "none") {
  guane_signal_required_packages()

  messages <- character()

  if (inherits(tree, "multiPhylo")) {
    tree <- tree[[1]]
    messages <- c(
      messages,
      "A multiPhylo object was detected. Module 1 currently uses the first tree."
    )
  }

  if (!inherits(tree, "phylo")) {
    stop("The tree must be an ape `phylo` object.", call. = FALSE)
  }

  if (is.null(tree$edge.length)) {
    stop("The tree must have branch lengths.", call. = FALSE)
  }

  if (any(!is.finite(tree$edge.length)) || any(tree$edge.length <= 0)) {
    stop("All branch lengths must be positive finite values.", call. = FALSE)
  }

  data <- as.data.frame(data)

  required_cols <- c(taxon_col, response_col, predictor_col)
  required_cols <- required_cols[!is.null(required_cols) & nzchar(required_cols)]

  missing_cols <- setdiff(required_cols, names(data))
  if (length(missing_cols) > 0) {
    stop(
      "Missing column(s): ",
      paste(missing_cols, collapse = ", "),
      call. = FALSE
    )
  }

  if (anyDuplicated(data[[taxon_col]]) > 0) {
    stop("The taxon column contains duplicate labels.", call. = FALSE)
  }

  data[[taxon_col]] <- as.character(data[[taxon_col]])
  data[[response_col]] <- guane_as_numeric(data[[response_col]], response_col)

  if (!is.null(predictor_col) && nzchar(predictor_col)) {
    data[[predictor_col]] <- guane_as_numeric(data[[predictor_col]], predictor_col)
  } else {
    predictor_col <- NULL
  }

  keep_cols <- c(taxon_col, response_col, predictor_col)
  data <- data[, keep_cols, drop = FALSE]
  data <- data[stats::complete.cases(data), , drop = FALSE]

  common_taxa <- intersect(tree$tip.label, data[[taxon_col]])

  if (length(common_taxa) < 4) {
    stop(
      "Fewer than four matched taxa remain after matching tree and data.",
      call. = FALSE
    )
  }

  dropped_from_tree <- setdiff(tree$tip.label, common_taxa)
  dropped_from_data <- setdiff(data[[taxon_col]], common_taxa)

  if (length(dropped_from_tree) > 0) {
    tree <- ape::drop.tip(tree, dropped_from_tree)
    messages <- c(
      messages,
      paste(length(dropped_from_tree), "tree tips were dropped because they were absent from the data.")
    )
  }

  if (length(dropped_from_data) > 0) {
    messages <- c(
      messages,
      paste(length(dropped_from_data), "data rows were ignored because they were absent from the tree.")
    )
  }

  data <- data[match(tree$tip.label, data[[taxon_col]]), , drop = FALSE]
  rownames(data) <- data[[taxon_col]]

  data$.guane_y <- guane_transform_numeric(data[[response_col]], response_transform)

  if (!is.null(predictor_col)) {
    data$.guane_x <- guane_transform_numeric(data[[predictor_col]], predictor_transform)
  }

  list(
    tree = tree,
    data = data,
    messages = messages
  )
}

guane_fit_blomberg_k <- function(tree, y, nsim = 999) {
  fit <- tryCatch(
    phytools::phylosig(tree, y, method = "K", test = TRUE, nsim = nsim),
    error = function(e) e
  )

  if (inherits(fit, "error")) {
    return(list(ok = FALSE, error = conditionMessage(fit)))
  }

  list(
    ok = TRUE,
    K = unname(fit$K),
    p_value = unname(fit$P),
    object = fit
  )
}

guane_fit_pagel_lambda <- function(tree, y) {
  fit <- tryCatch(
    geiger::fitContinuous(tree, y, model = "lambda"),
    error = function(e) e
  )

  if (inherits(fit, "error")) {
    return(list(ok = FALSE, error = conditionMessage(fit)))
  }

  list(
    ok = TRUE,
    lambda = fit$opt$lambda,
    log_likelihood = fit$opt$lnL,
    aic = fit$opt$aic,
    aicc = fit$opt$aicc,
    object = fit
  )
}

guane_fit_pic_regression <- function(tree, y, x) {
  fit <- tryCatch({
    pic_y <- ape::pic(y, tree)
    pic_x <- ape::pic(x, tree)
    model <- stats::lm(pic_y ~ pic_x - 1)

    list(
      ok = TRUE,
      contrasts = data.frame(
        pic_response = pic_y,
        pic_predictor = pic_x
      ),
      coefficients = summary(model)$coefficients,
      r_squared = summary(model)$r.squared,
      object = model
    )
  }, error = function(e) {
    list(ok = FALSE, error = conditionMessage(e))
  })

  fit
}

guane_extract_gls_summary <- function(fit) {
  coef_table <- as.data.frame(summary(fit)$tTable)
  coef_table$term <- rownames(coef_table)
  rownames(coef_table) <- NULL

  list(
    coefficients = coef_table,
    log_likelihood = as.numeric(stats::logLik(fit)),
    aic = stats::AIC(fit),
    bic = stats::BIC(fit),
    object = fit
  )
}

guane_fit_pgls <- function(tree,
                           data,
                           taxon_col,
                           model = c("BM", "OU"),
                           method = "ML",
                           ou_alpha = 1) {
  model <- match.arg(model)

  fit <- tryCatch({
    correlation_form <- stats::as.formula(paste("~", taxon_col))

    correlation_structure <- switch(
      model,
      BM = ape::corBrownian(
        phy = tree,
        form = correlation_form
      ),
      OU = ape::corMartins(
        value = ou_alpha,
        phy = tree,
        form = correlation_form,
        fixed = FALSE
      )
    )

    gls_fit <- nlme::gls(
      .guane_y ~ .guane_x,
      data = data,
      correlation = correlation_structure,
      method = method,
      na.action = stats::na.omit,
      control = nlme::glsControl(msMaxIter = 200)
    )

    out <- guane_extract_gls_summary(gls_fit)
    out$ok <- TRUE
    out$model <- model
    out
  }, error = function(e) {
    list(ok = FALSE, model = model, error = conditionMessage(e))
  })

  fit
}

guane_build_signal_code <- function(result) {
  input <- result$input
  method_code <- paste(sprintf('"%s"', input$methods), collapse = ", ")

  predictor_line <- if (is.null(input$predictor_col) || !nzchar(input$predictor_col)) {
    "  predictor_col = NULL,"
  } else {
    paste0('  predictor_col = "', input$predictor_col, '",')
  }

  paste(
    "# Reproducible code generated by Guane",
    "library(ape)",
    "library(phytools)",
    "library(geiger)",
    "library(nlme)",
    "",
    "# Replace `tree` and `trait_data` with your loaded objects.",
    "result <- guane_run_signal_module(",
    "  tree = tree,",
    "  data = trait_data,",
    paste0('  taxon_col = "', input$taxon_col, '",'),
    paste0('  response_col = "', input$response_col, '",'),
    predictor_line,
    paste0('  response_transform = "', input$response_transform, '",'),
    paste0('  predictor_transform = "', input$predictor_transform, '",'),
    paste0("  methods = c(", method_code, "),"),
    paste0("  k_nsim = ", input$k_nsim, ","),
    paste0('  pgls_method = "', input$pgls_method, '",'),
    paste0("  ou_alpha = ", input$ou_alpha),
    ")",
    "",
    "cat(result$report)",
    sep = "\n"
  )
}

guane_format_signal_report <- function(result) {
  lines <- c(
    "Phylogenetic signal and comparative regression",
    "================================================",
    "",
    "Data status",
    "-----------",
    paste("Taxa included:", length(result$tree$tip.label)),
    paste("Response trait:", result$input$response_col),
    paste("Response transformation:", result$input$response_transform)
  )

  if (!is.null(result$input$predictor_col) && nzchar(result$input$predictor_col)) {
    lines <- c(
      lines,
      paste("Predictor trait:", result$input$predictor_col),
      paste("Predictor transformation:", result$input$predictor_transform)
    )
  }

  if (length(result$messages) > 0) {
    lines <- c(lines, "", "Messages", "--------", paste("-", result$messages))
  }

  lines <- c(lines, "", "Normality checks", "----------------")
  for (normality_row in result$normality) {
    lines <- c(
      lines,
      paste0(
        "- ", normality_row$trait,
        ": n = ", normality_row$n,
        ", Shapiro-Wilk p = ",
        ifelse(is.na(normality_row$p_value), "NA", signif(normality_row$p_value, 4)),
        ". ", normality_row$interpretation
      )
    )
  }

  if (length(result$signal) > 0) {
    lines <- c(lines, "", "Phylogenetic signal", "-------------------")

    if (!is.null(result$signal$blomberg_k)) {
      k <- result$signal$blomberg_k
      lines <- c(
        lines,
        if (isTRUE(k$ok)) {
          paste0(
            "- Blomberg's K = ", signif(k$K, 5),
            "; randomization p = ", signif(k$p_value, 5), "."
          )
        } else {
          paste("- Blomberg's K failed:", k$error)
        }
      )
    }

    if (!is.null(result$signal$pagel_lambda)) {
      lambda <- result$signal$pagel_lambda
      lines <- c(
        lines,
        if (isTRUE(lambda$ok)) {
          paste0(
            "- Pagel's lambda = ", signif(lambda$lambda, 5),
            "; logLik = ", signif(lambda$log_likelihood, 5),
            "; AICc = ", signif(lambda$aicc, 5), "."
          )
        } else {
          paste("- Pagel's lambda failed:", lambda$error)
        }
      )
    }
  }

  if (!is.null(result$pic)) {
    lines <- c(lines, "", "Phylogenetic independent contrasts", "-----------------------------------")
    if (isTRUE(result$pic$ok)) {
      coefficient <- result$pic$coefficients[1, 1]
      p_value <- result$pic$coefficients[1, 4]
      lines <- c(
        lines,
        paste0(
          "- PIC regression slope = ", signif(coefficient, 5),
          "; p = ", signif(p_value, 5),
          "; R² = ", signif(result$pic$r_squared, 5), "."
        )
      )
    } else {
      lines <- c(lines, paste("- PIC regression failed:", result$pic$error))
    }
  }

  if (length(result$pgls) > 0) {
    lines <- c(lines, "", "PGLS regression", "---------------")

    for (model_name in names(result$pgls)) {
      fit <- result$pgls[[model_name]]

      if (!isTRUE(fit$ok)) {
        lines <- c(lines, paste("-", model_name, "PGLS failed:", fit$error))
        next
      }

      slope_row <- fit$coefficients[fit$coefficients$term == ".guane_x", , drop = FALSE]

      if (nrow(slope_row) == 1) {
        lines <- c(
          lines,
          paste0(
            "- ", model_name,
            " PGLS slope = ", signif(slope_row$Value, 5),
            "; p = ", signif(slope_row[["p-value"]], 5),
            "; AIC = ", signif(fit$aic, 5),
            "; BIC = ", signif(fit$bic, 5), "."
          )
        )
      }
    }
  }

  paste(lines, collapse = "\n")
}

guane_run_signal_module <- function(tree,
                                    data,
                                    taxon_col,
                                    response_col,
                                    predictor_col = NULL,
                                    response_transform = "none",
                                    predictor_transform = "none",
                                    methods = c(
                                      "blomberg_k",
                                      "pagel_lambda",
                                      "pic",
                                      "pgls_bm",
                                      "pgls_ou"
                                    ),
                                    k_nsim = 999,
                                    pgls_method = "ML",
                                    ou_alpha = 1) {
  methods <- unique(methods)

  prep <- guane_prepare_signal_data(
    tree = tree,
    data = data,
    taxon_col = taxon_col,
    response_col = response_col,
    predictor_col = predictor_col,
    response_transform = response_transform,
    predictor_transform = predictor_transform
  )

  y <- stats::setNames(prep$data$.guane_y, prep$data[[taxon_col]])

  has_predictor <- !is.null(predictor_col) && nzchar(predictor_col)

  if (any(methods %in% c("pic", "pgls_bm", "pgls_ou")) && !has_predictor) {
    stop(
      "PIC and PGLS require a predictor trait.",
      call. = FALSE
    )
  }

  result <- list(
    input = list(
      taxon_col = taxon_col,
      response_col = response_col,
      predictor_col = predictor_col,
      response_transform = response_transform,
      predictor_transform = predictor_transform,
      methods = methods,
      k_nsim = k_nsim,
      pgls_method = pgls_method,
      ou_alpha = ou_alpha
    ),
    tree = prep$tree,
    data = prep$data,
    messages = prep$messages,
    normality = list(),
    signal = list(),
    pic = NULL,
    pgls = list()
  )

  result$normality$response <- guane_normality_check(
    prep$data$.guane_y,
    paste(response_col, "after", response_transform)
  )

  if (has_predictor) {
    result$normality$predictor <- guane_normality_check(
      prep$data$.guane_x,
      paste(predictor_col, "after", predictor_transform)
    )
    x <- stats::setNames(prep$data$.guane_x, prep$data[[taxon_col]])
  }

  if ("blomberg_k" %in% methods) {
    result$signal$blomberg_k <- guane_fit_blomberg_k(
      prep$tree,
      y,
      nsim = k_nsim
    )
  }

  if ("pagel_lambda" %in% methods) {
    result$signal$pagel_lambda <- guane_fit_pagel_lambda(prep$tree, y)
  }

  if ("pic" %in% methods) {
    result$pic <- guane_fit_pic_regression(prep$tree, y, x)
  }

  if ("pgls_bm" %in% methods) {
    result$pgls$BM <- guane_fit_pgls(
      tree = prep$tree,
      data = prep$data,
      taxon_col = taxon_col,
      model = "BM",
      method = pgls_method,
      ou_alpha = ou_alpha
    )
  }

  if ("pgls_ou" %in% methods) {
    result$pgls$OU <- guane_fit_pgls(
      tree = prep$tree,
      data = prep$data,
      taxon_col = taxon_col,
      model = "OU",
      method = pgls_method,
      ou_alpha = ou_alpha
    )
  }

  result$code <- guane_build_signal_code(result)
  result$report <- guane_format_signal_report(result)

  class(result) <- c("guane_signal_result", class(result))
  result
}

guane_plot_signal_overview <- function(result) {
  old_par <- graphics::par(no.readonly = TRUE)
  on.exit(graphics::par(old_par), add = TRUE)

  has_predictor <- ".guane_x" %in% names(result$data)

  if (has_predictor) {
    graphics::par(mfrow = c(2, 2))
  } else {
    graphics::par(mfrow = c(2, 1))
  }

  graphics::hist(
    result$data$.guane_y,
    main = "Response trait distribution",
    xlab = result$input$response_col
  )

  stats::qqnorm(
    result$data$.guane_y,
    main = "Response trait Q-Q plot"
  )
  stats::qqline(result$data$.guane_y)

  if (has_predictor) {
    graphics::plot(
      result$data$.guane_x,
      result$data$.guane_y,
      xlab = result$input$predictor_col,
      ylab = result$input$response_col,
      main = "Trait association"
    )
    graphics::abline(
      stats::lm(.guane_y ~ .guane_x, data = result$data),
      lwd = 2
    )
  }

  ape::plot.phylo(
    result$tree,
    cex = 0.7,
    main = "Phylogeny used in analysis"
  )
}

guane_plot_pic <- function(result) {
  if (is.null(result$pic) || !isTRUE(result$pic$ok)) {
    graphics::plot.new()
    graphics::text(0.5, 0.5, "PIC regression was not run or failed.")
    return(invisible(NULL))
  }

  graphics::plot(
    result$pic$contrasts$pic_predictor,
    result$pic$contrasts$pic_response,
    xlab = "Predictor independent contrasts",
    ylab = "Response independent contrasts",
    main = "PIC regression"
  )
  graphics::abline(result$pic$object, lwd = 2)

  invisible(NULL)
}
