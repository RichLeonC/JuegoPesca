import controlP5.*;
import ddf.minim.*;

Barco barco;
Sail sail;
int MaxPeces = 30;

final int peso1 = 10;
final int peso2 = 15;
final int peso3 = 20;
final int peso4 = 25;

int lastTime = 0; // Variable para realizar un seguimiento del tiempo del último evento
int interval = 10000;

float g = 0.1;
PVector gravity;

boolean userWindApplied = false;
int indexCarnadaActual = -1;
boolean isHandlingEvent = false;

//menu
ControlP5 cp5; //ControlP5
float FuerzaViento = 0.1;
float FuerzaCorriente = 0.006;
float pezPayaso = 0;
float pezGlobo = 0;
float pezAngel = 0;
float pezAtun = 0;
CheckBox carnadaEscogidaCheckBox;
int carnadaEscogidaIndex;
Knob knobViento;
Knob knobCorriente;

//imagenes
PImage BarcoSprite;
PImage Nube1;
PImage Nube2;
PImage Nube3;
PImage Nube4;
PImage CoralI;
PImage CoralD;

float forceBoat = 5;

float fuerzaRod;
Slider barra;
Slider payasoBarra;
Slider globoBarra;
Slider atunBarra;
Slider angelBarra;
Button botonPescar;

color colorVerde = color(0, 255, 0);
color colorAmarillo = color(255, 255, 0);
color colorAnaranjado = color(255, 165, 0);
color colorRojo = color(255, 0, 0);
color[] colores = {colorVerde, colorAmarillo, colorAnaranjado, colorRojo};
int colorIndex = 1; // Índice del color actual
color colorAnterior = colorVerde;
int tiempoPresionado = 0;
//Sistema de corrientes y peces
FishSystem system;
PVector g2;
float attractForce = 1;
PVector mouse;
float[] probabilidades;

//oceano
float t = 0;

//Musica
Minim minim;
AudioPlayer player;


void setup() {
  frameRate(60);
  //size(1920,1080);
  fullScreen(P2D, 1);
  gravity = new PVector(0, g, 0);
  barco = new Barco(width*0.5, height*0.35, 10);
  probabilidades = distributeProbabilities();
  //Menu
  cp5 = new ControlP5(this);
  minim = new Minim(this);
  player = minim.loadFile("fishingSong.mp3");
  player.play();


  createMenu(width/10, width/18);

  //Sistema de corrientes y peces
  system = new FishSystem();
  g2 = new PVector(0, 0.1);
  mouse = new PVector(0, 0);
  // Generar peces al inicio
  generateMultipleFish(10); // Genera 5 peces al inicio
  
  //imagenes
  BarcoSprite  = loadImage("Barco.png");
  Nube1  = loadImage("nubes0.png");
  Nube2  = loadImage("nubes1.png");
  Nube3  = loadImage("nubes4.png");
  Nube4  = loadImage("nubes3.png");
  
  CoralI  = loadImage("CoralesIzq.png");
  CoralD  = loadImage("CoralesDer.png");
  
 

}

void draw() {
  background(200, 220, 255);
  fill(0, 0, 220, 100);
    
  imageMode(CORNER);
  image(Nube4, 0, 0, width/2, height/4); 
  image(Nube2, width - width/2, 0, width/2, height/2);
  noStroke();
  
  FuerzaViento = knobViento.getValue();
  FuerzaCorriente = knobCorriente.getValue();
  drawOceanGradient();
  drawOceanSurface();
  imageMode(CORNER);
  image(CoralI, 0, height - height/2, width/2, height/2);
  image(CoralD, width - width/2, height - height/2, width/2, height/2);
  
  cp5.get(Textlabel.class, "puntosLabel").setText("Puntos: " + barco.puntos);
  t += (FuerzaCorriente*0.10);
  barco.display();
  barco.update();
  if (mousePressed) {
    float fuerza = (float)barra.getValue() + 1;
    barra.setValue(fuerza);
    color colorActual;
    if (fuerza < 50) {
      float tiempoPresionadoFraccion = map(fuerza, 0, 50, 0, 1);
      colorActual = lerpColor(color(0, 255, 0), color(255, 255, 0), tiempoPresionadoFraccion);
    } else {
      float tiempoPresionadoFraccion = map(fuerza-50, 0, 75, 0, 1);
      colorActual = lerpColor(color(255, 255, 0), color(255, 0, 0), tiempoPresionadoFraccion);
    }
    barra.setColorForeground(colorActual);
  }
  int currentTime = millis();
  if (currentTime - lastTime >= interval) {
    int x = random(0,1) > 0.5? width: -width;
    int y = random(0,1) > 0.5? height: height/2;
    system.addFish(x,y,50);
    //println("Ha pasado 10 segundos, realiza algo aquí");
    lastTime = currentTime;
  }

  system.update();
  if(system.pescando){   
    botonPescar.setVisible(true);
    system.barraPelea.displayBarra();
  }   
}

