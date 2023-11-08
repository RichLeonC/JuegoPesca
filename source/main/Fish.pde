enum FishType{
  ANGEL, ATUN, PAYASO, GLOBO
}

class Fish extends Agent2D {
  float maxSpeed;
  float maxSteeringForce;
  float arrivalRadius;
  float lookAhead;
  float wanderRadius;
  float wanderNoise;
  float wanderNoiseInc;
  boolean debug;
  float pathAhead;
  float alignmentRadio;
  float alignmentRatio;
  float separationRadio;
  float separationRatio;
  float cohesionRadio;
  float cohesionRatio;
  boolean pescado = false;
  boolean isChasing = false;
  FishType type;
  PImage pezSprite;
  
  
  Fish(float x, float y, float mass, FishType type) {
    super(x, y, mass);
    this.type = type;
    r = sqrt(mass);
    setColor();
    damp = 0.6;
    borderBehaviour = BorderBehaviour.WRAP;
    maxSpeed = 1;
    maxSteeringForce = 1;
    arrivalRadius = 300;
    lookAhead = 40;
    wanderRadius = 30;
    debug = false;
    wanderNoise = random(100);
    wanderNoiseInc = 0.01;
    pathAhead = 30;
    separationRadio = 100;
    separationRatio = 6; 
    alignmentRadio = 80;
    alignmentRatio = 1;
    cohesionRadio = 150;
    cohesionRatio = 1;
  }
  
  void setColor(){
    switch(type){
      case GLOBO:
        this.pezSprite = loadImage("Globo.png");
        this.c = color(0,0,255);//azul
        break;
      case ANGEL:
        this.c = color(255); //blanco
        this.pezSprite = loadImage("Angel.png");
        break;
      case ATUN:
        this.c = color(156,156,156); //gris
        this.pezSprite = loadImage("Atun.png");
        break;
      case PAYASO:
        this.c = color(255,255,0); //amarillo
        this.pezSprite = loadImage("Payaso.png");
        break;
      default:
        this.c = color(0);
        this.pezSprite = loadImage("Atun.png");
        break;
    
    }
  }
  
  @Override
  void update() {
    vel.add(acc);
    vel.limit(maxSpeed);
    pos.add(vel);
    acc.mult(0);
    borders();
  }
  
  void updatePescado() {
    vel.add(acc);
    vel.limit(maxSpeed);
    acc.mult(0);
    borders();
  }
  
  @Override  
  void display() {
    strokeWeight(1);
    stroke(255);
    fill(c);
    pushMatrix();
    translate(pos.x, pos.y);
    //point(0, 0);
    rotate(vel.heading());
    scale(1, -1);

    imageMode(CORNERS);
    image(pezSprite, 0, -r-2, r*10, r*10);
    popMatrix();
  }
  @Override
  void applyForce(PVector force) {
    PVector f = force.copy();
    f.div(mass);
    acc.add(f);
  }  
  
  void seek(PVector target) {
    PVector desired = PVector.sub(target, pos);
    PVector steering = PVector.sub(desired, vel);
    steering.limit(maxSteeringForce);
    applyForce(steering);
  }
  
  void arrive(PVector target) {
    seek(target);
    float d = pos.dist(target);
    float speed = map(d, 0, arrivalRadius, 0, maxSpeed);
    vel.limit(speed);
  }
  
