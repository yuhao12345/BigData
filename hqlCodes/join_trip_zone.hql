create table yuhaok_trip_zone (
  VendorID smallint,
  tpep_pickup_datetime timestamp,
  tpep_dropoff_datetime timestamp,
  passenger_count tinyint,
  trip_distance decimal,
  PUBorough string,
  DOBorough string,
  total_amount decimal,
  tip_amount decimal
)
  stored as orc;

insert overwrite table yuhaok_trip_zone
  select t.VendorID as VendorID, t.tpep_pickup_datetime as tpep_pickup_datetime, t.tpep_dropoff_datetime as tpep_dropoff_datetime,
  t.passenger_count as passenger_count, t.trip_distance as trip_distance,
  so.Borough as PUBorough, sd.Borough as DOBorough, t.total_amount as total_amount,
  t.tip_amount as tip_amount
  from yuhaok_trip t join yuhaok_taxizone so join yuhaok_taxizone sd
    on t.PULocationID = so.LocationID and t.DOLocationID = sd.LocationID and t.passenger_count>0;
