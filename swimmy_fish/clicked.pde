void mouseReleased() {
  //if(abs(mouseX-xBtnPause)<wBtnPause && abs(mouseY-yBtnPause)<hBtnPause) {
  if (dist(mouseX,mouseY,xBtnPause,yBtnPause)<wBtnPause/2) {
    paused = true;
  } else if(paused && btnResume.isPressed()) {
    paused=false;
  } else if(lost || paused) {
    if(btnRestart.isPressed()) {
      reset();
    }
  } else if(!started) {
    if(btnShowSelect.isPressed()) {
      indexSelection = selectedFish;
      if(indexSelection == -1) indexSelection = 0;
      selectionMenu = true;
    } else started = true;
  } else if(selectionMenu) {
    if(prev.isPressed()){
      indexSelection--;
      if(indexSelection-1 < 0) indexSelection = fishImages.length-1;
    } else if(next.isPressed()){
      indexSelection++;
      if(indexSelection> fishImages.length-1) indexSelection = 0;
    } else if(btnSelect.isPressed()) {
      selectedFish = indexSelection;
      fisheditor.clear();
      fisheditor.putInt("fish",selectedFish);
      fisheditor.commit();
      //println(settings.getInt("fish",-4));
      selectionMenu=false;
      started=false;
      fish = fishImages[selectedFish];
    }
  } else {
    nextY = ybird-200;
  up=true;
  //goingUp=0;
  }
}