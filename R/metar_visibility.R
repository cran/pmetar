#' Get visibility information.
#'
#' Extract and parse visibility information from METAR weather report.
#'
#' @param x character vector; a METAR weather report or reports.
#' @param metric For the default metric = TRUE returned distances are in meters. If it's FALSE, in miles.
#' @param numeric_only logical; if TRUE only a numeric value will be returned
#'
#' @return a numeric vector with visibility information, in meters or miles.
#'
#' @export
#'
#' @examples
#' metar_visibility("EPWA 281830Z 18009KT 140V200 9999 SCT037 03/M01 Q1008 NOSIG")
#' metar_visibility("CYUL 281800Z 13008KT 30SM BKN240 01/M06 A3005 RMK CI5 SLP180")
#' metar_visibility("201711271930 METAR LEMD 271930Z 02002KT CAVOK 04/M03 Q1025")
#' metar_visibility("KBLV 011657Z AUTO 25015G30KT 210V290 3/8SM R32L/1000FT FG
#' BKN005 01/M01 A2984")
#'
metar_visibility <- function(x, metric = TRUE, numeric_only = FALSE) {
  # check if x is a data frame
  if(is.data.frame(x)){
    stop("pmetar package error: Invalid input format! Argument is not an atomic vector.", call. = FALSE)
  }
  # define conversion coefficients
  if(metric){
    cfm <- 1
    cfi <- 1609.344
    p_text <- " meters"
  } else {
    cfm <- 1/1609.344
    cfi_height <- 1
    cfi <- 1
    p_text <- " miles"
  }
  out <- c(1:length(x))
  out[1:length(x)] <- NA
  # Remove part after RMK
  x <- stringr::str_split_fixed(x, pattern = "RMK", n = 2)[,1]
  # Remove part after TEMPO
  x <- stringr::str_split_fixed(x, pattern = "TEMPO", n = 2)[,1]
  # cases like 1 3/4SM
  fT <- stringr::str_detect(x, pattern = "\\s\\d\\s\\d\\/\\dSM\\s")
  out[fT] <- round((as.numeric(stringr::str_extract(stringr::str_extract(x[fT], pattern = "\\s\\d\\s\\d\\/\\dSM\\s"), pattern = "\\s\\d\\s")) +
                   as.numeric(stringr::str_sub(stringr::str_extract(stringr::str_extract(x[fT], pattern = "\\s\\d\\s\\d\\/\\dSM\\s"), pattern = "\\d\\/"), 1, 1)) /
                   as.numeric(stringr::str_sub(stringr::str_extract(stringr::str_extract(x[fT], pattern = "\\s\\d\\s\\d\\/\\dSM\\s"), pattern = "\\/\\d"), -1, -1))) * cfi,
                   2)
  # cases like 3/4SM
  fT2 <- stringr::str_detect(x, pattern = "\\s\\d\\/\\dSM\\s")
  fT <- !(fT & fT2)
  out[fT] <- round((as.numeric(stringr::str_sub(stringr::str_extract(x[fT], pattern = "\\s\\d\\/\\dSM\\s"), 2, 2)) /
                   as.numeric(stringr::str_sub(stringr::str_extract(x[fT], pattern = "\\s\\d\\/\\dSM\\s"), 4, 4))) * cfi, 2)
  fT <- stringr::str_detect(x, pattern = "\\s\\d{4}\\s")
  out[fT] <- round(as.numeric(stringr::str_sub(stringr::str_extract(x[fT], pattern = "\\s\\d{4}\\s"), 2, 5)) * cfm, 2)
  fT <- stringr::str_detect(x, pattern = "\\s[\\d]+SM\\s")
  out[fT] <- round(as.numeric(stringr::str_sub(stringr::str_extract(x[fT], pattern = "\\s[\\d]+SM\\s"), 1, -4)) * cfi, 2)
  # CAVOK - Ceiling And Visibility OK, indicating no cloud below 5,000 ft (1,500 m) or
  # the highest minimum sector altitude and no cumulonimbus or towering cumulus at any level,
  # a visibility of 10 km (6 mi) or more and no significant weather change
  fT <- stringr::str_detect(x, pattern = "CAVOK")  

  if (numeric_only) {
    # CAVOK first
    out[fT] <- round(10000.00 * cfm, 2)
    # cases like P6SM
    fT <- stringr::str_detect(x, pattern = "\\sP[\\d]+SM\\s")
    out[fT] <- round(as.numeric(stringr::str_sub(stringr::str_remove(stringr::str_extract(x[fT], pattern = "\\sP[\\d]+SM\\s"), pattern = "P"), 1, -4)) * cfi, 2)
    # cases like P3/4SM
    fT <- stringr::str_detect(x, pattern = "\\sP\\d\\/\\dSM\\s")
    out[fT] <- round((as.numeric(stringr::str_sub(stringr::str_extract(x[fT], pattern = "\\sP\\d\\/\\dSM\\s"), 3, 3)) /
                        as.numeric(stringr::str_sub(stringr::str_extract(x[fT], pattern = "\\sP\\d\\/\\dSM\\s"), 5, 5))) * cfi, 2)
    # cases like P9000
    fT <- stringr::str_detect(x, pattern = "\\sP\\d{4}\\s")
    out[fT] <- round(as.numeric(stringr::str_sub(stringr::str_extract(x[fT], pattern = "\\sP\\d{4}\\s"), 3, 6)) * cfm, 2)
  } else {
    # CAVOK first
    out[fT] <- "Ceiling And Visibility OK"
    # cases like P6SM
    fT <- stringr::str_detect(x, pattern = "\\sP[\\d]+SM\\s")
    out[fT] <- paste0("greater than ",
                      round(as.numeric(stringr::str_sub(stringr::str_remove(stringr::str_extract(x[fT], pattern = "\\sP[\\d]+SM\\s"), pattern = "P"), 1, -4)) * cfi, 2),
                      p_text)
    # cases like P3/4SM
    fT <- stringr::str_detect(x, pattern = "\\sP\\d\\/\\dSM\\s")
    out[fT] <- paste0("greater than ",
                      round((as.numeric(stringr::str_sub(stringr::str_extract(x[fT], pattern = "\\sP\\d\\/\\dSM\\s"), 3, 3)) /
                        as.numeric(stringr::str_sub(stringr::str_extract(x[fT], pattern = "\\sP\\d\\/\\dSM\\s"), 5, 5))) * cfi, 2),
                      p_text)
    # cases like P9000
    fT <- stringr::str_detect(x, pattern = "\\sP\\d{4}\\s")
    out[fT] <- paste0("greater than ",
                      round(as.numeric(stringr::str_sub(stringr::str_extract(x[fT], pattern = "\\sP\\d{4}\\s"), 3, 6)) * cfm, 2),
                      p_text)
  }
  out
}
