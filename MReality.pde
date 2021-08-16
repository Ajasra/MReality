/* ---------------------------------------
The MReality app
Matching realtime image from web-camera and sound with pseudo 3d space
The interactive appliction, take input from web-cam and audio input from mic
Vasily Betin `16
www.vasily.onl */

import processing.video.*;
import ddf.minim.*;
import controlP5.*;
import processing.pdf.*;
import javax.swing.JFileChooser;
import java.io.File;       

//set variables for input
Minim minim;
AudioInput in;
Capture cam;
PImage img, imgInv;

//timer for color changing
int timer = 100, tm;

//mode
int mode = 0;
int modeP;
boolean isActiveCamera = true;
boolean saveVideo = false;
boolean dimensionNumber = true;
boolean oneLayout = false;
boolean selLayout = true;
boolean realColor = true;
boolean invert = false;
boolean savePDF = false;
int boxMode = 1;
int boxMode2 = 1;
boolean recordPDF = false;
boolean rotateObj = true;
boolean audioReactive = true;
boolean fillColor = true;
boolean changeAxis = false;
boolean isSpheric = false;
boolean isDrag = false;
boolean isTransition = true;

ControlP5 cp5;

float moveEasing = .3;
float stepSize = 10;
float oSize = 9;
float previousStepSize = 10;
float deepDiapason = 0.5;
float transparency2max = 100;
float transparency2min = 50;
float transparency1 = 200;
float hOffset = -.6;
float dOffset = 0.0;
int transitionFrame = 10;
int transitionStart = 0;

float positionX, positionY;
float camPositionX, camPositionY;
float camEasing = .4;
float speedX, speedY;

float level, move;

float mLevelMin = 0.0000001, levelMin = mLevelMin;
float mLevelMax = 0.01, levelMax = mLevelMax;
float tempMin = mLevelMin, tempMax = mLevelMax;

color imgCol, imgColInv, pixel;
boolean autoMove = false;

//leap motion
boolean leapMotionMode = false;
float[] features = new float[15];
int numFound = 0;
float delayTimer = 0;

boolean initDot = true;
int cols, rows;
int numberD = 0;
Dot[] dot;
int nearestC = 4;
float colorTrashold = 200;
boolean scannerMode = false;

boolean initImg = true;
PImage selImage;
boolean fileSelected = false;

Movie selMovie;
boolean initMovie = true;
boolean movieSelected = false;
boolean moviePayed = false;

float coef = 1;

boolean xRand = true;
int timeX = 0, timeY = 0;

int nextColor = 0;
int nextX = 0, nextY = 0;
int nextStyle = 0;
int nextMoodTime = 0;

float coef1, coef2;
float sCoef = 1;

void setup()
{
  
  String[] cameras = Capture.list();
  
  for(int i = 0; i < cameras.length; i++){
    println(i + " _ " + cameras[i]);
  }
  
  //fullScreen(OPENGL);
  size(1920, 1080, OPENGL);
  smooth();
  rectMode(CENTER);
  if(moviePayed){    
    frameRate(6);
  }else{
    frameRate(15);
  }

  // load and start the camera
  cam = new Capture(this, 640, 480);
  //cam = new Capture(this, cameras[1]);
  cam.start();       

  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 256);
  
  textFont(createFont("Helvetica", 14, true));
  background(0); 
  
  createControls();
  settingsInitalise();
  
  positionX = width/2;
  positionY = height/2;
  camPositionX = positionX;
  camPositionY = positionY;

  speedX = random(-1,1) * random(1, 15);
  speedY = random(-1,1) * random(1, 15);

}

