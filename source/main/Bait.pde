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
      carnadaSprite = new PImage(); 
      selectSprite();
  }
  
  void selectSprite(){
    switch(type){
        case SARDINA:
          this.carnadaSprite = sardinaSprite;
          this.assetW = r * 10;
          this.assetH = r * 10;
          this.c = color(128,128,128);
          break;
        case CAMARON:
          this.carnadaSprite = camaronSprite;
          this.c = color(255,165,0);
          this.assetW = r * 10;
          this.assetH = r * 10;
          break;
        case LOMBRIZ:
          this.c = color(255,192,203);
          this.carnadaSprite = lombrizSprite;
          this.assetW = r * 10;
          this.assetH = r * 14;
          break;
        case NONE:
          this.c = color(0);
          this.assetW = r * 10;
          this.assetH = r * 14;
          this.carnadaSprite = anzueloSpriteImg;
          break;
      }
  }
  
  @Override  
  void update() {
    if (!fixed) {
      vel.add(acc);
      pos.add(vel);
      acc.mult(0);
      borders();
    }
  }
  
  @Override
  void borders() {
    if (pos.y >= height - r) {
      vel.y *= -damp;
      pos.y = constrain(pos.y, r, height - r);
    }
    if (pos.y < height*0.31) {
        barco.rod.pescado = false;
        for(Fish f : system.fish){
          f.pescado = false;
          f.huyendo = false;
          f.picado = false;
          f.isChasing = false;
        }
        system.pescando = false;
    }
  }
  
  
  @Override  
  void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    noStroke();
    fill(c);
    imageMode(CENTER);
    if(system.pescando){
      image(anzueloSpriteImg, -5, 0, assetW, assetH);
    }else{
      image(carnadaSprite, -5, 0, assetW, assetH);
    }
    
    popMatrix();
  }
  
  
}
