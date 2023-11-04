class FishSystem {
  ArrayList<Fish> fish;
  Currents field;

  FishSystem() {
    fish = new ArrayList<Fish>();
    field = new Currents(50);
  }
  // este método también dibuja en pantalla
  void update() {
    field.update();
    //field.display();
    for (Fish a : fish) {     
      a.applyForce(field.getVector(a.pos.x, a.pos.y));
      a.separateAlignCohere(fish);
      // Verificar si el pez ha llegado a la mitad superior de la pantalla
      if (a.pos.y < height * 0.3) {
        // Invertir su velocidad en el eje Y para hacerlo retroceder
        a.vel.y *= -1;      
      }
      a.update();
      a.display();
      

    }
  }
  void addFish(float x, float y, float mass) {
    Fish a = new Fish(x, y, mass);
    a.randomVel(1);
    fish.add(a);
  }
  void applyForce(PVector force) {
    for (Fish a : fish) {
      a.applyForce(force);
    }
  }
  void attract(float x, float y, float rate) {
    for (Fish a : fish) {
      PVector dif = new PVector(x, y);
      dif.sub(a.pos);
      dif.setMag(rate);
      a.applyForce(dif);
    }
  }
  void repel(float x, float y, float rate) {
    attract(x, y, -rate);
  }  
}
