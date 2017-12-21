#!/usr/bin/env node

var AWS = require('aws-sdk');
AWS.config.update({region: 'us-west-2'});
var lambda = new AWS.Lambda();
const axois = require('axois');


axois.get('https://api.ipify.org/?format=json').then(function (response) {

    var params = {
      FunctionName: 'weather', /* required */
      // ClientContext: '{}',
      InvocationType: 'RequestResponse', // Event | RequestResponse | DryRun,
      LogType: 'Tail', // None | Tail,
      Payload: '', // new Buffer('...') || 'STRING_VALUE' /* Strings will be Base-64 encoded on your behalf */,
      // Qualifier: 'STRING_VALUE'
    };
    lambda.invoke(params, function(err, data) {
      if (err) console.log(err, err.stack); // an error occurred
      else     console.log(data);           // successful response
    });

}).catch(function (err) {
    console.error('ERROR:', err);
});

