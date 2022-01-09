# hbase shell: create 'yuhaok_trip_hbase','trip'
# disable 'yuhaok_trip_hbase'
# drop 'yuhaok_trip_hbase'


# at hive
create external table yuhaok_trip_hbase (
  route string,
  total_passenger int,
  total_distance decimal,
  total_fare decimal,
  total_tip decimal,
  num int,
  num_PRCP int,
  num_SNOW int)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES ('hbase.columns.mapping' = ':key,trip:total_passenger,trip:total_distance,trip:total_fare,trip:total_tip,trip:num,trip:num_PRCP,trip:num_SNOW')
TBLPROPERTIES ('hbase.table.name' = 'yuhaok_trip_hbase');


insert overwrite table yuhaok_trip_hbase
select concat(puborough, year, month),
  total_passenger,
  total_distance,
  total_fare,
  total_tip,
  num,
  num_PRCP,
  num_SNOW from yuhaok_fare_monthly;
