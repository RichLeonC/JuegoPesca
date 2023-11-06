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
      if(a.pos.y < barco.pos.y && a.pescado){
        fish.remove(a);
        barco.addPoints(a.type);
        barco.rod.pescado = false;
        println("Puntos: ", barco.puntos);
        break;
      }
      if(a.pescado){
        a.acc = new PVector(0,0);
        a.pos = barco.rod.carnada.pos;
        a.pos.y = a.pos.y-barco.rod.carnada.mass/2;
      } else {
        if(a.pos.dist(barco.rod.carnada.pos) < 5 && a.isChasing){
          //println("Un pez Pesco la carnada");
          barco.rod.pescado = true;
          a.pescado = true;
        }else if(a.pos.dist(barco.rod.carnada.pos) < 50 && !barco.rod.pescado && matchTypes(a.type,barco.rod.carnada.type)){
          println("Un pez persigue la carnada");
          a.seek(barco.rod.carnada.pos);
          a.isChasing = true;
        }else{
          a.applyForce(field.getVector(a.pos.x, a.pos.y));
          a.separateAlignCohere(fish);
          a.isChasing = false;
        }
      }
      
      // Verificar si el pez ha llegado a la mitad superior de la pantalla
      if (a.pos.y < height * 0.3) {
        // Invertir su velocidad en el eje Y para hacerlo retroceder
        a.vel.y *= -1;      
      } else if (a.pos.y > height) {
          // Si el pez se encuentra por debajo del borde inferior de la pantalla, rebótalo.
          a.vel.y *= -1;
          a.pos.y = height; // Ajusta la posición para evitar que quede fuera de la pantalla.
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
  
  boolean matchTypes(FishType fish, BaitType bait){
    if(fish == FishType.ATUN && bait == BaitType.SARDINA){
      return true;
    }
    if(fish == FishType.GLOBO && bait == BaitType.CAMARON){
      return true;
    }
    if(fish == FishType.PAYASO && bait == BaitType.LOMBRIZ){
      return true;
    }
    if(fish == FishType.ANGEL && (bait == BaitType.CAMARON || bait == BaitType.LOMBRIZ)){
      return true;
    }
    if(bait == BaitType.NONE){
      Random random = new Random();
      float randomValue = random.nextFloat(0,1);
      return randomValue <= 0.3;
    }
    return false;
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
