 enum BorderBehaviour {
  NONE, BORDERS, WRAP
}

class Agent2D {
  PVector pos;
  PVector vel;
  PVector acc;
  float r;
  color c;
  float mass;
  float damp;
  boolean fixed;
  BorderBehaviour borderBehaviour;

  Agent2D(float x, float y, float mass) {
    pos = new PVector(x, y);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    r = sqrt(mass / PI) * 2;
    c = color(0);
    this.mass = mass;
    damp = 0.9;
    fixed = false;
    borderBehaviour = BorderBehaviour.BORDERS;
  }
  void update() {
    if (!fixed) {
      vel.add(acc);
      pos.add(vel);
      acc.mult(0);
      borders();
    }
  }
  void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    noStroke();
    fill(c);
    ellipse(0, 0, r * 2, r * 2);
    popMatrix();
  }
  void randomVel(float mag) {
    vel = PVector.random2D();
    vel.setMag(mag);
  }
  void applyForce(PVector force) {
    PVector f = force.copy();
    f.div(mass);
    acc.add(f);
  }
  void applyGravity(PVector force) {
    acc.add(force);
  }
  void applyFriction(float c) {
    PVector fric = vel.copy();
    fric.normalize();
    fric.mult(-c);
    applyForce(fric);
  }
  void applyDrag(float c) {
    PVector drag = vel.copy();
    drag.normalize();
    drag.mult(vel.magSq());
    drag.mult(-c);
    applyForce(drag);
  }
  void fix() {
    fixed = true;
  }
  void unfix() {
    fixed = false;
  }
  void borders() {
    if (borderBehaviour == BorderBehaviour.BORDERS) {
      if (pos.x <= r || pos.x >= width - r) {
        vel.x *= -damp;
        pos.x = constrain(pos.x, r, width - r);
      }
      if (pos.y >= height - r) {
        vel.y *= -damp;
        pos.y = constrain(pos.y, r, height - r);
      }
    } else if (borderBehaviour == BorderBehaviour.WRAP) {
      if (pos.x > width + r) pos.x = -r;
      if (pos.x < -r) pos.x = width + r;
      if (pos.y > height + r) pos.y = -r;
      if (pos.y < -r) pos.y = height + r;
    } else if (borderBehaviour == BorderBehaviour.NONE) {
    }
  }
}
