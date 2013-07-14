
var connect = require('connect');

var oneDay = 86400000;

connect(
  connect.static('baked/', { maxAge: oneDay })
).listen(process.argv[2] || 80);

/*
var express = require('express');

var app = express();

app.use(express.static('baked'));

app.listen(80);*/
