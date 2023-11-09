class Rod extends Spring{
   int largoCuerda = 25;
   ArrayList<Agent2D> agentesCuerda;
   ArrayList<RodThread> springsCuerda;
   PVector posBase;
   Bait carnada;
   boolean lanzada = false;
   boolean pescado = false;
   int pesoExtra = 0;

  Rod(float restLen, float k, float x, float y){
    super(restLen, k);
    agentesCuerda = new ArrayList();
    springsCuerda = new ArrayList();
    posBase = new PVector(x+100, y-200);
    this.carnada = new Bait(posBase.x, posBase.y, 10, BaitType.NONE);
    crearCuerda(carnada);
  }
  
  void setBait(int index){
    Bait carnada;
    int pesoCarnada;
    switch(index){
      case 0:
        pesoCarnada = peso4;
        carnada = new Bait(posBase.x, posBase.y, pesoCarnada, BaitType.SARDINA);
        break;
      case 1:
        pesoCarnada = peso3;
        carnada = new Bait(posBase.x, posBase.y, pesoCarnada, BaitType.CAMARON);
        break;
      case 2:
        pesoCarnada = peso2;
        carnada = new Bait(posBase.x, posBase.y, pesoCarnada, BaitType.LOMBRIZ);
        break;
      default:
        pesoCarnada = peso1;
        carnada = new Bait(posBase.x, posBase.y, pesoCarnada, BaitType.NONE);
        break;
    }
    crearCuerda(carnada);
  }
  
  void addPeso(){
    pesoExtra++;
    pesoExtra = constrain(pesoExtra,0,5);
  }
  
  void substractPeso(){
    pesoExtra--;
    pesoExtra = constrain(pesoExtra,0,5);
  }
  
  void crearCuerda(Bait bait){
    agentesCuerda = new ArrayList();
    springsCuerda = new ArrayList();
    Agent2D a1 = new Agent2D(posBase.x-restLen/2, posBase.y, 1);
    float masaCuerda = 0.1;
    switch((int)carnada.mass){
        case peso1:
          masaCuerda = peso1*0.6/peso2;
          break;
        case peso2:
          masaCuerda = peso2*0.6/peso2;
          break;
        case peso3:
          masaCuerda = peso3*0.6/peso2;
          break;
        case peso4:
          masaCuerda = peso3*0.6/peso2;
          break;
      }
    agentesCuerda.add(a1);
    a1.fix();
    for (float i = 0; i < largoCuerda; i++) {
        Agent2D a = new Agent2D(posBase.x + restLen*((posBase.x-100)%2), posBase.y, masaCuerda);
        /*float c = i%2 != 0? 1: -1;
        Agent2D a = new Agent2D(posBase.x + restLen/2*c, posBase.y, masaCuerda);
        //println(a.pos.x);*/
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
    int largoMar = 7;
    float fuerzaCuerda = 0;
    float fuerzaCarnada = 0;
    switch((int)carnada.mass){
      case peso1:
        fuerzaCuerda = peso1*-0.4/peso2;
        fuerzaCarnada = peso1*-0.7/peso2;
        largoMar = 1;
        break;
      case peso2:
        fuerzaCuerda = -0.4;
        fuerzaCarnada = -0.7;
        largoMar = 2;
        break;
      case peso3:
        fuerzaCuerda = peso3*-0.4/peso2;
        fuerzaCarnada = -0.99;
        largoMar = 3;
        break;
      case peso4:
        fuerzaCuerda = peso3*-0.4/peso2; 
        fuerzaCarnada = -1.5;
        largoMar = 4;
        break;
    }
    for (Agent2D a : agentesCuerda) {
      a.applyGravity(gravity);
      a.applyDrag(0.005);
      if(a.pos.y > height*0.3){
        if(a.mass > 1){
          a.applyDrag(0.3);
          a.applyForce(new PVector(0,fuerzaCarnada));
        }
        else if( i < largoCuerda - largoMar - pesoExtra){
          //a.fix();
          a.applyForce(new PVector(0,fuerzaCuerda));
          a.applyDrag(0.1);
        }
      }
      i++;
      a.update();
      //a.display();
      
    }
    for (RodThread s : springsCuerda) {
      s.update();
      s.display();
    }
    carnada.display();
  }
  
  /*void setPosiciones(float x, float y){
    posBase = new PVector(x,y);
    for (float i = 0; i < agentesCuerda.size(); i++) {
        Agent2D a = agentesCuerda.get((int)i);
        if(a.fixed){
          float c = i%2 != 0? 1: -1;
          a.pos.x = (posBase.x + restLen/2*c);
        }
    }
  }*/
  
  void moverBase(float x, float y){
    //setPosiciones(x,y);
    //carnada.pos.x = x + restLen/2;
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
  
  
  
  void lanzar(float fuerzaP){
    //println(fuerzaP);
    int n = fuerzaP < 1? -1: 1;
    float fuerza = 0;
    switch((int)carnada.mass){
        case peso1:
          fuerza = peso1*(fuerzaP*2.5)/peso2;
          break;
        case peso2:
          fuerza = peso2*(fuerzaP*2.5)/peso2;
          break;
        case peso3:
          fuerza = peso3*(fuerzaP*2.5)/peso2;
          break;
        case peso4:
          fuerza = peso3*(fuerzaP*2.5)/peso2;
          break;
      }
    if(!lanzada){
      lanzada = true;
      Agent2D a2 = agentesCuerda.get(agentesCuerda.size()-1);
      a2.unfix();
      a2.applyForce(new PVector(fuerza,-fuerza*1.5*n));
      a2.update();
      for(int i = agentesCuerda.size()-2; i > 0; i--){
        Agent2D a = agentesCuerda.get(i);
        a.unfix();
        a.applyForce(new PVector(fuerza*0.01,-fuerza*0.04*n));
        a.update();
      }
    }
  }
}
