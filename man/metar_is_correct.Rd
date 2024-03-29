% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/metar_is_correct.R
\name{metar_is_correct}
\alias{metar_is_correct}
\title{Check if METAR report is correct.}
\usage{
metar_is_correct(x, verbose = FALSE)
}
\arguments{
\item{x}{character vector; METAR weather report or reports.}

\item{verbose}{logical; default FALSE}
}
\value{
if verbose = FALSE, TRUE if a METAR is correct, FALSE if not.

if verbose = TRUE, all incorrect METAR reports will be printed
}
\description{
Function checks METRAR reports syntax.
}
\details{
It checks:\cr
appearance of not allowed characters: ! \ ? . , ; : * # & ' " ) and
multiple slash characters\cr
wind speed syntax\cr
wind direction syntax\cr
pressure syntax\cr
air and dew point temperature syntax\cr
if an airport code is the first element or appear
immediately after METAR, SPECI, METAR COR ro SPECI COR.
}
\examples{
metar_is_correct("EPWA 281830Z 18009KT 140V200 9999 SCT037 03/M01 Q1008 NOSIG")
metar_is_correct("CYUL 281800Z 13008KT 30SM BKN240 01/M06 A3005 RMK CI5! SLP180")
metar_is_correct("201711271930 METAR LEMD 271930Z 02002KT CAVOK 04//M03 Q1025")

}
