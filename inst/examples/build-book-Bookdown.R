# confirm im in bookdown repo dir
getwd()

# render bookdown to pdf
# bookdown::render_book(
#   input = "inst/examples/index.Rmd",
#   output_format = "pdf_book",
#   output_dir = "inst"
# ) # FAIL -- i was in inst/ and i should have been in inst/examples/

# cd to inst dir
setwd("inst/examples/")
getwd()

# try to render again
bookdown::render_book(
  input = "index.Rmd",
  output_format = "bookdown::pdf_book"
)

# TRY - https://github.com/brentthorne/posterdown/issues/42
# install tinytex and update tlmgr
library(tinytex)
tlmgr_update() # didnt work - ERROR

capabilities()
