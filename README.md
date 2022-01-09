# BigData

Target:

•	Implement the Lambda architecture: store the raw data in Hadoop on Amazon EMR (HDFS), create the batch view (MapReduce, Hive), move the view into the serving layer (NoSQL, HBase), get the real-time data into Kafka.

•	Query the data from a web app based on Node.js and REST API.


In this application, I downloaded 20 months data of NYC taxi report (~30GB) which includes the origin, destination, distance, passenger number, etc. I combine this report data with weather data of NYC.

In the web app, I want to know the average passenger number, the average trip distance, and the average fare for each trip. This value may vary relative to the weather of that month. People may incline to choose taxi during the bad weather even for a short-distance journey. So I also incorporate the ratio of rainy and snowy day for each month. It turns out the average distance of each trip has little correlation with the weather.

Following the lecture, I store the csv file as ORC format since it is faster to read and write in Hive.

Although the output values are mainly average value over each month, I store their sum in the hive and hbase and calculate the average in the web app. This is because we need to incorporate the data from the speed layer. If we calculate the average table in the batch view, it is harder to combine it with streaming data.

https://user-images.githubusercontent.com/31739574/148672268-81458cee-1b19-42b6-a004-6b4224b6b2ea.mp4

# Code and tables
1.	download data and move them to hdfs

getTripData.sh   :   download data to /yuhaok/tripData

ingestTrip.sh    :    copy data to hdfs 

2.	explain the table by Serde and store as ORC table in hive

create_taxizone_table.hql    :    create table yuhaok_taxizone  (relation between locationID, NYC location)

hive_weather.hql  :  create table yuhaok_weather (relation among time, sun, rain, temperature)

hive_trip.hql   :  create table yuhaok_trip  (relation among locationID, payment, trip distance…)

3.	join weather, taxi zone, trip

join_trip_zone.hql   :  create intermediate table yuhaok_trip_zone

join_trip_weather.hql   :  create table yuhaok_trip_weather

4.	prepare batch view

group by the origin place and year and month

trip_fare.hql    :   create table yuhaok_fare_monthly

write_to_hbase_trip.hql   :    save table to hbase

5.	create kafka topic  “yuhaok_final_kafka”

To consume the data in this topic:
kafka-console-consumer.sh --bootstrap-server b-1.mpcs53014-kafka.198nfg.c7.kafka.us-east-2.amazonaws.com:9092,b-2.mpcs53014-kafka.198nfg.c7.kafka.us-east-2.amazonaws.com:9092 -topic yuhaok_final_kafka --from-beginning

6.	query the HBase and realize the web app

7.	use web page to manually feed in new data

Web code  : taxi_trip_final.zip

8.	CodeDeploy the app with balanced Loader






