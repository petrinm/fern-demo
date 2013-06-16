


class BeatingCamera extends Fxs {
  float jump = 0;
  BeatingCamera(int start) {
    super(start);
  }
  boolean display() {
    if(millis() - startTime > 32000)
      return false;
      
    jump *= 0.95;
    if(beat.isOnset())
      jump = 0.05;
    zoom = 2 + jump;
    return true;
  }
}

class BeatingBackground extends Fxs {
  color a, b;
  float jump = 0;
  BeatingBackground(int start, color bb) {
    super(start);
    b = bb;
  }
  boolean display() {
    if(millis() - startTime > 7000)
      return true;
    
    jump *= 0.91;
    if(beat.isOnset())
      jump = 1;
    
    bg = lerpColor(a, b, jump);
    return true;
  }
  
  void start() {
    a = bg; 
  }
}

class AcceleratedGrowing extends Fxs {
  int duration;
  AcceleratedGrowing(int sstart, int dur) {
    super(sstart);
    duration = dur;
  }
  boolean display() {
    mainBranch.growSpeed = 0.03;
    return millis() - startTime < duration;
  }
  void start() { 
    mainBranch.growSpeed = 0.033;
  }
}
