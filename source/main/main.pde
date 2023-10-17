Rod rod;

float g = 0.1;
PVector gravity;

void setup(){
  size(1280,720);
  //fullScreen(P2D,1);
  gravity = new PVector(0, g, 0);
  rod = new Rod(3,20);
}

void draw(){
  background(0);
  rod.update();
  fill(0, 0, 220, 100);
  rectMode(CORNER);
  rect(0, height / 2, width, height);
}

void keyPressed(){
  if(key == 'a') {
    rod.recoger();
  }
  else if (keyCode == RIGHT) {
    rod.lanzar();
  }
}
