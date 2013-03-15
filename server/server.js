
var connect = require('connect'),
	gzip = require('connect-gzip');

connect.createServer(
  gzip.staticGzip('site')
).listen(80);
