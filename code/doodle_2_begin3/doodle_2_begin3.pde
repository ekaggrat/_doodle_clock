// PINSS

/*
X-STEP 15
 X-DIR 10
 X-ENABBLE 14
 X-STOP 18
 Y-STEP 16
 Y-DIR 17
 Y-ENABLE 14
 Y-STOP 4
 ERASE 13
 WRITE 12
 
 // motor calculations
 motor step angle: 18 degrees
 motor steps per revolution : `360/18 = 20
 motor reduction gear : 1:100
 motor steps after reduction 20*100= 2000
 motor microstepping 1/16
 motor steps after reduction : 2000*16 = 32000 steps
 motor degrees moved per step = 360/32000 = 0.01125 degrees
 motor base  gear ratio 14:23 = 1:0.608
 steps  for base motor = 32000*1.642 = 52544
 motor base degrees per step = 360/50290 = 0.006851
 
 l1 = 80.4; // the length of the shoulder
 float l2 = 88; // the length of the elbow
 
 
 */
#include <AccelStepper.h>
# define x_step 15
# define x_dir 10
# define xy_enable 14
# define y_step 16
# define y_dir 17
# define deg_per_step 0.0125

# define y_stop 4
# define x_stop 18
# define erase_p 13
# define write_p 12
# define test_led 0
boolean x_homestate = false;
boolean y_homestate = false;
boolean currentlyRunning = true;


AccelStepper stepper_x(1,x_step,x_dir);
AccelStepper stepper_y(1,y_step,y_dir);

boolean acceleration = true;
boolean usingAcceleration = true;

float currentMaxSpeed = 18000.0;
float currentAcceleration = 14000.0;

float px, py;  // location

void setup(){

  pinMode(x_step,OUTPUT);
  pinMode(x_dir,OUTPUT);
  pinMode(x_stop,INPUT);
  pinMode(xy_enable,OUTPUT);
  pinMode(y_step,OUTPUT);
  pinMode(y_dir,OUTPUT);

  pinMode(test_led,OUTPUT);

  pinMode(y_stop,INPUT);
  pinMode(erase_p,OUTPUT);
  pinMode(write_p,OUTPUT);
  Serial.begin(9600);
  stepper_x.setMaxSpeed(15000.0);
  stepper_x.setAcceleration(15000.0);
  stepper_y.setMaxSpeed(15000.0);
  stepper_y.setAcceleration(15000.0);

  pul_low();
  //stepper_x.setCurrentPosition(0);

}

void loop(){



  home_x();
  home_y();


  //line_test();

  pen_dn();
  eight(70,118);
  delay(1000);
  erase(70,118);
  pen_up();
  pos(55,118);
  pen_dn();
  five(55,118);
  delay(1000);
  erase(55,118);
  pen_up();
  pos(25,118);
  pen_dn();
  one(25,118);

  delay(1000);
  erase(25,118);
  
  pen_dn();
  one(12,118);
 pen_up();
  delay(1000);
erase(12,118);

  pen_up();
 pos(55,118);

  set_zero();
}

void  eight(float xx,float yy){

  float shift_x = xx;
  float shift_y = yy;

  int i;

  float u[17]= {
    3.2,9.98,13.32,13.32,9.98,3.32,0,0,3.32,9.98,13.32,13.32,9.98,3.32,0,0,3.32                                };
  float v[17]= {
    0,0,3.33,6.66,10,10,13.33,16.66,20,20,16.66,13.32,10,10,6.66,3.32,0                                };

  for (i = 0; i < 17; i = i + 1) {
    float x_pos = shift_x  + u[i];
    float y_pos = shift_y  + v[i];
    pos(x_pos,y_pos);
  }
}

void four(float xx,float yy){

  float shift_x = xx;
  float shift_y = yy;
  int i;
  pen_up();
  pos(shift_x+10,shift_y+0);
  pen_dn();
  float u[9]={
    10,10,10,10,5,0,5.25,10,13.32 
  };
  float v[9]={
    0,6.66,2.35,20,13.3,6.66,6.66,6.66,6.66 
  };


  for (i = 0; i < 9; i = i + 1) {
    float x_pos = shift_x  + u[i];
    float y_pos = shift_y  + v[i];
    pos(x_pos,y_pos);
  }
}

