## ----setup_ops, include = FALSE-----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.path = "figures/bootstrap-",
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
n <- 100; p <- 6; m <- 2
X <- matrix(rnorm(n * p), n, p)
eta1 <- X[, 1] + 0.4 * X[, 2] - 0.6 * X[, 3]
eta2 <- -0.5 * X[, 2] + 0.7 * X[, 4] + 0.5 * X[, 5]
Y <- cbind(eta1, eta2) + matrix(rnorm(n * m, sd = 0.5), n, m)

## ----fit, eval=LOCAL, cache=TRUE----------------------------------------------
fit <- pls_fit(X, Y, ncomp = 3, scores = "r")

## ----boot-xy, eval=LOCAL, cache=TRUE------------------------------------------
boot_xy <- pls_bootstrap(X, Y, ncomp = 3, R = 50, type = "xy",
                         parallel = "none", return_scores = TRUE)
head(summarise_pls_bootstrap(boot_xy))

## ----boot-xy-plot, fig.height=4.5, eval=LOCAL, cache=TRUE---------------------
plot_pls_bootstrap_coefficients(boot_xy, variables = colnames(X))

## ----boot-xt, eval=LOCAL, cache=TRUE------------------------------------------
boot_xt <- pls_bootstrap(X, Y, ncomp = 3, R = 50, type = "xt",
                         parallel = "none", return_scores = TRUE)
head(summarise_pls_bootstrap(boot_xt))

## ----boot-xt-plot, fig.height=4.5, eval=LOCAL, cache=TRUE---------------------
plot_pls_bootstrap_coefficients(boot_xt, responses = colnames(Y))

## ----boot-score-summary, eval=LOCAL, cache=TRUE-------------------------------
score_mats <- boot_xt$score_samples
score_means <- sapply(score_mats, function(M) colMeans(M)[1:2])
apply(score_means, 1, summary)

## ----boot-parallel, eval=FALSE------------------------------------------------
# future::plan(future::multisession, workers = 2)
# boot_xy_parallel <- pls_bootstrap(X, Y, ncomp = 3, R = 100, type = "xy",
#                                   parallel = "future")
# future::plan(future::sequential)

