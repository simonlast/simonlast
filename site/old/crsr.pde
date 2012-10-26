//cursor.
PImage p1,p2,g2,coffee,flag,rocket;
PVector grav = new PVector(0,.15);
Player p;
float playerSpeed, distance, cloudSpeed, flagPos;
Platform ground;
boolean pDir, started, paused, newLevelPhase, isRocket;
ArrayList platforms, clouds;
PVector pDimen;
PFont f;
char[] types = {'l','d','s',}; //'F' type for new level
int stamina, upgrade, maxStamina, points, maxFall, maxRise;
ArrayList rockets;
int levelPoints = 30;
PVector blockDimen = new PVector(1200,300);
int flags = 0;
float rocketSpeed = 2;
int rocketChance = 7;

void setup(){
  size(1000,600);
  noStroke();
  background(143,188,143);
  f = loadFont("Serif-30.vlw");
  p1 = loadImage("px/player.png");
  p2 = loadImage("px/player2.png");
  g2 = loadImage("px/ground.png");
  coffee = loadImage("px/coffee.png");
  flag = loadImage("px/flag.png");
  rocket = loadImage("px/rocket.png");
  pDimen = new PVector(200,30);
  
  p = new Player(100,100);
  playerSpeed = 4.0;
  ground = new Platform(0,height-80,1000,100);
  ground.setColor(49,79,79);
  ground.hit = 2;
  pDir = true;
  platforms = new ArrayList();
  for(int x=0; x<levelPoints+1; x++){
   platforms.add(new Platform(x*600+blockDimen.x+random(-100,100),random(-1*blockDimen.y,blockDimen.y),pDimen.x,pDimen.y));
   if(x==levelPoints){
   Platform temp = (Platform)platforms.get(levelPoints);
   temp.type = 'F'; 
   flagPos = temp.pos.y;
   newLevelPhase = false;
   }
  }
  rockets = new ArrayList();
   //Platform temp = (Platform)platforms.get(0);
   //temp.type = 'F'; 
   //flagPos = temp.pos.y;
  clouds = new ArrayList();
  cloudSpeed = .3;
  for(int x=0; x<levelPoints; x++){
   clouds.add(new Cloud(x*600+blockDimen.x+random(-100,100),random(-300,400),200+random(100),130)); 
  }
  
  distance = 0;
  stamina = maxStamina = 200;
  //loadNewGround(0.0);
  started = false;
  paused = false;
  maxFall = 6;
  maxRise = -10;
  isRocket = false;
}

void draw(){
  if(!paused){
  background(143,188,143);
  showText();
  if(p.pos.y > height)
  restart(); 
  if(p.pos.x > width/2)
  translate((p.pos.x-width/2) *-1,0);
  if(p.pos.y < height*1/3)
  translate(0,(height*1/3-p.pos.y));
    for(int x=0; x<clouds.size(); x++){
   Cloud temp = (Cloud)clouds.get(x);
  temp.render(); 
  }
  for(int x=0; x<platforms.size(); x++){
   Platform temp = (Platform)platforms.get(x);
  temp.render(); 
  }
  ground.render();
  p.render();
  if(isRocket){
    for(int x=0; x<rockets.size(); x++){
   Rocket temp = (Rocket)rockets.get(x);
  if(temp.pos.y > height)
  rockets.remove(temp);
  else
  temp.render(); 
  }
  }
  }else{
  showText();
    
  }
}

void keyPressed(){
  //stamina++;
  if(started){
    if(!paused){
 if(key == 'a' || keyCode == LEFT){
   if(stamina>0){
   stamina--;
   p.v.x = -1 * playerSpeed;
   pDir = !pDir;
   if(p.v.y > maxRise)
   p.v.y -= 2;
   }
 }
 /* if(key == ' ' || key == 'w'){

   p.v.y = -1 * playerSpeed;
   //p.onPlat = false;

 }*/
  if(key == 'd' || keyCode == RIGHT){
   if(stamina>=0){
   stamina-=2;
   p.v.x = playerSpeed;
   pDir = !pDir;
   if(p.v.y > maxRise)
   p.v.y -= 2;
   }
 }
 if(key == 'p')
   paused = true;
   
 if(key == 'o'){
   restart();
 }
    }else{
      if(newLevelPhase){
        newLevelPhase = false;
        paused = false;
        levelPoints+= 5;
        flags++;
        maxStamina -= 5;
        rocketChance++;
        rocketSpeed+= .5;
        blockDimen.add(new PVector(100,20));
        restart(); 
      }
      if(key == 'p')
      paused = false;
      
    }
  }else{
    if(p.pos.y >= ground.pos.y - p.dimen.y)
    started = true;
  
  }
}

