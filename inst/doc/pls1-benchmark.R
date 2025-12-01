## ----setup_ops, include = FALSE-----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.path = "figures/benchmarking-pls1-",
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
set.seed(123)

## ----data-generation----------------------------------------------------------
n <- 1500
p <- 80
ncomp <- 6

X <- bigmemory::big.matrix(nrow = n, ncol = p, type = "double")
X[,] <- matrix(rnorm(n * p), nrow = n)

y_vec <- scale(X[,] %*% rnorm(p) + rnorm(n))

y <- bigmemory::big.matrix(nrow = n, ncol = 1, type = "double")
y[,] <- y_vec

X[1:6, 1:6]
y[1:6,]

## ----internal-benchmark, eval=LOCAL, cache=TRUE-------------------------------
internal_bench <- bench::mark(
  dense_simpls = pls_fit(as.matrix(X[]), y_vec, ncomp = ncomp,
                         backend = "arma", algorithm = "simpls"),
  streaming_simpls = pls_fit(X, y, ncomp = ncomp, backend = "bigmem",
                             algorithm = "simpls", chunk_size = 512L),
  dense_nipals = pls_fit(as.matrix(X[]), y_vec, ncomp = ncomp,
                         backend = "arma", algorithm = "nipals"),
  streaming_nipals = pls_fit(X, y, ncomp = ncomp, backend = "bigmem",
                             algorithm = "nipals", chunk_size = 512L),
  dense_kernelpls = pls_fit(as.matrix(X[]), y_vec, ncomp = ncomp,
                         backend = "arma", algorithm = "kernelpls"),
  streaming_kernelpls = pls_fit(X, y, ncomp = ncomp, backend = "bigmem",
                             algorithm = "kernelpls", chunk_size = 512L),
  dense_widekernelpls = pls_fit(as.matrix(X[]), y_vec, ncomp = ncomp,
                         backend = "arma", algorithm = "widekernelpls"),
  streaming_widekernelpls = pls_fit(X, y, ncomp = ncomp, backend = "bigmem",
                             algorithm = "widekernelpls", chunk_size = 512L),
  iterations = 20,
  check = FALSE
)
internal_bench_res <-internal_bench[,2:5]
internal_bench_res <- as.matrix(internal_bench_res)
rownames(internal_bench_res) <- names(internal_bench$expression)

## ----internal-benchmark-plot, eval=LOCAL, cache=TRUE--------------------------
dotchart(internal_bench_res[,2], labels=rownames(internal_bench_res),xlab="median_time_s")
dotchart(internal_bench_res[,3], labels=rownames(internal_bench_res),xlab="itr_per_sec")
dotchart(internal_bench_res[,4], labels=rownames(internal_bench_res),xlab="mem_alloc_bytes")

## ----external-benchmark-------------------------------------------------------
data("external_pls_benchmarks", package = "bigPLSR")
sub_pls1 <- subset(external_pls_benchmarks,task=="pls1" & !algorithm=="widekernelpls")
sub_pls1$n <- factor(sub_pls1$n)
sub_pls1$p <- factor(sub_pls1$p)
sub_pls1$q <- factor(sub_pls1$q)
sub_pls1$ncomp <- factor(sub_pls1$ncomp)
replications(~package+algorithm+task+n+p+ncomp,data=sub_pls1)

sub_pls1_wide <- subset(external_pls_benchmarks,external_pls_benchmarks$task=="pls1" & algorithm=="widekernelpls")
sub_pls1_wide$n <- factor(sub_pls1_wide$n)
sub_pls1_wide$p <- factor(sub_pls1_wide$p)
sub_pls1_wide$q <- factor(sub_pls1_wide$q)
sub_pls1_wide$ncomp <- factor(sub_pls1_wide$ncomp)
replications(~package+algorithm+task+n+p+ncomp,data=sub_pls1_wide)

sub_pls2 <- subset(external_pls_benchmarks,external_pls_benchmarks$task=="pls2" & !algorithm=="widekernelpls")
sub_pls2$n <- factor(sub_pls2$n)
sub_pls2$p <- factor(sub_pls2$p)
sub_pls2$q <- factor(sub_pls2$q)
sub_pls2$ncomp <- factor(sub_pls2$ncomp)
replications(~package+algorithm+task+n+p+ncomp,data=sub_pls2)

sub_pls2_wide <- subset(external_pls_benchmarks,external_pls_benchmarks$task=="pls2" & algorithm=="widekernelpls")
sub_pls2_wide$n <- factor(sub_pls2_wide$n)
sub_pls2_wide$p <- factor(sub_pls2_wide$p)
sub_pls2_wide$q <- factor(sub_pls2_wide$q)
sub_pls2_wide$ncomp <- factor(sub_pls2_wide$ncomp)
replications(~package+algorithm+task+n+p+ncomp,data=sub_pls2_wide)

## ----external-sample-result---------------------------------------------------
sub_pls1