  void wander() {
    PVector desired = vel.copy();
    desired.setMag(lookAhead);
    desired.add(pos);
    if (debug) {
      stroke(255);
      strokeWeight(1);
      line(pos.x, pos.y, desired.x, desired.y);
      noFill();
      ellipse(desired.x, desired.y,
        wanderRadius * 2, wanderRadius * 2);
    }
    PVector target = vel.copy();
    target.setMag(wanderRadius);
    target.rotate(map(noise(wanderNoise), 0, 1, -PI, PI));
    wanderNoise += wanderNoiseInc;
    desired.add(target);
    if (debug) {
      stroke(#FF0000);
      strokeWeight(5);
      point(desired.x, desired.y);
    }
    seek(desired);
  }
  void follow(PathSegment segment) {
    PVector desired = vel.copy();
    desired.setMag(lookAhead);
    desired.add(pos);
    PVector v = PVector.sub(desired, segment.start);
    PVector w = PVector.sub(segment.end, segment.start);
    w.normalize();
    w.setMag(v.dot(w));
    PVector normal = PVector.add(segment.start, w);
    w.setMag(w.mag() + pathAhead);
    PVector target = PVector.add(segment.start, w);
    if (desired.dist(normal) > segment.r) {
      seek(target);
    }
    if (debug) {
      stroke(255);
      strokeWeight(1);
      line(pos.x, pos.y, desired.x, desired.y);
      stroke(#FF0000);
      strokeWeight(5);
      point(desired.x, desired.y);
      stroke(#00FF00);
      point(normal.x, normal.y);
      stroke(#0000FF);
      point(target.x, target.y);
    }
  }
  void follow(Path path) {
    PVector predicted = getPredictedPos();
    try {
      ArrayList<PVector> points = getValidAheadPoint(predicted, path);
      PVector normal = points.get(0);
      PVector ahead = points.get(1);
      if (predicted.dist(normal) > r) {
        seek(ahead);
      } else {
        //va dentro del camino
      }
      if (debug) {
        stroke(255);
        strokeWeight(1);
        line(pos.x, pos.y, predicted.x, predicted.y);
        stroke(255, 0, 0);
        strokeWeight(5);
        point(predicted.x, predicted.y);
        stroke(0, 255, 0);
        point(normal.x, normal.y);
        stroke(0, 0, 255);
        point(ahead.x, ahead.y);
      }
    }
    catch (Exception e) {
      // esto sucedería cuando no hay un punto que seguir
      // qué hacer? deambular?
    }
  }
  PVector getPredictedPos() {
    PVector predicted = vel.copy();
    predicted.setMag(lookAhead);
    predicted.add(pos);
    return predicted;
  }
  
  ArrayList<PVector> getValidAheadPoint(PVector predicted, Path path) throws Exception {
    int closest = path.getClosestSegmentIndex(pos);
    for (int i = 0; i < path.segments.size(); i++) {
      PathSegment s = path.segments.get((closest + i) % path.segments.size());
      ArrayList<PVector> aheadPoints = s.getAheadPoints(predicted, pathAhead);
      PVector normal = aheadPoints.get(0);
      PVector ahead = aheadPoints.get(1);
      if (s.contains(ahead)) {
        return aheadPoints;
      }
      if (debug) {
        strokeWeight(5);
        stroke(0, 255, 0);
        point(normal.x, normal.y);
        stroke(0, 0, 255);
        point(ahead.x, ahead.y);
      }
    }
    throw new Exception("Couldn't find a valid ahead point to follow.");
  }
  
  void separateAlignCohere(ArrayList<Fish> agents){
    PVector alignment = new PVector(0, 0);
    PVector separation = new PVector(0, 0);
    PVector cohesion = new PVector(0, 0);
    int alignCount = 0;
    int separateCount = 0;
    int cohesionCount = 0;

    for (Fish a : agents) {
        if (a != this) {
            float distance = pos.dist(a.pos);

            if (distance < alignmentRadio) {
                alignment.add(a.vel);
                alignCount++;
            }

            if (distance < separationRadio) {
                PVector dif = PVector.sub(pos, a.pos);
                dif.normalize();
                dif.div(pos.dist(a.pos));
                separation.add(dif);
                separateCount++;
            }

            if (a.type == this.type && (distance < cohesionRadio)) {
                cohesion.add(a.pos);
                cohesionCount++;
            }
        }
    }

    if (alignCount > 0) {
        alignment.div(alignCount);
        alignment.setMag(alignmentRatio);
        alignment.limit(maxSteeringForce);
        applyForce(alignment);
    }

    if (separateCount > 0) {
        separation.div(separateCount);
        separation.setMag(separationRatio);
        separation.limit(maxSteeringForce);
        applyForce(separation);
    }

    if (cohesionCount > 0) {
        cohesion.div(cohesionCount);
        cohesion.sub(pos);
        cohesion.setMag(cohesionRatio);
        cohesion.limit(maxSteeringForce);
        applyForce(cohesion);
    }

    if (debug) {
        stroke(255, 128);
        strokeWeight(1);
        noFill();
        ellipse(pos.x, pos.y, Math.max(alignmentRadio, Math.max(separationRadio, cohesionRadio)) * 2, Math.max(alignmentRadio, Math.max(separationRadio, cohesionRadio)) * 2);
    }
  }
}
