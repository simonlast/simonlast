
/*var connect = require('connect');

connect.createServer(
  connect.static('site')
).listen(80);*/

var express = require('express');

var app = express();

app.use(express.static('baked'));

app.listen(80);
