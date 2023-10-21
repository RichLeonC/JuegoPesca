import controlP5.*;

Barco barco;
Sail sail;

float g = 0.1;
PVector gravity;

boolean userWindApplied = false;

//menu
ControlP5 cp5; //ControlP5
float FuerzaViento = 128;
float FuerzaCorriente = 50;
float pezPayaso = 0;
float pezGlobo = 0;
float pezAngel = 0;
float pezAtun = 0;
CheckBox CarnadaEscogida;

//Sistema de corrientes y peces
FishSystem system;
PVector g2;
float attractForce = 1;
PVector mouse;

void setup() {
  frameRate(60);
  //size(1280,720);
  fullScreen(P2D, 1);
  gravity = new PVector(0, g, 0);
  barco = new Barco(width/2, height*0.35, 10);
  //Menu
  cp5 = new ControlP5(this);
  createMenu(width/10, width/18);
  
  //Sistema de corrientes y peces
  system = new FishSystem();
  g2 = new PVector(0, 0.1);
  mouse = new PVector(0, 0);
}

void draw() {
  background(200, 220, 255);
  // background(0);
  fill(0, 0, 220, 100);
  noStroke();
  rectMode(CORNER);
  rect(0, height*0.3, width, height*0.7); //El 30% es cielo, el 70% es agua
  barco.display();
  barco.update();
  
  //sistemas de corrientes y peces
  // Generar múltiples peces automáticamente a intervalos regulares
  if (frameCount % 30 == 0) { // Genera peces cada segundo (30 fotogramas)
    for (int i = 0; i < 5; i++) { // Agrega 5 peces en cada generación
      float x = random(width); // Posición X aleatoria
      float y = random(height); // Posición Y aleatoria
      system.addFish(x, y, 50);
    }
  }
  
  mouse.x = mouseX;
  mouse.y = mouseY;
  if (mousePressed && mouseButton == LEFT) {
    system.addFish(mouseX, mouseY, 50);// float mass = 50;
  }
  if (keyPressed && key == 'a') {
    system.attract(mouseX, mouseY, attractForce);
  }
  if (keyPressed && key == 'z') {
    system.repel(mouseX, mouseY, attractForce);
  }
  system.update();  
}

void keyPressed() {
  float force = 5;

  if (key == 'a') {
    userWindApplied = true;
    barco.applyForce(new PVector(-force, 0));
    barco.applyWind(-0.1);
  } else if (key=='d') {
    userWindApplied = true;

    barco.applyForce(new PVector(force, 0));
    barco.applyWind(0.1);
  }
  if (key == 'r') {
    barco.recoger();
  } else if (key=='c') {
    barco.lanzar();
  }
}

void keyReleased(){
    if (key == 'a' || key == 'd') {
    userWindApplied = false;
  }
  
}
  
void createMenu(int x, int y) {

  int spacing = 30;
  int knobSize = 150;
  int sliderOffset = 50;
  int checkboxOffset = 30; 
  
   ControlFont customFont = new ControlFont(createFont("Arial", 18));
  
  // Perillas
  cp5.addKnob("FuerzaViento")
     .setPosition(x - knobSize - spacing, y - knobSize/2)
     .setRadius(knobSize/2)
     .setRange(0, 255)
     .setValue(128)
     .setFont(customFont);

  cp5.addKnob("FuerzaCorriente")
     .setPosition(x + spacing, y - knobSize/2)
     .setRadius(knobSize/2)
     .setRange(0, 100)
     .setValue(50)
     .setFont(customFont);

  // Sliders 
  cp5.addSlider("pezPayaso")
     .setPosition(x - knobSize - spacing, y + knobSize/2 + sliderOffset)
     .setWidth(200) 
     .setHeight(30) 
     .setRange(0, 100)
     .setFont(customFont);

  cp5.addSlider("pezGlobo")
     .setPosition(x - knobSize - spacing, y + knobSize/2 + sliderOffset * 2)
     .setWidth(200) 
     .setHeight(30) 
     .setRange(0, 100)
     .setFont(customFont);

  cp5.addSlider("pezAngel")
     .setPosition(x - knobSize - spacing, y + knobSize/2 + sliderOffset * 3)
     .setWidth(200) 
     .setHeight(30) 
     .setRange(0, 100)
     .setFont(customFont);

  cp5.addSlider("pezAtun")
     .setPosition(x - knobSize - spacing, y + knobSize/2 + sliderOffset * 4)
     .setWidth(200)
     .setHeight(30)
     .setRange(0, 100)
     .setFont(customFont);


  cp5.addTextlabel("titleLabel")
                 .setText("Opciones de Carnada")
                 .setPosition(x - knobSize - spacing, y + knobSize/2 + sliderOffset * 5 + checkboxOffset)
                 .setFont(customFont) 
                 .setColor(color(255)) 
                 .setColorBackground(color(0, 100));


  // Checkboxes
  cp5.addCheckBox("CarnadaEscogida")
     .setPosition(x - knobSize - spacing, y + knobSize/2 + sliderOffset * 6 + checkboxOffset)
     .setItemWidth(30) 
     .setItemHeight(30) 
     .setColorForeground(color(120))
     .setColorActive(color(255))
     .setColorLabel(color(255))
     .setFont(customFont)
     .addItem("Carnada1", 1)
     .addItem("Carnada2", 2)
     .addItem("Carnada3", 3)
     .addItem("Carnada4", 4)
     .setFont(customFont);;
}

void FuerzaViento(float val) {
  println("FuerzaViento 1: " + val);
  FuerzaViento = val;
}

void FuerzaCorriente(float val) {
  println("FuerzaCorriente 2: " + val);
  FuerzaCorriente = val;
}

void pezPayaso(float val) {
  println("pezPayaso: " + val);
  pezPayaso = val; 
}

void pezGlobo(float val) {
  println("pezGlobo: " + val);
  pezGlobo = val; 
}

void pezAngel(float val) {
  println("pezAngel: " + val);
  pezAngel = val; 
}

void pezAtun(float val) {
  println("pezAtun: " + val);
  pezAtun = val; 
}
