//drawingboard
PFont f;
ArrayList<Word> words;
String[] alice;
Word selected;
boolean instructions = true;

int counter = 0;
final float driftSpeed = .1;

void setup(){
 size(900,600); 
 smooth();
 background(255);
 String[] doc = loadStrings("alice.txt");
   String allText = join(doc, " ");
  alice = splitTokens(allText, " ',.?!:;[]-");
 selected = null;
 words = new ArrayList<Word>();
  f= loadFont("Serif-20.vlw");
 for(counter=0; counter<7; counter++){
   Word w = new Word(random(width),random(height),alice[counter+6]);
   words.add(w);
   if(counter>0)
   words.get(words.size()-1).connect(words.get(words.size()-2));
 }
 counter+=6;

 stroke(0);
}

void draw(){
  
  background(255);
    for(Word w:words)
    w.renderConnectors();
  for(Word w:words)
    w.render();
    
  if(instructions){
    textFont(f,20);
    fill(255,172);
    noStroke();
    rect(0,0,340,55);
    fill(0);
   text("Press any key to generate the next word\nMove words by dragging them",10,20);
   stroke(1);
  }
  
  
}

void mouseDragged(){

 if(selected != null && selected.hovering()) 
   selected.pos = new PVector(mouseX-selected.wi.x/2,mouseY-selected.wi.y/2);
}

void keyPressed(){
  if(key == 'o'){
    instructions = true;
    words = new ArrayList<Word>();
    for(counter=0; counter<7; counter++){
   Word w = new Word(random(width),random(height),alice[counter+6]);
   words.add(w);
   if(counter>0)
   words.get(words.size()-1).connect(words.get(words.size()-2));
 }
 counter+=6;
  }else{
  instructions = false;
    Word w = new Word(random(width),random(height),alice[counter]);
   words.add(w);
   if(counter>0)
   words.get(words.size()-1).connect(words.get(words.size()-2));
   counter++;
  }
}

class Word{
  PVector pos;
  PVector lastPos;
 String val;
 ArrayList<Word> connectors;
 PVector wi;
 PVector veloc;
 boolean hover;
 
  Word(float x, float y, String st) {
   pos = new PVector(x,y);
   val = st; 
   wi = new PVector(30+10*(st.length()-2),30);
   connectors = new ArrayList<Word>();
   veloc = new PVector(random(-1,1),random(-1,1));
  hover = false;
  }
  
  void connect(Word w){
   connectors.add(w); 
  }
  
  void render(){
     veloc.normalize();
    veloc.mult(driftSpeed);
    pos.add(veloc);
    if(pos.x <= 0){
      pos.x=0;
      veloc.x *= -1;
    }
    if(pos.x + wi.x >= width){
      pos.x = width-wi.x;
      veloc.x *= -1;
    }
    if(pos.y <= 0){
      pos.y = 0;
      veloc.y *= -1;
    }
    if(pos.y + wi.y >= height){
      pos.y = height-wi.y;
      veloc.y *= -1;
    }
    
    if(hovering()){
     strokeWeight(3); 
     selected = this;
    }
    else{
      strokeWeight(1);
      //selected = null; 
    }
   
    fill(255,220);
    rect(pos.x,pos.y,wi.x,wi.y);
    textFont(f,20);
    fill(0);
    text(val,pos.x+5,pos.y+20);
  }
  
  boolean hovering(){
   if(mouseX >= pos.x && mouseX <= pos.x+wi.x && mouseY >= pos.y && mouseY <= pos.y+wi.y)
    return true;
   return false; 
  }
  
  void renderConnectors(){
    strokeWeight(1);
     for(Word w:connectors)
      line(pos.x+wi.x/2,pos.y+wi.y/2,w.pos.x+w.wi.x/2,w.pos.y+w.wi.y/2);
  }
  
  void roundRect(float x, float y, float w, float h)
{
  float corner = w/10.0;
  float midDisp = w/20.0;
  
  beginShape();  
  curveVertex(x+corner,y);
  curveVertex(x+w-corner,y);
  curveVertex(x+w+midDisp,y+h/2.0);
  curveVertex(x+w-corner,y+h);
  curveVertex(x+corner,y+h);
  curveVertex(x-midDisp,y+h/2.0);
  
  curveVertex(x+corner,y);
  curveVertex(x+w-corner,y);
  curveVertex(x+w+midDisp,y+h/2.0);
  endShape();
}
  
  
}
