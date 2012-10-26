//SNAKE

float blockWidth;
int numBlocksX, numBlocksY;
Block[] blocks;
ArrayList<SnakeTail> tail;
SnakeHead snake;
color bkg;


void setup(){
 size(screenWidth,screenHeight-60);
 smooth();
 noStroke();
 frameRate(8);
 
 bkg = color(200);
 
 if(width > height){
   blockWidth = height/40.0;
   numBlocksX = 1;
 }else{
   blockWidth = width/40.0;
   numBlocksY = 1;
 }
 
   numBlocksX += (int)(width/blockWidth);
   numBlocksY += (int)(height/blockWidth);
   
   blocks = new Block[numBlocksY*numBlocksX];
   
   
   for(int x=0; x<numBlocksX*numBlocksY; x++){
     blocks[x] = new Block((x % numBlocksX)*blockWidth,(x / numBlocksX)*blockWidth,x); 
   }
  
   snake = new SnakeHead(blocks[blocks.length/2 + numBlocksX/2 - 1]);
   tail = new ArrayList<SnakeTail>();
   
   blocks[(int)random(blocks.length)].treat = true;
   blocks[(int)random(blocks.length)].treat = true;
   
}

void draw(){
  
  background(bkg);
  
    
  for(SnakeTail t : tail){
    //println(t.b.pos);
   t.render(); 

  }
  
  snake.render();


  
  for(Block b : blocks){
   b.render(); 
  }
  
  
  
}

void restart(){
 for(int x=0; x<numBlocksX*numBlocksY; x++){
     blocks[x] = new Block((x % numBlocksX)*blockWidth,(x / numBlocksX)*blockWidth,x); 
   }
  
   snake = new SnakeHead(blocks[blocks.length/2 + numBlocksX/2 - 1]);
   tail = new ArrayList<SnakeTail>();
   blocks[(int)random(blocks.length)].treat = true;
   blocks[(int)random(blocks.length)].treat = true;
}

void keyPressed(){
  
 if((keyCode == RIGHT || key == 'd') && snake.leftRight != -1){
   snake.leftRight = 1;
   snake.upDown = 0;
  
 }else if((keyCode == LEFT || key == 'a') && snake.leftRight != 1){
   snake.leftRight = -1;
   snake.upDown = 0;
  
 }else if((keyCode == UP || key == 'w' ) && snake.upDown != 1){
   snake.upDown = -1;
   snake.leftRight = 0;
  
 }else if((keyCode == DOWN || key == 's') && snake.upDown != -1){
   snake.upDown = 1;
   snake.leftRight = 0;
  
 } 
}

class Block{
 PVector pos;
 int index;
 color c;
 boolean treat;

 Block(float x, float y, int index){
   pos = new PVector(x,y);
  c = color(random(220,255));
  this.index = index;
  treat = false;
 } 
  
 
 void render(){
  fill(c);
  if(treat){
   fill(120); 
  }
  rect(pos.x,pos.y,blockWidth,blockWidth,blockWidth/4.0); 
 }
 
}

interface GameObject{
  
    Block getBlock();
  
    color getColor();
    
    int getUpDown();
    
    int getLeftRight();
  
    void render();
}


class SnakeHead implements GameObject{
  
  int upDown, leftRight;
  Block b;
  color c;
  
  SnakeHead(Block b){
    upDown = 0;
    leftRight = 0;
    this.b = b;
    c = color(120);
    b.c = c;
  }
  
  color getColor(){
   return c; 
  }
  
  int getUpDown(){
   return upDown; 
  }
  
  int getLeftRight(){
   return leftRight; 
  }
  
  Block getBlock(){
   return b; 
  }
  
  void render(){ //position updates here
    Block last = b;

    if(tail.size() == 0){
     b.c = color(random(220,255)); 
    }else{
    
    for(int x=0; x<tail.size(); x++){
     SnakeTail t = tail.get(x);
     if(x != tail.size()-1 && t.b == b){
       restart();
     } 
    }
    
    }
    
    
    if(upDown == 1){
      if(b.index+numBlocksX > blocks.length){
       restart();
      }else{
        b = blocks[b.index+numBlocksX];
      }
    }else if(upDown == -1){
      if(b.index-numBlocksX < 0){
       restart();
      }else{
        b = blocks[b.index-numBlocksX];
      }
    }else if(leftRight == -1){
      if((b.index / numBlocksX) != ((b.index-1) / numBlocksX) || b.index-1 < 0){
         restart();
      }else{
        b = blocks[b.index-1];
      }
    }else if(leftRight == 1){
      if((b.index / numBlocksX) != ((b.index+1) / numBlocksX) || b.index > blocks.length){
       restart();
      }else{
        b = blocks[b.index+1];
      }
    }
    
    
    if(b.treat){
      b.treat = false;
      blocks[(int)random(blocks.length)].treat = true;
     if(tail.size() == 0){
       println(b.pos);
       println(last.pos);
      tail.add(new SnakeTail(last,upDown,leftRight,this));
     }else{
      SnakeTail lastTail = tail.get(0);
      tail.add(0,new SnakeTail(lastTail.last,lastTail.upDown,lastTail.leftRight,lastTail));
       println(lastTail.b.pos);
       println(last.pos);

        
      }
      
     } 
      
      
      
    

     b.c = c;
  }
  
}


class SnakeTail implements GameObject{
  
  int upDown, leftRight;
  color c;
  Block b,last;
  GameObject next;
  
  SnakeTail(Block b, int upDown, int leftRight, GameObject next){
    this.upDown = upDown;
    this.leftRight = leftRight;
    this.b = b;
    last = b;
    this.next = next;
    c = color(120);
    b.c = c;
  }
  
   color getColor(){
   return c; 
  }
  
    int getUpDown(){
   return upDown; 
  }
  
  int getLeftRight(){
   return leftRight; 
  }
  
  
  Block getBlock(){
   return b; 
  }
  
  void render(){
    if(this == tail.get(0))
    b.c = color(random(220,255));
    upDown = next.getUpDown();
    leftRight = next.getLeftRight();
    last = b;
    b = next.getBlock();
    b.c = c;

  }
}



