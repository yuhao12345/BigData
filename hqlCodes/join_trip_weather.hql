create table yuhaok_trip_weather (
  VendorID smallint,
  year smallint,
  month tinyint,
  day tinyint,
  passenger_count tinyint,
  trip_distance decimal,
  PUBorough string,
  DOBorough string,
  total_amount decimal,
  tip_amount decimal,
  PRCP decimal,
  SNOW decimal,
  TMIN decimal)
  stored as orc;

insert overwrite table yuhaok_trip_weather
  select t.VendorID as VendorID, cast(substr(w.day,1,4) as int) as year, 
  cast(substr(w.day,6,2) as int) as month, cast(substr(w.day,9,2) as int) as day,
  t.passenger_count as passenger_count, t.trip_distance as trip_distance,
  t.PUBorough as PUBorough, t.DOBorough as DOBorough, t.total_amount as total_amount,
  t.tip_amount as tip_amount, w.PRCP as PRCP, w.SNOW as SNOW, w.TMIN as TMIN
  from yuhaok_trip_zone t join yuhaok_weather w
    on to_date(t.tpep_pickup_datetime) = w.day;
