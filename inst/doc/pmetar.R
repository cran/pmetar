## ----label = "set options", include = FALSE-----------------------------------
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

## ----label = "get historical METAR reports from JFK", eval = FALSE------------
# dm <- metar_get_historical("JFK", start_date = "2020-06-27", end_date = "2020-06-29", from = "iastate")

## ----label = "create dm offline", echo = FALSE--------------------------------
dm <- c("202006270000 METAR KJFK 270000Z AUTO 19007KT 10SM CLR 23/18 A2990 RMK T02300180 MADISHF",
        "202006270005 METAR KJFK 270005Z AUTO 19008KT 10SM CLR 24/18 A2990 RMK T02400180 MADISHF",
        "202006270010 METAR KJFK 270010Z AUTO 20008KT 10SM CLR 24/18 A2990 RMK T02400180 MADISHF",
        "202006270015 METAR KJFK 270015Z AUTO 21005KT 10SM FEW110 24/18 A2990 RMK T02400180 MADISHF",
        "202006270020 METAR KJFK 270020Z AUTO 21005KT 10SM SCT110 24/18 A2990 RMK T02400180 MADISHF",
        "202006270025 METAR KJFK 270025Z AUTO 23008KT 10SM SCT110 24/17 A2990 RMK T02400170 MADISHF")

## ----label = "show head of dm"------------------------------------------------
head(dm)

## ----label = "example for Ogimet", eval = FALSE-------------------------------
# metar_get_historical("JFK", start_date = "2020-06-27", end_date = "2020-06-29", from = "ogimet")

## ----checking the syntax of reports-------------------------------------------
metar_is_correct(dm[1:5])

## ----adding one incorrect report----------------------------------------------
dc <- c(dm[1:5],
        "202006261625 SPEC KJFK 261625Z AUTO 28009KT 10SM CLR 30/12 A2995 RMK T03000120")
metar_is_correct(dc)

## -----------------------------------------------------------------------------
dc[!metar_is_correct(dc)]

## ----checking the syntax of reports with verbose------------------------------
metar_is_correct(dc, verbose = TRUE)

## ----remove dates at the begining of reports----------------------------------
(dm[length(dm)])
my_report <- substr(dm[length(dm)], 14, nchar(dm[length(dm)]))
my_report

## ----find airport-------------------------------------------------------------
metar_airport(my_report)

## ----find location------------------------------------------------------------
metar_location(metar_airport(my_report))

## ----find day time and zone---------------------------------------------------
metar_day(my_report)
metar_hour(my_report)
metar_time_zone(my_report)

## ----find dir and speed-------------------------------------------------------
metar_dir(my_report)
metar_speed(my_report, metric = TRUE)
metar_speed(my_report, metric = FALSE)

## ----variable direction-------------------------------------------------------
variable_direction_METAR <- "EPWA 281830Z 18009KT 140V200 9999 SCT037 03/M01 Q1008 NOSIG"
metar_dir(variable_direction_METAR)

## ----numeric only variable----------------------------------------------------
metar_dir(variable_direction_METAR, numeric_only = TRUE)

## ----find visibility----------------------------------------------------------
metar_visibility(my_report, metric = TRUE)
metar_visibility(my_report, metric = FALSE)

## ----find visibility CAVOK----------------------------------------------------
metar_visibility("201711271930 METAR LEMD 271930Z 02002KT CAVOK 04/M03 Q1025 NOSIG= NOSIG=")
metar_visibility("201711271930 METAR LEMD 271930Z 02002KT CAVOK 04/M03 Q1025 NOSIG= NOSIG=", numeric_only = TRUE)

## ----find visibility PdSM-----------------------------------------------------
metar_visibility("200005120845 METAR METAR MMGL 120845Z 27005KT P6SM FEW230 18/04 A3012 RMK 00190 062 903", metric = FALSE)
metar_visibility("200005120845 METAR METAR MMGL 120845Z 27005KT P6SM FEW230 18/04 A3012 RMK 00190 062 903", metric = FALSE, numeric_only = TRUE)

## ----weather condition codes--------------------------------------------------
metarWXcodes

## ----find weather conditions--------------------------------------------------
metar_wx_codes(my_report)

## -----------------------------------------------------------------------------
metar_wx_codes("202002022205 METAR KEWR 022205Z AUTO 24008KT 6SM -RA -SN BR SCT006 BKN014 OVC024 02/01 A2954 RMK T00200010 MADISHF")

## ----cloud coverage-----------------------------------------------------------
metar_cloud_coverage(my_report)

## ----find tempreature---------------------------------------------------------
metar_temp(my_report)

## ----find dew point-----------------------------------------------------------
metar_dew_point(my_report)

## ----find temperature after RMK-----------------------------------------------
metar_temp("202001010851 METAR KEWR 010851Z 27010KT 10SM FEW030 BKN070 BKN100 BKN210 04/M03 A2969 RMK SLP054 T00391033 52012")
metar_dew_point("202001010851 METAR KEWR 010851Z 27010KT 10SM FEW030 BKN070 BKN100 BKN210 04/M03 A2969 RMK SLP054 T00391033 52012")

## ----find pressure------------------------------------------------------------
metar_pressure(my_report)

## ----find pressure hPa--------------------------------------------------------
metar_pressure("EPWA 281830Z 18009KT 140V200 9999 SCT037 03/M01 Q1008 NOSIG")

## ----find pressure inHg-------------------------------------------------------
metar_pressure("EPWA 281830Z 18009KT 140V200 9999 SCT037 03/M01 Q1008 NOSIG", altimeter = TRUE)

## ----find wind shear----------------------------------------------------------
metar_windshear("CYWG 172000Z 30015G25KT 3/4SM R36/4000FT/D -SN BLSN BKN008 OVC040 M05/M08 A2992 REFZRA WS RWY36 RMK SF5NS3 SLP134")

## ----find runway visibility in m----------------------------------------------
metar_rwy_visibility("CYWG 172000Z 30015G25KT 3/4SM R36/4000FT/D -SN BLSN BKN008 OVC040 M05/M08 A2992 REFZRA WS RWY36 RMK SF5NS3 SLP134")

## ----find runway visibility in ft---------------------------------------------
metar_rwy_visibility("CYWG 172000Z 30015G25KT 3/4SM R36/4000FT/D -SN BLSN BKN008 OVC040 M05/M08 A2992 REFZRA WS RWY36 RMK SF5NS3 SLP134",
                     metric = FALSE)

## -----------------------------------------------------------------------------
head(dm)

## ----decode metars------------------------------------------------------------
decoded_metars <- metar_decode(dm)

## ----columns names------------------------------------------------------------
names(decoded_metars)

## -----------------------------------------------------------------------------
print.data.frame(head(decoded_metars))

## ----handling incorrect reports-----------------------------------------------
metar_decode(dc)

## ----example of metar_print---------------------------------------------------
metar_print(dm[1])

