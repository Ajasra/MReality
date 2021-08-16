class Dot {
  int curI;
  float x, y, xR, yR, curX1, curY1, curZ1, curX2, curY2, curZ2, dX, dY;
  color colC1, colP1, colC2, colP2, colNat, prevCol;
  float darkness = 0, curDark = 0, radius = 0, radRot, opacity, borderOpacity1, borderOpacity2;
  float xMove, yMove, xPos, yPos;
  float s, t, s1, s2, s3, s4, s5, s6;
  float pMove;
  int nearest[] = new int[nearestC];
  int pMod1, pMod2;
  
  Dot(int i, float x1, float y1){
      this.curI = i;
      this.x = x1; this.y = y1;
      
      if(fileSelected){  //photo
        this.xR = random(selImage.width);
        this.yR = random(selImage.height);
        this.s = map(this.x, 0, selImage.width, 0, 360);
        this.t = map(this.y, 0, selImage.height, 0, 360);
      }else if(movieSelected){ //video
        this.xR = random(selMovie.width);
        this.yR = random(selMovie.height);
        this.s = map(this.x, 0, selMovie.width, 0, 360);
        this.t = map(this.y, 0, selMovie.height, 0, 360);
      }else{ //webcam
        this.xR = random(cam.width);
        this.yR = random(cam.height);
        this.s = map(this.x, 0, cam.width, 0, 360);
        this.t = map(this.y, 0, cam.height, 0, 360);
      }

    this.colC1 = img.get(int(this.x),int(this.y));
    this.colC2 = imgInv.get(int(this.x),int(this.y));
    this.prevCol = this.colC1;
    this.pMove = move;
    
    this.pMod1 = boxMode;
    this.pMod2 = boxMode2;
  }
  
  void updateNearest(){
    nearest = new int[nearestC];
    for(int q = 0; q < nearestC; q++){
        this.nearest[q] = 0;
        float dist = width + height;
        for(int j = 0; j < numberD; j++){
          float[] posP = dot[j].getCoordinate();
          float temp = 0;
          boolean inArray = false;
          
          for(int k = 0; k < nearestC; k++){
            if(this.nearest[k] == j) inArray = true;
          }
          temp = dist(this.xR, this.yR, posP[0], posP[1]);
          if((temp < dist) && (this.curI != j) && !inArray){
            dist = temp;
            this.nearest[q] = j;
          }
        }
      }
  }
  
  void updateColor(){
    if(xRand){
      this.colC1 = img.get(int(this.x),int(this.y));
      this.colC2 = imgInv.get(int(this.x),int(this.y));
    }else{
      this.colC1 = img.get(int(this.xR),int(this.yR));
      this.colC2 = imgInv.get(int(this.xR),int(this.yR));
    }
  }
  
  void updateDarkness(){
    
    if(xRand){
      if(fileSelected){
        this.colNat = selImage.get(int(this.x),int(this.y));
      }else if(movieSelected){
        this.colNat = selMovie.get(int(this.x),int(this.y));
      }else{
        this.colNat = cam.get(int(this.x),int(this.y));
      }
    }else{
      if(fileSelected){
        this.colNat = selImage.get(int(this.xR),int(this.yR));
      }else if(movieSelected){
        this.colNat = selMovie.get(int(this.xR),int(this.yR));
      }else{ //webcam
        this.colNat = cam.get(int(this.xR),int(this.yR));
      }
    }
    
    
    if(scannerMode){
      float r1 = red(colNat); float g1 = green(colNat); float b1 = blue(colNat);
      float r2 = red(prevCol); float g2 = green(prevCol); float b2 = blue(prevCol);
      float diff = dist(r1,g1,b1,r2,g2,b2);
      if(diff  > colorTrashold){
         this.darkness = 255 / 255.0;
      }
      this.prevCol = this.colNat;
    }else{
      this.darkness = brightness(this.colNat) / 255.0;
    }
    this.curDark = this.darkness;
    this.colP1 = this.colC1;
    this.colP2 = this.colC2;
  }
  
  void draw(){
    updateDarkness();
    
    if(invert){
      this.curDark = 1 - this.darkness; 
    }else{
      this.curDark = this.darkness; 
    }
    this.radius = oSize * this.curDark;
    this.radRot = this.radius/15 * 2 * PI * frameCount / 50 * PI;
    this.opacity = map(this.curDark, 0, 1, transparency2min, transparency2max);
    this.borderOpacity1 = constrain(transparency1 + 50, 0, 255);
    this.borderOpacity2 = constrain(this.opacity + 50, 0, 255);
    
    if(xRand){
      this.dX = this.x * coef;
      this.dY = this.y * coef;
      this.xMove = map(this.x, 0.0, cam.width, 1, -1);
      this.yMove = map(this.y, 0.0, cam.height, 1, -1);
    }else{
      this.dX = this.xR * coef;
      this.dY = this.yR * coef;
      this.xMove = map(this.xR, 0.0, cam.width, 2, -2);
      this.yMove = map(this.yR, 0.0, cam.height, 2, -2);
    }
    
    pMove = pMove + (move-pMove) * moveEasing;
    this.yPos = dY - pMove * darkness * yMove * 2;
    this.xPos = dX - pMove * darkness * xMove * 2;
    
    
    if(isTransition){
      if(boxMode != this.pMod1 || boxMode2 != this.pMod2) { 
        
        if(transitionStart == 0){
          transitionStart = frameCount;
        }
        
        if(random(transitionFrame) > (transitionFrame - (frameCount - transitionStart))){
          this.pMod1 = boxMode;
        }
        if(random(transitionFrame) > (transitionFrame - (frameCount - transitionStart))){
          this.pMod2 = boxMode2;
        }
        
        if((transitionFrame - (frameCount - transitionStart)) < 1) transitionStart = 0;
       
        
      }      
    }else{
        if(boxMode != this.pMod1 || boxMode2 != this.pMod2) { 
          this.pMod2 = boxMode2;
          this.pMod1 = boxMode;
        }
     }
    
    
    if(!oneLayout){ 
      drawLayout(2, this.pMod2);
      drawLayout(1, this.pMod1);
    }else{
      if(selLayout){
        drawLayout(1, this.pMod1);
      }else{
        drawLayout(2, this.pMod2);
      }
    }
    
    if(scannerMode){
       if(this.darkness > 0){
          this.darkness -= 0.1;
      } 
      this.darkness = constrain(this.darkness, 0, 1);
    }
  }
  
  void drawLayout(int layout, int boxMode){
    
    pushMatrix();
    if(layout == 1){ // back layout
      if(realColor){  //real colot
      if(fillColor){
          fill(colNat, transparency1);
        }else{
          noFill();
        } 
        stroke(colNat, borderOpacity1);
      }else{
        if(fillColor){
          fill(colP1, transparency1);
        }else{
          noFill();
        }
        stroke(colP1, borderOpacity1);
      }
      this.curX1 = this.dX;
      this.curY1 = this.yPos;
      this.curZ1 = - this.radius * pMove * deepDiapason;
      if(!changeAxis){
        if(isSpheric){
          
          this.s1 = (this.curZ1 + 300) * cos(radians(this.s)) * sin(radians(this.t)) * sCoef;
          this.s2 = (this.curZ1 + 300) * sin(radians(this.s)) * sin(radians(this.t)) * sCoef;
          this.s3 = (this.curZ1 + 300) * cos(radians(this.t)) * sCoef;
          translate(this.s1 + width/2, this.s2 + height/2, this.s3);
        }else{
          translate(this.curX1, this.curY1, this.curZ1);
        }
      }else{
        translate(this.curX1, this.curZ1 - hOffset * height, -this.curY1 + dOffset * height);
      }
      if(changeAxis && boxMode == 7){
        rotateX(radians(90));
      }else if(isSpheric && boxMode == 7){
        rotateX(radians(this.s));
        rotateY(radians(this.s));
        rotateZ(radians(this.t));
      }else if(boxMode != 5 && boxMode != 6 && boxMode != 7 && boxMode != 8 && boxMode != 9 && boxMode != 10 && rotateObj){
        rotateX(radRot);
        rotateY(radRot);
        rotateZ(radRot);
      }
    }else{  // front layout
      if(realColor){
        if(fillColor){
          fill(colNat, this.opacity);
        }else{
          noFill(); 
        }
        stroke(colNat, borderOpacity2);
      }else{
        if(fillColor){
          fill(colP2, this.opacity);
        }else{
          noFill();
        }
        stroke(colP2, borderOpacity2);
      }
      this.curX2 = this.xPos;
      this.curY2 = this.dY;
      this.curZ2 = this.radius * pMove * deepDiapason;
      if(!changeAxis){
        if(isSpheric){
          
          this.s4 = (this.curZ2 + 300) * cos(radians(this.s)) * sin(radians(this.t)) * sCoef;
          this.s5 = (this.curZ2 + 300) * sin(radians(this.s)) * sin(radians(this.t)) * sCoef;
          this.s6 = (this.curZ2 + 300) * cos(radians(this.t)) * sCoef;
          if(isDrag){
            translate(this.s1 + width/2, this.s2 + height/2, this.s6);
          }else{
            translate(this.s4 + width/2, this.s5 + height/2, this.s6);
          }
        }else{
          translate(this.curX2, this.curY2, this.curZ2);
        }
      }else{
        translate(this.curX2, this.curZ2 - hOffset * height, -this.curY2  + dOffset * height);
      }
      if(changeAxis && boxMode == 7){
        rotateX(radians(-90));
      }if(boxMode != 5 && boxMode != 6 && boxMode != 7 && boxMode != 8 && boxMode != 9 && boxMode != 10 && rotateObj){
        rotateX(-radRot);
        rotateY(-radRot);
        rotateZ(-radRot);
      }
    }

    if(boxMode == 1){
      box(radius);
    }else if(boxMode == 2){
      beginShape();
      vertex(-radius/2, -radius/2, -radius/2);
      vertex( radius/2, -radius/2, -radius/2);
      vertex(   0,    0,  radius/2);
    
      vertex( radius/2, -radius/2, -radius/2);
      vertex( radius/2,  radius/2, -radius/2);
      vertex(   0,    0,  radius/2);
    
      vertex( radius/2, radius/2, -radius/2);
      vertex(-radius/2, radius/2, -radius/2);
      vertex(   0,   0,  radius/2);
    
      vertex(-radius/2,  radius/2, -radius/2);
      vertex(-radius/2, -radius/2, -radius/2);
      vertex(   0,    0,  radius/2);
      endShape(CLOSE);
    }else if(boxMode == 3){
      sphereDetail(6);
      sphere(radius);
    }else if(boxMode == 4){ 
      point(0,0,0);
    }else if(boxMode == 5){
      noFill();
      if(!xRand){
        beginShape();
        for(int i = 0; i < nearestC; i++){
           if(this.nearest[i] != 0)  drawVertex(this.curI, this.nearest[i], layout);
        }
        vertex(0, 0, 0);
        endShape(CLOSE);
      }else{
        if((this.curI > cols) && (this.curI > 0) && (this.curI % cols > 0)){
          beginShape();
          drawVertex(this.curI, this.curI-cols-1, layout);
          drawVertex(this.curI, this.curI-cols, layout);
          vertex(0, 0, 0);
          drawVertex(this.curI, this.curI-1, layout);
          endShape(CLOSE);
        }
      }
    }else if(boxMode == 6){
      //to previous by diagonal
      if(!xRand){
        beginShape();
        for(int i = 0; i < nearestC; i++){
           if(this.nearest[i] != 0)  drawVertex(this.curI, this.nearest[i], layout);
        }
        vertex(0, 0, 0);
        endShape(CLOSE);
      }else{
        if((this.curI > cols) && (this.curI > 0) && (this.curI % cols > 0)){
          beginShape();
          drawVertex(this.curI, this.curI-cols-1, layout);
          drawVertex(this.curI, this.curI-cols, layout);
          vertex(0, 0, 0);
          drawVertex(this.curI, this.curI-1, layout);
          endShape(CLOSE);
        }
      }
    }else if(boxMode == 7){
      box(radius, radius, this.curZ1);
    }else if(boxMode == 8){
      //to previous by diagonal
      if(!xRand){
        beginShape();
        for(int i = 0; i < nearestC; i++){
           if(this.nearest[i] != 0)  drawVertex(this.curI, this.nearest[i], layout);
        }
        vertex(0, 0, 0);
        endShape(CLOSE);
      }else{
        if((this.curI > cols) && (this.curI > 0) && (this.curI % cols > 0)){
          drawLine(this.curI, this.curI - 1, layout);
        }
      }
    }else if(boxMode == 9){
      if(!xRand){
        beginShape();
        for(int i = 0; i < nearestC; i++){
           if(this.nearest[i] != 0)  drawVertex(this.curI, this.nearest[i], layout);
        }
        vertex(0, 0, 0);
        endShape(CLOSE);
      }else{
        if((this.curI > cols) && (this.curI > 0) && (this.curI % cols > 0)){
          drawLine(this.curI, this.curI - cols, layout);
        }
      }
    }

    popMatrix(); 
  }
  
  //return position in real time
  float[] getPosition(){
    float[] pos = new float[12];
    pos[0] = this.curX1;
    pos[1] = this.curY1;
    pos[2] = this.curZ1;
    pos[3] = this.curX2;
    pos[4] = this.curY2;
    pos[5] = this.curZ2;
    pos[6] = this.s1;
    pos[7] = this.s2;
    pos[8] = this.s3;
    pos[9] = this.s4;
    pos[10] = this.s5;
    pos[11] = this.s6;
    return pos;
  }
  
  float[] getCoordinate(){
    float[] pos = new float[2];
    pos[0] = this.xR;
    pos[1] = this.yR;
    return pos;
  }
  
  void selectDots(int layout){
    for(int i = 0; i < nearestC; i++){
       if(this.nearest[i] != 0)  drawLine(this.curI, this.nearest[i], layout);
    }
  }
  
}

