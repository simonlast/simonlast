// set the scene size
var WIDTH = window.innerWidth,
  HEIGHT = window.innerHeight;

// set some camera attributes
var VIEW_ANGLE = 45,
  ASPECT = WIDTH / HEIGHT,
  NEAR = 0.1,
  FAR = 10000;

// get the DOM element to attach to
// - assume we've got jQuery to hand
var container = document.querySelector("#three-container");

// create a WebGL renderer, camera
// and a scene
var renderer = new THREE.WebGLRenderer();
var camera =
  new THREE.PerspectiveCamera(
    VIEW_ANGLE,
    ASPECT,
    NEAR,
    FAR);

var scene = new THREE.Scene();

// add the camera to the scene
scene.add(camera);

// the camera starts at 0,0,0
// so pull it back
camera.position.z = 500;

// start the renderer
renderer.setSize(WIDTH, HEIGHT);

// attach the render-supplied DOM element
container.appendChild(renderer.domElement);

// set up the sphere vars
var radius = 5,
    segments = 16,
    rings = 16;

// // create the sphere's material
var sphereMaterial =
  new THREE.MeshLambertMaterial(
    {
      color: 0xFFFFFF
    });


// var sphereMaterial =
// 		new THREE.MeshPhongMaterial({
// 			ambient: 0x030303,
// 			color: 0xdddddd,
// 			specular: 0x009900,
// 			shininess: 30,
// 			shading: THREE.FlatShading
// 		});

// create a point light
var pointLight =
  new THREE.PointLight(0xFFFFFF);

// set its position
pointLight.position.x = 10;
pointLight.position.y = 50;
pointLight.position.z = 130;

// add to the scene
scene.add(pointLight);

// util

var random = function(min, max){
	return (Math.random() * (max - min)) + min;
}


// Bird

var Bird = function(){

	this.NUM_NEIGHBORS = 12;

	this.SEPARATION_NUM_NEIGHBORS = 4;
	this.SEPARATION_WEIGHT = 4;

	this.ALIGNMENT_NUM_NEIGHBORS = 12;
	this.ALIGNMENT_WEIGHT = 1;

	this.COHESION_NUM_NEIGHBORS = 20;
	this.COHESION_WEIGHT = 2;

	this.sphere = new THREE.Mesh(

	  new THREE.SphereGeometry(
	    radius,
	    segments,
	    rings),

	  sphereMaterial);

	// add the sphere to the scene
	scene.add(this.sphere);
	this.sphere.geometry.dynamic = true;
	this.sphere.geometry.verticesNeedUpdate = true;
	this.sphere.geometry.normalsNeedUpdate = true;

	this.v = new THREE.Vector3(1, 1, 1);
	this.sphere.position.x += random(-20, 20);
	this.sphere.position.y += random(-20, 20);
	this.sphere.position.z += random(-20, 20);

};


Bird.prototype.render = function() {
	var _this = this;
	var newV = new THREE.Vector3();

	var diffs = [
		this.separationRule(),
		this.alignmentRule(),
		this.cohesionRule()
	];

	_.each(diffs, function(diff){
		newV.add(diff);
	});

	this.v.add(newV);
	this.v.multiplyScalar(0.5);

	this.sphere.position.add(this.v);

};

Bird.prototype.clamp = function(val, min, max){

	if (val > max){
		val = min;
	} else if (val < min){
		val = max
	}

	return val;
}


Bird.prototype.getAveragePosition = function(otherBirds){
	var averagePosition = new THREE.Vector3();

	_.each(otherBirds, function(bird){
		averagePosition.add(bird.sphere.position);
	});

	averagePosition.divideScalar(otherBirds.length);
	return averagePosition;
};


Bird.prototype.getAverageV = function(otherBirds){
	var averageV = new THREE.Vector3();

	_.each(otherBirds, function(bird){
		averageV.add(bird.v);
	});

	averageV.divideScalar(otherBirds.length);
	return averageV;
};


Bird.prototype.getNeighbors = function(numNeighbors){
	var _this = this;

	var neighbors = _.filter(birds, function(bird){
		return bird !== _this;
	})

	var neighbors = _.sortBy(neighbors, function(bird){
		return _this.sphere.position.distanceTo(bird.sphere.position);
	});

	return _.first(neighbors, numNeighbors);
};

Bird.prototype.separationRule = function(){
	var neighbors = this.getNeighbors(1);
	var closestNeighbor = neighbors[0];
	var neighborPosition = closestNeighbor.sphere.position.clone();
	var sub = neighborPosition.sub(this.sphere.position);

	var distance = sub.length();
	sub.multiplyScalar(1/(distance * distance));

	return sub.negate().multiplyScalar(this.SEPARATION_WEIGHT);
};

Bird.prototype.alignmentRule = function(){
	var neighbors = this.getNeighbors(this.ALIGNMENT_NUM_NEIGHBORS);
	var averageV = this.getAverageV(neighbors);
	return averageV.normalize().multiplyScalar(this.ALIGNMENT_WEIGHT);
};

Bird.prototype.cohesionRule = function(){
	var neighbors = this.getNeighbors(this.COHESION_NUM_NEIGHBORS);
	var averageNeighborPosition = this.getAveragePosition(neighbors);
	return averageNeighborPosition.normalize().multiplyScalar(this.COHESION_WEIGHT);
};

var birds = []


var updateCamera = function(){

	var sortedByPosition = _.sortBy(birds, function(bird){
		return bird.sphere.position.length();
	});

	camera.lookAt(sortedByPosition[0].sphere.position);

}


// draw!
var render = function(){
	_.each(birds, function(bird){
		bird.render();
	});

	// updateCamera();

	renderer.render(scene, camera);

	requestAnimationFrame(render);
};

var MOUSEX = 0, MOUSEY = 0;

document.addEventListener("mousemove", function(e){
	MOUSEX = e.clientX;
	MOUSEY = e.clientY;
});


onDocumentKeyDown = function(event){
	var delta = 200;
	var keycode = event.keyCode;
	switch(keycode){
		case 37 : //left arrow
			camera.position.x = camera.position.x - delta;
			break;
		case 38 : // up arrow
			camera.position.z = camera.position.z - delta;
			break;
		case 39 : // right arrow
			camera.position.x = camera.position.x + delta;
			break;
		case 40 : //down arrow
			camera.position.z = camera.position.z + delta;
			break;
	}
};

document.addEventListener("keydown", onDocumentKeyDown);


for (var i = 0; i < 100; i++) {
	birds.push(new Bird());
};

render();