float[] distributeProbabilities() {
  Random random = new Random();
  float[] probabilities = new float[4];
  float remainingProbability = 1.0f;

  for (int i = 0; i < 3; i++) {
    float minProbability = Math.max(0.1f, remainingProbability - 0.7f);
    float maxProbability = Math.min(0.7f, remainingProbability - 0.1f);
    float randomProbability = minProbability + random.nextFloat() * (maxProbability - minProbability);
    probabilities[i] = round(randomProbability * 100.0) / 100.0; // Redondea a 2 decimales
    remainingProbability -= probabilities[i];
  }

  probabilities[3] = round(remainingProbability * 100.0) / 100.0; // Redondea a 2 decimales

  // Mezcla el orden para obtener una distribución aleatoria
  for (int i = 0; i < probabilities.length - 1; i++) {
    int j = random.nextInt(probabilities.length - i) + i;
    float temp = probabilities[i];
    probabilities[i] = probabilities[j];
    probabilities[j] = temp;
  }

  return probabilities;
}

void keyPressed() {
  
  forceBoat = 5-(FuerzaViento*3.5);
  
  if (key == 'a') {
    userWindApplied = true;
    
    barco.applyForce(new PVector(-forceBoat, 0));
    barco.applyWind(-FuerzaViento);
  } else if (key=='d') {
    userWindApplied = true;

    barco.applyForce(new PVector(forceBoat, 0));
    barco.applyWind(FuerzaViento);
  }
  if (key == ' ') {
    barco.recoger();
  }
  if(key == 'w'){
    barco.rod.addPeso();
  }
  if(key == 's'){
    barco.rod.substractPeso();
  }
}

void mousePressed() {
  if (mouseY > height*0.3 && mouseX > 70) {
    barra.setVisible(true);
  }
}

void mouseReleased(){
  if(mouseY > height*0.3  && mouseX > 70){
    //println("Entra a lanzar");
    fuerzaRod = barra.getValue();
    if(mouseX < barco.pos.x){
      barco.lanzar(-fuerzaRod);
    }else{
      barco.lanzar(fuerzaRod);
    }
    //println(fuerzaRod);
    
  }
  barra.setValue(0);
  barra.setVisible(false);
}

void keyReleased() {
  if (key == 'a' || key == 'd') {
    userWindApplied = false;
  }
}

void drawOceanGradient() {
  noStroke();
  rectMode(CORNER);

  // Cantidad de tonos azules
  int numTonos = height - (int)(height * 0.3);

  for (int i = 0; i < numTonos; i++) {
    // Mapeo de la posición del rectángulo al rango de colores deseados
    float inter = map(i, 0, numTonos, 0, 1);
    int c = lerpColor(color(0, 0, 220, 100), color(0, 0, 140), inter);
    fill(c);
    // Dibujamos el rectángulo
    rect(0, (height * 0.3) + i, width, 1);
  }
}

void drawWave(float yStart, float waveHeight, float wavelength) {
  beginShape();
  // Extremo izquierdo de la ventana
  vertex(0, height);
  
  for (float x = 0; x <= width+50; x+=50) {
   
    float y1 = yStart + noise((x / wavelength) +t) * waveHeight - waveHeight/2;
    int c1 = getGradientColor(y1 + yStart); 
    fill(c1, 150); 
    vertex(x, y1);

  }
  //extremo derecho de la ventana
  vertex(width, height);
  endShape(CLOSE);
  
}

// Función para obtener el color del gradiente basado en la altura y
int getGradientColor(float y) {
  float inter = map(y, height * 0.3, height, 0, 1);
  return lerpColor(color(0, 0, 220, 100), color(0, 0, 140), inter);
}