void one(float xx,float yy){

  float shift_x = xx;
  float shift_y = yy;
  int i;

  pen_up();
  pos(shift_x + 6.66,shift_y + 0);
  pen_dn();

  float u[4]={
    6.66,6.66,6.66,6.66

  };
  float v[4]={
    0,5.32,12.75,20

  };


  for (i = 0; i < 4; i = i + 1) {
    float x_pos = shift_x  + u[i];
    float y_pos = shift_y  + v[i];
    pos(x_pos,y_pos);
  }
}

void toww(float xx,float yy){

  float shift_x = xx;
  float shift_y = yy;
  int i;

  pen_up();
  pos(shift_x + 13.6,shift_y + 0);
  pen_dn();

  float u[10]={
    13,6.66,0,0,3.3,10,13.3,13.3,10,0
  };
  float v[10]={
    0,0,0,6.66,10,10,13.3,16.66,20,16.66
  };


  for (i = 0; i < 10; i = i + 1) {
    float x_pos = shift_x  + u[i];
    float y_pos = shift_y  + v[i];
    pos(x_pos,y_pos);
  }
}


void three(float xx,float yy){

  float shift_x = xx;
  float shift_y = yy;
  int i;



  float u[12]={
    3.33,10,13.3,13.3,10,6.6,10,13.3,13.3,10,3.3,0

  };
  float v[12]={
    0,0,3.3,6.66,10,10,10,13.3,16.6,20,20,6.66

  };


  for (i = 0; i < 12; i = i + 1) {
    float x_pos = shift_x  + u[i];
    float y_pos = shift_y  + v[i];
    pos(x_pos,y_pos);
  }
}

void five(float xx,float yy){

  float shift_x = xx;
  float shift_y = yy;
  int i;
  float u[10]={
    3.22,6.66,13.32,13.32,9.98,4.9,0,0,6.66,13.32
  };
  float v[10]={
    0,0,3.32,10,13.32,13.33,13.33,20,20,20
  };
  for (i = 0; i < 10; i = i + 1) {
    float x_pos = shift_x  + u[i];
    float y_pos = shift_y  + v[i];
    pos(x_pos,y_pos);
  }
}


void nine(float xx,float yy){

  float shift_x = xx;
  float shift_y = yy;
  int i;
  float u[13]={
    3.32,6.6,9.98,13.3,13.3,13.3,9.9,3.32,0,0,3.33,8.3,13.3
  };
  float v[13]={
    0,0,3.3,6.66,10,16.6,20,20,16.6,13.33,10,10,10
  };
  for (i = 0; i < 13; i = i + 1) {
    float x_pos = shift_x  + u[i];
    float y_pos = shift_y  + v[i];
    pos(x_pos,y_pos);
  }
}

void zero(float xx,float yy){

  float shift_x = xx;
  float shift_y = yy;
  int i;
  float u[11]={
    5,8.3,11.3,11.6,11.66,8.3,5,1.6,1.6,1.6,5

  };
  float v[11]={
    0,0,6.6,10,16.66,20,20,16.66,10,3.3,0

  };
  for (i = 0; i < 11; i = i + 1) {
    float x_pos = shift_x  + u[i];
    float y_pos = shift_y  + v[i];
    pos(x_pos,y_pos);
  }
}

void seven(float xx,float yy){

  float shift_x = xx;
  float shift_y = yy;
  int i;
  float u[6]={
    3.33,6.5,9.7,13.32,7.1,0
  };
  float v[6]={
    0,6.38,12.7,20,20,20
  };
  for (i = 0; i < 6; i = i + 1) {
    float x_pos = shift_x  + u[i];
    float y_pos = shift_y  + v[i];
    pos(x_pos,y_pos);
  }
}

void six(float xx,float yy){

  float shift_x = xx;
  float shift_y = yy;
  int i;
  
  float u[16]={
    3.3,9.98,13.3,13.3,9.98,4.9,0,0,3.3,6.6,9.98,6.6,3.33,0,0,0

  };
  float v[16]={
    0,0,3.3,6.66,10,10,10,13.3,16.6,20,20,20,16.67,13.33,10,3.33

  };
  for (i = 0; i < 16; i = i + 1) {
    float x_pos = shift_x  + u[i];
    float y_pos = shift_y  + v[i];
    pos(x_pos,y_pos);
  }
}









