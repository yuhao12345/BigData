cd tripData

for name in *.csv
  do tail -n +2 $name | hdfs dfs -put - /yuhaok/trip/$name;
done


tail -n +2 taxizone.csv | hdfs dfs -put - /yuhaok/taxizone/taxizone.csv

tail -n +2 weatherNYC.csv | hdfs dfs -put - /yuhaok/weather/weatherNYC.csv

### do tail -n +2 $name | split -l 2700000 - ${name%.csv}_split_