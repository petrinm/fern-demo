

class Fxs {
  
  int startTime;
  
  Fxs(int start) {
    startTime = start; 
  }
  
  boolean display() {
    return false;
  }
  
  void start() { }
  void stop() { }
  
  String getName() {
    String className = getClass().getName();
    return className.substring(className.indexOf("$")+1, className.length()); 
  }
}

class Intro extends Fxs {
  Intro() {
    super(0);
  }
  boolean display() {
    if(millis() > 14000)
      return false;
      
    pushMatrix();
    fill(#45A0FF);
    
    textSize(1);
    translate(0, 3);
    scale(1, -1);
    rotate(-0.3316);
    
    text("CODE+", 0, 0);
    text("AUDIO+", 0, 0.9);
    text("GRAPHICS+", 0, 1.8);
    
    rotate(0.6);
    text("Fern!", 5, 2.0);
    
    popMatrix();
    
    return true;
  }
}

class Brancher extends Fxs {
  //Branch mainBranch;
  Brancher() {
    super(0);
    
  }
  boolean display() {
    mainBranch.update();
    mainBranch.draw();
    if(debug)
      mainBranch.drawDebug();
    return true;
  }
  void start() {
    mainBranch = new Branch( new PVector(0.0f, 1.5f), -0.1 , 0);
    mainBranch.nextAngleSpeed = -0.06; 
  }
  
}

class LetterBoxing extends Fxs {
  float phase = 0;
  LetterBoxing(int start) {
    super(start);
  }
  boolean display() {
    resetMatrix();
    translate(-WIDTH  / 2, -HEIGHT / 2); 
    rectMode(CORNERS);
    noStroke();
    fill(0);
    
    phase = min(1, phase+0.01);
    
    rect(0, 0, 1280, phase * 93);
    rect(0, 720-phase*93, 1280, 720);
    return true;
  }
}

class Credits extends Fxs {
  float fade = 0;
  int state = 1;
  
  Credits(int start) {
    super(start);
  }
  boolean display() {
    
    mainBranch.branchingProbability = 0.001;
    mainBranch.growSpeed *= 0.9999;
    pushMatrix();
    resetMatrix();
    translate(-WIDTH  / 2, -HEIGHT / 2); 
    rectMode(CORNERS);
    noStroke();
    
    fade = min(255, fade+1);
    fill(255,255,255,fade);

    scale(30,30);
    if( state == 1 ) {
      pushMatrix();
      scale(4,4);
      //translate(0, -1);
      fill(69, 160, 255, fade);
      text("Fern!", 0.15, 4.7);
      popMatrix();
      fill(255,255,255,fade);
      text("Made for Code+Audio+Graphics 2013 party!", 1, 20);
    }
    else if( state == 2 ) {
      text("Coding/Graphics/Desing: petrinm", 1, 18.8);
      text("Music: project-zero - Still breathing", 1, 20);
    }
    else if( state == 3 ) {
      text("Greetings for:", 1, 17.6);
      text("Exitium, Aikadilaatio,", 1, 18.8);
      text("Jonux, kaksoisv and tasdu...", 1, 20);
    }
    else if( state == 4 ) {
      text("and of course for DOT", 1, 18.8);
      text("for organizing the party.", 1, 20);
    }
    
    if(state < 6 && millis() - startTime > state * 6000) {
     fade = 0; state++;
    }
    
    popMatrix();
    return true; 
  }
}

class Spectrum extends Fxs {
  float fade = 160;
  Spectrum(int start) {
    super(start);
  }
  
  boolean display() {
    if(millis() > 240000)
      fade *= 0.99;
      
    resetMatrix();
    translate(-WIDTH  / 2, -HEIGHT / 2); 
    rectMode(CORNERS);
    fill(80, 114, 11, fade);
    noStroke();
    
    int w = int( (HEIGHT / 3) / fft.avgSize());
    for(int i = 0; i < fft.avgSize(); i++)
    {
      rect(0, HEIGHT-w*i, fft.getAvg(i)*4, HEIGHT-w*(i+1) );
    }
    
    return fade > 1;
  }
}
