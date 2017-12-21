// const http = require('http');
// const https = require('https');
const axios = require('axios');
const Promise = require('bluebird');
// const querystring = require('querystring');

exports.handler = function(event, context, callback) {
    console.log('event:', JSON.stringify(event, null, 4));

    let sourceIP = event.sourceIP;
    let endpoint = 'http://freegeoip.net/json/' + encodeURIComponent(sourceIP);

    axios.get(endpoint).then(function (response) {
	    callback(null, JSON.stringify(response, null, 4));
    }).catch(function (err) {
		console.log("Error: " + err);
	    callback(err);
    });



	// https.get(endpoint, (resp) => {
	//   let data = '';

	//   // A chunk of data has been recieved.
	//   resp.on('data', (chunk) => {
	//     data += chunk;
	//   });

	//   // The whole response has been received. Print out the result.
	//   resp.on('end', () => {
	// 	console.log('end:', data);
	// //     console.log(JSON.parse(data).explanation);
	// 	callback(null, JSON.parse(data));
	//   });

	// }).on("error", (err) => {
	// 	console.log("Error: " + err.message);
	//     callback(err.message);
	// });






    // let location = event.location;
    // if (!location) {
    // 	location = 'Irvine, California';
    // }
    // let params = {
    // 	query: location
    // };
    // let endpoint = 'https://www.metaweather.com/api/location/search/?' + querystring.stringify(params);

}


