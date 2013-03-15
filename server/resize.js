var fs = require('fs-extra');
var easyimg = require('easyimage');

var resizeImages = function(){
 	var base = 'site/screens/';
 	var images = fs.readdirSync(base);

 	fs.removeSync(base + "thumbs");
 	fs.mkdirsSync(base + "thumbs");

 	for(k in images){
 		var curr = images[k];
 		console.log(curr);
 		if(curr !== 'thumbs' && curr[0] !== '.')
 		easyimg.resize(
		  {
		     src: base + curr, dst: base + 'thumbs/' + curr,
		     width:375
		     },
		  function(err, image) {
		     console.log(image.name + ' cropped: ' + image.width + ' x ' + image.height);
		  }
		);
 	}
}

resizeImages();