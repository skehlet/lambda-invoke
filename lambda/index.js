const http = require('http');

exports.handler = function(event, context, callback) {
    // ...

    console.log('event:', JSON.stringify(event, null, 4));


    let endpoint = 'http://freegeoip.net/json/';

    let ip = event.ip;
    if (ip) {
    	endpoint += ip;
    }

	http.get(endpoint, (resp) => {
	  let data = '';

	  // A chunk of data has been recieved.
	  resp.on('data', (chunk) => {
	    data += chunk;
	  });

	  // The whole response has been received. Print out the result.
	  resp.on('end', () => {
		console.log('end:', data);
	//     console.log(JSON.parse(data).explanation);
		callback(null, JSON.parse(data));
	  });

	}).on("error", (err) => {
		console.log("Error: " + err.message);
	    callback(err.message);
	});

}


