/**
  @author: KduckGames
  
  TODO:
  *sound on app version
  *money system -> save in txt file
  *create settings menu
  *character unlocking -> money
  *animation lost
  "*accesories
*/


import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;
import android.media.MediaPlayer;
import android.view.MotionEvent;
import android.content.res.AssetManager;
import android.content.res.AssetFileDescriptor;
//AssetManager am = this.getActivity().getAssets();

void setup() {
  //size(displayWidth,displayHeight,P2D);
  //println('k');
  
  gest =new Gestures(100,150,this);    // iniate the gesture object first value is minimum swipe length in pixel and second is the diagonal offset allowed
  gest.setSwipeUp("swipeUp");    // attach the function called swipeUp to the gesture of swiping upwards
  gest.setSwipeDown("swipeDown");    // attach the function called swipeDown to the gesture of swiping downwards
  gest.setSwipeLeft("swipeLeft");  // attach the function called swipeLeft to the gesture of swiping left
  gest.setSwipeRight("swipeRight");  // attach the function called swipeRight to the gesture of swiping right

  frameRate(60.0);
  //println(frameRate);
  hscore = this.getActivity().getSharedPreferences("hiscore",0);
  sceditor = hscore.edit();
  
  fishPref = this.getActivity().getSharedPreferences("fish",0);
  fisheditor = fishPref.edit();
  
  moneyCount = this.getActivity().getSharedPreferences("money",0);
  moneyeditor = moneyCount.edit();
  
  money = moneyCount.getInt("money",-4);
  selectedFish = fishPref.getInt("fish",selectedFish);
  //println(settings.getInt("fish",-4));
  
  try {
    coinSound = new MediaPlayer();
    //----------APP---------
    //(non testé)
    AssetFileDescriptor afd = this.getActivity().getApplicationContext().getAssets().openFd("coin.wav");
    coinSound.setDataSource(afd);
    //--------PREVIEW-------
    //coinSound.setDataSource(dataPath("coin.wav"));
    //coinSound.prepare();
    println("Successfully loaded audio file");
  } 
  catch(IOException e) {
    e.printStackTrace();
    println("file did not load");
  }
  
  /*editor.clear();
  editor.putInt("score",2);
  editor.commit();*/
  
  ybird = height/2;
  hbird = width/8;
  wbird = width/8;
  xbird = width/4;
  
  lastY=ybird-10;
  
  wObstacle=width/5;
  xObstacle=width+wObstacle/2;
  yObstacle=0;
  hObstacle=height;
  
  xCoin = xObstacle;
  rCoin = width/8;
  yCoin = 0;
  
  btnRestart = new Button(width/2,height/3*2,width/2,height/14);
  btnResume = new Button(width/2,height/3*2-btnRestart.h*1.2,width/2,height/14);
  btnShowSelect = new Button(width/2,height-height/16-40,width-width/10,height/8);
  btnSelect = new Button(width/2,height/4*3,width/2,height/14);
  
  wBtnPause=width/6-10;
  hBtnPause=wBtnPause;
  xBtnPause=width-wBtnPause/2-10;
  yBtnPause=height/14-hBtnPause/2+10;
  
  //-------IMAGES INIT(APP)---------
  /*
  fishImages = loadImages("fishes");
  println(fishImages);
  */
  // -----IMAGES INIT(PREVIEW)--------
  
  String[] filenames = listPaths(dataPath("fishes"));
  //String[] filenames = {"doctor.png","panda.png"};
  
  for (int i = 0; i < filenames.length; i++) {
    if(filenames[i].toLowerCase().endsWith(".png")) {
      fishes.append(filenames[i]);
    }
    //println(filenames[i]);
  }
  //println(fishes);
  //println(fishes.size());
  fishImages = new PImage[fishes.size()];
  for(int i = 0; i<fishes.size(); i++) {
    //print(loadImage(dataPath("fishes/fish.png")));
    //println(new File(fishes[i]+".png").exists());
    //if(new File(fishes[i]+".png").exists()) 
    fishImages[i] = loadImage(fishes.get(i));
  }
  
  //---END INIT----
  
  shark = loadImage("shark.png");
  sharkBis = loadImage("shark-bis.png");
  pause = loadImage("pause.png");
  coin = loadImage("coin.png");
  prev = new ImageButton(width/8,height/4*3,width/5,width/4,loadImage("prev.png"));
  next = new ImageButton(width/8*7,height/4*3,width/5,width/4,loadImage("next.png"));
  
  reset();
  fish = fishImages[selectedFish];
  imageMode(CENTER);
  //image(fish,xbird,ybird,hbird,wbird);
  //println(money);
}

void reset() {
  up=false;
  xObstacle=width+wObstacle/2;
  speed=5;
  ybird = height/2;
  lastY=ybird-10;
  lost=false;
  score = 0;
  paused = false;
  started=false;
  hiPassed=false;
  hiscore=hscore.getInt("hiscore",hiscore);
  //println(fishPref.getInt("money",-4));
  
}