void showText(){
  textFont(f,30);
  fill(255);
  if(started && !paused){
 points = (int)(distance/10-1.9);
 //text("Distance from Start: " + points +"\nAltitude: " + (int)(height-p.pos.y)/10,width-400,30);
 text("Stamina: ",10,30);
 text("Flags reached: " + flags ,width-250,30);
 fill(255,99,71);
 noStroke();
 rect(160,10,stamina,20);
 fill(255);
  }
 else{
   fill(255,99,71);
   noStroke();
   rect(width-320,height-300,400,300);
   if(paused){
   rect(width-80,height-400,20,100);
   rect(width-130,height-450,150,70);
   fill(255);
   if(!newLevelPhase)
   text("paused",width-105,height-410);
   else{
     fill(255,99,71);
   rect(width-300,height-450,200,70);
   fill(255);
   text("LEVEL CLEARED",width-270,height-405);
   }
   }
   fill(255);
   if(!newLevelPhase && !paused)
   text("Use 'a' and 'd' to fly!\nGet to the flag by\nlanding on platforms.\nPress any key to begin.",width-300,height-250); 
   else if(!newLevelPhase && paused)
   text("Use 'a' and 'd' to fly!\nGet to the flag by\nlanding on platforms.\nPress 'p' to unpause.",width-300,height-250); 
   else
   text("Press any key\nto advance",width-250,height-250);    
 }
}

class Player{
  PVector pos;
  PVector dimen;
  PVector v;
  boolean onPlat;
  
  Player(float x, float y){
  pos = new PVector(x,y);
  v = new PVector(0.0,0.0); 
  dimen = new PVector(40.0,140.0); 
  onPlat = false;
  }
  
  boolean isBounce(Platform pl){
   if(v.y > 0 && pos.x + dimen.x >= pl.pos.x && pos.x <= pl.pos.x + pl.dimen.x
     && pos.y + dimen.y >= pl.pos.y && pos.y+dimen.y <= pl.pos.y + pl.dimen.y){
       onPlat = true;
       pl.hit++;
        //int x = (int)sqrt(sq(p.pos.x-100)+sq(p.pos.y-400));
       // if(distance < x)
        //distance = x;
        for(int x=0; x<platforms.size(); x++){
         Platform temp = (Platform)platforms.get(x);
         if(pos.x-temp.pos.x > 5000){
         platforms.remove(temp); 
       }
        }
        if(stamina <= maxStamina)
        stamina++;
        if(pl.type == 'F'){
         if(flagPos - 30 <= pl.pos.y - 80){
         paused = true;
         newLevelPhase = true;
         }
         else
         flagPos-= .5; 
        }
        if(pl.hit <2 && random(rocketChance)>5){
        isRocket = true;
        for(int x=0; x<flags; x++)
        rockets.add(new Rocket(pos.x,x+1));
        }
       return true; 
      }
      else{
        onPlat = false;
        return false;
      }
  }
  
  void correct(){
  //ground
  if(isBounce(ground)){
  v = new PVector(0,0);
  pos.y = ground.pos.y - dimen.y;  
  }
  for(int x=0; x<platforms.size(); x++){
   Platform temp = (Platform)platforms.get(x);
   if(isBounce(temp)){
  if(v.y > playerSpeed/20)
  v = new PVector(v.x/2,-1*v.y/4);
  else
  v = new PVector(0,0);
  pos.y = temp.pos.y - dimen.y; 
  switch(temp.type){
   case 'l': restart(); break;
   case 'd': temp.v.y = 2; break;
   case 's': stamina = maxStamina;
  } 
  }
  }
  }
  
