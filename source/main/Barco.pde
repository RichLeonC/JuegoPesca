class Barco extends Agent2D {
  Sail sail;

  Barco(float x, float y, float mass) {
    super(x, y, mass);
    r*=30;
    sail = new Sail(12, 10);
  }
  
  void applyWind(float wind){
    sail.applyWind(wind);
  }
  
  void update(){
    super.update();
    sail.update();
  }

  @Override
    void display() {
    pushMatrix();
    translate(pos.x, pos.y);

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

    popMatrix();
    sail.setPosition(pos.x, pos.y - 5.2*r/2);
    sail.display();
  }
}
