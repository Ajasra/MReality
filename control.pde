void settingsInitalise(){
  camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
  fill(255);
  textAlign(CENTER);
  text("Settings:", width/2, 100);
  textAlign(LEFT);
  text("Press key 's' to toggle between setting screen and visualisation \n" + 
  "Press key 'r' to reset camera view to default \n" +
  "Press key 'x' to reset color \n" +
  "Press key 'q' to reset layouts style \n" +
  "Click left mouse button to save picture \n" +
  "Video control: SPACE - play/pause, SHIFT + r - reset to start \n", 50, 580);
}

void createControls() {
  cp5 = new ControlP5(this);
  cp5.addRange("levelController")
             // disable broadcasting since setRange and setRangeValues will trigger an event
             .setBroadcast(false) 
             .setPosition(50,170)
             .setSize(width-200,20)
             .setHandleSize(20)
             .setHandleSize(20)
             .setRange(0, 1000)
             .setRangeValues(0,1000)
             // after the initialization we turn broadcast back on again
             .setBroadcast(true)
             .setColorForeground(#0074d9)
             .setColorBackground(#002d5a)
             .setColorValueLabel(color(0))
             .setCaptionLabel("Audio level control");
   cp5.addButton("autoLevelBut")
             .setPosition(50,200)
             .setSize(100,20)
             .setCaptionLabel("Auto level");
   cp5.addButton("useWeb")
             .setPosition(200,200)
             .setSize(100,20)
             .setCaptionLabel("Use WebCam");
   cp5.addButton("loadFile")
             .setPosition(350,200)
             .setSize(100,20)
             .setCaptionLabel("'o' Load Image");
   cp5.addButton("loadVideo")
             .setPosition(500,200)
             .setSize(100,20)
             .setCaptionLabel("Load Video");
             
   cp5.addSlider("moveEasing")
             .setRange(0, 1)
             .setPosition(50, 250)
             .setSize(100, 20)
             .setCaptionLabel("'(' ')' Easing of movement by z-axis");
   cp5.addSlider("transparency1")
             .setBroadcast(false)
             .setRange(0, 255)
             .setPosition(50, 280)
             .setSize(100, 20)
             .setBroadcast(true)
             .setValue(transparency1)
             .setCaptionLabel("Transparency for back");
    cp5.addSlider("transparency2min")
             .setBroadcast(false)
             .setRange(0, 255)
             .setPosition(50, 310)
             .setSize(100, 20)
             .setBroadcast(true)
             .setValue(transparency2min)
             .setCaptionLabel("Minimum transparency for front");
    cp5.addSlider("transparency2max")
             .setBroadcast(false)
             .setRange(0, 255)
             .setPosition(50, 340)
             .setSize(100, 20)
             .setBroadcast(true)
             .setValue(transparency2max)
             .setCaptionLabel("Maximum transparency for front");
     cp5.addSlider("deepDiapason")
             .setRange(0, 2)
             .setPosition(50, 370)
             .setSize(100, 20)
             .setCaptionLabel("'Sft + 1/2' The deep of the space");
      cp5.addSlider("stepSize")
             .setRange(2, 50)
             .setPosition(50, 400)
             .setSize(100, 20)
             .setCaptionLabel("'z' Step Size");
       cp5.addSlider("camEasing")
             .setRange(0, 1)
             .setPosition(350, 250)
             .setSize(100, 20)
             .setCaptionLabel("'Shift + 3/4' Camera moving easing");
      cp5.addSlider("colorTrashold")
             .setRange(0, 1000)
             .setPosition(350, 280)
             .setSize(100, 20)
             .setCaptionLabel("'Shift + 5/6' Color trashold for Scanner mode");
             
      cp5.addSlider("hOffset")
             .setRange(-20, 20)
             .setPosition(350, 310)
             .setSize(100, 20)
             .setCaptionLabel("'Shift + 7/8' Y-offset for changed axis mode");
      cp5.addSlider("dOffset")
             .setRange(-20, 20)
             .setPosition(350, 340)
             .setSize(100, 20)
             .setCaptionLabel("'Shift + Y/U' z-offset for changed axis mode");
      cp5.addSlider("oSize")
             .setRange(0, 100)
             .setPosition(350, 370)
             .setSize(100, 20)
             .setCaptionLabel("'Shift + [/]'size of objects");
      cp5.addSlider("transitionFrame")
             .setRange(0, 200)
             .setPosition(350, 400)
             .setSize(100, 20)
             .setCaptionLabel("'Count of frames for transition");
             
      cp5.addSlider("boxMode")
             .setRange(1, 9)
             .setPosition(50, 500)
             .setNumberOfTickMarks(9)
             .setSize(200, 20)
             .setCaptionLabel("'q' Level 1: Boxes / Triangles / Spheres / Points / Polygons / Flat / Horizontal line / Vertical line");
      cp5.addSlider("boxMode2")
             .setRange(1, 9)
             .setPosition(50, 530)
             .setNumberOfTickMarks(9)
             .setSize(200, 20)
             .setCaptionLabel("'q' Level 2: Boxes / Triangles / Spheres / Points / Polygons / Flat / Horizontal line / Vertical line");
             
      cp5.addToggle("isActiveCamera")
             .setPosition(675,250)
             .setSize(50,20)
             .setCaptionLabel("'a' Active / Fixed")
             .setMode(ControlP5.SWITCH);
      cp5.addToggle("rotateObj")
             .setPosition(675,290)
             .setSize(50,20)
             .setCaptionLabel("Rotate object / Not")
             .setMode(ControlP5.SWITCH);
      cp5.addToggle("isTransition")
             .setPosition(675,330)
             .setSize(50,20)
             .setCaptionLabel("'T' Transition easing / Not")
             .setMode(ControlP5.SWITCH);
      cp5.addToggle("realColor")
             .setPosition(675,370)
             .setSize(50,20)
             .setCaptionLabel("'c' Real color / Random color")
             .setMode(ControlP5.SWITCH);
      cp5.addToggle("invert")
             .setPosition(675,410)
             .setSize(50,20)
             .setCaptionLabel("'i' Invert / Standart")
             .setMode(ControlP5.SWITCH);
      cp5.addToggle("fillColor")
             .setPosition(675,450)
             .setSize(50,20)
             .setCaptionLabel("'y' Fill / Not")
             .setMode(ControlP5.SWITCH);
             
      cp5.addToggle("savePDF")
             .setPosition(825,250)
             .setSize(50,20)
             .setCaptionLabel("Save PDF / Not")
             .setMode(ControlP5.SWITCH);
      cp5.addToggle("saveVideo")
             .setPosition(825,330)
             .setSize(50,20)
             .setCaptionLabel("'v' Save video / Not")
             .setMode(ControlP5.SWITCH);
      cp5.addToggle("autoMove")
             .setPosition(825,370)
             .setSize(50,20)
             .setCaptionLabel("'n' Auto camera / Control camera")
             .setMode(ControlP5.SWITCH);
      cp5.addToggle("xRand")
             .setPosition(825,410)
             .setSize(50,20)
             .setCaptionLabel("'k' Fixed dots / Random dots")
             .setMode(ControlP5.SWITCH);
      cp5.addToggle("scannerMode")
             .setPosition(825,450)
             .setSize(50,20)
             .setCaptionLabel("'h' Scanner / Normal")
             .setMode(ControlP5.SWITCH);
      cp5.addToggle("audioReactive")
             .setPosition(975,250)
             .setSize(50,20)
             .setCaptionLabel("'u' Audio Reactive / Not")
             .setMode(ControlP5.SWITCH);
      cp5.addToggle("changeAxis")
             .setPosition(975,290)
             .setSize(50,20)
             .setCaptionLabel("'t' Change Axis / Not")
             .setMode(ControlP5.SWITCH);
      cp5.addToggle("isSpheric")
             .setPosition(975,330)
             .setSize(50,20)
             .setCaptionLabel("'O' Shperic / Not")
             .setMode(ControlP5.SWITCH);
      cp5.addToggle("oneLayout")
             .setPosition(975,370)
             .setSize(50,20)
             .setCaptionLabel("'l' One Layout / Two")
             .setMode(ControlP5.SWITCH);
      cp5.addToggle("selLayout")
             .setPosition(975,410)
             .setSize(50,20)
             .setCaptionLabel("'L' First / Second")
             .setMode(ControlP5.SWITCH);
      cp5.addToggle("isDrag")
             .setPosition(975,450)
             .setSize(50,20)
             .setCaptionLabel("'D' Drag for spheric / Not")
             .setMode(ControlP5.SWITCH);
}

void updateButtonVisibility(boolean rec) {
  if (rec) {
    try {
      cp5.getController("levelController").setVisible(false);
      cp5.getController("transparency1").setVisible(false);
      cp5.getController("transparency2min").setVisible(false);
      cp5.getController("transparency2max").setVisible(false);
      cp5.getController("deepDiapason").setVisible(false);
      cp5.getController("stepSize").setVisible(false);
      cp5.getController("isActiveCamera").setVisible(false);
      cp5.getController("oneLayout").setVisible(false);
      cp5.getController("boxMode").setVisible(false);
      cp5.getController("boxMode2").setVisible(false);
      cp5.getController("realColor").setVisible(false);
      cp5.getController("saveVideo").setVisible(false);
      cp5.getController("autoLevelBut").setVisible(false);
      cp5.getController("loadFile").setVisible(false);
      cp5.getController("loadVideo").setVisible(false);
      cp5.getController("invert").setVisible(false);
      cp5.getController("savePDF").setVisible(false);
      cp5.getController("rotateObj").setVisible(false);
      cp5.getController("useWeb").setVisible(false);
      cp5.getController("autoMove").setVisible(false);
      cp5.getController("xRand").setVisible(false);
      cp5.getController("scannerMode").setVisible(false);
      cp5.getController("moveEasing").setVisible(false);
      cp5.getController("audioReactive").setVisible(false);
      cp5.getController("camEasing").setVisible(false);
      cp5.getController("colorTrashold").setVisible(false);
      cp5.getController("fillColor").setVisible(false);
      cp5.getController("changeAxis").setVisible(false);
      cp5.getController("hOffset").setVisible(false);
      cp5.getController("dOffset").setVisible(false);
      cp5.getController("isSpheric").setVisible(false);
      cp5.getController("oSize").setVisible(false);
      cp5.getController("selLayout").setVisible(false);
      cp5.getController("isDrag").setVisible(false);
      cp5.getController("isTransition").setVisible(false);
      cp5.getController("transitionFrame").setVisible(false);
    } catch (Exception ex) {
    }
  } else {
    try {
      cp5.getController("levelController").setVisible(true);
      cp5.getController("transparency1").setVisible(true);
      cp5.getController("transparency2min").setVisible(true);
      cp5.getController("transparency2max").setVisible(true);
      cp5.getController("deepDiapason").setVisible(true);
      cp5.getController("stepSize").setVisible(true);
      cp5.getController("isActiveCamera").setVisible(true);
      cp5.getController("boxMode").setVisible(true);
      cp5.getController("boxMode2").setVisible(true);
      cp5.getController("oneLayout").setVisible(true);
      cp5.getController("realColor").setVisible(true);
      cp5.getController("saveVideo").setVisible(true);
      cp5.getController("autoLevelBut").setVisible(true);
      cp5.getController("loadFile").setVisible(true);
      cp5.getController("loadVideo").setVisible(true);
      cp5.getController("invert").setVisible(true);
      cp5.getController("savePDF").setVisible(true);
      cp5.getController("rotateObj").setVisible(true);
      cp5.getController("useWeb").setVisible(true);
      cp5.getController("autoMove").setVisible(true);
      cp5.getController("xRand").setVisible(true);
      cp5.getController("scannerMode").setVisible(true);
      cp5.getController("moveEasing").setVisible(true);
      cp5.getController("audioReactive").setVisible(true);
      cp5.getController("camEasing").setVisible(true);
      cp5.getController("colorTrashold").setVisible(true);
      cp5.getController("fillColor").setVisible(true);
      cp5.getController("changeAxis").setVisible(true);
      cp5.getController("hOffset").setVisible(true);
      cp5.getController("dOffset").setVisible(true);
      cp5.getController("isSpheric").setVisible(true);
      cp5.getController("oSize").setVisible(true);
      cp5.getController("selLayout").setVisible(true);
      cp5.getController("isDrag").setVisible(true);
      cp5.getController("isTransition").setVisible(true);
      cp5.getController("transitionFrame").setVisible(true);
    } catch (Exception ex) {
    }
  }
}

//setting screen
void setSettings(){
  float xLevel = map(level,levelMin,levelMax,100, width-200);
  fill(color(random(0,255),random(0,255),random(0,255)));
  noStroke();
  ellipse(xLevel, 150, 5, 5); 
}

//handle with events of mouse and keyboard
void mousePressed(){
  if(mouseButton == LEFT && (mode == 1)){
    savePicture();
  }
}

void savePicture(){
  saveFrame("screen/" + day() + "_" + hour() + "_self-######.png");
    if(savePDF){
      recordPDF = true;
    }
}

void keyPressed(){
  if(key == ' ' && movieSelected){
    if(moviePayed){
      selMovie.play();
    }else{
      selMovie.pause();
    }
    moviePayed = !moviePayed;
  }
  if(key == 's'){
    clear();
    background(0);
    switch(mode){
      case 0:
        mode = 1;
        break;
      case 1:
        settingsInitalise();
        mode = 0;
        break;
      case 2:
        mode = 1;
        break;
      default:
        settingsInitalise();
        mode = 0;
        break;   
    }
  }else if(key == 'r'){
    positionX = width/2;
    positionY = height/2;
    isActiveCamera = !isActiveCamera; 
  }else if(key == 'v'){     //record video
    saveVideo = !saveVideo;
    cp5.getController("saveVideo").setValue(float(int(saveVideo)));
  }else if(key == 'a'){     //active camera
    isActiveCamera = !isActiveCamera;
    cp5.getController("isActiveCamera").setValue(float(int(isActiveCamera)));
  }else if(key == 'l'){
    oneLayout = !oneLayout;
    cp5.getController("oneLayout").setValue(float(int(oneLayout)));
  }else if(key == 'L'){
    selLayout = !selLayout;
    cp5.getController("selLayout").setValue(float(int(selLayout)));
  }else if(key == 'h'){
    scannerMode = !scannerMode;
    cp5.getController("scannerMode").setValue(float(int(scannerMode)));
  }else if(key == 'k'){
    coef1 = coef;
    xRand = !xRand;
    cp5.getController("xRand").setValue(float(int(xRand)));
    coef = coef1;
  }else if(key == 'c'){
    realColor = !realColor;
    cp5.getController("realColor").setValue(float(int(realColor)));
  }else if(key == 'i'){
    invert = !invert;
    cp5.getController("invert").setValue(float(int(invert)));
  }else if(key == 'q'){   //random mode
    boxMode = round(random(1,10));
    boxMode2 = round(random(1,10));
    cp5.getController("boxMode").setValue(boxMode);
    cp5.getController("boxMode2").setValue(boxMode2);
  }else if(key == 'z'){   //random step size
    stepSize = round(random(2,50));
    cp5.getController("stepSize").setValue(stepSize);
    initDot = true;       //random color
  }else if(key == 'x'){
    selectColor();
  }else if(key == 'o'){
    mode = 2;
    fileSelected = false;
    initImg = true;
  }else if(key == 'p'){
    background(0);
    if(mode != 3){
      modeP = mode;
      mode = 3;
    }else{
      mode = modeP;
    }
  }else if(key == 'n'){
    autoMove = !autoMove;
    cp5.getController("autoMove").setValue(float(int(autoMove)));
  }else if(key == '+'){
    if(!isSpheric){
      coef = coef * 1.1;
    }else{
      sCoef = sCoef * 1.1;
    }
  }else if(key == '-'){
    if(!isSpheric){
      coef = coef * 0.9;
    }else{
      sCoef = sCoef * .9;
    }
  }else if(key == '('){
    moveEasing = moveEasing * .9;
    moveEasing = constrain(moveEasing, 0, 1);
    cp5.getController("moveEasing").setValue(moveEasing);
  }else if(key == ')'){
    moveEasing = moveEasing * 1.1;
    moveEasing = constrain(moveEasing, 0, 1);
    cp5.getController("moveEasing").setValue(moveEasing);
  }else if(key == '{'){
    oSize = oSize * .9;
    oSize = constrain(oSize, 0, 100);
    cp5.getController("oSize").setValue(oSize);
  }else if(key == '}'){
    oSize = oSize * 1.1;
    oSize = constrain(oSize, 0, 100);
    cp5.getController("oSize").setValue(oSize);
  }else if(key == '!'){
    deepDiapason = deepDiapason * 0.9;
    deepDiapason = constrain(deepDiapason, 0, 2);
    cp5.getController("deepDiapason").setValue(deepDiapason);
  }else if(key == '@'){
    deepDiapason = deepDiapason * 1.1;
    deepDiapason = constrain(deepDiapason, 0, 2);
    cp5.getController("deepDiapason").setValue(deepDiapason);
  }else if(key == 'u'){
    audioReactive = !audioReactive;
    cp5.getController("audioReactive").setValue(float(int(audioReactive)));
  }else if(key == '#'){
    camEasing = camEasing * 0.9;
    camEasing = constrain(camEasing, 0, 1);
    cp5.getController("camEasing").setValue(camEasing);
  }else if(key == '$'){
    camEasing = camEasing * 1.1;
    camEasing = constrain(camEasing, 0, 2);
    cp5.getController("camEasing").setValue(camEasing);
  }else if(key == '%'){
    colorTrashold = colorTrashold * 0.9;
    colorTrashold = constrain(colorTrashold, 0, 1000);
    cp5.getController("colorTrashold").setValue(colorTrashold);
  }else if(key == '^'){
    colorTrashold = colorTrashold * 1.1;
    colorTrashold = constrain(colorTrashold, 0, 1000);
    cp5.getController("colorTrashold").setValue(colorTrashold);
  }else if(key == '&'){
    hOffset = hOffset - .05;
    cp5.getController("hOffset").setValue(hOffset);
  }else if(key == '*'){
    hOffset = hOffset + .05;
    cp5.getController("hOffset").setValue(hOffset);
  }else if(key == 'Y'){
    dOffset = dOffset - .05;
    cp5.getController("dOffset").setValue(dOffset);
  }else if(key == 'U'){
    dOffset = dOffset + .05;
    cp5.getController("dOffset").setValue(dOffset);
  }else if(key == 'y'){
    fillColor = !fillColor;
    cp5.getController("fillColor").setValue(float(int(fillColor)));
  }else if(key == 't'){
    changeAxis = !changeAxis;
    cp5.getController("changeAxis").setValue(float(int(changeAxis)));
  }else if(key == 'T'){
    isTransition = !isTransition;
    cp5.getController("isTransition").setValue(float(int(isTransition)));
  }else if(key == ' '){
     if(movieSelected){
       if(moviePayed){
         selMovie.pause();
       }else{
          selMovie.play(); 
       }
     }
  }else if(key == 'R'){
    if(movieSelected){
      selMovie.stop();
    }
  }else if(key == 'O'){
    isSpheric = !isSpheric;
    cp5.getController("isSpheric").setValue(float(int(isSpheric)));
  }else if(key == 'D'){
    isDrag = !isDrag;
    cp5.getController("isDrag").setValue(float(int(isDrag)));
  }
}

//autolevel
void controlEvent(ControlEvent theControlEvent) {
  if(theControlEvent.isController()) { 
    if(theControlEvent.isFrom("levelController")) {
      tempMin = theControlEvent.getController().getArrayValue(0);
      tempMax = theControlEvent.getController().getArrayValue(1);
      mLevelMin = map(tempMin, 0 , 1000, levelMin, levelMax);
      mLevelMax = map(tempMax, 0 , 1000, levelMin, levelMax);
    }
  }
}

//Load File
void loadFile(){
  mode = 2;
  fileSelected = false;
  initImg = true;
}

//Load video
void loadVideo(){
  mode = 4;
  movieSelected = false;
  initMovie = true;
}

void useWeb(){
  initImg = true;
  fileSelected = false;
  initMovie = true;
  movieSelected = false;
  mode = 3;
  initDot = true;
}

//Auto level for mic
void autoLevelBut() {
  float[] aLevel = new float[100];
  float levelP = 0, levelC;
  int i = 0;
  
  while(i < aLevel.length){
    levelC = in.left.level();
    if(levelP != levelC){
      levelP = levelC;
      aLevel[i] = in.left.level();
      i++;
    }
  }
  mLevelMin = min(aLevel);
  mLevelMax = max(aLevel);
  levelMin = mLevelMin;
  levelMax = mLevelMax;
  background(0);
  settingsInitalise();
}