void drawLine(int i1, int i2, int layout){
  float[] posC = dot[i1].getPosition();
  float[] posP = dot[i2].getPosition();
  if(changeAxis){
    if(layout == 1){
      line(0, 0, 0, -posC[0] + posP[0], -posC[2] + posP[2], -(-posC[1] + posP[1]));
    }else{
      line(0, 0, 0, -posC[3] + posP[3], -posC[5] + posP[5], -(-posC[4] + posP[4]));
    }
  }else{
    if(isSpheric){
      if(layout == 1){
        line(0, 0, 0, -posC[6] + posP[6], -posC[7] + posP[7], -posC[8] + posP[8]);
      }else{
        if(!isDrag){
          line(0,0,0, -posC[9] + posP[9], -posC[10] + posP[10], -posC[11] + posP[11]);
        }
      }
    }else{
      if(layout == 1){
        line(0, 0, 0, -posC[0] + posP[0], -posC[1] + posP[1], -posC[2] + posP[2]);
      }else{
        line(0, 0, 0, -posC[3] + posP[3], -posC[4] + posP[4], -posC[5] + posP[5]);
      }
    }
  }
}

void drawVertex(int i1, int i2, int layout){
  float[] posC = dot[i1].getPosition();
  float[] posP = dot[i2].getPosition();
  if(changeAxis){
    if(layout == 1){
      vertex( -posC[0] + posP[0], -posC[2] + posP[2], -(-posC[1] + posP[1]));
    }else{
      vertex( -posC[3] + posP[3], -posC[5] + posP[5], -(-posC[4] + posP[4]));
    }
  }else{
    if(isSpheric && xRand){
      if(layout == 1){
        vertex( -posC[6] + posP[6], -posC[7] + posP[7], -posC[8] + posP[8]);
      }else{
        if(!isDrag){
          vertex( -posC[9] + posP[9], -posC[10] + posP[10], -posC[11] + posP[11]);
        }
      }
    }else{
      if(layout == 1){
        vertex( -posC[0] + posP[0], -posC[1] + posP[1], -posC[2] + posP[2]);
      }else{
        vertex( -posC[3] + posP[3], -posC[4] + posP[4], -posC[5] + posP[5]);
      }
    }
  }
}

void updateAllNearest(){
  for(int i = 1; i < numberD; i++){
    dot[i].updateNearest();
  }
}