Rod rod;
Barco barco;

float g = 0.1;
PVector gravity;


void setup() {
  //size(1280,720);
  fullScreen(P2D, 1);
  gravity = new PVector(0, g, 0);
  rod = new Rod(3, 20);
  barco = new Barco(width/2, height*0.35, 10);
}

void draw() {
  background(200, 220, 255);
  
  fill(0, 0, 220, 100);
  rectMode(CORNER);
  rect(0, height*0.3, width, height*0.7); //El 30% es cielo, el 70% es agua
  rod.update();
  barco.display();
  barco.update();
}

void keyPressed() {
  float force = 5;
  
  if(key == 'a'){
    barco.applyForce(new PVector(-force,0));
  }
  else if(key=='d'){
    barco.applyForce(new PVector(force,0));
  }
  if (key == 'r') {
    rod.recoger();
  } else if (key=='c') {
    rod.lanzar();
  }
}
