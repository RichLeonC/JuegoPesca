import java.util.Random;

class FishSystem {
  ArrayList<Fish> fish;
  Currents field;
  Boolean pescando = false;


  FishSystem() {
    fish = new ArrayList<Fish>();
    field = new Currents(50);
    barraPelea = new BarraPelea();
  }

  // este método también dibuja en pantalla
  void update() {
    field.update();
    //field.display();
    for (Fish a : fish) {
      if(a.isChasing && !a.huyendo){
        if (a.pos.dist(barco.rod.carnada.pos) < 20) {
          this.pescando = true; 
          a.picado = true;
          a.isChasing = false;
        }
      }
      else if(a.picado){
        a.isChasing = false;
        if (barraPelea.Win() == 1) {
          a.pescado = true;
          a.picado = false;
          system.pescando = false;
          barraPelea.win = 2;
        }else if (barraPelea.Win() == 0){
          println("Pero si entra aqui");
          a.picado = false;
          a.isChasing = false;
          a.pescado = false;
          a.huyendo = true;
          a.huyeTime = millis();
          barraPelea.win = 2;
        }
        a.pos = barco.rod.carnada.pos;
      }
      else if(a.pescado){
        a.acc = new PVector(0,0);
        a.pos = barco.rod.carnada.pos;
        a.pos.y = a.pos.y-barco.rod.carnada.mass/2;
        if (a.pos.y < height*0.35) {
          a.picado = false;
          a.pescado = false;
          fish.remove(a);
          barco.addPoints(a.type);
          barco.rod.pescado = false;
          println("Puntos: ", barco.puntos);
          break;
        }
      }
      else if(a.huyendo){
        a.pos = a.pos.copy();
        if (currentTime - a.huyeTime >= 3000) {
          println("Entra aqui nooo");
          a.huyendo = false;
        }
        a.applyForce(field.getVector(a.pos.x, a.pos.y));
        a.separateAlignCohere(fish);
        a.isChasing = false;
      }
      else{
        if(a.pos.dist(barco.rod.carnada.pos) < 100 && !barco.rod.pescado && matchTypes(a.type,barco.rod.carnada.type) && !a.huyendo){
          println("Un pez persigue la carnada");
          a.seek(barco.rod.carnada.pos);
          a.isChasing = true;
        } else {
          a.applyForce(field.getVector(a.pos.x, a.pos.y));
          a.separateAlignCohere(fish);
          a.isChasing = false;
        }
      }      
      a.separateAlignCohere(fish);
      if(a.pos.y < height * 0.35){
        a.applyForce(new PVector(0,1));
      }
      a.update();
      a.display();
    }
    for (Agent2D a : barco.rod.agentesCuerda) {
      if (a.pos.y > height * 0.3) {
        a.applyForce(field.getVector(a.pos.x, a.pos.y).div(100));
      }
      a.update();
    }
  }

  boolean matchTypes(FishType fish, BaitType bait) {
    if (fish == FishType.ATUN && bait == BaitType.SARDINA) {
      return true;
    }
    if (fish == FishType.GLOBO && bait == BaitType.CAMARON) {
      return true;
    }
    if (fish == FishType.PAYASO && bait == BaitType.LOMBRIZ) {
      return true;
    }
    if (fish == FishType.ANGEL && (bait == BaitType.CAMARON || bait == BaitType.LOMBRIZ)) {
      return true;
    }
    if (bait == BaitType.NONE) {
      Random random = new Random();
      float randomValue = random.nextFloat(0, 1);
      return randomValue <= 0.3;
    }
    return false;
  }



  void addFish() {
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
    float x, y;
    FishType type;
    if (randomNumber < pezAngel) {
      type = FishType.ANGEL;
      y = random(height* 0.4, height * 0.8);
    } else if (randomNumber < pezAngel + pezPayaso) {
      type = FishType.PAYASO;
      y = random(height * 0.4, height * 0.5);
    } else if (randomNumber < pezAngel + pezPayaso + pezAtun) {
      type = FishType.ATUN;
      y = random(height *0.7, height * 0.8);
    } else {
      type = FishType.GLOBO;
      y = random(height * 0.6, height * 0.8);
    }
    x = width; // Posición X aleatoria
    int mass = 50;
    Fish a = new Fish(x, y, mass, type);
    a.randomVel(0.1);
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
