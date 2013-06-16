

import ddf.minim.*;
import ddf.minim.analysis.*;
import java.util.Collections;



int HEIGHT = 720;
int WIDTH = 1280;
/*
boolean sketchFullScreen() {
  return true;
}*/




float ASPECT_RATIO = (float)WIDTH / HEIGHT;
float zoom = 2;

Minim minim;
FFT fft;

AudioPlayer music;
BeatDetect beat;
Branch mainBranch;

int prev = millis();
PVector camera;

Fxs[] effects = {
  new Intro(),
  new Brancher(),
  new Spectrum(1000),
  new BeatingBackground(36000, color(219,190,83 ,255)),
  new BeatingCamera(44000),
  new AcceleratedGrowing(76000, 12000),
  new BeatingBackground(100000, color(219,190,83 ,255)),
  new BeatingCamera(117000),
  new LetterBoxing(241000), // 247000
  new Credits(241000 + 5000),  
};

ArrayList<Fxs> runningEffects = new ArrayList();
int effectIdx = 0;

boolean debug = false;


color bg;

PShape flowerShape;

PFont font;

void setup() {
  size(WIDTH, HEIGHT, P2D); 
  frame.setTitle("Fern");
  frameRate(60); 
  smooth();
  randomSeed(19095);

  font = loadFont("Aharoni-Bold-48.vlw");
  textFont(font, 32);
  
  setupAudio();
  
  camera = new PVector(4,5);
  bg = color(#B19943);
  
  flowerShape = loadShape("flower.svg");
}

void setupAudio() {
  minim = new Minim(this);
  music = minim.loadFile("zero-project_still_breathing.mp3", 2048);
  music.play();
  fft = new FFT(music.bufferSize(), music.sampleRate());
  fft.logAverages(22, 3);
  beat = new BeatDetect();
  beat.setSensitivity(13);
}


void draw() {
  
  if(!music.isPlaying())
    exit();
  
  resetMatrix();
  scale(WIDTH / (zoom * 2.0) / ASPECT_RATIO, -HEIGHT / ( zoom * 2.0));
  
  background(bg);
  
  // CAMERA UPDATE
  if(mainBranch != null)
    camera.lerp( mainBranch.getTip(), 0.01 );
  translate( -camera.x, -camera.y );
  
  // UPDATE
  fft.forward(music.mix);
  beat.detect(music.mix);
  
  if(beat.isOnset() || millis() - prev > 4000 ) {
    if(millis() < 12000)
      mainBranch.nextAngleSpeed = random(-0.05, 0.05);
    else
      mainBranch.nextAngleSpeed = random(-0.25, 0.25);
    prev = millis();
  }
  
  
  // check new?
  while(effectIdx < effects.length && effects[effectIdx].startTime <= millis()) {
    Fxs n = effects[effectIdx];
    print("starting " + n.getName() + "\n");
    
    n.start();
    runningEffects.add( n );
    effectIdx++;
  }
  
  // update olds
  for(int i = 0; i < runningEffects.size(); i++) {
    if( !runningEffects.get(i).display() ) {
      print("killing " + runningEffects.get(i).getName() + "\n");
      runningEffects.remove(i);
    }
  }
  
}


void stop() {
  music.close();
  minim.stop();
  super.stop(); 
}

void keyPressed() {
  if (key == ENTER) {
    print(millis() + ",");
  }
  else if( key == ' ') {
     debug = !debug;
     if(debug)
       print("debug on\n");
     else
       print("debug off\n");
  }
  else if(key == 'p') {
    print("\ntime: "+millis()+"\n"); 
  }
}
