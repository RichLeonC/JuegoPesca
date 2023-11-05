class RodThread extends Spring {
  
  public RodThread(Agent2D a1, Agent2D a2, float restLen, float k) {
    super(a1,a2,restLen,k);
  }
  
  @Override
  void update() {
    PVector springForce = PVector.sub(a2.pos, a1.pos);
    float len = springForce.mag();
    float displacement = len - restLen;
    springForce.setMag(-k * displacement);
    springForce.div(2);
    if(Double.isNaN(springForce.x) || Double.isNaN(springForce.y)){
        springForce.x = 0;
        springForce.y = 0;
        springForce.z = 0;
    }
    //springForce.x = constrain(springForce.x,0.01,0.5);
    //springForce.y = constrain(springForce.y,-0.5,-0.1);
    a2.applyForce(springForce);
    springForce.mult(-1);
    a1.applyForce(springForce);
  }
  
  
}
