
class Branch {
  
  int maxSteps;
  float stepLength;
  float thickness;
  float growSpeed;
  float angle, angleSpeed;
  boolean neverEnding = false;
  float branchingProbability;
  int depth;
  
  float m = 0;
  boolean growing = true;
  ArrayList<Branch> branches;
  ArrayList<PVector> points;
  float nextAngleSpeed;
  
  ArrayList<Leaf> leaves;
  int lastBranching, lastLeaf;
  
  Branch(PVector pos, float _angle, int _depth) {
    stepLength = 0.2f;
    growSpeed = 0.02;
    branches = new ArrayList();
    leaves = new ArrayList();
    lastBranching = lastLeaf = millis();
    depth = _depth;
    
    points = new ArrayList();
    points.add( new PVector(pos.x, pos.y) );
    points.add( new PVector(pos.x, pos.y) );
    
    branchingProbability = 0.03;
    
    if(depth == 0) {
      thickness = 0.07;
      neverEnding = true;
      maxSteps = 80;
      branchingProbability = 0.04;
    }
    else if(depth == 1) {
      thickness = 0.05;
      maxSteps = int(random(5,15));
    }
    else if(depth >= 2) {
      thickness = 0.03f;
      maxSteps = int(random(2,6));
    }
    
    angle = _angle;
    if( round(random(0,1)) == 1 )
      angleSpeed = random(0.05, 0.2);
    else
      angleSpeed = random(-0.2, -0.05);
    nextAngleSpeed = angleSpeed;
    
  }

  void update() {
    if(!growing)
      return;
    int l = points.size() - 1;
    PVector prev = points.get(l - 1);
    float n = min(m + growSpeed, stepLength);
    points.get(l).set( prev.x + cos(angle) * n, prev.y + sin(angle) * n );
    
    if(n == stepLength) {
      if(l == maxSteps) {
        if(neverEnding) {
          for(int i = 0; i < branches.size(); i++) {
            if(points.get(0).x == branches.get(i).points.get(0).x && points.get(0).y == branches.get(i).points.get(0).y) {
              branches.remove(i);
              break;
            }
              
          }
          points.remove(0);
        }
        else {
          growing = false;
          return;
        }
      }
      
      m = n - stepLength;
      angleSpeed = nextAngleSpeed;
      angle += angleSpeed;
      points.add( new PVector(prev.x, prev.y) );
    }
    else
      m = n;
    
    for(Branch branch: branches)
      branch.update();
    
    // Branching?
    float prob =  branchingProbability;
    float delay = 400;
    if(depth == 0 && beat.isOnset()) {
      prob = 1;
      delay = 200; 
    }
    
    if(depth < 4 && millis() - lastBranching > delay && points.size() > 3 && prob > random(1)) {
      float aangle = angle;
      if( round(random(0,1)) == 1 )
        aangle += random(-1.0, -0.3);
      else
        aangle += random(0.3, 1.0);
      
      if(aangle < 0) aangle += 6.2831853;
      else if(aangle > 6.28) aangle -= 6.2831853;
      
      Branch b = new Branch( points.get(points.size() - 2), aangle, depth+1);
      branches.add(b);
      lastBranching = millis();
    }
    
    // Leaves
    if( millis() - lastLeaf > 200 && points.size() > 3 && 0.2 > random(1)) {
      float max = 0.4;
      if(depth == 1)
        max = 0.3;
      if(depth == 2)
        max = 0.2;
      Leaf lea = new Leaf( points.get(points.size() - 2), max);
      leaves.add(lea);
      lastLeaf = millis();
    }
	
    if(beat.isOnset() && depth != 0 && 0.3 > random(1)) {
      Flower fl = new Flower( points.get(points.size() - 2) );
      leaves.add(fl);
      
    }
    
    if(leaves.size() > 40) {
      leaves.remove(0); 
    }
    
  }
  
  
  void drawDebug() {
    strokeWeight(0.005);
    stroke(#ED1E79);
    noFill();
    for(PVector point: points) {
      ellipse(point.x, point.y, 0.03, 0.03);
    }
    beginShape();
    for(PVector point: points) {
      vertex(point.x, point.y);
    }
    endShape();
    for(Branch branch: branches)
      branch.drawDebug();
  }
  
  void draw() {
      
    noStroke();
    fill(#492A19);
    
    ArrayList<PVector> wayback = new ArrayList();
    
    beginShape(POLYGON);
    int l = points.size();
    //vertex( points.get(0).x, points.get(0).y );
    for(int i = 0; i < l; i++) {
      PVector a = points.get(i);
      if(i == l - 1) {
        vertex(a.x, a.y);
        //vertex(a.x, a.y);
      } else {
        PVector n = PVector.sub(points.get(i+1), a);
        float t = thickness;
        if(i > l - 20) 
          t -= (20 - (l-i-1)) * thickness / 20;
        t /= n.mag();
        vertex( a.x+t*n.y, a.y-t*n.x );
        wayback.add( new PVector( a.x-t*n.y, a.y+t*n.x ) );
      }
    }
    Collections.reverse(wayback);
    int r = 0;
    for(PVector point: wayback) {
      if( r == 0 )
        r++;
      else
        vertex( point.x, point.y );
      
    }
    //curveVertex( wayback.get(l-2).x, wayback.get(l-2).y );
    endShape(CLOSE);
    
    for(Branch branch: branches)
      branch.draw();
  }
  
  void drawLeaves(){
    for(Branch branch: branches)
      branch.drawLeaves();
    for(Leaf leaf: leaves)
      leaf.draw();
  }
  
  PVector getTip() {
    return points.get( points.size() - 1 );
  }
  
}
