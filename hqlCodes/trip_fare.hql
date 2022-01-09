create table yuhaok_fare_monthly (
  PUBorough string,
  Year smallint,
  Month tinyint,
  total_passenger int,
  total_distance decimal,
  total_fare decimal,
  total_tip decimal,
  num int,
  num_PRCP int,
  num_SNOW int);


insert overwrite table yuhaok_fare_monthly
  select puborough, year, month, 
  sum(passenger_count),
  sum(trip_distance),
  sum(total_amount),
  sum(tip_amount),
  count(*),
  count(if(prcp>0,1,null)),
  count(if(snow>0,1,null))
  from yuhaok_trip_weather
  group by puborough, year, month;