void erase(float xx,float yy){

  float shift_x = xx;
  float shift_y = yy;
  int i;
  pen_up();



  float u[13]={
    0,13.33,0,13.3,0,13,0,13,0,13,13,0,0

  };
  float v[13]={
    0,0,5,5,10,10,15,15,20,20,0,0,20

  };


  for (i = 0; i < 13; i = i + 1) {

    float x_pos = shift_x  + u[i];
    float y_pos = shift_y  + v[i];
    pos(x_pos,y_pos);
    erase_dn();
  }
  erase_up();
}







void line_test(){


  pen_dn();
  putline(70,113,70,143);
  pen_up();
  pos(70,122);
  delay(1000);
  pen_dn();
  putline(70,122,10,122);
  delay(1000);
  putline(10,123,10,143);
  delay(1000);
  putline(10,143,70,143);



  delay(1000);
  pen_up();
  pul_low();

}





void pen_dn(){

  digitalWrite(write_p,HIGH);
}
void pen_up(){
  digitalWrite(write_p,LOW);
}
void erase_dn(){
  digitalWrite(erase_p,HIGH);
}
void  erase_up(){
  digitalWrite(erase_p,LOW);
}
void set_zero(){
  x_homestate = false;
  y_homestate = false;

}





void mov_test(long xx,long yy){

  float current_x = stepper_x.currentPosition();
  float current_y = stepper_y.currentPosition();
  int bac_x = 50;
  int bac_y = 100;

  if ( xx > current_x){
    xx = xx;
  }
  if ( xx < current_x){
    xx = xx + bac_x;
  }

  if ( yy > current_y){
    yy = yy ;
  }
  if ( yy < current_y){
    yy = yy + bac_y;
  }



  stepper_x.moveTo(xx);
  stepper_y.moveTo(yy);
  while (stepper_x.distanceToGo() != 0 || stepper_y.distanceToGo() != 0){
    stepper_x.run();
    stepper_y.run();
  }



}








void home_x(){
  digitalWrite(xy_enable,LOW);
  int x_home = digitalRead(x_stop);

  while(x_home == 0){
    int x_home = digitalRead(x_stop);

    if (x_homestate == true){
      pul_low();
      break;
    }
    if (x_home == 1){
      digitalWrite(test_led,HIGH);
      x_homestate = true;
      break;
    }
    digitalWrite(test_led,LOW);
    stepper_x.move(-100);
    stepper_x.run();
  }
  stepper_x.setCurrentPosition(0);
  Serial.println(stepper_x.currentPosition());
}

void home_y(){
  digitalWrite(xy_enable,LOW);

  int y_home = digitalRead(y_stop);
  while(y_home == 0){
    int y_home = digitalRead(y_stop);

    if (y_homestate == true){
      pul_low();
      break;
    }
    if (y_home == 1){
      digitalWrite(test_led,HIGH);
      y_homestate = true;
      break;
    }
    digitalWrite(test_led,LOW);
    stepper_y.move(-100);
    stepper_y.run();
  }
  stepper_y.setCurrentPosition(0);
  Serial.println(stepper_y.currentPosition());
}







void pul_low(){

  digitalWrite(x_step,LOW);
  digitalWrite(x_dir,LOW);
  digitalWrite(xy_enable,HIGH);
  digitalWrite(y_step,LOW);
  digitalWrite(y_dir,LOW);

  digitalWrite(erase_p,LOW);
  digitalWrite(write_p,LOW);
}



void pos ( float x,float y) // function to convert a x,y co-ordinate into corresponding servo angles .... used in putline function to plot a line

{
  float l1 = 80.4; // the length of the shoulder
  float l2 = 88; // the length of the elbow
  //float c2 = sq(x);
  //float c2 = (sq(x) + sq(y) - sq(l1) - sq (l2));
  double cb2 = 2*l1*l2;

  double c2 = (sq(x) + sq(y) - sq(l1) - sq (l2)) / cb2;
  double s2 = sqrt(1-sq(c2));
  double k1 = (l1 + l2 * c2);
  double k2 = (l2 * s2);

  double shoulder_ang = rtod((atan2(y,x) - atan2(k2,k1)));
  double elbow_ang = rtod(atan2(s2,c2));

  double  y_pos = int(shoulder_ang/0.006851) ;
  double  x_pos = int(elbow_ang/0.01125) ;
  mov_test(x_pos,y_pos);
  Serial.println(x_pos);
  Serial.println(y_pos);
}

float pos_rad_x ( float x,float y) // function to convert a x,y co-ordinate into corresponding servo angles .... used in putline function to plot a line