  void render(){ 
    
  correct();  
  if(!onPlat){
  if(v.y < maxFall)
  v.add(grav);
  pos.add(v);  
  
  }
  else
  pos.add(v); 

  if(v.y==0 && !keyPressed)
  v = new PVector(0.0,0.0); 
  //rect(pos.x,pos.y,dimen.x,dimen.y); //testing
  if(pDir)
  image(p1, pos.x,pos.y);  
  else
  image(p2, pos.x-dimen.x/2-20,pos.y); 
  }
}

void restart(){
  setup();
}

class Platform{
  PVector pos;
  PVector dimen;
  int r,g,b;
  PVector v;
  char type;
  int hit;
  
  Platform(float x, float y, float w, float h){
   pos = new PVector(x,y);
   dimen = new PVector(w,h);
   r = g = b = 60;
  if((int)random(3)==0) 
   type = types[(int)random(types.length)];
   else
   type = 'n';
   v = new PVector(0,0);
   hit = 0;
  }
  
 void setColor(int r1, int g1, int b1){
 r = r1;
 g = g1; 
 b = b1; 
 }
  
  void render(){
    if(pos.y > height)
    platforms.remove(this);
    pos.add(v);
    //fill(r,g,b);   
    if(dimen.x > 500){
    fill(205,133,63);
    rect(pos.x,pos.y,dimen.x,dimen.y);
    }
    else{
     if(type == 'l') //lava
     tint(255,50,50);
     
     if(type == 'd') //fall
     tint(255,127);

    image(g2,pos.x,pos.y-10);
    if(type == 's') //coffee
     image(coffee,pos.x+10,pos.y-coffee.height+15);
    if(type == 'F'){
      stroke(0);
      strokeWeight(3);
      line(pos.x+13,pos.y-3,pos.x+13,pos.y-80);
      image(flag,pos.x+15,flagPos-30);
      strokeWeight(0);
    }
    tint(255);
    
  }
  
  }
  
}

class Cloud{
  PVector[] pos = new PVector[3];
  PVector[] dimen = new PVector[3];
  int r,g,b;
  PVector v;
  
  Cloud(float x, float y, float x1, float y1){
    pos[0] = new PVector(x,y);
    pos[1] = new PVector(x+random(-1*x1/10,x1/8),y+random(-1*y1/8,y1/8));
    pos[2] = new PVector(x+random(-1*x1/10,x1/8),y+random(-1*y1/8,y1/8));
    dimen[0] = new PVector(x1,y1);
    dimen[1] = new PVector(x1,y1);
    dimen[2] = new PVector(x1,y1);
    r = g = b = 255;
    if((int)random(2) == 0)
    v = new PVector(cloudSpeed,0);
    else v = new PVector(-1*cloudSpeed,0);
    
  }
  
  void render(){
  fill(r,g,b,20);
  noStroke();
  for(int i=0; i<3; i++){
  pos[i].add(v);
  rect(pos[i].x,pos[i].y,dimen[i].x,dimen[i].y);  
  }
  }
  
}

class Rocket{
  PVector pos;
  PVector dimen;
  PVector v;
  float speed;
  
 Rocket(float x, int seed){
  pos = new PVector(x+random(-100,100)*seed,p.pos.y-height/2);
  dimen = new PVector(rocket.width,rocket.height);
  v = new PVector(p.pos.x-pos.x+random(-100,100),p.pos.y-pos.y+random(-100,100));
  v.normalize();
  speed = rocketSpeed;
  v.mult(speed);
 }

 
 boolean isHit(){
   float x = pos.x+dimen.x/2;
   float y = pos.y+dimen.y;
   if(x>= p.pos.x && x<= p.pos.x + p.dimen.x && y<=p.pos.y+p.dimen.y && y>= p.pos.y){
    return true;
     }
    return false;
     
 }
 void render(){
 if(isHit())
 restart();
 else{
 pos.add(v);
 image(rocket,pos.x,pos.y);
 }
 }
}

