#' Check Whether R Has Received SIGTERM
#'
#' @description
#'
#' On Unix-like operating systems, a process can be sent the `SIGTERM` signal
#' to initiate a graceful shutdown. By default in R, this ends the process.
#' However, when this package is loaded, we install a signal handler that
#' prevents this from happening and instead allows the user to check for the
#' signal with this function.
#'
#' On Windows, this function will always return `NA`.
#'
#' @return `TRUE` if R has received `SIGTERM` and `FALSE` if it has not. If
#'   `SIGTERM` is not available (e.g. on Windows), the return value is `NA`
#'   instead.
#'
#' @export
has_sigterm_flag <- function() {
  .Call("R_has_sigterm_flag", PACKAGE = "sigterm")
}

.onLoad <- function(libname, pkgname) {
  if (.Call("R_install_handler", PACKAGE = "sigterm")) {
    packageStartupMessage("Installed the SIGTERM handler.")
  }
}

#' @useDynLib sigterm, .registration = TRUE
NULL
