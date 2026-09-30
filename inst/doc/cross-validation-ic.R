## ----setup_ops, include = FALSE-----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.path = "figures/cv-ic-",
  fig.width = 7,
  fig.height = 5,
  dpi = 150,
  message = FALSE,
  warning = FALSE
)

LOCAL <- identical(Sys.getenv("LOCAL"), "TRUE")
set.seed(2025)

## ----data---------------------------------------------------------------------
library(bigPLSR)
n <- 120; p <- 8
X <- matrix(rnorm(n * p), n, p)
eta <- X[, 1] - 0.8 * X[, 2] + 0.5 * X[, 3]
y <- eta + rnorm(n, sd = 0.4)

## ----cv, eval=LOCAL, cache=TRUE-----------------------------------------------
# cv_res <- pls_cross_validate(X, y, ncomp = 4, folds = 6,
#                              metrics = c("rmse", "r2"),
#                              parallel = "none")
# head(cv_res$details)

## ----cv-summary, eval=LOCAL, cache=TRUE---------------------------------------
# cv_res$summary

## ----cv-select, eval=LOCAL, cache=TRUE----------------------------------------
# pls_cv_select(cv_res, metric = "rmse")

## ----ic, eval=LOCAL, cache=TRUE-----------------------------------------------
# fit <- pls_fit(X, y, ncomp = 4, scores = "r")
# ic_tbl <- pls_information_criteria(fit, X, y)
# ic_tbl

## ----ic-select, eval=LOCAL, cache=TRUE----------------------------------------
# pls_select_components(fit, X, y, criteria = c("aic", "bic"))

## ----future-example, eval=FALSE-----------------------------------------------
# future::plan(future::multisession, workers = 2)
# cv_parallel <- pls_cross_validate(X, y, ncomp = 4, folds = 6,
#                                   metrics = c("rmse", "mae"),
#                                   parallel = "future",
#                                   future_seed = TRUE)
# future::plan(future::sequential)

