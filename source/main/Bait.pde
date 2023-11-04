 enum BaitType {
   SARDINA, CAMARON, LOMBRIZ, NONE
 }

class Bait extends Agent2D {
  BaitType type;

  public Bait(float x, float y, float mass, BaitType type){
      super(x,y,mass);
      this.type = type;
      this.c = color(255);
  }
  
  
}