void draw() {
  //if(coinSound==null) coinSound = new SoundFile(this, "coinSound.wav");
  strokeWeight(0);
  /*if(getIndex(fishes,selectedFish) != -1) fish = fishImages[getIndex(fishes,selectedFish)];
  else fish = fishImages[0];*/
  
  if(lost) {
    //coinSound.play();
    if(score>hiscore) {
      hiscore=score;
      sceditor.clear();
      sceditor.putInt("hiscore",hiscore);
      sceditor.commit();
      moneyeditor.clear();
      moneyeditor.putInt("money",money);
      moneyeditor.commit();
      //println(hiscore);
    }
    lastscore=score-1;
    drawEndScreen();
  } else if(paused) {
    image(fish,xbird,ybird,hbird,wbird);
    drawPauseMenu();
  } else if(selectionMenu) {
    drawSelectionMenu();
  } else {
   background(0,100,200);
   rectMode(CORNER);
   //fill(68,163,44);
   //rect(0,height/5*4,width,height/5*4); //grass
   rectMode(CENTER);
   imageMode(CENTER);
   //fill(71,17,105);
   //fill(0,50,200);
   //rect(xbird,ybird,hbird,wbird);
   //image(fish,xbird,ybird,hbird,wbird);
   
   if(started) drawObstacles();
   else {
     image(fish,xbird,ybird,hbird,wbird);
     textAlign(CENTER);
     fill(0);
     textSize(height/14);
     text("TAP TO START",width/2,height/4*3,width);
     fill(240,220,25);
     btnShowSelect.show();
     fill(0);
     textSize(height/20);
     text("CHANGE CHARACTER",btnShowSelect.x,btnShowSelect.y+height/80,btnShowSelect.w,btnShowSelect.h);
   }
   
   //pause btn
   imageMode(CENTER);
   image(pause,xBtnPause,yBtnPause,wBtnPause,hBtnPause);
   
   //score
   fill(0);
   textSize(height/14);
   textAlign(LEFT);
   text(score,width/6,height/14);
   textAlign(RIGHT);
   text("HI: "+hiscore,width-(width/6)-10,height/14);
   
   //text(money,width/2,height/2);
   
   if(up) {
    /*ybird-=wbird/12;
    goingUp++;
    if(goingUp>10) {
      goingUp = 0;
      up = false;
    }*/
    up();
   } else if(started) {

    //ybird+=gravity;
    fall();
   }
   // fish out of bounds
   if(ybird + hbird/2 > height || ybird-hbird/2 <0) {
    lost = true;
   }
  
   if(collision()) {// obstacle touched
     lost = true;
   } else {
     if(abs(xbird-xObstacle)<(wObstacle/2)) {// passed obstacle
       if(!passed) {
         score++;
         passed = true;
       }
     } else {
       passed=false;
     }
   }
   // collision with coin
   if(dist(xbird,ybird,xCoin,yCoin)<wbird/2+rCoin/2 && showCoin) {
     coinSound.start();
     showCoin = false;
     money++;
   }
  
  }
  
 
}



void drawObstacles() {
  if((xObstacle+wObstacle/2)<0) {
    xObstacle=width+wObstacle/2;
    speed+=0.1;
  } //arrivé au bord
  
  if(xObstacle==width+wObstacle/2) {
    showCoin = true;
    mode = int(random(2));
    if(score>20) {
      hiPassed=true;
    }
    //println(mode);
    if(mode == 0) { //tubes
      yObstacle=random(-height/3,height/4);
      hObstacle=height;
      yObstacle2 = yObstacle+hbird*4+hObstacle;
      
      yCoin = (yObstacle2+yObstacle)/2;
      
      if(score==hiscore) {
        nextIsHi=true;
      } else {
        nextIsHi=false;
      }
      if(score==lastscore) {
        nextIsLast=true;
      } else {
        nextIsLast=false;
      } 
      
    } else if(mode == 1) {
      hObstacle = wObstacle;
      yObstacle=int(random(hObstacle,height-hObstacle));
      yObstacle2=int(random(hObstacle,height-hObstacle));
      while(abs(yObstacle-yObstacle2)<hObstacle) {
        yObstacle2=int(random(hObstacle,height-hObstacle));
      }
      
      float min = min(yObstacle,yObstacle2);
      float max = max(yObstacle,yObstacle2);
      
      if(abs(yObstacle-yObstacle2)>wbird*3+hObstacle) yCoin = int(random(min+hObstacle/2+rCoin/2,max-hObstacle/2-rCoin/2));//(yObstacle+yObstacle2)/2;
      else {
        if(height-max(yObstacle,yObstacle2)>min) {
          yCoin = int(random(max+hObstacle+rCoin,height-rCoin));
        } else {
          yCoin = int(random(rCoin,min-hObstacle-rCoin));
        }
      }
    }
  }//init obstacle

  fill(163, 44, 84);
  if(nextIsLast) fill(0,200,10);
  if(nextIsHi) fill(0,0,255);
  
  if(mode == 0) {
    rect(xObstacle,yObstacle,wObstacle,hObstacle);
    rect(xObstacle,yObstacle2,wObstacle,hObstacle);
  } else if(mode == 1) {
    if(hiPassed){
      image(sharkBis,xObstacle,yObstacle,wObstacle*1.2,hObstacle);
      image(sharkBis,xObstacle,yObstacle2,wObstacle*1.2,hObstacle);
    } else {
      image(shark,xObstacle,yObstacle,wObstacle*1.2,hObstacle);
      image(shark,xObstacle,yObstacle2,wObstacle*1.2,hObstacle);
    }
  }
  
  if(showCoin) {
    image(coin,xCoin,yCoin,rCoin,rCoin);
  }
  
  xObstacle-=speed;
  xCoin = xObstacle;
}

