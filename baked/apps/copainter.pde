//coop painter
/* @pjs pauseOnBlur="true"; globalKeyEvents="true"; */
color bkg = color(255);

ArrayList<PVector> brush;
float rad = 25;
color col = color(83,119,122);
float[] controlRad = {300,150};
int numColors = 5;
color[] colors = {color(236,208,120),color(217,91,67),color(192,41,66),color(84,36,55),color(83,119,122)};

void setup(){
   size(screenWidth,screenHeight);
   background(255);
   noFill();
   noLoop();
   smooth();
   strokeWeight(rad);
   stroke(col);
    brush = new ArrayList<PVector>();
   
}

void draw(){
 drawBrush();
 drawControls();
}

void keyPressed(){
 if(key == 'r'){
  brush = new ArrayList<PVector>();
  background(255);
  redraw();
 } 
}

void mousePressed(){
  float rad1 = dist(mouseX,mouseY,0,0);
  if(rad1 < controlRad[1]/2){
    rad = rad1;
    redraw();
  }else{
    
    float rad2 = dist(mouseX,mouseY,0,height);
    
    if(rad2 < controlRad[0]/2){
      
      int num = (int)((rad2/(controlRad[0]/2))*numColors);

      col = colors[num];
      
    }else{
    
      brush.add(new PVector(mouseX,mouseY));
      loop();
    }
  }
}

void mouseDragged(){
  brush.add(new PVector(mouseX,mouseY));
}

void mouseReleased(){
  brush = new ArrayList<PVector>();
  noLoop();
}

void drawBrush(){
  beginShape();
  stroke(col);
  strokeWeight(rad);
  noFill();
  for(PVector p : brush){
    curveVertex(p.x, p.y);
  }
  endShape();
  
}

void drawControls(){
  noStroke();
  for(int x=numColors; x>0; x--){
   fill(colors[x-1]);
   ellipse(0,height,controlRad[0]/5*x,controlRad[0]/5*x);
  }
  
  fill(200);
  ellipse(0,0,controlRad[1],controlRad[1]);
  fill(100);
  ellipse(0,0,rad*2,rad*2);
  
  
  
  
}


