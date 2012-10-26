
PFont f;
ArrayList<Block> blocks;
Block player;
boolean gameOver,started,newLevel;
int level,blockCounter,score,madeCounter;
float translated;

final float playerDimen = 40;
color bkg = color(255,255,255);
final color textCol = color(70,130,180);
final float divisor = 10.0;  
final float playerVeloc = 9.0;
float decel = .8;

void setup(){
  size(screenWidth,screenHeight);
  background(bkg);
  noStroke();
  smooth();
  player = new Block(width/2-playerDimen/2,height-playerDimen*1.5,playerDimen);
  player.veloc.y = -2;
  blocks = new ArrayList<Block>();
  gameOver = false;
  newLevel = false;
  started = false;
  level = 1;
  blockCounter = 100;
  f = loadFont("BlairMdITCTT-Medium-48.vlw");
  translated = score = madeCounter =  0;
  player.a = 1;
}

void newGame(){
  background(bkg);
    player = new Block(width/2-playerDimen/2,height-playerDimen*1.5,playerDimen);
  player.veloc.y = -2;
  blocks = new ArrayList<Block>();
  gameOver = false;
  newLevel = false;
  started = false;
  level = 1;
  blockCounter = 100;
  translated = score = madeCounter =  0;
}


void draw(){
  background(bkg);
   fill(textCol);
  textFont(f,30);
  
  if(started){
  if(!gameOver){
    if(!newLevel){
    text("Level "+level,20,height/9);
    
    translated = (height-playerDimen*1.5)-player.pos.y;
    translate(0,translated);

  getPlayerPos();
  addMoreBlocks();
  
  Block toRemove = null;
  
  for(Block b : blocks){
    b.render();
    if(b.collides()){
      gameOver = true;
      started = true;
      newLevel = false;
      newGame();
    }
    if(b.pos.y > player.pos.y + playerDimen*1.5){
      toRemove = b;
      score++; 
      
    }
  }
  
  if(toRemove != null){
   blocks.remove(toRemove); 
  }
 
  
  if(score >= 10 + level*2){
    newLevel = true;
  }
  player.render();
  }else{
   newlevel(); 
  }
  }else{
   gameOver();
  }
  }else{
    welcome();
  }
  
  
}

void getPlayerPos(){
   
  if(player.pos.x < 0){
    player.pos.x = 0;
    player.veloc.x = 0; 
  }
  else if(player.pos.x + playerDimen > width){
    player.pos.x = width-playerDimen;
       player.veloc.x = 0; 
  } 
  else if(keyPressed && keyCode == LEFT){
    player.veloc.x = -1*playerVeloc;
  }
  else if(keyPressed && keyCode == RIGHT){
    player.veloc.x = playerVeloc;
  }
  
}

void addMoreBlocks(){
  int levelAmount = 150-level*10;
  if(levelAmount - 40 < 0)
  levelAmount = 60;
  blockCounter += (int)abs(player.veloc.y);
  if(blockCounter >= levelAmount && madeCounter < 10 + level*2){
   blockCounter = 0;
   if((int)random(5)==0 && level > 3)
   blocks.add(new MovingBlock(random(width-40),0-translated-60,40+level*3,40));
   else if((int)random(7)==0 && level > 5)
   blocks.add(new BombBlock(random(width-40),0-translated-60,40+level*3,40));
   else if((int)random(5)==0 && level > 7)
   blocks.add(new SizeBlock(random(width-40),0-translated-60,40+level*3,40,40+level*3+50));
   else
   blocks.add(new Block(random(width-40),0-translated-60,40+level*3,40, color(random(100,220),random(100,220),random(100,220))));
   madeCounter++;
  }
  
}

void welcome(){
 textFont(f,40);
 fill(textCol);
 text("Welcome to BlockDodge!",30,60); 
 textFont(f,30);
 text("Use left and right to move.\n\nAvoid other Blocks!\n\nClick here to start",30,200); 
}

