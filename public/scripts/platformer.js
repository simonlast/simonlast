/**
 * @author Simon Last
 */

canvas = document.getElementById("platform");
var ctx = canvas.getContext("2d");

canvas.width = window.innerWidth;
canvas.height = window.innerHeight;

/*
var pReady = false;
var pImage = new Image();
pImage.onload = function () {
	pReady = true;
};
pImage.src = "/px/freud-right.png";
*/

var player = {
	x: 100,
	y: -200,
	speed: 0,
	w: 54/1.3, //54 orig
	h: 133/1.3 //133 orig
};

var ground = {
	x:0,
	y:canvas.height*.97,
	w:canvas.width,
	h:canvas.height*.03
};

var goal = {
	x:canvas.width*13/16,
	y:canvas.height*.14,
	w:canvas.width/30,
	h:canvas.width/30
};

function Platform(x,y,w,h){
	this.x = x;
	this.y = y;
	this.w = w;
	this.h = h;
	this.render = function(){
		ctx.fillStyle = "rgb(191,119,48)"; 
		ctx.fillRect (this.x-translated,this.y,this.w,this.h); 
	}
}

function gameObject(x,y,w,h){
	this.x = x;
	this.y = y;
	this.w = w;
	this.h = h;
	this.render = function(){
		ctx.fillStyle = "rgb(46,139,87)"; 
		ctx.fillRect (this.x-translated,this.y,this.w,this.h); 
	}
}

//const
var grav = 80;
var playerSpeedX = 700;
var playerSpeedY = 1700;
var playerMaxSpeed = 30;

//var
var translated = 0;
var platforms = new Array();
var whiteGameObjects = new Array();
var blackGameObjects = new Array();
var gType = true;
var shiftClicked = false;
var level = 1;
var gameStarted = false;

platforms.push(new Platform(canvas.width/4,canvas.height*.2,canvas.width/8,canvas.height/20));
platforms.push(new Platform(canvas.width/5,canvas.height*.8,canvas.width/8,canvas.height/20));
platforms.push(new Platform(canvas.width/2,canvas.height*.5,canvas.width/8,canvas.height/20));
platforms.push(new Platform(canvas.width*3/4,canvas.height*.2,canvas.width/8,canvas.height/20));

whiteGameObjects.push(new gameObject(canvas.width*3/4,canvas.height-100,canvas.width/8,80));


var keysDown = {};

addEventListener("keydown", function (e) {
	keysDown[e.keyCode] = true;
}, false);

addEventListener("keyup", function (e) {
	delete keysDown[e.keyCode];
}, false);


var update = function (modifier) {
	
	player.y += player.speed;
	
	var didCollide;
	
	//player cannot go past 0 on left
	if(player.x <= translated){
		player.x = translated;
	}
	
	if(collisionCheck(modifier)){
	didCollide = true;
	}
	else{
	didCollide = false;
	}
	
	if(gType)
	if((player.x + player.w >= goal.x && player.x + player.w <= goal.x + goal.w) || (player.x <= goal.x + goal.w && player.x >= goal.x))
		if((player.y + player.h >= goal.y && player.y + player.h <= goal.y + goal.h) || (player.y <= goal.y + goal.h && player.y >= goal.y)){
			level++;
			gameStarted = false;
		}
	/*
	if (38 in keysDown && player.speed == 0 && didCollide) { // Player holding up
		player.speed = -1*playerSpeedY*modifier;
	}
	*/
	
	if (37 in keysDown) { // Player holding left
		player.x-= playerSpeedX*modifier;
		if(player.x - translated < canvas.width*1/3 && translated >= 0){
			translated -= playerSpeedX*modifier;
		}
	}
	if (39 in keysDown) { // Player holding right
		player.x+= playerSpeedX*modifier;
		if(player.x - translated > canvas.width*2/3){
			translated += playerSpeedX*modifier;
		}
	}
	
	if (16 in keysDown && player.speed == 0) { // Player hits shift
		shiftClicked = true;
	}
	if(shiftClicked  && player.speed == 0 && !(16 in keysDown)){
		gChange();
		shiftClicked = false
	}
	
	
	
	
	
};

var gChange = function () {
	gType = !gType;
	grav*=-1;
	playerSpeedY*=-1;
	if(gType){
		ground = {
			x:0,
			y:canvas.height*.97,
			w:canvas.width,
			h:canvas.height*.03
		};
	}else{
		ground = {
			x:0,
			y:0,
			w:canvas.width,
			h:canvas.height*.03
		};
		
		
		
	}
};