void drawOceanSurface() {
  for (int i = 0; i < 5; i++) {
    drawWave(height * 0.3 + i * 20, 60 - i * 12, 200 - i * 40);
  }
}

void createMenu(int x, int y) {

  int spacing = 30;
  int knobSize = 150;
  int sliderOffset = 50;
  int checkboxOffset = 30;

  ControlFont customFont = new ControlFont(createFont("Arial", 18));
  ControlFont fontPuntos = new ControlFont(createFont("Arial black", 30));

  // Perillas
  knobViento = cp5.addKnob("Fuerza Viento")
    .setPosition(1920*x/width - knobSize - spacing, 1080*y/height - knobSize/2)
    .setRadius(knobSize/2)
    .setRange(0, 1)
    .setValue(0.1)
    .setFont(customFont);
    

  knobCorriente = cp5.addKnob("Fuerza Corriente")
    .setPosition(1920*x/width + spacing, 1080*y/height - knobSize/2)
    .setRadius(knobSize/2)
    .setRange(0.00, 0.30)
    .setValue(0.06)
    .setFont(customFont);

  // Sliders
  payasoBarra = cp5.addSlider("pezPayaso")
    .setPosition(1920*x/width - knobSize - spacing, 1080*y/height + knobSize/2 + sliderOffset)
    .setWidth(200)
    .setHeight(30)
    .setRange(0, 1)
    .setFont(customFont);

  pezPayaso = probabilidades[0];
  payasoBarra.setValue(pezPayaso);
  payasoBarra.addListener(new ControlListener() {
    public void controlEvent(ControlEvent e) {
      //println("pezPayaso ahorita: ", pezPayaso);
      pezPayaso = payasoBarra.getValue();
      //println("pezPayaso despues del getValue: ", pezPayaso);
      //println("Debe ser menor de: ", 1-pezAngel-pezAtun-pezGlobo);
      pezPayaso = constrain(pezPayaso, 0, 1-pezAngel-pezAtun-pezGlobo);
      //println("pezPayaso despues del constrain: ", pezPayaso);
      payasoBarra.setValue(pezPayaso);
    }
  }
  );

  globoBarra = cp5.addSlider("pezGlobo")
    .setPosition(1920*x/width - knobSize - spacing, 1080*y/height + knobSize/2 + sliderOffset * 2)
    .setWidth(200)
    .setHeight(30)
    .setRange(0, 1)
    .setFont(customFont);

  pezGlobo = probabilidades[1];
  globoBarra.setValue(pezGlobo);
  globoBarra.addListener(new ControlListener() {
    public void controlEvent(ControlEvent e) {
      pezGlobo = globoBarra.getValue();
      pezGlobo = constrain(pezGlobo, 0, 1-pezAngel-pezAtun-pezPayaso);
      globoBarra.setValue(pezGlobo);
    }
  }
  );

  angelBarra = cp5.addSlider("pezAngel")
    .setPosition(1920*x/width - knobSize - spacing, 1080*y/height + knobSize/2 + sliderOffset * 3)
    .setWidth(200)
    .setHeight(30)
    .setRange(0, 1)
    .setFont(customFont);

  pezAngel = probabilidades[2];
  angelBarra.setValue(pezAngel);
  angelBarra.addListener(new ControlListener() {
    public void controlEvent(ControlEvent e) {
      pezAngel = angelBarra.getValue();
      pezAngel = constrain(pezAngel, 0, 1-pezGlobo-pezAtun-pezPayaso);
      angelBarra.setValue(pezAngel);
    }
  }
  );

  atunBarra = cp5.addSlider("pezAtun")
    .setPosition(1920*x/width - knobSize - spacing, 1080*y/height + knobSize/2 + sliderOffset * 4)
    .setWidth(200)
    .setHeight(30)
    .setRange(0, 1)
    .setFont(customFont);

  pezAtun = probabilidades[3];
  atunBarra.setValue(pezAtun);
  atunBarra.addListener(new ControlListener() {
    public void controlEvent(ControlEvent e) {
      pezAtun = atunBarra.getValue();
      pezAtun = constrain(pezAtun, 0, 1-pezGlobo-pezAngel-pezPayaso);
      atunBarra.setValue(pezAtun);
    }
  }
  );

  cp5.addTextlabel("titleLabel")
    .setText("Opciones de Carnada")
    .setPosition(1920*x/width - knobSize - spacing, 1080*y/height + knobSize/2 + sliderOffset * 5 + checkboxOffset)
    .setFont(customFont)
    .setColor(color(255))
    .setColorBackground(color(0, 100));


  // Checkboxes
  carnadaEscogidaCheckBox = cp5.addCheckBox("carnadaEscogidaCheckBox")
     .setPosition(1920*x/width - knobSize - spacing, 1080*y/height + knobSize/2 + sliderOffset * 6 + checkboxOffset)
     .setItemWidth(30) 
     .setItemHeight(30) 
     .setColorForeground(color(0,255,0))
     .setColorActive(color(150))
     .setColorLabel(color(255))
     .setFont(customFont)
     .addItem("Sardina", 1)
     .addItem("Camarón", 2)
     .addItem("Lombriz", 3)
     .addItem("Ninguna", 4)
     .setFont(customFont);
     
     cp5.addTextlabel("puntosLabel")
     .setText("Puntos: "+barco.puntos)
     .setPosition(width*1725/1920,height*35/1080)
     .setColorValue(0)
     .setFont(fontPuntos);
 
   for (Toggle t : carnadaEscogidaCheckBox.getItems()) {
      t.addListener(new ControlListener() {
        public void controlEvent(ControlEvent e) {
          if (e.getController() instanceof Toggle) {
            Toggle selectedToggle = (Toggle)e.getController();
            int selectedValue = (int)selectedToggle.getValue();
            String selectedItemName = selectedToggle.getName();
            switch(selectedItemName){
              case "Sardina":
                carnadaEscogidaCheckBox.deactivateAll();
                carnadaEscogidaCheckBox.activate(0);
                carnadaEscogidaIndex = 0;
                break;
              case "Camarón":
                carnadaEscogidaCheckBox.deactivateAll();
                carnadaEscogidaCheckBox.activate(1);
                carnadaEscogidaIndex = 1;
                break;
              case "Lombriz":
                carnadaEscogidaCheckBox.deactivateAll();
                carnadaEscogidaCheckBox.activate(2);
                carnadaEscogidaIndex = 2;
                break;
              case "Ninguna":
                carnadaEscogidaCheckBox.deactivateAll();
                carnadaEscogidaCheckBox.activate(3);
                carnadaEscogidaIndex = 3;
                break;
            }
            barco.setBait(carnadaEscogidaIndex);
            barco.rod.lanzada = false;
            //println("Elemento seleccionado: " + selectedItemName + " con valor " + selectedValue);
            // Realiza acciones específicas basadas en el elemento seleccionado
          barco.setBait(carnadaEscogidaIndex);
          barco.rod.lanzada = false;
          println("Elemento seleccionado: " + selectedItemName + " con valor " + selectedValue);
          // Realiza acciones específicas basadas en el elemento seleccionado
        }
      }
    }
    );
  }

  barra = cp5.addSlider("fuerza")
    .setPosition(width/2, 10)
    .setSize(100, 20)
    .setRange(0, 100)
    .setValue(fuerzaRod)
    .setColorForeground(color(255))
    .setColorBackground(color(150))
    .setColorValueLabel(0)
    .setLabelVisible(false);
  barra.setVisible(false);
  
    botonPescar = cp5.addButton("pescar")
     .setPosition(width / 2 - 50, height - 50)
     .setSize(100, 40)
     .setLabel("Clic aquí")
     .setVisible(false);
}



void FuerzaViento(float val) {
  FuerzaViento = val;
}

void FuerzaCorriente(float val) {
  FuerzaCorriente = val;
}

void pezPayaso(float val) {
  pezPayaso = val;
}

void pezGlobo(float val) {
  pezGlobo = val;
}

void pezAngel(float val) {
  pezAngel = val;
}

void pezAtun(float val) {
  pezAtun = val;
}

void pescar(){
  print("entra");
  system.barraPelea.clicButton();
}

void generateMultipleFish(int numFish) {
  for (int i = 0; i < numFish; i++) {
    float x = random(width); // Posición X aleatoria
    float y = random(height * 0.5, height); // Posición Y aleatoria en la mitad inferior de la pantalla
    system.addFish(x, y, 50);
  }
}
