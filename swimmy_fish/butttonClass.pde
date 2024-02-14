class Button {
  float x,y;
  int w,h;
  Button(float xb,float yb,int wb,int hb) {
   x=xb;
   y=yb;
   w=wb;
   h=hb; 
  }
  
  boolean isPressed() {
    if(abs(mouseX-x)<w/2 && abs(mouseY-y)<h/2) {
      return true;
    } else return false;
  }
  
  void show() {
    rectMode(CENTER);
    rect(x,y,w,h);
  }
}

class ImageButton extends Button {
  PImage img;
  ImageButton(float xb,float yb,int wb,int hb, PImage image) {
    super(xb,yb,wb,hb);
    img = image;
  }
  
  void show() {
    imageMode(CENTER);
    image(img,x,y,w,h);
  }
}