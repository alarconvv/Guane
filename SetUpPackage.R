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


