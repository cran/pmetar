context("METAR get")

testthat::skip_if_offline(host = "aviationweather.gov")

x1 <- "EPWA"
x2 <- "CYUL"
x3 <- "MAD"
x4 <- "WAW"

test_that("Check if output is character", {
  expect_equal(is.character(metar_get(x1)), TRUE)
  expect_equal(is.character(metar_get(x2)), TRUE)
  expect_equal(is.character(metar_get(x3)), TRUE)
  expect_equal(is.character(metar_get(x4)), TRUE)
})

x1 <- "aa"
x2 <- "AcdEE"
x4 <- "AAAA"
x5 <- "EPWAa"
x6 <- 123

x <- c(x1, x2, x3, x4, x5, x6)

dx <- data.frame(metar = x)

test_that("Check incorrect inputs", {
  expect_equal(metar_get(x1), "No METAR found!")
  expect_equal(metar_get(x2), "No METAR found!")
  expect_equal(metar_get(x4), "No METAR found!")
  expect_equal(metar_get(x5), "No METAR found!")
  expect_equal(metar_get(x6), "No METAR found!")
  expect_error(metar_get(x))
  expect_error(metar_get(dx$metar))
})

x3 <- "a "
dxt <- tibble::as_tibble(dx)

test_that("Check invalid input format", {
  expect_error(metar_get(x3))
  expect_error(metar_get(dx))
  expect_error(metar_get(dxt))
})

