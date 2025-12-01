## ----setup_ops, include = FALSE-----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.path = "figures/auto-selection-",
  fig.width = 7,
  fig.height = 5,
  dpi = 150,
  message = FALSE,
  warning = FALSE
)

LOCAL <- identical(Sys.getenv("LOCAL"), "TRUE")
set.seed(2025)

## ----echo=FALSE, message=FALSE------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")

