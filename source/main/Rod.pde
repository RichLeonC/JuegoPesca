class Rod extends Spring{
   int largoCuerda = 100;
   ArrayList<Agent2D> agentesCuerda;
   ArrayList<Spring> springsCuerda;
   PVector posBase;
   


  Rod(float restLen, float k){
    super(restLen, k);
    agentesCuerda = new ArrayList();
    springsCuerda = new ArrayList();
    posBase = new PVector(width/2-300, height/2 -200);
    int masaAgentes = 2;
    Agent2D a1 = new Agent2D(posBase.x, posBase.y, masaAgentes);
    agentesCuerda.add(a1);
    a1.fix();
    for (float x = 0; x < largoCuerda; x++) {
        Agent2D a = new Agent2D(posBase.x, posBase.y, masaAgentes);
        agentesCuerda.add(a);
        a.fix();
    }
    Agent2D a2 = new Agent2D(posBase.x, posBase.y, masaAgentes*3);
    agentesCuerda.add(a2);
    a2.fix();
    for(int i = 0; i < agentesCuerda.size()-1; i++){
        Agent2D a = agentesCuerda.get(i);
        Agent2D b = agentesCuerda.get(i+1);
        Spring s = new Spring(a, b, restLen, k);
        springsCuerda.add(s);
    }
  }
  
  void update(){
    for (Agent2D a : agentesCuerda) {
      a.applyGravity(gravity);
      a.applyDrag(0.005);
      if(a.pos.y > height/2){
         a.applyDrag(0.3);
      }
      a.update();
    }
    for (Spring s : springsCuerda) {
      s.update();
      s.display();
    }
  }
  
  void recoger(){
    for(int i = 0; i < agentesCuerda.size()-1; i++){
        Agent2D a = agentesCuerda.get(i);
        Agent2D b = agentesCuerda.get(i+1);
        if(!a.fixed){
          b.pos = a.pos;
          b.update();
          a.pos = new PVector(posBase.x, posBase.y);
          a.fix();
          a.update();
          break;
        }
      }
  }
  
  void lanzar(){
    Agent2D a2 = agentesCuerda.get(agentesCuerda.size()-1);
      a2.unfix();
      a2.applyForce(new PVector(5,-10));
      for(int i = agentesCuerda.size()-2; i > 0; i--){
        Agent2D a = agentesCuerda.get(i);
        Agent2D b = agentesCuerda.get(i+1);
        if(a.fixed && a.pos.dist(b.pos)>10){
          a.unfix();
          a.applyForce(new PVector(10,-15));
          a.update();
        }else if (!a.fixed){
          a.applyForce(new PVector(5,-7));
          a.update();
        }
      }
  }

}
