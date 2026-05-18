# Connect project with github and set up package
# Viviana Romero-Alarcon
#'
#' May 18 2026
#'

#Libraries
install.packages(c(
  "usethis",
  "devtools",
  "roxygen2",
  "testthat",
  "desc",
  "styler",
  "lintr"
))


# mane the project a git repo
usethis::use_git()

# Connect with repo
usethis::use_git_remote(name = "origin", url = "https://github.com/alarconvv/Guane.git")


# Setting up the package
usethis::use_roxygen_md()
usethis::use_testthat()
usethis::use_package_doc()
usethis::use_readme_md()



## Add packages
usethis::use_package("shiny")
usethis::use_package("bslib")
usethis::use_package("ape")
usethis::use_package("phytools")
usethis::use_package("geiger")
usethis::use_package("nlme")
usethis::use_package("dplyr")
usethis::use_package("readr")
usethis::use_package("readxl")
usethis::use_package("jsonlite")
usethis::use_package("shinyAce")
usethis::use_package("shiny.i18n")
usethis::use_package("rlang")
usethis::use_package("cli")
usethis::use_package("checkmate")

# Dependences for development
usethis::use_package("testthat", type = "Suggests")
usethis::use_package("devtools", type = "Suggests")
usethis::use_package("roxygen2", type = "Suggests")

# Lisence
usethis::use_gpl_license(version = 3, include_future = TRUE)


# I will keep two branches for this repo
#-----------------------------------------

# main = develop
# master = stable version

# Create modules
# Create R executables files
usethis::use_r("app_factory")
usethis::use_r("module_registry")
usethis::use_r("mod_signal")
usethis::use_r("run_app.R")

# Do documentation
devtools::document()
devtools::load_all()
