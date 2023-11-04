class PathSegment {
  PVector start;
  PVector end;
  float r;
  color c;
  
  PathSegment(float x1, float y1, float x2, float y2, float r, color c) {
    start = new PVector(x1, y1);
    end = new PVector(x2, y2);
    this.r = r;
    this.c = c;
  }
  void display() {
    strokeWeight(r * 2);
    stroke(c);
    line(start.x, start.y, end.x, end.y);
    strokeWeight(1);
    stroke(255);
    line(start.x, start.y, end.x, end.y);
  }
  float distance(PVector pos) {
    PVector v = PVector.sub(pos, start);
    PVector w = PVector.sub(end, start);
    w.normalize();
    w.setMag(v.dot(w));
    w.add(start);
    float normalDist = pos.dist(w);
    float startDist = pos.dist(start);
    float endDist = pos.dist(end);
    if (contains(w)) {
      return normalDist;        
    } else {
      return min(startDist, endDist);
    }
  }
  boolean contains(PVector pos) {
    float A = pos.dist(start);
    float B = pos.dist(end);
    float C = start.dist(end);
    return A + B - C < 0.01;   
  }
  ArrayList<PVector> getAheadPoints(PVector predicted, float pathAhead) {
    ArrayList<PVector> result = new ArrayList();
    PVector v = PVector.sub(predicted, start);
    PVector w = PVector.sub(end, start);
    w.normalize();
    float projection = v.dot(w);
    w.setMag(projection);
    PVector normal = PVector.add(w, start);
    if (projection > 0) {
      w.setMag(w.mag() + pathAhead);
    } else {
      w.setMag(w.mag() - pathAhead);
    }
    PVector ahead = PVector.add(w, start);
    result.add(normal);
    result.add(ahead);
    return result;
  }
}
