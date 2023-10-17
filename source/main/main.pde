import controlP5.*;

Rod rod;
Barco barco;

float g = 0.1;
PVector gravity;

//menu
ControlP5 cp5; //ControlP5

void setup() {
  //size(1280,720);
  fullScreen(P2D, 1);
  gravity = new PVector(0, g, 0);
  rod = new Rod(3, 20);
  barco = new Barco(width/2, height*0.35, 10);
  //Menu
  cp5 = new ControlP5(this);
  createMenu(width/10, width/12);
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

void createMenu(int x, int y) {
  int buttonSize = 80;
  int spacing = 20;
  int knobSize = 100;
  int sliderOffset = 20;
  int checkboxOffset = 20; 

  // Botones
  cp5.addButton("Boton1")
     .setPosition(x - buttonSize/2, y - buttonSize - spacing)
     .setSize(buttonSize, buttonSize)
     .setLabel("Aplicar Cambios");

  // Perillas
  cp5.addKnob("FuerzaViento")
     .setPosition(x - knobSize - spacing, y - knobSize/2)
     .setRadius(knobSize/2)
     .setRange(0, 255)
     .setValue(128);

  cp5.addKnob("FuerzaCorriente")
     .setPosition(x + spacing, y - knobSize/2)
     .setRadius(knobSize/2)
     .setRange(0, 100)
     .setValue(50);

  // Sliders 
  cp5.addSlider("pezPayaso")
     .setPosition(x - knobSize - spacing, y + knobSize/2 + sliderOffset)
     .setRange(0, 100);

  cp5.addSlider("pezGlobo")
     .setPosition(x - knobSize - spacing, y + knobSize/2 + sliderOffset * 2)
     .setRange(0, 100);

  cp5.addSlider("pezAngel")
     .setPosition(x - knobSize - spacing, y + knobSize/2 + sliderOffset * 3)
     .setRange(0, 100);

  cp5.addSlider("pezAtun")
     .setPosition(x - knobSize - spacing, y + knobSize/2 + sliderOffset * 4)
     .setRange(0, 100);

  // Checkboxes
  cp5.addCheckBox("Checkbox")
     .setPosition(x - knobSize - spacing, y + knobSize/2 + sliderOffset * 5 + checkboxOffset)
     .setColorForeground(color(120))
     .setColorActive(color(255))
     .setColorLabel(color(255))
     .addItem("Carnada1", 1)
     .addItem("Carnada2", 2)
     .addItem("Carnada3", 3)
     .addItem("Carnada4", 4);
}

void Boton1() {
  println("Botón 1 presionado");
}

void Boton2() {
  println("Botón 2 presionado");
}

void FuerzaViento(float val) {
  println("FuerzaViento 1: " + val);
}

void FuerzaCorriente(float val) {
  println("FuerzaCorriente 2: " + val);

}
