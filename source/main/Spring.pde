class Spring {
  Agent2D a1;
  Agent2D a2;
  float restLen;
  float k;
  color c;
  
  Spring(Agent2D a1, Agent2D a2, float restLen, float k) {
    this.a1 = a1;
    this.a2 = a2;
    this.restLen = restLen;
    this.k = k;
    c = color(#C34DFF, 128);
  }
  
  Spring(float restLen, float k) {
    this.restLen = restLen;
    this.k = k;
    c = color(#C34DFF, 128);
  }
  
  void update() {
    PVector springForce = PVector.sub(a2.pos, a1.pos);
    float len = springForce.mag();
    float displacement = len - restLen;
    springForce.setMag(-k * displacement);
    springForce.div(100);
    a2.applyForce(springForce);
    springForce.mult(-1);
    a1.applyForce(springForce);
  }
  void display() {
    strokeWeight(2);
    float dif = abs(restLen - a1.pos.dist(a2.pos));
    colorMode(HSB);
    float h = hue(c);
    h = h - map(dif, 0, 100, 0, 255);
    color c2 = color(h, saturation(c), brightness(c), alpha(c));
    colorMode(RGB);
    stroke(c2);
    line(a1.pos.x, a1.pos.y, a2.pos.x, a2.pos.y);
  }
}
