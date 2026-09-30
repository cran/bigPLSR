## -----------------------------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment  = "#>",
  fig.path = "figures/benchmark-short-",
  fig.width  = 6,
  fig.height = 4,
  dpi = 150,
  message = FALSE,
  warning = FALSE
)


LOCAL <- identical(Sys.getenv("LOCAL"), "TRUE")

## ----eval=LOCAL, cache=TRUE---------------------------------------------------
# library(bigPLSR)
# library(ggplot2)
# library(dplyr)
# library(tidyr)
# 
# data("external_pls_benchmarks", package = "bigPLSR")
# 
# str(external_pls_benchmarks)

## ----eval=LOCAL, cache=TRUE---------------------------------------------------
# summ_best <- external_pls_benchmarks %>%
#   group_by(task, n, p, q, ncomp) %>%
#   mutate(
#     rank_time = rank(median_time_s, ties.method = "min"),
#     rank_mem  = rank(mem_alloc_bytes, ties.method = "min")
#   ) %>%
#   ungroup()
# 
# best_time <- summ_best %>%
#   filter(rank_time == 1L) %>%
#   count(task, package, algorithm, name = "n_best_time")
# 
# best_mem <- summ_best %>%
#   filter(rank_mem == 1L) %>%
#   count(task, package, algorithm, name = "n_best_mem")
# 
# best_time
# best_mem

## ----eval=LOCAL, cache=TRUE---------------------------------------------------
# example_pls1 <- external_pls_benchmarks %>%
#   filter(task == "pls1") %>%
#   group_by(n, p, q) %>%
#   filter(n == first(n), p == first(p), q == first(q)) %>%
#   ungroup()
# 
# example_pls1_size <- example_pls1 %>%
#   count(n, p, q, sort = TRUE) %>%
#   slice(1L) %>%
#   select(n, p, q)
# 
# example_pls1 <- external_pls_benchmarks %>%
#   semi_join(example_pls1_size, by = c("n", "p", "q")) %>%
#   filter(task == "pls1")

## ----eval=LOCAL, cache=TRUE---------------------------------------------------
# ggplot(example_pls1,
#        aes(x = ncomp, y = median_time_s,
#            colour = package, linetype = algorithm)) +
#   geom_line() +
#   geom_point() +
#   scale_y_log10() +
#   labs(
#     x = "Number of components",
#     y = "Median runtime (seconds, log scale)",
#     title = "PLS1 benchmark, fixed (n, p, q)",
#     subtitle = "Comparison across packages and algorithms"
#   ) +
#   theme_minimal()

## ----eval=LOCAL, cache=TRUE---------------------------------------------------
# ggplot(example_pls1,
#        aes(x = ncomp, y = mem_alloc_bytes / 1024^2,
#            colour = package, linetype = algorithm)) +
#   geom_line() +
#   geom_point() +
#   labs(
#     x = "Number of components",
#     y = "Memory allocated (MiB)",
#     title = "PLS1 benchmark, fixed (n, p, q)"
#   ) +
#   theme_minimal()

## ----eval=LOCAL, cache=TRUE---------------------------------------------------
# example_pls2 <- external_pls_benchmarks %>%
#   filter(task == "pls2") %>%
#   group_by(n, p, q) %>%
#   filter(n == first(n), p == first(p), q == first(q)) %>%
#   ungroup()
# 
# example_pls2_size <- example_pls2 %>%
#   count(n, p, q, sort = TRUE) %>%
#   slice(1L) %>%
#   select(n, p, q)
# 
# example_pls2 <- external_pls_benchmarks %>%
#   semi_join(example_pls2_size, by = c("n", "p", "q")) %>%
#   filter(task == "pls2")

## ----eval=LOCAL, cache=TRUE---------------------------------------------------
# ggplot(example_pls2,
#        aes(x = ncomp, y = median_time_s,
#            colour = package, linetype = algorithm)) +
#   geom_line() +
#   geom_point() +
#   scale_y_log10() +
#   labs(
#     x = "Number of components",
#     y = "Median runtime (seconds, log scale)",
#     title = "PLS2 benchmark, fixed (n, p, q)",
#     subtitle = "Comparison across packages and algorithms"
#   ) +
#   theme_minimal()

## ----eval=LOCAL, cache=TRUE---------------------------------------------------
# ggplot(example_pls2,
#        aes(x = ncomp, y = mem_alloc_bytes / 1024^2,
#            colour = package, linetype = algorithm)) +
#   geom_line() +
#   geom_point() +
#   labs(
#     x = "Number of components",
#     y = "Memory allocated (MiB)",
#     title = "PLS2 benchmark, fixed (n, p, q)"
#   ) +
#   theme_minimal()

