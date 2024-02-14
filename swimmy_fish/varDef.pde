int gravity = 10; //change fall speed
int xbird,ybird,hbird,wbird;

float nextY,lastY;

float xObstacle,yObstacle,yObstacle2,wObstacle,hObstacle;
float speed;
float xCoin,yCoin,rCoin;
boolean showCoin;

//SoundFile coinSound;
MediaPlayer coinSound;

int money;

boolean up = false;
int goingUp = 0;

boolean lost,paused = false;

int score;
int hiscore;
int lastscore=-1;
//String[] hscores;

int indexSelection;

int mode;

PImage fish;
PImage pause;
PImage shark,sharkBis;
PImage coin;

int selectedFish;
StringList fishes = new StringList();//{"fish","panda","sherif","gangster","samourai","red-dolphin","blue-dolphin","red-pharaon","doctor","soldier","gentleman","old-man","red-devil","blue-devil","blue-skeleton","gray-skeleton","happy-lion","sad-lion","angry-lion","lumberjack","skier"};
PImage[] fishImages; //= new PImage[fishes.length];
String[] imgNames; // for app
//PrintWriter writer;

boolean nextIsHi,nextIsLast,hiPassed = false;

boolean passed,started = false;

boolean selectionMenu = false;

//int xBtnRestart,yBtnRestart,wBtnRestart,hBtnRestart;
//float xBtnResume,yBtnResume,wBtnResume,hBtnResume;
int xBtnPause,yBtnPause,wBtnPause,hBtnPause;

Button btnRestart,btnResume,btnShowSelect,btnSelect;
ImageButton prev,next;

SharedPreferences hscore; 
SharedPreferences.Editor sceditor;

SharedPreferences fishPref;
SharedPreferences.Editor fisheditor;

SharedPreferences moneyCount;
SharedPreferences.Editor moneyeditor;

Gestures gest;