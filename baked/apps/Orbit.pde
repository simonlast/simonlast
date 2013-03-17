
ArrayList<Planet> planets;
Planet sun,earth,mars,jupiter;
Player player;
boolean pressed,sliderPressed;
PVector diff;
int initPos;
color bkg = color(30);

final float G = .01;
final float MASS = 2;
final float RAD = 15;

float g = .0025;
float pMass = 2;
float rad = 15;

void setup(){
  size(1100,750);
  smooth();

  background(bkg);
  stroke(172);
  strokeWeight(1);
  planets = new ArrayList<Planet>();
  
  sun = new Planet(50,300000,width/2,height/2,0,0);
  sun.c = color(255,215,0);
  planets.add(sun);
 
  earth = new Planet(20,1,width*.6,height/2,0,0);
  earth.c = color(102,205,170);
  earth.circleOrbit();
  
  mars = new Planet(15,.7,width*.7,height/2,0,0);
  mars.c = color(205,92,92);
  mars.circleOrbit();
  
  jupiter = new Planet(30,10,width*.8,height/2,0,0);
  jupiter.c = color(255,140,0);
  jupiter.circleOrbit();

  
 
  planets.add(mars);
  planets.add(earth);
   planets.add(jupiter);
  
  
  pressed = false;
  diff = new PVector(0,0);
  
  player = new Player(.01,width*.6,height/2,20,20);


  
}

void draw(){
  background(bkg);
 
  for(Planet p : planets)
    p.render();
    
  player.render();
  
}

//adding asteroids

void mousePressed(){
  if(!pressed){
    diff = new PVector(mouseX,mouseY);
  }
  pressed = true;
}

void mouseReleased(){
  
  diff.sub(new PVector(mouseX,mouseY));
  diff.div(30);
  planets.add(new Planet(rad,pMass,mouseX,mouseY,diff.x,diff.y));
  pressed = false;
  
}


class Planet{
 float r,mass;
 PVector pos,v,a; 
 color c;
  
 Planet(float r,float mass,float x,float y,float vx,float vy){
   this.r = r;
   this.mass = mass;
   this.pos = new PVector(x,y);
   this.v = new PVector(vx,vy);
   this.a = new PVector(0.0,0.0);
   c = color(200);
 }
 
 Planet(){
   
 }
 
 void update(){
   a = new PVector(0.0,0.0);
   for(Planet p : planets){
     if(p != this){
       float d = pos.dist(p.pos);
       if(d > r){
       float accel = g * p.mass / sq(d);
       PVector dA = PVector.sub(p.pos,pos);
       dA.normalize();
       dA.mult(accel);
       a.add(dA);
       }
     }
   }
   v.add(a);
   pos.add(v);
 }
 
 void circleOrbit(){
  update();
  v = new PVector(0,sqrt(a.mag()*(pos.x-sun.pos.x)));
  
 }
 
 void render(){
  update();
  fill(c);
  noStroke();
  ellipse(pos.x,pos.y,r,r);
 }
  
  
}

class Player extends Planet{
  float w,h;
  
  Player(float mass,float x,float y,float w, float h){
    super();
   this.mass = mass;
   this.pos = new PVector(x,y);
   this.v = new PVector(0,0);
   this.a = new PVector(0.0,0.0);
   c = color(172);
  }
  
  void render(){
   fill(200);
   rect(pos.x,pos.y,w,h);
  }
  
  
}



