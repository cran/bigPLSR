## -----------------------------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment  = "#>",
  fig.path = "figures/benchmark-long-",
  fig.width  = 6.5,
  fig.height = 4.5,
  dpi = 150,
  message = FALSE,
  warning = FALSE
)

LOCAL <- identical(Sys.getenv("LOCAL"), "TRUE")

## ----eval=LOCAL, cache=TRUE---------------------------------------------------
library(bigPLSR)
library(ggplot2)
library(dplyr)
library(tidyr)
library(forcats)

data("external_pls_benchmarks", package = "bigPLSR")

head(external_pls_benchmarks)

## ----eval=LOCAL, cache=TRUE---------------------------------------------------
bench <- external_pls_benchmarks %>%
  mutate(
    mem_mib      = mem_alloc_bytes / 1024^2,
    log_time     = log10(median_time_s),
    log_mem_mib  = log10(pmax(mem_mib, 1e-6)),
    impl         = paste(package, algorithm, sep = "::")
  )

## ----eval=LOCAL, cache=TRUE---------------------------------------------------
pls1_sizes <- bench %>%
  filter(task == "pls1") %>%
  count(n, p, q, sort = TRUE)

pls1_sizes

## ----eval=LOCAL, cache=TRUE---------------------------------------------------
size_pls1 <- pls1_sizes %>% slice(1L) %>% select(n, p, q)

pls1_subset <- bench %>%
  semi_join(size_pls1, by = c("n", "p", "q")) %>%
  filter(task == "pls1")

## ----eval=LOCAL, cache=TRUE---------------------------------------------------
ggplot(pls1_subset,
       aes(x = ncomp, y = median_time_s,
           colour = package, linetype = algorithm)) +
  geom_line() +
  geom_point() +
  scale_y_log10() +
  labs(
    x = "Number of components",
    y = "Median runtime (seconds, log scale)",
    title = "PLS1: fixed data size, varying components"
  ) +
  theme_minimal()

## ----eval=LOCAL, cache=TRUE---------------------------------------------------
ggplot(pls1_subset,
       aes(x = ncomp, y = mem_mib,
           colour = package, linetype = algorithm)) +
  geom_line() +
  geom_point() +
  labs(
    x = "Number of components",
    y = "Memory allocated (MiB)",
    title = "PLS1: fixed data size, memory behaviour"
  ) +
  theme_minimal()

## ----eval=LOCAL, cache=TRUE---------------------------------------------------
reference_impl <- "pls::simpls"

## 1) Reference rows for pls1
refs_pls1 <- bench %>%
  filter(task == "pls1", impl == reference_impl) %>%
  select(
    n, p, q, ncomp,
    time_ref = median_time_s,
    mem_ref  = mem_mib
  )

## 2) Join and compute ratios (only where a reference exists)
ratios_pls1 <- bench %>%
  filter(task == "pls1") %>%
  left_join(refs_pls1, by = c("n", "p", "q", "ncomp")) %>%
  filter(!is.na(time_ref), !is.na(mem_ref)) %>%
  mutate(
    rel_time = median_time_s / time_ref,
    rel_mem  = mem_mib      / mem_ref
  )

ggplot(ratios_pls1,
       aes(x = impl, y = rel_time)) +
  geom_hline(yintercept = 1, linetype = "dashed", colour = "grey50") +
  geom_boxplot() +
  coord_flip() +
  scale_y_log10() +
  labs(
    x = "Implementation",
    y = "Runtime ratio vs reference (log scale)",
    title = "PLS1: runtime ratios relative to pls::simpls"
  ) +
  theme_minimal()

## ----eval=LOCAL, cache=TRUE---------------------------------------------------
ggplot(ratios_pls1,
       aes(x = impl, y = rel_mem)) +
  geom_hline(yintercept = 1, linetype = "dashed", colour = "grey50") +
  geom_boxplot() +
  coord_flip() +
  scale_y_log10() +
  labs(
    x = "Implementation",
    y = "Memory ratio vs reference (log scale)",
    title = "PLS1: memory ratios relative to pls::simpls"
  ) +
  theme_minimal()

## ----eval=LOCAL, cache=TRUE---------------------------------------------------
pls2_sizes <- bench %>%
  filter(task == "pls2") %>%
  count(n, p, q, sort = TRUE)

pls2_sizes

## ----eval=LOCAL, cache=TRUE---------------------------------------------------
size_pls2 <- pls2_sizes %>% slice(1L) %>% select(n, p, q)

pls2_subset <- bench %>%
  semi_join(size_pls2, by = c("n", "p", "q")) %>%
  filter(task == "pls2")

## ----eval=LOCAL, cache=TRUE---------------------------------------------------
ggplot(pls2_subset,
       aes(x = ncomp, y = median_time_s,
           colour = package, linetype = algorithm)) +
  geom_line() +
  geom_point() +
  scale_y_log10() +
  labs(
    x = "Number of components",
    y = "Median runtime (seconds, log scale)",
    title = "PLS2: fixed data size, varying components"
  ) +
  theme_minimal()

## ----eval=LOCAL, cache=TRUE---------------------------------------------------
ggplot(pls2_subset,
       aes(x = ncomp, y = mem_mib,
           colour = package, linetype = algorithm)) +
  geom_line() +
  geom_point() +
  labs(
    x = "Number of components",
    y = "Memory allocated (MiB)",
    title = "PLS2: fixed data size, memory behaviour"
  ) +
  theme_minimal()

## ----eval=LOCAL, cache=TRUE---------------------------------------------------
pls2_q_grid <- bench %>%
  filter(task == "pls2") %>%
  count(n, p, q, sort = TRUE)

head(pls2_q_grid)

## ----eval=LOCAL, cache=TRUE---------------------------------------------------
grid_example <- pls2_q_grid %>%
  slice(1L) %>%
  select(n, p)

pls2_q_subset <- bench %>%
  semi_join(grid_example, by = c("n", "p")) %>%
  filter(task == "pls2", ncomp == max(ncomp))

ggplot(pls2_q_subset,
       aes(x = q, y = median_time_s,
           colour = package, linetype = algorithm)) +
  geom_line() +
  geom_point() +
  scale_y_log10() +
  labs(
    x = "Number of responses q",
    y = "Median runtime (seconds, log scale)",
    title = "PLS2: influence of q at fixed n and p"
  ) +
  theme_minimal()

## ----eval=LOCAL, cache=TRUE---------------------------------------------------
bench_kernel <- bench %>%
  filter(algorithm %in% c("kernelpls", "widekernelpls"))

## ----eval=LOCAL, cache=TRUE---------------------------------------------------
kern_pls1 <- bench_kernel %>% filter(task == "pls1")

ggplot(kern_pls1,
       aes(x = n, y = median_time_s,
           colour = package, linetype = algorithm)) +
  geom_line() +
  geom_point() +
  scale_y_log10() +
  labs(
    x = "Number of observations n",
    y = "Median runtime (seconds, log scale)",
    title = "Kernel PLS1: scaling with n"
  ) +
  theme_minimal()