var collisionCheck = function (modifier) {
	if(gType){ //NORMAL MODE
	if(player.y + player.h >= ground.y){
		player.y = ground.y - player.h;
		player.speed = 0;
		return true;
	}
	if(player.speed > 0){
	 for (var i = platforms.length - 1; i >= 0; i--){
	  			if(player.y + player.h >= platforms[i].y && player.y + player.h <= platforms[i].y + platforms[i].h  && player.x + player.w >= platforms[i].x && player.x <= platforms[i].x+platforms[i].w){
					player.y = platforms[i].y - player.h;
					player.speed = 0;
					return true;
					}
	 		};
	}
	if(player.speed < playerMaxSpeed)
		player.speed += grav*modifier;
		
	return false;
	}else{ //BLACK MODE
		
	if(player.y <= ground.y + ground.h){
		player.y = ground.y + ground.h;
		player.speed = 0;
		return true;
	}
	if(player.speed < 0){
	 for (var i = platforms.length - 1; i >= 0; i--){
					
				if(player.y <= platforms[i].y + platforms[i].h && player.y >= platforms[i].y && player.x + player.w >= platforms[i].x && player.x <= platforms[i].x+platforms[i].w){
					player.y = platforms[i].y + platforms[i].h;
					player.speed = 0;
					return true;
					}
	 		};
	}
	if(player.speed < playerMaxSpeed)
		player.speed += grav*modifier;
		
	return false;
		
		
		
	}
	
};

var render = function () {
	if(gType){ //NORMAL MODE
	//clear background
	ctx.fillStyle = "rgb(221,241,249)"; 
	ctx.fillRect (0,0,canvas.width,canvas.height); 

 	
 	/*
 	if (pReady) {
		ctx.drawImage(pImage, 400,400);
	}
	*/
 	
 	//draw ground
	ctx.fillStyle = "rgb(191,119,48)";  
 	ctx.fillRect (ground.x,ground.y,ground.w,ground.h); 
 	
 	for (var i = platforms.length - 1; i >= 0; i--){
	  platforms[i].render();
	 };
	
	for (var i = whiteGameObjects.length - 1; i >= 0; i--){
	  whiteGameObjects[i].render();
	 };
	 
	 //draw goal
	ctx.fillStyle = "rgb(255,140,0)";  
 	ctx.fillRect (goal.x-translated, goal.y, goal.w,goal.h); 
	 
	 	//draw player
	ctx.fillStyle = "rgb(200,0,0)";  
 	ctx.fillRect (player.x-translated, player.y, player.w,player.h); 
 
 }else{ //BLACK MODE
 	ctx.fillStyle = "rgb(0,0,0)"; 
	ctx.fillRect (0,0,canvas.width,canvas.height); 
 		
 	 	//draw ground
	ctx.fillStyle = "rgb(191,119,48)";  
 	ctx.fillRect (ground.x,ground.y,ground.w,ground.h); 
 	
 	for (var i = platforms.length - 1; i >= 0; i--){
	  platforms[i].render();
	 };
	 
	 for (var i = blackGameObjects.length - 1; i >= 0; i--){
	  blackGameObjects[i].render();
	 };
	 
	 	//draw player
	ctx.fillStyle = "rgb(200,0,0)";  
 	ctx.fillRect (player.x-translated, player.y, player.w,player.h); 
 		
 	}

};

var greeting = function () {
	ctx.font = "60pt Helvetica";
		//clear background
	ctx.fillStyle = "rgb(221,241,249)"; 
	ctx.fillRect (0,0,canvas.width,canvas.height); 
	
	ctx.fillStyle = "rgb(70,130,180)"; // text color
	if(level == 1){
		
   	 ctx.fillText("Welcome",canvas.width/2-200,canvas.height/2);
	}else{
	ctx.fillText("Welcome to level " + level,canvas.width/2-200,canvas.height/2);
	}
	
	if(32 in keysDown){
		gameStarted = true;
		if(level > 1)
		resetGame();
	}
};

var resetGame = function () {
	player.x = 0;
	player.y = -200;
	//var
	translated = 0;
	platforms = new Array();
	whiteGameObjects = new Array();
	blackGameObjects = new Array();
	gType = true;
	shiftClicked = false;

}

var main = function () {
	var now = Date.now();
	var delta = now - then;
	
	//if(gameStarted){
	update(delta / 1000);
	render();
	//}else{
	//	greeting();
	//}

	then = now;
};


var then = Date.now();
setInterval(main, 1);




