var express = require('express')
var app = express()

app.get('/', function (req, res) {
    res.setHeader('Content-Type', 'text/plain');
    res.sendFile(__dirname + "/" + "octocat.txt");
})

var server = app.listen(8080, function () {
    console.log('Server listening on port 8080!')
})
module.exports = server;
