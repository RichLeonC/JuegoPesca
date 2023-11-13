class RodThread extends Spring {
  
  public RodThread(Agent2D a1, Agent2D a2, float restLen, float k) {
    super(a1,a2,restLen,k);
  }
  
  @Override
  void update() {
    if(!a2.fixed){
      //print(a2.pos);
      //print(a1.pos);
      if(Double.isNaN(a2.pos.x) || Double.isNaN(a2.pos.y)){
          a2.pos.x = barco.pos.x;
          a2.pos.y = barco.pos.y;
      }
      PVector springForce = PVector.sub(a2.pos, a1.pos);
      float len = springForce.mag();
      float displacement = len - restLen;
      springForce.setMag(-k * displacement);
      springForce.div(2);
      if(Double.isNaN(springForce.x) || Double.isNaN(springForce.y)){
          springForce.x = 2;
          springForce.y = 2;
      }
      //springForce.x = constrain(springForce.x, -0.5, 0.5);
      //springForce.y = constrain(springForce.y, -0.5, 0.5);
      // Aplicar un límite a la magnitud total de la fuerza
      float maxForceMagnitude = 1; // Ajusta este valor según tus necesidades
      
      springForce = springForce.limit(maxForceMagnitude);
      //println(springForce.mag());
      a2.applyForce(springForce);
      springForce.mult(-1);
      a1.applyForce(springForce);
    }
  }
  
  
}
