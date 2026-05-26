# Connect project with github and set up package
# Viviana Romero-Alarcon
#'
#' May 18 2026
#'


#installed.packages(c("usethis", "devtools", "roxygen2", "testthat", "desc", "styler", "lintr"))

#usethis::create_package("Guane", rstudio = TRUE, open = TRUE)

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


# Setting up the package first time
usethis::use_roxygen_md()
usethis::use_testthat()
usethis::use_package_doc()
usethis::use_readme_md()
usethis::use_testthat(edition = 3)

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

usethis::use_r("ui_mod_template")
usethis::use_r("server_mod_template")
usethis::use_r("core_template")

usethis::use_r("ui_mod_signal.R")
usethis::use_r("server_mod_signal.R")

usethis::use_r("core_read_data")
usethis::use_r("core_diagnose_data")


# Test

usethis::use_test("core_read_data")
usethis::use_test("core_diagnose_data")
usethis::use_test("core_signal")

# Load packages to the environment

devtools::document()
devtools::load_all()

guane::run_app()

run_app(module = "signal")


# test independency
tree <- ape::rtree(5)

traits <- data.frame(
  species = tree$tip.label,
  body_size = rnorm(5)
)

core_diagnose_tree_traits(tree, traits, "species")
core_signal_summary(traits$body_size)


# # all package checking

devtools::check()


#'#######################   ENVIRONMENT     ############################
#'To restore the R project from R environment:
#' 1 ----- If it is necessary, cloning the repository (Remember i am working on main and master is the public branch
#' Update master before cloning or pulling)
#'
#' 2 ------open the project in Rstudio, the run":

source("renv/activate.R")
renv::restore()


#' it ask for update say yes, if you are sure there is no problem with new packages version
#'
#' 3 ----- Check if libraries matches the lockfile by running

renv::status()

#' Then, project is syncronized
#' 4 ---- run and check packages after restoring envi
#' all packages should pass test without error

devtools::check()

#' If I need new packages or update them I should instal trhough renv

renv::install("packageName")

#' and update the lockfile througth

renv::snapshot()


#' 6 ---- at the end of the day, before committing changes:
#' run docummentation

devtools::document()
devtools::check()
renv::status()

#' then commit in github
#'
#'

#git add DESCRIPTION renv.lock .Rprofile renv/activate.R README.md .gitignore
#git add NAMESPACE man/
#git commit -m "Vyear.month.day.hour"
#git push origin main


########### DESCRIPTION document's structure #######

#Imports -> has all packages required to work properly
#Suggests: -> packages for development, testing, checking or documentation


########### Files that are required in the package for reproducibility #######

#' i must commit them every time

#renv.lock -> version lock for package
#renv/activate.R -> how to activate the environment
#.Rprofile -> instruction for R project
#DESCRIPTION -> decription of mandatory versions
#README.md -> package or project description
#.gitignore -> doc must not submitted to github



#' every time i run devtools::document() devtools::check() renv::status(), i must to
#' commit NAMESPACE
# git add NAMESPACE man/


########### I MUST omit those documents in github #######

#' 7 ----- These should be listed in .gitignore

#renv/library/
#  renv/staging/
#  .Rproj.user/
#  .DS_Store
#guane-renv-test/



