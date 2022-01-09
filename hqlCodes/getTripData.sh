mkdir tripData
cd tripData

for mnth in `seq 1 7`; do
  wget https://nyc-tlc.s3.amazonaws.com/trip+data/yellow_tripdata_2021-0${mnth}.csv
done

for yr in `seq 2019 2020`; do
  for mnth in `seq 1 9`; do
    wget https://nyc-tlc.s3.amazonaws.com/trip+data/yellow_tripdata_${yr}-0${mnth}.csv
  done
done

for yr in `seq 2019 2020`; do
  for mnth in `seq 10 12`; do
    wget https://nyc-tlc.s3.amazonaws.com/trip+data/yellow_tripdata_${yr}-${mnth}.csv
  done
done