
canvas = document.getElementById("platform");
var ctx = canvas.getContext("2d");

canvas.width = window.innerWidth;
canvas.height = window.innerHeight;

var posx = 0;
var posy = 0;

function Line(x,y,x2,y2,vx,vy,c){
	this.x = x;
	this.y = y;
	this.r = r;
	//this.vx = vx+Math.random()*dev-dev/2;
	this.vy = vy;
	this.c = c;
	this.render = function(modifier){
		this.vy += grav*modifier;
		var vDev = .3;
		this.vx += Math.random()*vDev - vDev/2;
		this.x += this.vx;
		this.y += this.vy;
		ctx.fillStyle = c;
		//ctx.fillStyle = "rgba(255,0,0,172)"; 
		ctx.beginPath();
		this.r -= .1;
		ctx.arc(this.x, this.y, this.r, 0, Math.PI*2, true); 
		ctx.closePath();
		ctx.fill();
		
		/*
		ctx.beginPath();
    	ctx.rect(this.x-this.r, this.y, 2*this.r, this.r/2);
    	ctx.fillStyle = randColor;
    	ctx.closePath();
    	ctx.fill();
    	*/
	}
}

addEventListener("mousedown",function (e) {
	var mouseX, mouseY;
	    if(e.offsetX) {
        mouseX = e.offsetX;
        mouseY = e.offsetY;
    }
    else if(e.layerX) {
        mouseX = e.layerX;
        mouseY = e.layerY;
    }
   
});


var main = function () {
	

};



setInterval(main, 1);
