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
        float angle = map(noise(noiseX, noiseY, noiseT), 0.1, 1, -PI/2, PI/2);
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
        float angle;
        // Desactivar el flowfield en las primeras filas
        if (r < 9) {
            angle = 0; // Ángulo que no tiene influencia
        } else if (r == 9 || r == 10 || r == 11 ) {
                  angle = PI / 2;
        } else if (r >= rows - 1) {
            angle = PI * 1.5; // Ángulo de 90 grados para las dos últimas filas
        } else {
              angle = map(noise(noiseX, noiseY, noiseT), 0, 1, -PI/2, PI/2);
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
