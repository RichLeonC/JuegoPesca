class FlowField {
  PVector[][] grid;
  float size;
  int rows;
  int cols;
  float defaultMag;
  float noiseRes;
  float noiseT;
  float noiseInc;

  FlowField(int size) {
    defaultMag = 1;
    noiseRes = 0.1;
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
        float angle = map(noise(noiseX, noiseY, noiseT), 0, 1, 0, TWO_PI);
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
        float angle = map(noise(noiseX, noiseY, noiseT), 0, 1, 0, TWO_PI);
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
