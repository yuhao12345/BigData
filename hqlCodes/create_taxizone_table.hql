-- Make sure you have put stations.txt in hdfs://inputs/stations
CREATE EXTERNAL TABLE yuhaok_taxizone (LocationID smallint, Borough string, Zone string, service_zone string)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
   "separatorChar" = "\,",
   "quoteChar"     = "\""
)
STORED AS TEXTFILE
  location '/yuhaok/taxizone';