void draw()
{ 
  
  if(cam.available()) { //<>//
    cam.read(); cam.loadPixels();
    
    if(audioReactive){
      level = in.left.level();
      level = constrain(level, mLevelMin, mLevelMax);
      move = map(level, mLevelMin, mLevelMax, 2, 50);
    }else{
      move = deepDiapason * 50;
    }
    
    switch(mode){
      case 0: //settings
        updateButtonVisibility(false);
        setSettings();
        break;
        
      case 1: //drawing
        updateButtonVisibility(true);
        //auto mode
        if(nextStyle <= millis() && autoMove) {
          boxMode = round(random(1,7));
          boxMode2 = round(random(1,7));
          cp5.getController("boxMode").setValue(boxMode);
          cp5.getController("boxMode2").setValue(boxMode2);
          nextStyle = round(random(1000,5000)) + millis();
        }

        if(nextColor <= millis() && autoMove){
          if(random(0,100) > 40) {
            realColor = !realColor;
            cp5.getController("realColor").setValue(float(int(realColor)));
          }else{
            selectColor();
          }
          nextColor = round(random(3000,10000)) + millis();
        }

        if(autoMove){
          positionX = movePositionX();
          positionY = movePositionY();
          nextMood();
        }else if(isActiveCamera){
          speedX = mouseX - positionX;
          speedX = constrain(speedX, -15, 15);
          speedY = mouseY - positionY;
          speedY = constrain(speedY, -15, 15);
          positionX = mouseX;
          positionY = mouseY;
        }
        camPositionX = camPositionX + (positionX - camPositionX) * camEasing;
        camPositionY = camPositionY + (positionY - camPositionY) * camEasing;
        
        camera(camPositionX, camPositionY, (camPositionY/2) / tan(PI/10), width/2, height/2, 0, 0, 1, 0);
        
        
        if(initDot){
          initalizeDots();
          initDot = false;
        }
        
        if (recordPDF) {
          beginRaw(PDF, "screen/" + day() + "_" + hour() + "_frame-####.pdf");
        }
        
        drawDots();
        
        if (recordPDF) {
          endRaw();
          recordPDF = false;
        }
        
        if(saveVideo){
          saveFrame("screen/video/" + day() + "_" + hour() + "_self-######.tiff");
        }
        
        //println(frameRate);
        break;
        
      case 2: //open file
        updateButtonVisibility(true);
        if(initImg){
          loadNewFile();
          initImg = false;
        }
        drawImg();
        break;
        
      case 3: //show real image
        updateButtonVisibility(true);
        drawInput();
        break;
        
      case 4: // load movie
        updateButtonVisibility(true);
        if(initMovie){
          loadNewVideo();
          initMovie = false;
          fileSelected = false;
        }
        drawMovie();
        break;
        
      default:
        updateButtonVisibility(false);
        setSettings();
      break;
    };
  }
  if(stepSize != previousStepSize){
    initDot = true;
  }
  previousStepSize = stepSize;
  
}

// Called every time a new frame is available to read
void movieEvent(Movie m) {
  m.read();
}

void loadNewFile(){ 
  selectInput("Select a file to process:", "fileSelected");
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
    initImg = true;
    mode = 0;
  } else {
    selImage = loadImage(selection.getAbsolutePath());
    fileSelected = true;
    initDot = true;
  }
}

void drawImg(){
  background(0);
  if(fileSelected){
    selImage = resizeImage(selImage, 640, 480);
    image(selImage, (width - selImage.width) / 2, (height - selImage.height) / 2, selImage.width, selImage.height);
  }
}

void loadNewVideo(){
  selectInput("Select a file to process:", "videoSelected");
}

void videoSelected(File selection){
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
    initMovie = true;
    mode = 0;
  } else {
    selMovie = new Movie(this, selection.getAbsolutePath());
    selMovie.frameRate(6);
    selMovie.speed(.3);
    movieSelected = true;
    initDot = true;
    fileSelected = false;
    selMovie.loop();
  }
}

void drawMovie(){
  background(0);
  if(movieSelected){
    selMovie = resizeVideo(selMovie, 800, 600);
    image(selMovie, (width - selMovie.width) / 2, (height - selMovie.height) / 2, selMovie.width, selMovie.height);
  }
}

//to see what we work with
void drawInput(){
  background(0);
  if(fileSelected){
    image(selImage, (width - selImage.width) / 2, (height - selImage.height) / 2, selImage.width, selImage.height);
  }else if(movieSelected){
    resizeVideo(selMovie, 640, 480);
  }else{
    image(cam, (width - cam.width) / 2, (height - cam.height) / 2, cam.width, cam.height);
  }
}

