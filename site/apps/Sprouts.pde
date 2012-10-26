//SPROUTS
color bkg = color(255);
PFont f;
float sproutWidth = 8;
float sproutSelectionWidth = sproutWidth*2.5;
float thresh = 10;
float pointThresh = 5;
float checkerThresh = 10;

Sprout pressed = null;
Sprout connected = null;
Sprout newSprout = null;
LineSegment currLine;
boolean drawPhase, pickNewPhase, isLegal, player, gameOver;

ArrayList<Sprout> sprouts;
ArrayList<CurveShape> curves;
ArrayList<LineSet> curveLines;


void setup() {
  size(1000, 600);
  background(bkg);
  noStroke();
  smooth();

  f = loadFont("Helvetica-30.vlw");

  sprouts = new ArrayList<Sprout>();
  for (int x=0; x<3; x++)
    sprouts.add(new Sprout(300*x+170, height/2));

  drawPhase = pickNewPhase = false;
  isLegal = true;
  player = true;
  gameOver = false;
  curves = new ArrayList<CurveShape>();
 
  curveLines = new ArrayList<LineSet>();
  
  currLine = null;
}

void draw() {
  noStroke();
  fill(0);
  textFont(f,30);
  background(bkg);
  
  if(gameOver){
   text("Game Over!",20,40); 
   if(player){
     text("\nPlayer 2 wins!",20,40); 
   }else{
      text("\nPlayer 1 wins!",20,40);
   }
   text("\n\nPress 'r' to restart",20,40);
  }else if (drawPhase) {
    curves.get(curves.size()-1).addPos();
    currLine = curves.get(curves.size()-1).getCurrLine();
    text("Draw a line to another sprout!",20,40);
    text("Press Z to undo",width-280,40);
    if(!isLegal){
      text("Not legal!",40,200);
    }
  }
  else if (pickNewPhase) {
    PVector nearPos = curves.get(curves.size()-1).findNearest();
    newSprout = null;
    if (nearPos != null) {
      newSprout = new Sprout(nearPos.x, nearPos.y);
      newSprout.render();
    }
    text("Place a new sprout!",20,40);
    text("Press Z to undo",width-280,40);
  }else{
    
     gameOver = gameOverCheck();
     
     
   text("Pick a sprout!",20,40); 
   if(player){
     text("Player 1",width-150,40); 
   }else{
     text("Player 2",width-150,40); 
   }
  }
  
 

  for (Sprout s : sprouts) {
    if (s.isOver()) {
      s.over = true;
    }
    else {
      s.over = false;
    }
    s.render();
  }

  for (CurveShape c : curves) {
    c.render();
  }
  
}

void keyPressed(){
 if(key == 'z' || key == 'Z'){
  if(drawPhase){
    drawPhase = false;
    curves.remove(curves.size()-1);
    pressed.connectors--;
    isLegal = true;
    
    System.out.println(pressed.connectors);
  }else if(pickNewPhase){
    pickNewPhase = false;
    curves.remove(curves.size()-1);
    pressed.connectors--;
    connected.connectors--;
    System.out.println(pressed.connectors + " " + connected.connectors);
  }
 }else if(key == 'r' || key == 'R'){
  setup();
 } 
  
}


void mousePressed() {
  if (drawPhase) {
    if(isLegal){
    for (Sprout s : sprouts) {
      if (s.over && s.connectors < 3) {
        s.connectors++;
        connected = s;
        curves.get(curves.size()-1).addPos(s.pos.x, s.pos.y);
        System.out.println(s.connectors);
        drawPhase = false;
        pickNewPhase = true;
       // pressed = null;
        break;
      }
    }
    }
  }
  else if (pickNewPhase) {

    if (newSprout != null) {
      sprouts.add(newSprout);
      newSprout.connectors += 2;
      pickNewPhase = false;
      curves.get(curves.size()-1).setLines();
      player = !player;
    }
  }
  else {
    for (Sprout s : sprouts) {
      if (s.over && s.connectors < 3) {
        s.pressed = true; 
        pressed = s;
        s.connectors++;
        drawPhase = true;
        curves.add(new CurveShape(pressed.pos.x, pressed.pos.y));
        System.out.println(pressed.pos.x);
        break;
      }
    }
  }
}

