-- This file will create an ORC table with trip

-- First, map the CSV data we downloaded in Hive
create external table yuhaok_trip_csv(
  VendorID smallint,
  tpep_pickup_datetime timestamp,
  tpep_dropoff_datetime timestamp,
  passenger_count tinyint,
  trip_distance decimal,
  RatecodeID smallint,
  store_and_fwd_flag string,
  PULocationID smallint,
  DOLocationID smallint,
  payment_type tinyint,
  fare_amount decimal,
  extra decimal,
  mta_tax decimal,
  tip_amount decimal,
  tolls_amount decimal,
  improvement_surcharge decimal,
  total_amount decimal,
  congestion_surcharge decimal)
  row format serde 'org.apache.hadoop.hive.serde2.OpenCSVSerde'

WITH SERDEPROPERTIES (
   "separatorChar" = "\,",
   "quoteChar"     = "\""
)
STORED AS TEXTFILE
  location '/yuhaok/trip';

-- Run a test query to make sure the above worked correctly
select * from yuhaok_trip_csv limit 2;

-- Create an ORC table for trip data (Note "stored as ORC" at the end)
create table yuhaok_trip(
  VendorID smallint,
  tpep_pickup_datetime timestamp,
  tpep_dropoff_datetime timestamp,
  passenger_count tinyint,
  trip_distance decimal,
  RatecodeID smallint,
  store_and_fwd_flag string,
  PULocationID smallint,
  DOLocationID smallint,
  payment_type tinyint,
  fare_amount decimal,
  extra decimal,
  mta_tax decimal,
  tip_amount decimal,
  tolls_amount decimal,
  improvement_surcharge decimal,
  total_amount decimal,
  congestion_surcharge decimal)
  stored as orc;

-- Copy the CSV table to the ORC table
insert overwrite table yuhaok_trip select * from yuhaok_trip_csv;