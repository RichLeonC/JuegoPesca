class Fish extends Agent2D {
  float maxSpeed;
  float maxSteeringForce;
  float arrivalRadius;
  
  Fish(float x, float y, float mass) {
    super(x, y, mass);
    r = sqrt(mass);
    c = color(random(128, 255), 0, random(128, 255), 255);
    damp = 0.6;
    borderBehaviour = BorderBehaviour.NONE;
    maxSpeed = 0.00003;
    maxSteeringForce = 1;
    arrivalRadius = 300;
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
    beginShape();
    vertex(r, 0);
    vertex(-2.0/3.0 * r, -2.0/3.0 * r);
    vertex(-r/3.0, 0);
    vertex(-2.0/3.0 * r, 2.0/3.0 * r);
    endShape(CLOSE);
    popMatrix();
  }
  @Override
  void applyForce(PVector force) {
    PVector f = force.copy();
    f.div(mass);
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
}
