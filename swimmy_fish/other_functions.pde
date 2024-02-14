int getIndex(String[] list, String element) {
  for(int i = 0; i<list.length; i++) {
    if(list[i] == element) return i;
  }
  return -1;
}

boolean collision() {
   /*if(abs(xObstacle-xbird)<(wbird/2+wObstacle/2)) {
     if(abs(yObstacle-ybird)<(hbird/2+hObstacle/2) || abs(yObstacle2-ybird)<(hbird/2+hObstacle/2)) return true;
   }
   return false;*/
  switch(mode) {
    case 0: 
      if(abs(xObstacle-xbird)<(wbird/2+wObstacle/2)) {
        if(abs(yObstacle-ybird)<(hbird/2+hObstacle/2) || abs(yObstacle2-ybird)<(hbird/2+hObstacle/2)) return true;
      }
      return false;
    //break;
    case 1:
      if(dist(xbird,ybird,xObstacle,yObstacle)<wbird/2+wObstacle/2 || dist(xbird,ybird,xObstacle,yObstacle2)<wbird/2+wObstacle/2) return true;
      return false;
    //break;
    default:
      return false;
  }
}

// android touch event. 
public boolean surfaceTouchEvent(MotionEvent event) {
 // check what that was  triggered  
  switch(event.getAction()) {
  case MotionEvent.ACTION_DOWN:    // ACTION_DOWN means we put our finger down on the screen 
    gest.setStartPos(new PVector(event.getX(), event.getY()));    // set our start position
    break;
  case MotionEvent.ACTION_UP:    // ACTION_UP means we pulled our finger away from the screen  
    gest.setEndPos(new PVector(event.getX(), event.getY()));    // set our end position of the gesture and calculate if it was a valid one
    break;
  }
  return super.surfaceTouchEvent(event);
}

void swipeLeft() {
  //println("swiped");
  if(selectionMenu) {
    indexSelection++;
      if(indexSelection> fishImages.length-1) indexSelection = 0;
    
  }
}

void swipeRight() {
  //println("swiped");
  if(selectionMenu) {
    indexSelection--;
      if(indexSelection-1 < 0) indexSelection = fishImages.length-1;
    
  }
}

void swipeUp() {
  
}

void swipeDown() {
  
}