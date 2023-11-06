class Sail {
  ArrayList<Agent2D> agents = new ArrayList<Agent2D>();
  ArrayList<Spring> springs = new ArrayList<Spring>();
  int rows;
  int cols;
  float cellWidth; //Width de las celdas
  float cellHeight; //Height de las celdas
  PVector gravity;
  PVector wind;
  float k;
  float x, y;

  Sail(int rows, int cols) {
    this.rows = rows;
    this.cols = cols;
    this.cellWidth = width/cols/8;
    this.cellHeight = height/rows/7;
    this.gravity = new PVector(0, 0.15);
    this.wind = new PVector(0, 0);
    this.k = 4;
    createSailGrid();
  }

  void setPosition(float x, float y) {
    this.x = x;
    this.y = y;
  }

  public void addParticles() {
    for (int i = 0; i<rows; i++) {
      for (int j = 0; j < cols; j++) {
        Agent2D a = new Agent2D(j*cellWidth, i*cellHeight, 0.7);
        if (j==0) a.fix();
        agents.add(a);
      }
    }
  }

  public void createSailGrid() {
    addParticles();
    for (int i = 0; i<rows; i++) {
      for (int j = 0; j<cols; j++) {
        Agent2D p = agents.get(i*cols+j);

        //Conectamos la particula horizontalmente con su vecino derecho
        if (j<cols-1) {
          Agent2D rightNeighbor = agents.get(i*cols+(j+1));
          Spring s = new Spring(p, rightNeighbor, cellWidth, k);
          springs.add(s);
        }

        //Conectamos la particula verticalmente con su vecino de abajo
        if (i<rows-1) {
          Agent2D downNeighbor = agents.get((i+1)*cols+j);
          Spring s = new Spring(p, downNeighbor, cellHeight, k);
          springs.add(s);
        }

        //Conectamos la particula diagonalmente con su vecino diagonal de abajo y a la derecha
        if (i<rows-1 && j<cols-1) {
          Agent2D diagonalNeighbor = agents.get((i+1)*cols+(j+1));
          float diagonalLen = dist(j*cellWidth, i*cellHeight, (j+1)*cellWidth, (i+1)*cellHeight);
          Spring s = new Spring(p, diagonalNeighbor, diagonalLen, k);
          springs.add(s);
        }

        //Conectamos la particula diagonalmente con su vecino diagonal de abajo y a la izquierda
        if (i<rows-1 && j>0) {
          Agent2D diagonalNeighbor = agents.get((i+1)*cols+(j-1));
          float diagonalLen = dist(j*cellWidth, i*cellHeight, (j-1)*cellWidth, (i+1)*cellHeight);
          Spring s = new Spring(p, diagonalNeighbor, diagonalLen, k);
          springs.add(s);
        }
      }
    }
  
}

public void update() {
  for (Agent2D a : agents) {
    //a.applyGravity(new PVector(0, 0.1));
    a.applyDrag(0.01);
    a.applyForce(wind);
    if (!userWindApplied) applyWind(random(-0.1, 0.15));

    a.update();
    //a.display();
  }

  for (Spring s : springs) {
    s.update();
    //s.display();
  }
}

public void applyWind(float wind) {
  this.wind.x = wind;
}

public void display() {
  color blue = color(#001489);
  color white = color(255);
  color red = color(#DA291C);
  noStroke();
  pushMatrix();
  translate(x, y);
  for (int i = 0; i<rows-1; i++) {
    beginShape(TRIANGLE_STRIP);
    for (int j = 0; j<cols; j++) {
      Agent2D a1 = agents.get(i*cols+j);
      Agent2D a2 = agents.get((i+1)*cols+j);

      //Si estamos en la primera franja
      if (i<rows/9) {
        fill(blue);
      } else if (i<3*rows/9) {//Si estamos en la segunda franja
        fill(white);
      } else if (i<6*rows/9) { //Si estamos en la franja del medio
        fill(red);
      } else if (i<8*rows/9) { //Si estamos en la cuarta franja
        fill(white);
      } else { //Ultima franka
        fill(blue);
      }
      vertex(a1.pos.x, a1.pos.y);
      vertex(a2.pos.x, a2.pos.y);
    }
    endShape();
  }
  popMatrix();
}
}
