/**
 * @author Simon Last
 */

canvas = document.getElementById("platform");
var ctx = canvas.getContext("2d");

canvas.width = window.innerWidth;
canvas.height = window.innerHeight;

var grav = 15;
var counter = 0;
var thresh = 2000;
var letter = 'X'
var randColor = "";

function gameObject(x,y,r,vx,vy,c,str){
	this.x = x;
	this.y = y;
	this.r = r;
	var dev = 1;
	this.vx = vx+Math.random()*dev-dev/2;
	this.vy = vy;
	this.c = c;
	this.render = function(modifier){
		//this.vy += grav*modifier;
		//var vDev = .3;
		//this.vx += Math.random()*vDev - vDev/2;
		//this.x += this.vx;
		//this.y += this.vy;
		ctx.fillStyle = c;
		//ctx.fillStyle = "rgba(255,0,0,172)"; 
		/*ctx.beginPath();
		this.r -= .1;
		ctx.arc(this.x, this.y, this.r, 0, Math.PI*2, true); 
		ctx.closePath();
		ctx.fill();
		*/
		/*
		ctx.beginPath();
    	ctx.rect(this.x-this.r, this.y, 2*this.r, this.r/2);
    	ctx.fillStyle = randColor;
    	ctx.closePath();
    	ctx.fill();
		*/
		//this.r += 10;
		var rand = Math.random()*4;
		if(rand < 1){
			this.x -= this.r;
		}else if(rand < 2){
			this.x += this.r;	
		}else if(rand < 3){
			this.y += this.r;		
		}else{
			this.y -= this.r;
		}

		ctx.font = 'italic bold ' + this.r + 'px sans-serif';
		ctx.textBaseline = 'bottom';
		ctx.fillText(str, this.x,this.y);
	}
}

var objects = new Array();
// objects.push(new gameObject(100,100,100,0,0));
   var c = "rgba(";
    for (j = 0; j < 3; j++) {
      var v = Math.floor(Math.random()*100)+120; // 0-255;
      c += v + ",";
    }
    c += ".5)";
     //objects.push(new gameObject(canvas.width*3/4,canvas.height/4,Math.random(50)+50,0,2,c));

  document.onkeypress=function(e){
 var e=window.event || e
 letter = String.fromCharCode(e.charCode)
 newRandom(letter);
}  
     
addEventListener("mousedown", function (e) {
	    var mouseX, mouseY;

    if(e.offsetX) {
        mouseX = e.offsetX;
        mouseY = e.offsetY;
    }
    else if(e.layerX) {
        mouseX = e.layerX;
        mouseY = e.layerY;
    }
    var c = "rgba(";
    for (j = 0; j < 3; j++) {
      var v = Math.floor(Math.random()*100)+120; // 0-255;
      c += v + ",";
    }
    c += ".03)";
     objects.push(new gameObject(mouseX,mouseY,Math.random(50)+50,0,2,c));
}, false);

var newRandom = function(str){
			    var c = "rgba(";
    for (j = 0; j < 3; j++) {
      var v = Math.floor(Math.random()*100)+120; // 0-255;
      c += v + ",";
    }
    c += ".1)";
		objects.push(new gameObject(Math.random()*canvas.width,Math.random()*canvas.height,Math.random(50)+50,0,2,c,str));
	
}

var newRandomColor = function(){
	randColor = "rgba(";
    for (j = 0; j < 3; j++) {
      var v = Math.floor(Math.random()*100)+120; // 0-255;
      randColor += v + ",";
    }
    randColor += ".5)";
		objects.push(new gameObject(Math.random()*canvas.width,-50,Math.random(50)+50,0,2,c));
	
}

var update = function (modifier) {
	if(counter >= thresh){
		counter = 0;
		newRandom();
	}
	for (var i=0; i < objects.length; i++) {
	  objects[i].render(modifier);
	  if(objects[i].r > canvas.width){
	  	objects.splice(i, 1);
	  }
	};

}; 

var main = function () {
	var now = Date.now();
	var delta = now - then;
	counter += delta;
	update(delta / 1000);
	
	then = now;

};
	var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

     for (var i=0; i < 10; i++) {	
     letter = possible.charAt(Math.floor(Math.random() * possible.length));
      newRandom(letter);
     };
var then = Date.now();
setInterval(main, 1);
