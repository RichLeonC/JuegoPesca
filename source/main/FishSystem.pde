import java.util.Random;

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
      if(a.pescado){
        a.acc = new PVector(0,0);
        a.pos = barco.rod.carnada.pos;
        a.pos.y = a.pos.y-barco.rod.carnada.mass/2;
      } else {
        if(a.pos.dist(barco.rod.carnada.pos) < 5){
          println("Un pez Pesco la carnada");
          barco.rod.pescado = true;
          a.pescado = true;
        }else if(a.pos.dist(barco.rod.carnada.pos) < 50 && !barco.rod.pescado){
          println("Un pez persigue la carnada");
          a.seek(barco.rod.carnada.pos);
        }else{
          a.applyForce(field.getVector(a.pos.x, a.pos.y));
          a.separateAlignCohere(fish);
        }
      }
      
      // Verificar si el pez ha llegado a la mitad superior de la pantalla
      if (a.pos.y < height * 0.3) {
        // Invertir su velocidad en el eje Y para hacerlo retroceder
        a.vel.y *= -1;      
      }
      a.update();
      a.display();
      

    }
    for (Agent2D a : barco.rod.agentesCuerda) {     
      // Verificar si el pez ha llegado a la mitad superior de la pantalla
      if (a.pos.y > height * 0.3) {
        a.applyForce(field.getVector(a.pos.x, a.pos.y).div(100));
      }
      a.update();
    }
  }
  void addFish(float x, float y, float mass) {
    Random random = new Random();
    float totalProbability = pezPayaso + pezGlobo + pezAngel + pezAtun;
    if (totalProbability < 1.0) {
        // Añadir la diferencia uniformemente para que sume 1
        float remainingProbability = 1.0 - totalProbability;
        float uniformProbability = remainingProbability / 4.0;
        pezPayaso += uniformProbability;
        pezGlobo += uniformProbability;
        pezAngel += uniformProbability;
        pezAtun += uniformProbability;
    }
    float randomNumber = random.nextFloat();
    FishType type;
    if (randomNumber < pezAngel) {
        type = FishType.ANGEL;
    } else if (randomNumber < pezAngel + pezPayaso) {
        type = FishType.PAYASO;
    } else if (randomNumber < pezAngel + pezPayaso + pezAtun) {
        type = FishType.ATUN;
    } else {
        type = FishType.GLOBO;
    }
    Fish a = new Fish(x, y, mass, type);
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
