 enum BaitType {
   SARDINA, CAMARON, LOMBRIZ, NONE
 }

class Bait extends Agent2D {
  BaitType type;
  PImage carnadaSprite;
  float assetW;
  float assetH;

  public Bait(float x, float y, float mass, BaitType type){
      super(x,y,mass);
      this.type = type;
      switch(type){
        case SARDINA:
          this.carnadaSprite = loadImage("Sardina.png");
          this.assetW = r * 10;
          this.assetH = r * 10;
          this.c = color(128,128,128);
          break;
        case CAMARON:
          this.carnadaSprite = loadImage("Camaron.png");
          this.c = color(255,165,0);
          this.assetW = r * 10;
          this.assetH = r * 10;
          break;
        case LOMBRIZ:
          this.c = color(255,192,203);
          this.carnadaSprite = loadImage("Lombriz.png");
          this.assetW = r * 10;
          this.assetH = r * 14;
          break;
        default:
          this.c = color(0);
          this.assetW = r * 10;
          this.assetH = r * 14;
          this.carnadaSprite = loadImage("anzuelo.png");
          break;
      }
  }
  @Override  
  void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    noStroke();
    fill(c);
    imageMode(CENTER);
    image(carnadaSprite, -5, 0, assetW, assetH);
    popMatrix();
  }
  
  
}