void initalizeDots(){
  if(fileSelected){
    cols = round(selImage.width / (stepSize + 2));
    rows = round(selImage.height / (stepSize + 2));
  }else if(movieSelected){
    cols = round(selMovie.width / (stepSize + 2));
    rows = round(selMovie.height / (stepSize + 2));
  }else{
    cols = round(cam.width / (stepSize + 2));
    rows = round(cam.height / (stepSize + 2));
  }
  int i = 0;
  numberD = cols * rows;
  dot = new Dot[numberD];
  float x, y;
  
  boxMode = boxModeRand(boxMode); 
  boxMode2 = boxModeRand(boxMode2);
  
  img = loadImage(round(random(1,16)) + ".jpg");
  imgInv = loadImage(round(random(1,16)) + ".jpg");
  imgInv.filter(INVERT);
  
  for (int r = 0; r <  rows; r++) {
    for (int c = 0; c < cols; c++) {
      x = c * (stepSize + 2) + stepSize/2;
      y = r * (stepSize + 2) + stepSize/2;
      
      dot[i] = new Dot(i, x, y);
      i++;
    }
  }
  selectColor();
  updateAllNearest();
  setScaleCoef();
}

//set coefficient for scale image
void setScaleCoef(){
  if(fileSelected){  //photo
      coef1 = width / selImage.width;
      coef2 = height / selImage.height;
    }else if(movieSelected){ //video
      coef1 = width / selMovie.width;
      coef2 = height / selMovie.height;
    }else{ //webcam
      coef1 = width / cam.width;
      coef2 = height / cam.height;
    }
    if(coef1 > coef2){
      coef = coef1;
    }else{
      coef = coef2;
    }
}

//set color for dots
void selectColor(){
    img = loadImage(round(random(1,16)) + ".jpg");
    imgInv = loadImage(round(random(1,16)) + ".jpg");
    imgInv.filter(INVERT);
    for(int i = 0; i < numberD; i++){
      dot[i].updateColor();
    }
}

//draw dots on the screen
void drawDots(){
  background(0);
  
  if(tm == 0 && !autoMove){
    selectColor();
  }
  tm -= 1;
  
  pushMatrix();
    if(!isSpheric){
      if(fileSelected){  //photo
        translate((width - selImage.width * coef)/2,(height-selImage.height * coef)/2, 0);
      }else if(movieSelected){ //video
        translate((width - selMovie.width * coef)/2,(height-selMovie.height * coef)/2, 0);
      }else{ //webcam
        translate((width - cam.width * coef)/2,(height-cam.height * coef)/2, 0);
      }
    }
  
  noStroke(); fill(255);
  for(int i = 0; i < numberD; i++){
    dot[i].draw();
  }
  popMatrix();
}

//chech box mode for random value
int boxModeRand(int mode){
  if(mode == 8){
    mode = round(random(1,7));
  }
  return mode;
}

//resizing photo
PImage resizeImage(PImage img, int w, int h){
  if(img.width > w){
     img.resize(w,0); 
  }
  if(img.height > h){
     selImage.resize(0,h); 
  }
  return img;
}

//resizing video image
Movie resizeVideo(Movie vid, int w, int h){
  /*if(vid.width > w){
    vid.resize(w,0);
  }
  if(vid.height > h){
    vid.resize(0,h);
  }*/
  return vid;
}

//autoMove
float movePositionX(){
  if(nextX <= millis()){
    speedX = random(-1,1) * random(1, 10);
    nextX = round(random(1000,5000)) + millis();
  }
  
  positionX += speedX;
  if(positionX < 0 || positionX > width){
    speedX = -speedX;
  }
  return positionX;
}

float movePositionY(){
  
  if(nextY <= millis()){
    speedY = random(-1,1) * random(1, 10);
    nextY = round(random(1000,5000)) + millis();
  }

  positionY += speedY;
  if(positionY < 0 || positionY > height){
    speedY = -speedY;
  }
  return positionY;
}

void nextMood(){
  if(nextMoodTime <= millis()){
      nextMoodTime = millis() + round(random(10000,60000));
      if(random(0,100) > 50) {
         scannerMode = !scannerMode;
         cp5.getController("scannerMode").setValue(float(int(scannerMode))); 
      }
      if(random(100,200) > 170) {
        xRand = !xRand;
        coef1 = coef;
      }
      if(random(200,300) > 270){
        invert = !invert;
        cp5.getController("invert").setValue(float(int(invert)));
      }
  }
}

//stop programm
void stop()
{
  in.close();
  minim.stop();
  cam.stop();
  super.stop();
}