boolean gameOverCheck(){
 int lives = 3*sprouts.size();
 for(Sprout s : sprouts){
    lives -= s.connectors;
 } 
 if(lives < 2){
 return true;
 }
 return false;
}

class Sprout {
  PVector pos;
  int connectors;
  boolean over, pressed;

  Sprout(float x, float y) {
    this(x, y, 0);
    over = pressed = false;
  }

  Sprout(float x, float y, int c) {
    pos = new PVector(x, y); 
    connectors = c;
    over = pressed = false;
  }

  boolean isOver() {
    float disX = pos.x - mouseX;
    float disY = pos.y - mouseY;
    if (sqrt(sq(disX) + sq(disY)) < sproutSelectionWidth/2 ) {
      return true;
    } 
    else {
      return false;
    }
  }


  void render() {
    if (over) {
      fill(0, 100);
      ellipse(pos.x, pos.y, sproutSelectionWidth, sproutSelectionWidth);
    }
    fill(0);
    ellipse(pos.x, pos.y, sproutWidth, sproutWidth);
  }
}

class CurveShape {
  ArrayList<PVector> vertices;

  CurveShape(float x, float y) {
    vertices = new ArrayList<PVector>();
    vertices.add(new PVector(x, y));
  }

  void addPos() {
    vertices.add(new PVector(mouseX, mouseY));
  }

  void addPos(float x, float y) {
    vertices.add(new PVector(x, y));
  }

  PVector findNearest() {
    for (PVector p : vertices) {
      if (sqrt(sq(p.x-mouseX)+sq(p.y-mouseY)) < thresh) {
        return p;
      }
    }
    return null;
  }
 
  
  LineSegment getCurrLine(){
    return new LineSegment(vertices.get(vertices.size()-1),vertices.get(vertices.size()-2));
  }
  
  void setLines(){
    LineSet s = new LineSet();
    s.addAll(vertices);
    curveLines.add(s);
  }

  void render() {
    noFill();
    stroke(0);
    beginShape();
    for (PVector p : vertices) {
      curveVertex(p.x, p.y);
    }
    endShape();
    if(drawPhase){
      for(LineSet l : curveLines){
         if(l.intersects(currLine)){
           isLegal = false;
      }
      }
      
    }
  }
}


class LineSegment{
 PVector start,end;

 public LineSegment(float x, float y, float x1, float y1){
  start = new PVector(x,y);
  end = new PVector(x1,y1);
  
 }
 
  public LineSegment(PVector p1, PVector p2){
  start = new PVector(p1.x,p1.y);
  end = new PVector(p2.x,p2.y);
  
 }
 
 boolean ccw(PVector A,PVector B,PVector C){
    return (C.y-A.y)*(B.x-A.x) > (B.y-A.y)*(C.x-A.x);
 }

 boolean intersects(LineSegment other){
   PVector A = start;
   PVector B = end;
   PVector C = other.start;
   PVector D = other.end;
   return ccw(A,C,D) != ccw(B,C,D) && ccw(A,B,C) != ccw(A,B,D);
  
  
  }
}

class LineSet{
 ArrayList<LineSegment> segments;

 public LineSet(){
  segments = new ArrayList<LineSegment>();
  
 } 
 
 void add(float x, float y, float x1, float y1){
  segments.add(new LineSegment(x,y,x1,y1)); 
 }
 
 void addAll(ArrayList<PVector> v){
   PVector last = null;
   for(PVector p : v){
     if(last != null){
       add(last.x,last.y,p.x,p.y);
     }
     last = p;
     
   }
   
 }
 
 boolean intersects(LineSegment other){
   PVector pos = other.end;
   if(pressed.pos.dist(pos) < thresh || connected.pos.dist(pos) < thresh || newSprout.pos.dist(pos) < thresh)
     return false;
  for(LineSegment l : segments){
   if(l.intersects(other)){
    return true; 
   }
  }
   return false; 
   
 }
  
  
}

