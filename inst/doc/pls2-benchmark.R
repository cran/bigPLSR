## ----setup_ops, include = FALSE-----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.path = "figures/benchmarking-pls2-",
  fig.width = 7,
  fig.height = 5,
  dpi = 150,
  message = FALSE,
  warning = FALSE
)

LOCAL <- identical(Sys.getenv("LOCAL"), "TRUE")
set.seed(2025)

## ----setup, message=FALSE-----------------------------------------------------
library(bigPLSR)
library(bigmemory)
library(bench)
set.seed(456)

## ----eval=FALSE---------------------------------------------------------------
# bench::mark(
#   dense = pls_fit(X[], Y_mat, ncomp = ncomp, algorithm = "rkhs_xy"),
#   streaming = pls_fit(X, Y, ncomp = ncomp, backend = "bigmem",
#                       algorithm = "kf_pls", chunk_size = 1024L)
# )

## ----eval=FALSE---------------------------------------------------------------
# future::plan(future::multisession, workers = 2)
# pls_cross_validate(X[], Y_mat, ncomp = 4, folds = 3,
#                    parallel = TRUE)
# future::plan(future::sequential)

## ----data-generation, eval=LOCAL, cache=TRUE----------------------------------
# n <- 1200
# p <- 60
# q <- 3
# ncomp <- 4
# 
# X <- bigmemory::big.matrix(nrow = n, ncol = p, type = "double")
# X[,] <- matrix(rnorm(n * p), nrow = n)
# 
# loading_matrix <- matrix(rnorm(p * q), nrow = p)
# latent_scores <- matrix(rnorm(n * q), nrow = n)
# Y_mat <- scale(latent_scores %*% t(loading_matrix[1:q, , drop = FALSE]) +
#                  matrix(rnorm(n * q, sd = 0.5), nrow = n))
# 
# Y <- bigmemory::big.matrix(nrow = n, ncol = q, type = "double")
# Y[,] <- Y_mat
# 
# X[1:6, 1:6]
# Y[1:6, 1:min(6, q)]

## ----internal-benchmark, eval=LOCAL, cache=TRUE-------------------------------
# internal_bench <- bench::mark(
#   dense_simpls = pls_fit(as.matrix(X[]), Y_mat, ncomp = ncomp,
#                          backend = "arma", algorithm = "simpls"),
#   streaming_simpls = pls_fit(X, Y, ncomp = ncomp, backend = "bigmem",
#                              algorithm = "simpls", chunk_size = 512L),
#   dense_nipals = pls_fit(as.matrix(X[]), Y_mat, ncomp = ncomp,
#                          backend = "arma", algorithm = "nipals"),
#   streaming_nipals = pls_fit(X, Y, ncomp = ncomp, backend = "bigmem",
#                              algorithm = "nipals", chunk_size = 512L),
#   iterations = 15,
#   check = FALSE
# )
# internal_bench

## ----external-benchmark-------------------------------------------------------
data("external_pls_benchmarks", package = "bigPLSR")
subset(external_pls_benchmarks, task == "pls2")

