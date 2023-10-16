class Rod extends Spring{
   ArrayList<Agent2D> cuerda;


  Rod(float restLen, float k){
    super(restLen, k);
    Agent2D a1 = new Agent2D(width/2,height/2,5);
    Agent2D a2 = new Agent2D(width/2,height/2,5);
    this.a1 = a1;
    this.a2 = a2;
    a1.fix();
    a2.unfix();
  }

}
