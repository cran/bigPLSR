## ----setup_ops, include = FALSE-----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.path = "figures/double-rkhs-pls-",
  fig.width = 7,
  fig.height = 5,
  dpi = 150,
  message = FALSE,
  warning = FALSE
)

LOCAL <- identical(Sys.getenv("LOCAL"), "TRUE")
set.seed(2025)

## ----eval=LOCAL, cache=TRUE---------------------------------------------------
# library(bigPLSR)
# set.seed(42)
# n <- 60; p <- 6; m <- 2
# X <- matrix(rnorm(n * p), n, p)
# Y <- cbind(sin(X[,1]) + 0.4 * X[,2]^2,
#            cos(X[,3]) - 0.3 * X[,4]^2) + matrix(rnorm(n*m, sd=.05), n, m)
# 
# op <- options(
#   bigPLSR.rkhs_xy.kernel_x = "rbf",
#   bigPLSR.rkhs_xy.gamma_x  = 0.5,
#   bigPLSR.rkhs_xy.kernel_y = "linear",
#   bigPLSR.rkhs_xy.lambda_x = 1e-6,
#   bigPLSR.rkhs_xy.lambda_y = 1e-6
# )
# on.exit(options(op), add = TRUE)
# 
# fit <- pls_fit(X, Y, ncomp = 3, algorithm = "rkhs_xy", backend = "arma")
# Yhat <- predict(fit, X)
# mean((Y - Yhat)^2)

