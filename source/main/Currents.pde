class Currents {
  PVector[][] grid;
  float size;
  int rows;
  int cols;
  float defaultMag;
  float noiseRes;
  float noiseT;
  float noiseInc;

  Currents(int size) {
    defaultMag = 1;
    noiseRes = 0.2;
    noiseT = random(100);
    noiseInc = 0.01;
    this.size = size;
    rows = (int)height / size + 1;
    cols = (int)width / size + 1;
    grid = new PVector[rows][];
    for (int r = 0; r < rows; r++) {
      grid[r] = new PVector[cols];
      for (int c = 0; c < cols; c++) {
        float noiseX = c * noiseRes;
        float noiseY = r * noiseRes;
        float angle = map(noise(noiseX, noiseY, noiseT), 0.1, 1, TWO_PI, 0);
        if(r == rows-2 || r == rows-1){ // Los de abajo apuntan arriba
          angle = -1.6;
        }
        else if(r == rows-4){ // Los de abajo apuntan arriba
          angle = map(noise(noiseX, noiseY, noiseT), 0.1, 1, -4.71,-4.71);
        }
        else if(c == cols - 2 || c == cols - 1 || c == 0 || c == 1  ){ //los de los extremos apuntan a la izquierda
          angle = 3.14;
        }
        else if(r < 8){
          angle = map(noise(noiseX, noiseY, noiseT), 0.1, 1, -4.71,-4.71);
        }
        grid[r][c] = PVector.fromAngle(angle);
        grid[r][c].setMag(defaultMag);
      }
    }
  }
  void update() {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        float noiseX = c * noiseRes;
        float noiseY = r * noiseRes;
        float angle = map(noise(noiseX, noiseY, noiseT), 0.1, 1, 1, 5);

        if(r == rows-2 || r == rows-1){ // Los de abajo apuntan arriba
          angle = -1.6;
        }
        else if(r == rows-3){ 
          angle = map(noise(noiseX, noiseY, noiseT), 0.1, 1, 3*PI/4, 5*PI/4);
        }
        else if(c == cols - 2 || c == cols - 1 || c == 0 || c == 1  ){ //los de los extremos apuntan a la izquierda
          angle = 3.14;
        }
        else if(r < 7){
          angle = map(noise(noiseX, noiseY, noiseT), 0.1, 1, -PI, -3*PI/2);
        }
        else if(r < 8){
          angle = map(noise(noiseX, noiseY, noiseT), 0.1, 1, -PI, -3*PI/2);
        }
        grid[r][c] = PVector.fromAngle(angle);
        grid[r][c].setMag(defaultMag);
      }
    }
    noiseT += noiseInc;
  }
  void display() {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        displayVector(grid[r][c], c * size, r * size);
      }
    }
  }
  void displayVector(PVector v, float x, float y) {
    noFill();
    stroke(128);
    strokeWeight(1);
    rect(x, y, size, size);
    PVector v2 = v.copy();
    v2.setMag(size / 2 - 5);
    PVector center = new PVector(x + size/2, y + size/2);
    PVector end = PVector.add(center, v2);
    line(center.x, center.y, end.x, end.y);
  }
  PVector getVector(float x, float y) {
    if (x >= 0 && x <= width) {
      if (y >= 0 && y <= height) {
        int r = (int)(y / size);
        int c = (int)(x / size);
        return grid[r][c];
      }
    }
    return new PVector(0, 0);
  }
}