void drawEndScreen() {
  textAlign(CENTER);
  fill(0);
  textSize(height/14);
  text("PERDU", width/2,height/4);  
  fill(160,40,80);
  btnRestart.show();
  //rect(xBtnRestart,yBtnRestart,wBtnRestart,hBtnRestart);
  fill(255);
  textSize(height/20);
  text("RESTART",btnRestart.x,btnRestart.y+btnRestart.h/4,btnRestart.w,btnRestart.h);
}

void drawPauseMenu() {
  textAlign(CENTER);
  fill(0);
  textSize(height/14);
  text("PAUSED", width/2,height/4); 
   
  fill(160,40,80);
  btnRestart.show();
  fill(255);
  textSize(height/20);
  text("RESTART",btnRestart.x,btnRestart.y+btnRestart.h/4,btnRestart.w,btnRestart.h);
  //text("RESTART",xBtnRestart,yBtnRestart+hBtnRestart/4,wBtnRestart,hBtnRestart);
  
  fill(0,255,0);
  btnResume.show();
  //rect(xBtnResume,yBtnResume,wBtnResume,hBtnResume);
  fill(255);
  textSize(height/20);
  text("RESUME",btnResume.x,btnResume.y+btnResume.h/4,btnResume.w,btnResume.h);
  
}

void drawSelectionMenu() {
  imageMode(CENTER);
  rectMode(CENTER);
  background(0,100,200);
  //int index = 1;
  
  prev.show();
  textAlign(CENTER);
  fill(0,255,0);
  btnSelect.show();
  textSize(height/16);
  fill(0);
  text("SELECT",btnSelect.x,btnSelect.y+height/16/4,btnSelect.w,btnSelect.h);
  next.show();
  
  noFill();
  strokeWeight(5);
  int ts = height/20;
  textSize(ts);
  //-----NAME(PREVIEW)-----
  
  String[] splited = fishes.get(indexSelection).split("/");
  //println("blbl.png".split(".png"));
  String[] fullName = splited[splited.length-1].split(".png");
  //println(splited[splited.length-1]);
  //println(fullName);
  
  
  //------NAME(APP)-----
  //String[] fullName = imgNames[indexSelection].split(".png");
  
  //-------END NAME------
  String name = fullName[0].replace("-"," ");
  
  rect(width/2,height/2, width/4+width/30,width/4+width/30);
  image(fishImages[indexSelection],width/2,height/2,width/4,width/4);
  text(name,width/2,height/2-2*ts);
  
  int preIndex = indexSelection-1;
  if(preIndex<0) {
    preIndex = fishImages.length-1;
  }
  strokeWeight(2);
  rect(width/5,height/2, width/8+width/30,width/8+width/30);
  image(fishImages[preIndex],width/5,height/2,width/8,width/8);
  
  int nextIndex = indexSelection+1;
  if(nextIndex>fishImages.length-1) {
    nextIndex = 0;
  }
  rect(width/5*4,height/2, width/8+width/30,width/8+width/30);
  image(fishImages[nextIndex],width/5*4,height/2,width/8,width/8);
} 

void onPause() {
  super.onPause();
  if(!selectionMenu && started) paused = true;
  fisheditor.clear();
  fisheditor.putInt("fish",selectedFish);
  fisheditor.commit();
  sceditor.putInt("hiscore",hiscore);
  sceditor.commit();
  moneyeditor.putInt("money",money);
  moneyeditor.commit();
}

void onStopped() {
  //editor.clear();
  fisheditor.putInt("fish",selectedFish);
  fisheditor.commit();
  sceditor.putInt("hiscore",hiscore);
  sceditor.commit();
  moneyeditor.putInt("money",money);
  moneyeditor.commit();
}

void onBackPressed() {
  if(lost || paused) {
    System.exit(0);
  }
  if(!selectionMenu) paused = true;
  else selectionMenu = false; started=false;
}