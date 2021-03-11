
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sigterm

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/sigterm)](https://CRAN.R-project.org/package=sigterm)
[![R-CMD-check](https://github.com/atheriel/sigterm/workflows/R-CMD-check/badge.svg)](https://github.com/atheriel/sigterm/actions)
<!-- badges: end -->

On Unix-like operating systems, a process can be sent the `SIGTERM`
signal to initiate a graceful shutdown. This is widely used by container
platforms like Docker and Kubernetes. But for R, this abruptly ends the
process – no `on.exit()` handlers will run for the current function, no
finalizers will be triggered, nor will the `.Last()` handler be called.

This makes it hard to write R programs that clean up after themselves
when asked, for example closing network or database connections, writing
intermediate outputs to file, or finishing in-progress work that is
difficult to restart.

**sigterm** is an extremely simple package that provides a way to
implement just these kinds of operations in response to `SIGTERM`: when
the package is loaded, it will install a signal handler that prevents R
from immediately exiting. Users can then periodically check whether a
`SIGTERM` signal has been received and respond appropriately.

## Installation

**sigterm** is not yet available on [CRAN](https://CRAN.R-project.org).
You can install it from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("atheriel/sigterm")
```

## Usage

**sigterm** has only one exported function:

``` r
library(sigterm)
#> Installed the SIGTERM handler.
has_sigterm_flag()
#> [1] FALSE
```

This function will return `TRUE` when R has received the signal, for
example when sent through the shell:

``` r
system2("kill", c("-TERM", Sys.getpid()))
has_sigterm_flag()
#> [1] TRUE
```

Keep in mind that this package prevents R from exiting at all. You may
want to call `quit()` to do so instead, or simply return from the
current function or loop; it will depend on the context.

For example:

``` r
for (i in 1:100) {
  # Do some important work that should not be interrupted mid-task.
  
  if (has_sigterm_flag()) {
    message("Shutting down after task ", i, "...")
    break
  }
}
#> Shutting down after task 1...
```

Simply refusing to shut down will probably result in the process being
sent `SIGKILL` after some timeout (30 seconds by default in Kubernetes),
which cannot be caught and will terminate R immediately.

## License

Copyright 2021 Aaron Jacobs

Licensed under the Apache License, Version 2.0 (the “License”); you may
not use this file except in compliance with the License. You may obtain
a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an “AS IS” BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