void newlevel(){
 textFont(f,40);
 fill(textCol);
 text("You made it past level " + level + "!",30,60); 
 textFont(f,30);
 if(level+1 == 4)
 text("Watch out for Rainbow Blocks!\n\n(They move)",30,400);
  if(level+1 == 6)
 text("Watch out for Bomb Blocks!\n\n(They fall)",30,400);
  if(level+1 == 8)
 text("Watch out for Growing Blocks!\n\n(They change size)",30,400);
 text("Press any key to continue",30,200);
  
}

void gameOver(){
 textFont(f,40);
 fill(textCol);
 text("You Lost!\n\nYou made it to level " + level + "!",30,60); 
 textFont(f,30);
 text("Press any key to try again",30,300); 

}

void keyPressed(){
 mousePressed(); 
}

void mousePressed(){
 if(!started)
  started = true; 
  if(gameOver){
    newGame();
  }
 if(newLevel){
  newLevel = false;
  level++; 
  player.veloc.y -= .2;
  score = 0;
  madeCounter =  0;
  blocks = new ArrayList<Block>();
  player.pos.x = width/2-playerDimen/2;
 }
}

class Block{
  PVector pos,dimen,veloc;
  color col;
  float a;
  
  Block(float x, float y, float dimen){
    pos = new PVector(x,y);
    this.dimen = new PVector(dimen,dimen);
    col = color(0);
    veloc = new PVector(0,0);
  }
  
  Block(float x, float y, float xDimen, float yDimen,color c){
    pos = new PVector(x,y);
    this.dimen = new PVector(xDimen,yDimen);
    col = c;
    veloc = new PVector(0,0);
  }
  
  void setColor(color c){
    col = c;
  }
  
  void setVeloc(float x, float y){
   veloc = new PVector(x,y); 
  }
  
  void render(){
    fill(col);
    if( a != 0){
     veloc.x *= decel;
    }
    pos.add(veloc);
    rect(pos.x,pos.y,dimen.x,dimen.y);
  }
  
  boolean collides(){
    if(player.pos.x >= pos.x && player.pos.x <= pos.x + dimen.x && player.pos.y >= pos.y && player.pos.y <= pos.y + dimen.y)
      return true;
    if(player.pos.x + playerDimen >= pos.x && player.pos.x + playerDimen <= pos.x + dimen.x && player.pos.y >= pos.y && player.pos.y <= pos.y + dimen.y)
      return true;
    return false;
    
  }
    
}

class MovingBlock extends Block{
 
 MovingBlock(float x, float y, float xDimen, float yDimen){
  super(x,y,xDimen,yDimen,color(0));
  veloc = new PVector((int)random(-10,10)/10.0*level,0);
 }
 
 void render(){
    fill(random(255),random(255),random(255));
    if(pos.x < 0 || pos.x + dimen.x > width)
    veloc.x*= -1;
    pos.add(veloc);

    rect(pos.x,pos.y,dimen.x,dimen.y);
 }
  
  
}

class BombBlock extends Block{
 
 boolean alternate; 
  
 BombBlock(float x, float y, float xDimen, float yDimen){
  super(x,y,xDimen,yDimen,color(0));
  veloc = new PVector(0,1);
  alternate = true;
  }
  
  void render(){
    if(alternate){
    fill(270,0,0);
    alternate = false;
    }else{
    fill(0);
    alternate = true; 
    }
    
    veloc.y += .01;
    pos.add(veloc);

    rect(pos.x,pos.y,dimen.x,dimen.y);
 }

}

class SizeBlock extends Block{
 
 float maxSize,minSize;
 boolean increasing;

  
  SizeBlock(float x, float y, float xDimen, float yDimen, float maxSize){
  super(x,y,xDimen,yDimen,color(random(255),random(255),random(255)));
  this.maxSize = maxSize;
  minSize = xDimen;
  increasing = true;
  }
  
  void render(){
    if(dimen.x < maxSize && increasing){
     dimen.x++;
     pos.x -= .5; 
    }else if(dimen.x > minSize && !increasing){
     dimen.x--;
     pos.x+= .5;
    }else if(dimen.x >= maxSize || dimen.x <= minSize){
      increasing = !increasing;
    }
   
    pos.add(veloc);
    fill(col);
    rect(pos.x,pos.y,dimen.x,dimen.y);
 }

}





    
