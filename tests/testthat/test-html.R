test_that("build_404 creates correct 404 page", {
  skip_on_cran()
  skip_if_not_pandoc()

  tmp_dir <- withr::local_tempdir()
  withr::local_dir(tmp_dir)

  # default page
  expect_false(file.exists("404.html"))
  expect_null(build_404()$rmd_cur)
  expect_false(file.exists("404.html"))

  # custom pages
  xfun::write_utf8(c("# Page not found", "", "I am created with _404.Rmd"), "_404.Rmd")
  build_404()
  expect_true(file.exists("404.html"))
  expect_match(xfun::file_string("404.html"), "I am created with _404.Rmd", fixed = TRUE)

  # do nothing if one exist
  expect_null(build_404()$html)

  unlink(c("404.html", "_404.Rmd"))

  xfun::write_utf8(c("# Page not found", "", "I am created with _404.md"), "_404.md")
  build_404()
  expect_true(file.exists("404.html"))
  expect_match(xfun::file_string("404.html"), "I am created with _404.md", fixed = TRUE)
})

test_that("add_toc_class() adds the class on correct toc element", {
  toc <- "<li><a href=\"06-share.html#sharing-your-book\"><span class=\"toc-section-number\">7</span> Sharing your book</a><ul>"
  expect_match(add_toc_class(toc), '^<li class="has-sub">')
  toc <- "<li><a href=\"06-share.html#sharing-your-book\"><span class=\"toc-section-number\">7</span> Sharing your book</a>"
  expect_match(add_toc_class(toc), '^<li class="has-sub">')
  toc <- "<li><a href=\"03-parts.html#parts\"><span class=\"toc-section-number\">4</span> Parts</a></li>"
  expect_no_match(add_toc_class(toc), '^<li class="has-sub">')
})

test_that("add_toc_class() works for all pandoc versions", {
  skip_on_cran()
  skip_if_not_pandoc()
  skip_if_not_installed("xml2")
  md <- withr::local_tempfile(fileext = ".md")
  html <- withr::local_tempfile(fileext = ".html")
  xfun::write_utf8(c("# h1", "## h2", "# h12", "# h13", "## h34"), md)
  rmarkdown::pandoc_convert(md, to = "html4", from = "markdown",
                            options = c("--toc", "-s", rmarkdown::pandoc_metadata_arg("title", "test")),
                            output = html)
  res <- add_toc_class(xfun::read_utf8(html))
  xml2::write_html(xml2::xml_find_first(
    xml2::read_html(paste(res, collapse = "\n")),
    "//div[@id = 'TOC']"
  ), html)
  pandoc_version <- ifelse(rmarkdown::pandoc_available("2.8"), "post2.8", "pre2.8")
  expect_snapshot_file(html, name = "toc-has-sub.html", variant = pandoc_version, compare = compare_file_text)
})
