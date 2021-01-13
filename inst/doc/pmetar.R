## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  tidy = FALSE
)

## ----get a METAR report with ICAO code----------------------------------------
library(dplyr)
library(pmetar)
metar_get("EPWA")

## ----get a METAR report with IATA code----------------------------------------
metar_get("EWR")

## -----------------------------------------------------------------------------
dm <- metar_get_historical("JFK", start_date = "2020-06-25", end_date = "2020-06-29", from = "iastate")
head(dm)

## ---- eval = FALSE------------------------------------------------------------
#  metar_get_historical("JFK", start_date = "2020-06-25", end_date = "2020-06-29", from = "ogimet")

## -----------------------------------------------------------------------------
(dm[length(dm)])
my_report <- substr(dm[length(dm)], 14, nchar(dm[length(dm)]))
my_report

## -----------------------------------------------------------------------------
metar_airport(my_report)

## -----------------------------------------------------------------------------
metar_location(metar_airport(my_report))

## -----------------------------------------------------------------------------
metar_day(my_report)
metar_hour(my_report)
metar_time_zone(my_report)

## -----------------------------------------------------------------------------
metar_dir(my_report)
metar_speed(my_report, metric = TRUE)
metar_speed(my_report, metric = FALSE)

## -----------------------------------------------------------------------------
variable_direction_METAR <- "EPWA 281830Z 18009KT 140V200 9999 SCT037 03/M01 Q1008 NOSIG"
metar_dir(variable_direction_METAR)

## -----------------------------------------------------------------------------
metar_dir(variable_direction_METAR, numeric_only = TRUE)

## -----------------------------------------------------------------------------
metar_visibility(my_report, metric = TRUE)
metar_visibility(my_report, metric = FALSE)

## -----------------------------------------------------------------------------
metarWXcodes

## -----------------------------------------------------------------------------
metar_wx_codes(my_report)

## -----------------------------------------------------------------------------
metar_wx_codes("202002022205 METAR KEWR 022205Z AUTO 24008KT 6SM -RA -SN BR SCT006 BKN014 OVC024 02/01 A2954 RMK T00200010 MADISHF")

## -----------------------------------------------------------------------------
metar_cloud_coverage(my_report)

## -----------------------------------------------------------------------------
metar_temp(my_report)

## -----------------------------------------------------------------------------
metar_dew_point(my_report)

## -----------------------------------------------------------------------------
metar_temp("202001010851 METAR KEWR 010851Z 27010KT 10SM FEW030 BKN070 BKN100 BKN210 04/M03 A2969 RMK SLP054 T00391033 52012")
metar_dew_point("202001010851 METAR KEWR 010851Z 27010KT 10SM FEW030 BKN070 BKN100 BKN210 04/M03 A2969 RMK SLP054 T00391033 52012")

## -----------------------------------------------------------------------------
metar_pressure(my_report)

## -----------------------------------------------------------------------------
metar_pressure("EPWA 281830Z 18009KT 140V200 9999 SCT037 03/M01 Q1008 NOSIG")

## -----------------------------------------------------------------------------
metar_pressure("EPWA 281830Z 18009KT 140V200 9999 SCT037 03/M01 Q1008 NOSIG", altimeter = TRUE)

## -----------------------------------------------------------------------------
metar_windshear("CYWG 172000Z 30015G25KT 3/4SM R36/4000FT/D -SN BLSN BKN008 OVC040 M05/M08 A2992 REFZRA WS RWY36 RMK SF5NS3 SLP134")

## -----------------------------------------------------------------------------
metar_rwy_visibility("CYWG 172000Z 30015G25KT 3/4SM R36/4000FT/D -SN BLSN BKN008 OVC040 M05/M08 A2992 REFZRA WS RWY36 RMK SF5NS3 SLP134")

## -----------------------------------------------------------------------------
metar_rwy_visibility("CYWG 172000Z 30015G25KT 3/4SM R36/4000FT/D -SN BLSN BKN008 OVC040 M05/M08 A2992 REFZRA WS RWY36 RMK SF5NS3 SLP134",
                     metric = FALSE)

## -----------------------------------------------------------------------------
head(dm)

## -----------------------------------------------------------------------------
decoded_metars <- metar_decode(dm)

## -----------------------------------------------------------------------------
names(decoded_metars)

## -----------------------------------------------------------------------------
print.data.frame(head(decoded_metars))

## -----------------------------------------------------------------------------
if (!grepl('SunOS',Sys.info()['sysname'])){
  decoded_metars %>% as_tibble %>% rmarkdown::paged_table()  
}

