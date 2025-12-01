## ----setup_ops, include = FALSE-----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.path = "figures/rkhs-",
  fig.width = 7,
  fig.height = 5,
  dpi = 150,
  message = FALSE,
  warning = FALSE
)

LOCAL <- identical(Sys.getenv("LOCAL"), "TRUE")
set.seed(2025)

## ----dense-example------------------------------------------------------------
library(bigPLSR)
set.seed(42)
n <- 120; p <- 8; m <- 2
X <- matrix(rnorm(n * p), n, p)
Y <- cbind(
  sin(X[, 1]) + 0.3 * X[, 2]^2 + rnorm(n, sd = 0.1),
  cos(X[, 3]) - 0.2 * X[, 4] + rnorm(n, sd = 0.1)
)

fit_rkhs <- pls_fit(X, Y, ncomp = 3, algorithm = "rkhs",
                    kernel = "rbf", gamma = 1 / p, scores = "r")

options(bigPLSR.rkhs_xy.lambda_x = 1e-6)
options(bigPLSR.rkhs_xy.lambda_y = 1e-6)

fit_rkhs_xy <- pls_fit(X, Y, ncomp = 3, algorithm = "rkhs_xy",
                       kernel = "rbf", gamma = 1 / p,
                       scores = "none")

head(predict(fit_rkhs, X))
head(predict(fit_rkhs_xy, X))

## ----eval=FALSE---------------------------------------------------------------
# library(bigmemory)
# Xbm <- as.big.matrix(X)
# Ybm <- as.big.matrix(Y)
# 
# fit_stream <- pls_fit(Xbm, Ybm, ncomp = 3, backend = "bigmem",
#                       algorithm = "rkhs", kernel = "rbf",
#                       gamma = 1 / p, chunk_size = 1024L,
#                       scores = "none")

## ----eval=FALSE---------------------------------------------------------------
# y <- as.integer(X[, 1]^2 + X[, 2]^2 + rnorm(n, sd = 0.2) > 1)
# fit_logit <- pls_fit(X, y, ncomp = 2, algorithm = "klogitpls",
#                      kernel = "rbf", gamma = 1 / p)
# mean(predict(fit_logit, X))

