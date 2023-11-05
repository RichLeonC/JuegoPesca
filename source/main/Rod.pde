class Rod extends Spring{
   int largoCuerda = 30;
   ArrayList<Agent2D> agentesCuerda;
   ArrayList<RodThread> springsCuerda;
   PVector posBase;
   Bait carnada;
   boolean lanzada = false;
   boolean pescado = false;

  Rod(float restLen, float k, float x, float y){
    super(restLen, k);
    agentesCuerda = new ArrayList();
    springsCuerda = new ArrayList();
    posBase = new PVector(x+100, y-200);
    this.carnada = new Bait(posBase.x, posBase.y, 5, BaitType.NONE);
    crearCuerda(carnada);
  }
  
  void setBait(int index){
    Bait carnada;
    int pesoCarnada;
    switch(index){
      case 0:
        pesoCarnada = 20; 
        carnada = new Bait(posBase.x, posBase.y, pesoCarnada, BaitType.SARDINA);
        break;
      case 1:
        pesoCarnada = 15;
        carnada = new Bait(posBase.x, posBase.y, pesoCarnada, BaitType.CAMARON);
        break;
      case 2:
        pesoCarnada = 10;
        carnada = new Bait(posBase.x, posBase.y, pesoCarnada, BaitType.LOMBRIZ);
        break;
      default:
        pesoCarnada = 5;
        carnada = new Bait(posBase.x, posBase.y, pesoCarnada, BaitType.NONE);
        break;
    }
    crearCuerda(carnada);
}
  
  void crearCuerda(Bait bait){
    agentesCuerda = new ArrayList();
    springsCuerda = new ArrayList();
    Agent2D a1 = new Agent2D(posBase.x, posBase.y, carnada.mass/10);
    agentesCuerda.add(a1);
    a1.fix();
    for (float i = 0; i < largoCuerda; i++) {
        Agent2D a = new Agent2D(posBase.x + restLen*((posBase.x-100)%2), posBase.y, 0.5);
        agentesCuerda.add(a);
        a.fix();
    }
    Bait a2 = bait;
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
          RodThread s = new RodThread(a, b, restLen, k);
          springsCuerda.add(s);
        }
    }
  }
  
  void update(){
    int i = 0;
    for (Agent2D a : agentesCuerda) {
      a.applyGravity(gravity);
      a.applyDrag(0.005);
      if(a.pos.y > height*0.3){
        if(a.mass > 1){
          a.applyDrag(0.3);
          a.applyForce(new PVector(0,-0.5*carnada.mass/100));
        }
        else if( i < largoCuerda - 5){
          //a.fix();
          a.applyForce(new PVector(0,-0.2));
          a.applyDrag(0.03);
        }
      }
      i++;
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
     crearCuerda(carnada);
     lanzada = false;
   }
  }
  
  void lanzar(float fuerza){
    if(!lanzada){
      lanzada = true;
      println("entra");
      Agent2D a2 = agentesCuerda.get(agentesCuerda.size()-1);
      a2.unfix();
      a2.applyForce(new PVector(fuerza*a2.mass,-fuerza*a2.mass));
      a2.update();
      for(int i = agentesCuerda.size()-2; i > 0; i--){
        Agent2D a = agentesCuerda.get(i);
        a.unfix();
        a.applyForce(new PVector(10,-10));
        a.update();
      }
    }
  }
}
