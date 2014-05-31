var connect = require("connect");
var path    = require("path");

var oneDay     = 86400000;
var publicPath = path.join(__dirname, "../public/");

connect(
  connect.static(publicPath, { maxAge: oneDay })
).listen(process.argv[2] || 80);