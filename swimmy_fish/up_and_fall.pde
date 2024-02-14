void fall() {
  float speed = (ybird-lastY)/10;
  if(speed>15) speed = 15;
  ybird+=speed;
  //println(speed);
  int rot = int(speed);
  pushMatrix();
  translate(xbird,ybird);
  rotate(radians(rot));
  image(fish,0,0,hbird,wbird);
  popMatrix();
}

void up() {
  float speed = (ybird-nextY)/20;
  
  ybird-=speed;
  if(ybird<=nextY||speed<5) {
      up = false; 
      lastY = ybird-wbird/3;
    }
  int rot = int(speed);
  pushMatrix();
  translate(xbird,ybird);
  rotate(radians(-rot*2));
  image(fish,0,0,hbird,wbird);
  popMatrix();
  //image(fish,xbird,ybird,hbird,wbird);
}