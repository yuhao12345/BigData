-- This file will create an ORC table with trip

-- First, map the CSV data we downloaded in Hive
create external table yuhaok_weather_csv(
  STATION string,
  NAME string,
  day date,
  AWND decimal,
  FMTM decimal,
  PGTM decimal,
  PRCP decimal,
  SNOW decimal,
  SNWD decimal,
  TAVG decimal,
  TMAX decimal,
  TMIN decimal,
  TSUN decimal,
  WDF2 decimal,
  WDF5 decimal,
  WSF2 decimal,
  WSF5 decimal,
  WT01 decimal,
  WT02 decimal,
  WT03 decimal,
  WT04 decimal,
  WT05 decimal,
  WT06 decimal,
  WT07 decimal,
  WT08 decimal,
  WT09 decimal,
  WT11 decimal,
  WT13 decimal,
  WT14 decimal,
  WT16 decimal,
  WT17 decimal,
  WT18 decimal,
  WT19 decimal,
  WT22 decimal)
  row format serde 'org.apache.hadoop.hive.serde2.OpenCSVSerde'

WITH SERDEPROPERTIES (
   "separatorChar" = "\,",
   "quoteChar"     = "\""
)
STORED AS TEXTFILE
  location '/yuhaok/weather';

-- Run a test query to make sure the above worked correctly
select * from yuhaok_weather_csv limit 2;

-- Create an ORC table for trip data (Note "stored as ORC" at the end)
create table yuhaok_weather(
  STATION string,
  NAME string,
  day date,
  AWND decimal,
  FMTM decimal,
  PGTM decimal,
  PRCP decimal,
  SNOW decimal,
  SNWD decimal,
  TAVG decimal,
  TMAX decimal,
  TMIN decimal,
  TSUN decimal,
  WDF2 decimal,
  WDF5 decimal,
  WSF2 decimal,
  WSF5 decimal,
  WT01 decimal,
  WT02 decimal,
  WT03 decimal,
  WT04 decimal,
  WT05 decimal,
  WT06 decimal,
  WT07 decimal,
  WT08 decimal,
  WT09 decimal,
  WT11 decimal,
  WT13 decimal,
  WT14 decimal,
  WT16 decimal,
  WT17 decimal,
  WT18 decimal,
  WT19 decimal,
  WT22 decimal)
  stored as orc;

-- Copy the CSV table to the ORC table
insert overwrite table yuhaok_weather select * from yuhaok_weather_csv;