{
  float l1 = 80.4; // the length of the shoulder
  float l2 = 88; // the length of the elbow
  //float c2 = sq(x);
  //float c2 = (sq(x) + sq(y) - sq(l1) - sq (l2));
  double cb2 = 2*l1*l2;

  double c2 = (sq(x) + sq(y) - sq(l1) - sq (l2)) / cb2;
  double s2 = sqrt(1-sq(c2));
  double k1 = (l1 + l2 * c2);
  double k2 = (l2 * s2);

  double shoulder_ang = rtod((atan2(y,x) - atan2(k2,k1)));
  double elbow_ang = rtod(atan2(s2,c2));

  double  y_pos = int(shoulder_ang/0.01125) ;
  double  x_pos = int(elbow_ang/0.01125) ;

  return x_pos;

}
float pos_rad_y ( float x,float y) // function to convert a x,y co-ordinate into corresponding servo angles .... used in putline function to plot a line

{
  float l1 = 80.4; // the length of the shoulder
  float l2 = 88; // the length of the elbow
  //float c2 = sq(x);
  //float c2 = (sq(x) + sq(y) - sq(l1) - sq (l2));
  double cb2 = 2*l1*l2;

  double c2 = (sq(x) + sq(y) - sq(l1) - sq (l2)) / cb2;
  double s2 = sqrt(1-sq(c2));
  double k1 = (l1 + l2 * c2);
  double k2 = (l2 * s2);

  double shoulder_ang = rtod((atan2(y,x) - atan2(k2,k1)));
  double elbow_ang = rtod(atan2(s2,c2));

  double  y_pos = int(shoulder_ang/0.006851) ;
  double  x_pos = int(elbow_ang/0.01125) ;

  return y_pos;

}









double rtod(double fradians)
{
  return(fradians * 180.0 / PI);
}


void line(float newx,float newy) {
  long dx=newx-px;
  long dy=newy-py;
  int dirx=dx>0?1:-1;
  int diry=dy>0?-1:1;  // because the motors are mounted in opposite directions
  dx=abs(dx);
  dy=abs(dy);

  long i;
  long over=0;

  if(dx>dy) {
    for(i=0;i<dx;++i) {
      stepper_x.move(dirx);
      Serial.println(dirx);
      stepper_x.run();
      over+=dy;
      if(over>=dx) {
        over-=dx;
        stepper_y.move(diry);
        stepper_y.run();
      }

    }
  } 
  else {
    for(i=0;i<dy;++i) {
      stepper_y.move(diry);
      stepper_y.run();
      over+=dx;
      if(over>=dy) {
        over-=dy;
        stepper_x.move(dirx);
        stepper_x.run();
      }

    }
  }

  px=newx;
  py=newy;
}



















void putline (float xi,float yi,float xd, float yd) // funtion to plot line between two given points
{
  float distt = sqrt(sq(xd - xi) + sq(yd - yi));
  int numpart = distt / 0.5;
  float ddx = (xd - xi) / numpart;
  float l_slope = (yd - yi)/(xd - xi);




  if (yi == yd){ // horizontal line
    // Serial.println("horizontal line");
    if (xi < xd){


      for(float xaxis = xi; xaxis < xd; xaxis += 0.5)
      {
        pos(xaxis,yi);


      }
    }
    else if (xi > xd){
      for(float xaxis = xi; xaxis > xd; xaxis -= 0.5)
      {
        //for(float yaxis = yi; yaxis < yd; yaxis += 0.5)
        // {

        pos(xaxis,yi);


        //Serial.print(xaxis,DEC);
        //Serial.println(yi,DEC);
      }
    }
  }
  else if (xi == xd){ // vertical line
    //Serial.println("vertical line");
    if (yi < yd) {


      for(float yaxis = yi; yaxis < yd; yaxis += 0.5)
      {
        pos(xi,yaxis);

      }
    }
    else if ( yi > yd ){
      for(float yaxis = yi; yaxis > yd; yaxis -= 0.5)
      {
        pos(xi,yaxis);

      }
      //Serial.print(xi,DEC);
    } //Serial.println(yaxis,DEC);

  }
  else // diagonal line

    //Serial.println("diagonalline");

  for (float point = 1; point < numpart; point += 0.5)
  {
    float xpoint = xi + (ddx * point );
    float ypoint = l_slope * (xpoint - xi) + yi;
    pos(xpoint , ypoint);


    //Serial.print(xpoint,DEC);
    //Serial.println(ypoint,DEC);

  }
}


















