'use strict';
const http = require('http');
var assert = require('assert');
const express= require('express');
const app = express();
const mustache = require('mustache');
const filesystem = require('fs');
const url = require('url');
const port = Number(process.argv[2]);

const hbase = require('hbase')
var hclient = hbase({ host: process.argv[3], port: Number(process.argv[4])})

function rowToMap(row) {
	var stats = {}
	row.forEach(function (item) {
		stats[item['column']] = Number(item['$'])
	});
	return stats;
}

hclient.table('yuhaok_trip_hbase').row('Bronx20211').get((error, value) => {
	console.info(rowToMap(value))
	console.info(value)
})


app.use(express.static('public'));
app.get('/delays.html',function (req, res) {
    const route=req.query['origin'] + req.query['year'] + req.query['month'];
    console.log(route);
	hclient.table('yuhaok_trip_hbase').row(route).get(function (err, cells) {
		if (err){
			console.log("404")
		}

		const weatherInfo = rowToMap(cells);
		console.log(weatherInfo)
		function weather_delay(x) {
			var sum = weatherInfo["trip:" + x];
			var total_num = weatherInfo["trip:num"];
			if (total_num ==0 || total_num==null) return "-"
			return (sum/total_num).toFixed(3); /* 3 decimal place */
		}

		var template = filesystem.readFileSync("result.mustache").toString();
		var html = mustache.render(template,  {
			origin : req.query['origin'],
			dest : req.query['dest'],

			avg_distance: weather_delay("total_distance"),
			avg_fare: weather_delay("total_fare"),
			avg_tip:weather_delay("total_tip"),
			avg_passenger: weather_delay("total_passenger"),
			ratio_rain:weather_delay("num_PRCP"),
			ratio_snow:weather_delay("num_SNOW")


		});
		res.send(html);
	});
});

/* Send simulated weather to kafka */
var kafka = require('kafka-node');
var Producer = kafka.Producer;
var KeyedMessage = kafka.KeyedMessage;
var kafkaClient = new kafka.KafkaClient({kafkaHost: process.argv[5]});
var kafkaProducer = new Producer(kafkaClient);


app.get('/weather.html',function (req, res) {
	var station_val = req.query['station'];
	var distance = req.query['distance'];
	var fare = req.query['fare'];
	var tip = req.query['tip'];
	var rain_val = req.query['rain'];
	var snow_val = req.query['snow'];
	var report = {
		station : station_val,
		distance:distance,
		fare:fare,
		tip:tip,
		rain_val:rain_val,
		snow_val:snow_val
	};

	kafkaProducer.send([{ topic: 'yuhaok_final_kafka', messages: JSON.stringify(report)}],
		function (err, data) {
			console.log(report);
			res.redirect('submit-weather.html');
		});
});

app.listen(port);
