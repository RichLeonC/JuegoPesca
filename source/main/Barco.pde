
class Barco extends Agent2D {
  Sail sail;
  Rod rod;
  int puntos;

  float oscilationAmplitude = 3; // Amplitud de la oscilacion vertical
  float oscilationFrequency = 4; // Frecuencia de la oscilacion
  float rollAmplitude = 3; // Amplitud del balanceo
  float rollFrequency = 1.5; // Frecuencia del balanceo
  float offsetY = 0; // Desplazamiento vertical
  float roll = 0; // angulo de balanceo
  boolean cond = false;
  
  Barco(float x, float y, float mass) {
    super(x, y, mass);
    r*=30;
    sail = new Sail(10, 9);
    rod = new Rod(2,0.03,x,y);
    sail.setPosition(x-width/2+r/2+25, y-height*0.65+50);
  }
  
  void addPoints(FishType type){
      switch(type){
        case ATUN:
          puntos += 1;
          break;
        case ANGEL:
          puntos += 2;
          break;
        case GLOBO:
          puntos += 4;
          break;
        case PAYASO:
          puntos += 5;
          break;
      }
  }

  void applyWind(float wind) {
    sail.applyWind(wind);
  }

  void update() {
    super.update();
    rollFrequency = 1+FuerzaCorriente*11;
    offsetY = sin(millis() * oscilationFrequency * 0.001) * oscilationAmplitude;

    roll = sin(millis() * rollFrequency * 0.001) * rollAmplitude;
    
    sail.update();
    rod.moverBase(pos.x+195, pos.y-100+offsetY);
    /*if (pos.y > height*0.4) {
      applyForce(new PVector(0,-1));
    }
    applyGravity(new PVector(0,1));
    applyDrag(0.2);
    applyFriction(0.2);*/
  }

  void setBait(int index) {
    rod.setBait(index);
  }

  @Override
    void display() {
    pushMatrix();
    translate(pos.x, pos.y+offsetY-55);
    rotate(radians(roll));
    // Dibujar el cuerpo del barco
    fill(150, 75, 0);
    imageMode(CENTER);
    image(BarcoSprite, 0, -r-4, r*4, r*4);

    
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
