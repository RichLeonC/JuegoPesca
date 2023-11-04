class Rod extends Spring{
   int largoCuerda = 20;
   ArrayList<Agent2D> agentesCuerda;
   ArrayList<RodThread> springsCuerda;
   PVector posBase;
   Bait carnada;
   boolean lanzada = false;

  Rod(float restLen, float k, float x, float y){
    super(restLen, k);
    agentesCuerda = new ArrayList();
    springsCuerda = new ArrayList();
    posBase = new PVector(x+100, y-200);
    crearCuerda();
  }
  
  void crearCuerda(){
    float masaAgentes = 1;
    agentesCuerda = new ArrayList();
    springsCuerda = new ArrayList();
    Agent2D a1 = new Agent2D(posBase.x, posBase.y, masaAgentes);
    agentesCuerda.add(a1);
    a1.fix();
    for (float i = 0; i < largoCuerda; i++) {
        Agent2D a = new Agent2D(posBase.x + restLen*((posBase.x-100)%2), posBase.y, masaAgentes);
        agentesCuerda.add(a);
        a.fix();
    }
    Bait a2 = new Bait(posBase.x, posBase.y, masaAgentes*20, BaitType.NONE);
    agentesCuerda.add(a2);
    carnada = a2;
    a2.fix();
    for(int i = 0; i < agentesCuerda.size()-1; i++){
        Agent2D a = agentesCuerda.get(i);
        Agent2D b = agentesCuerda.get(i+1);
        if(i == agentesCuerda.size()-1){
          RodThread s = new RodThread(a, b, restLen, k);
          springsCuerda.add(s);
        }else{
          RodThread s = new RodThread(a, b, restLen, k/5);
          springsCuerda.add(s);
        }
    }
  }
  
  void update(){
    for (Agent2D a : agentesCuerda) {
      a.applyGravity(gravity);
      a.applyDrag(0.005);
      if(a.pos.y > height*0.3){
        if(a.mass > 1){
          a.applyDrag(0.3);
          a.applyForce(new PVector(0,-0.5));
        }
        else{
          //a.fix();
          a.applyForce(new PVector(0,-0.2));
          a.applyDrag(0.03);
        }
      }
      //a.display();
      a.update();
    }
    for (RodThread s : springsCuerda) {
      s.update();
      s.display();
    }
    carnada.display();
  }
  
  void moverBase(float x, float y){
    posBase = new PVector(x,y);
    for(Agent2D a : agentesCuerda){
      if(a.fixed){
        a.pos = new PVector(x,y);
      }
    }
  }
  
  void recoger(){
    int fixed = 0;
    for(int i = 1; i < agentesCuerda.size(); i++){
        Agent2D a = agentesCuerda.get(i-1);
        Agent2D b = agentesCuerda.get(i);
        if(!a.fixed){
          b.pos = a.pos;
          b.update();
          a.pos = new PVector(posBase.x, posBase.y);
          a.fix();
          a.update();
          break;
        }
        else{
          fixed++;
        }
   }
   if(fixed == largoCuerda - 1){
     crearCuerda();
     lanzada = false;
   }
  }
  
  void lanzar(float fuerza){
    if(!lanzada){
      lanzada = true;
      println("entra");
      Agent2D a2 = agentesCuerda.get(agentesCuerda.size()-1);
      a2.unfix();
      a2.applyForce(new PVector(fuerza,-fuerza));
      a2.update();
      for(int i = agentesCuerda.size()-2; i > 0; i--){
        Agent2D a = agentesCuerda.get(i);
        a.unfix();
        a2.applyForce(new PVector(fuerza/10,-fuerza/10));
        a.update();
      }
    }
  }
}
