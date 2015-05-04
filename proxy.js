/* jshint node: true */
'use strict';

// require('newrelic');
var args = process.argv,
    https = require('https'),
    fs = require('fs'),
    proxy = require('http-proxy').createProxy(),
    target,
    port,
    server;

// Get command line arguments.
target = args[2] || 'localhost';
port = parseInt(args[3]) || 443;

server = https.createServer({
    key: fs.readFileSync('/etc/ssl/server.key'),
    cert: fs.readFileSync('/etc/ssl/server.crt')
}, function(req, res) {
    // console.log(req);
    req.on('error', function(e) {
        console.log(e);
    });
    proxy.web(req, res, {'target': 'http://' + target});
    proxy.on('error', function(e) {
        res.statusCode = res.statusCode || 500;
        res.end();
    });
});

server.listen(port);
