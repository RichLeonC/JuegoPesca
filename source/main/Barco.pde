class Barco extends Agent2D {
  Sail sail;
  Rod rod;

  float oscilationAmplitude = 2; // Amplitud de la oscilacion vertical
  float oscilationFrequency = 0.5; // Frecuencia de la oscilacion
  float rollAmplitude = 3; // Amplitud del balanceo
  float rollFrequency = 1.5; // Frecuencia del balanceo
  float offsetY = 0; // Desplazamiento vertical
  float roll = 0; // angulo de balanceo
  boolean cond = false;
  
  Barco(float x, float y, float mass) {
    super(x, y, mass);
    r*=30;
    sail = new Sail(12, 10);
    rod = new Rod(2, 0.07, x, y);
  }

  void applyWind(float wind) {
    sail.applyWind(wind);
  }

  void update() {
    super.update();
   
    offsetY = sin(millis() * oscilationFrequency * 0.001) * oscilationAmplitude;

    roll = sin(millis() * rollFrequency * 0.001) * rollAmplitude;
    
    sail.update();
    rod.moverBase(pos.x+100, pos.y-200+offsetY);
  }

  void setBait(int index) {
    rod.setBait(index);
  }

  @Override
    void display() {
    pushMatrix();
    translate(pos.x, pos.y+offsetY);
    rotate(radians(roll));
    // Dibujar el cuerpo del barco
    fill(150, 75, 0);
    beginShape();
    vertex(-r, -r); //superior izquierdo
    vertex(r, -r); //superior derecho
    vertex(r/1.5, -r/2); //inferior derecho
    vertex(-r/1.5, -r/2); //infierior izquierdo
    endShape(CLOSE);

    fill(100);
    rect(0, -r, r/15, -1.7*r); // Mastil
    if(!cond){
    sail.setPosition(pos.x-17.9*r/2, pos.y - 12.7*r/2);
    cond = true;
    }
    
    sail.display();
    popMatrix();
    
    rod.update();
    
  }

  void lanzar(float fuerza) {
    rod.lanzar(fuerza);
  }

  void recoger() {
    rod.recoger();
  }
}
