class Path {
  ArrayList<PathSegment> segments;
  ArrayList<PVector> points;
  float r;
  color c;
  
  Path() {
    segments = new ArrayList();
    points = new ArrayList();
    r = 15;
    c = color(random(64, 192), random(64, 192), random(64, 192));
  }
  void addPoint(float x, float y) {
    PVector point = new PVector(x, y);
    points.add(point);
    if (points.size() > 1) {
      PVector start = points.get(points.size() - 2);
      PVector end = points.get(points.size() - 1);
      PathSegment s = new PathSegment(start.x, start.y, end.x, end.y, r, c);
      segments.add(s);
    }
  }
  void display() {
    for (PathSegment s : segments) {
      s.display();
    }
  }
  void clear() {
    points.clear();
    segments.clear();
  }
  int getClosestSegmentIndex(PVector pos) {
    int closest = 0;
    for (int i = 1; i < segments.size(); i++) {
      PathSegment s1 = segments.get(i);
      PathSegment s2 = segments.get(closest);
      if (s1.distance(pos) < s2.distance(pos)) {
        closest = i;
      }
    }
    return closest;
  }
}
