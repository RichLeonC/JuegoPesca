 enum BaitType {
   SARDINA, CAMARON, LOMBRIZ, NONE
 }

class Bait extends Agent2D {
  BaitType type;

  public Bait(float x, float y, float mass, BaitType type){
      super(x,y,mass);
      this.type = type;
      switch(type){
        case SARDINA:
          this.c = color(128,128,128);
          break;
        case CAMARON:
          this.c = color(255,165,0);
          break;
        case LOMBRIZ:
          this.c = color(255,192,203);
          break;
        default:
          this.c = color(0);
          break;
      }
  }
  
  
}
