class Barco extends Agent2D {

  Barco(float x, float y, float mass) {
    super(x, y, mass);
    r*=30;
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

    // Dibujar la vela


    popMatrix();
  }
}
