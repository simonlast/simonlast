/**
 * @author Simon Last
 */

canvas = document.getElementById("platform");
var ctx = canvas.getContext("2d");

canvas.width = window.innerWidth;
canvas.height = window.innerHeight;

var img = new Image();   // Create new img element  
img.onload = function(){  
	//var x = (img.width/canvas.width)*canvas.width;
	var y = (img.width/canvas.width)*canvas.width;
	//drawImage(image, sx, sy, sWidth, sHeight, dx, dy, dWidth, dHeight)
    ctx.drawImage(img, 0, 0,img.width, y, 0, 0, canvas.width, canvas.height);
};  
img.src = 'http://s3.amazonaws.com/data.tumblr.com/tumblr_lz8o1tx33V1rnohleo1_1280.png';
