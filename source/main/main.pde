Barco barco;

void setup() {
  //size(1280, 720);
  fullScreen(P2D,1);
  barco = new Barco(width/2, height*0.35, 10);
}

void draw() {
  background(200, 220, 255);  // color del cielo
  fill(100, 150, 255);  // color del agua
  rect(0, height*0.3, width, height*0.7); //El 30% es cielo, el 70% es agua
  
  
  barco.display();
  barco.update();
}


void keyPressed(){

  float force = 5;
  
  if(key=='a'){
    barco.applyForce(new PVector(-force,0));
    
  }
  else if(key=='d'){
     barco.applyForce(new PVector(force,0));
  }
}
