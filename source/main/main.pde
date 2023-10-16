Rod rod;

float rows = 300;
float columns = 500;
float gridRes = 2;
float restLen = 2;
float mass = 0.5;
float friction = 0;
float k = 0.1;
ArrayList<Spring> springs;
ArrayList<Agent2D> agents;
float g = 0.1;
PVector gravity;

void setup(){
  size(1280,720);
  //fullScreen(P2D,1);
  agents = new ArrayList();
  springs = new ArrayList();
  gravity = new PVector(0, g, 0);
  rod = new Rod(40,0.5);
  Agent2D a1 = new Agent2D(width/2-300, height/2-300, 5);
  agents.add(a1);
  a1.fix();
  for (float x = 0; x < 100; x++) {
      Agent2D a = new Agent2D(width/2-300, height/2-300, 5);
      agents.add(a);
      a.fix();
  }
  Agent2D a2 = new Agent2D(width/2-300, height/2-300, 10);
  agents.add(a2);
  a2.fix();
  print(agents.size());
  for(int i = 0; i < agents.size()-1; i++){
      Agent2D a = agents.get(i);
      Agent2D b = agents.get(i+1);
      Spring s = new Spring(a, b, 0.1, 20);
      springs.add(s);
  }
}

void draw(){
  background(0);
  for (Agent2D a : agents) {
    a.applyGravity(gravity);
    a.applyDrag(0.005);
    if(a.pos.y > height/2){
       a.applyDrag(0.3);
    }
    a.update();
  }
  for (Spring s : springs) {
    s.update();
    s.display();
  }
  /*rod.display();
  rod.a2.applyGravity(new PVector(0,0.1));
  rod.a2.update();*/
  if (keyPressed && keyCode == RIGHT) {
      Agent2D a2 = agents.get(agents.size()-1);
      a2.unfix();
      a2.applyForce(new PVector(5,-10));
      for(int i = agents.size()-2; i > 0; i--){
        Agent2D a = agents.get(i);
        Agent2D b = agents.get(i+1);
        if(a.fixed && a.pos.dist(b.pos)>10){
          a.unfix();
          a.applyForce(new PVector(2,-15));
          a.update();
        }else if (!a.fixed){
          a.applyForce(new PVector(1,-7));
          a.update();
        }
      }
  }
  fill(0, 0, 220, 100);
  rectMode(CORNER);
  rect(0, height / 2, width, height);
}

void keyPressed (){
    if(key == 'a') {
      for(int i = 0; i < agents.size()-1; i++){
        Agent2D a = agents.get(i);
        Agent2D b = agents.get(i+1);
        if(!a.fixed){
          b.pos = a.pos;
          b.update();
          a.pos = new PVector(width/2-300, height/2-300);
          a.fix();
          a.update();
          break;
        }
      }
    }
  }
