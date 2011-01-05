void keyPressed() {
  if(key == 'z') { 
    rot = rot - .5;
  } 
  else if(key == 'x') { 
    rot = rot + .5;
  }
  else if(key == 'w') { 
    _Z = _Z + amnt;
  }
  else if(key == 'a') { 
    _X = _X +amnt;
  }
  else if(key == 's') { 
    _Z = _Z - amnt;
  }
  else if(key == 'd') { 
    _X = _X - amnt;
  }
  else if(key == 'e') { 
    _Y = _Y - amnt;
  }
  else if(key == 'q') { 
    _Y = _Y + amnt;
  }
  else if(key == '1') { 
    ZTHRESH = ZTHRESH - 1;
  }
  else if(key == '2') { 
    ZTHRESH = ZTHRESH + 1;
  }
  else if(key == '3') { 
    pointSize = pointSize - 1;
  }
  else if(key == '4') { 
    pointSize = pointSize + 1;
  }
  else if(key == 'r') { 
    setup();
  }
  else if(key == 'o') {
    if(showGrid == true) {
      showGrid = false;
    }
    else { 
      showGrid = true;
    }
  }
  else if(key == 'p') {
    if(showAxis == true) {
      showAxis = false;
    }
    else { 
      showAxis = true;
    }
  }
  else if(key == 'l') {
    render();
  }
  else if(key == 'g') {
    makeBalloon();
  }
  else if (key == 'm') {
   subtractBackground(); 
  }
  else if (key == 'n') {
   subBackground = false; 
  }
}

