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

#include <math.h>
#include <Time.h> 

# define x_step 15
# define x_dir 13
# define xy_enable 14
# define y_step 16
# define y_dir 17
# define deg_per_step 0.0125

# define y_stop 23// 18
# define x_stop 12
# define erase_pa 25
# define erase_pb 26
# define write_pa 27
# define write_pb 28
# define pen_enable 21

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

// digit locations

int x_off = 9;
int y_off = -1;


int h1_x = 12  + x_off;
int h1_y = 118 + y_off;
int h2_x = 25 + x_off;
int h2_y = 118 + y_off;
int m1_x = 53 + x_off;
int m1_y = 118 + y_off;
int m2_x = 70 + x_off;
int m2_y = 118 + y_off;

// time code


int disp_m1 = minute()/10;
int disp_m2 = minute()%10;
int hh = hour();
int disp_h = hh;

int disp_h1 = disp_h / 10;
int disp_h2 = disp_h % 10;

int disp_h12 =abs( hh - 12);
int disp_h1_12 = disp_h12 / 10;
int disp_h2_12 = disp_h12 % 10;

int angle_offset = 90;//36.5;

void setup(){

  pinMode(x_step,OUTPUT);
  pinMode(x_dir,OUTPUT);
  pinMode(x_stop,INPUT);
  pinMode(xy_enable,OUTPUT);
  pinMode(y_step,OUTPUT);
  pinMode(y_dir,OUTPUT);

  pinMode(test_led,OUTPUT);

  pinMode(y_stop,INPUT);
  pinMode(erase_pa,OUTPUT);
  pinMode(write_pa,OUTPUT);
  pinMode(erase_pb,OUTPUT);
  pinMode(write_pb,OUTPUT);
  pinMode(pen_enable,OUTPUT);

  Serial.begin(9600);
  stepper_x.setMaxSpeed(15000.0);
  stepper_x.setAcceleration(15000.0);
  stepper_y.setMaxSpeed(15000.0);
  stepper_y.setAcceleration(15000.0);

  pul_low();
  //stepper_x.setCurrentPosition(0);

  // time  code

  int disp_m1 = minute()/10;
  int disp_m2 = minute()%10;
  int hh = hour();
  setTime(12,25,00,12,02,2012);

  home_y();
  //home_xfind ();
  // mov_x(1000);
  home_x ();

  pos(90,100);
  starttime();
}
void starttime() // function to plot time the first time .. still needs improvement
{
  //erase_all();
  erase(40 + x_off,118 + y_off);
  colon(40 + x_off,118 + y_off);

  int hh = hour();
  if (hh > 12){
    hh = hh-12;
  }

  int hh1 = hh/10;

  if (hh1 > 0 ){
    update_h1();
    update_h2();
    update_m1();
    update_m2();

  }
  else 
    update_h2();
  update_m1();
  update_m2();




}



void loop(){
  //erase_dn();
  //delay(500);

  //erase_up();
  //delay(10);
  //erase_dn();

  //erase(40,118);
  //colon(40,118);
  //idle();
  // stepper_x.moveTo(100);
  // stepper_x.moveTo(-100);
  //

  //pos(100,130);
  //erase_up();// 
  //digitalWrite(pen_enable,LOW);
  // pen_dn();
  // pos(20,130);
  //erase_up();
  //pen_up();
  //pos(90,30);


  //set_zero();
  //home_y();
  //home_x();


  printtime();
  idle();

  //int test =digitalRead(x_stop);
  //int test2 =digitalRead(y_stop);
  //Serial.print(test);
  //Serial.println(test2);

}



void  motor_enable(){
  digitalWrite(xy_enable,LOW);
}

void idle(){
  pen_up();
  pos(90,90);
  pul_low();
}

// time code
void printtime() // main function handling the ploting of the time digits
{
  int hh = hour();

  int h1 = hh / 10;
  int h2 = hh % 10;




  if ( hh > 12) {
    hh = hh - 12;
    int h1_12 = hh / 10;
    int h2_12 = hh % 10;

    int chk_hour1_12 = abs(disp_h1_12 - h1_12);
    int chk_hour2_12 = abs(disp_h2_12 - h2_12);





    if ( chk_hour1_12 > 0) {

      update_h1();
      disp_h1_12 = h1_12;
    }


    if ( chk_hour2_12 > 0) {

      update_h2();
      disp_h2_12 = h2_12;
    }
  }

  if ( hh <= 12) {



    int chk_hour1 = abs(disp_h1 - h1);
    int chk_hour2 = abs(disp_h2 - h2);





    if ( chk_hour1 > 0) {

      update_h1();
      disp_h1 = h1;
    }


    if ( chk_hour2 > 0) {

      update_h2();
      disp_h2 = h2;
    }
  }

  int m = minute();
  int m1 = m/ 10;
  int m2 = m% 10;
  int chk_min1 = abs(disp_m1 - m1);
  int chk_min2 = abs(disp_m2 - m2);



  if ( chk_min1 > 0) {
    update_m1();
    disp_m1 = m1;
  }
  if ( chk_min2 > 0) {
    update_m2();
    disp_m2 = m2;
  }
}  

void update_h1() // update hour1 digit
{
  motor_enable();
  erase(h1_x, h1_y);

  hour1();
}

void update_h2()// update hour2 digit
{
  motor_enable();
  erase(h2_x, h2_y);
  hour2();
}

void update_m1()// update minute1 digit
{
  motor_enable();
  erase(m1_x, m1_y);
  min1();
}

void update_m2()// update minute2 digit
{
  motor_enable();
  erase(m2_x, m2_y);
  min2();


}


void hour1()//calcuate hour 1
{
  int h = hour();
  if (h > 12) { 
    h = h - 12;
  }
  int h1 = h/ 10;
  Serial.println("h1");
  Serial.println(h1);

  digit(h1, h1_x, h1_y);
  pen_up();
  delay(20);
}
\

void blank()
{
}
void hour2()//calcuate hour 2
{
  int h = hour();
  if (h > 12) { 
    h = h - 12;
  }
  int h2 = h % 10;
  Serial.println("h2");
  Serial.println(h2);

  digit(h2, h2_x, h2_y);
  pen_up();
  delay(200);
}

void min1()//calcuate minute 1
{
  int m = minute();
  int m1 = m/ 10;
  Serial.println("m1");
  Serial.println(m1);
  digit(m1, m1_x, m1_y);
  pen_up();
  delay(200);
}

void min2()//calcuate minute 2
{
  int m = minute();
  int m2 = m % 10;
  Serial.println("m1");
  Serial.println(m2);
  digit(m2, m2_x, m2_y);
  pen_up();
  delay(200);
}

void digit(int time, float xp, float yp)// function to figure out which digit to plot
{
  if (time == 1) {

    onee(xp, yp);
  }
  else if (time ==2) {

    toww(xp, yp);
  }
  else if (time == 3) {

    three(xp, yp);
  }
  else  if (time == 4) {

    four(xp, yp);
  }
  else if (time == 5) {

    five(xp, yp);
  }
  else if (time == 6) {

    six(xp, yp);
  }
  else if (time == 7) {

    seven(xp, yp);
  } 
  else if (time == 8) {

    eight(xp, yp);
  }
  else if (time == 9) {

    nine(xp, yp);
  }
  else if (time == 0) {

    zerro(xp, yp);
  }
}







// digits  


void  colon(float xx,float yy){

  float shift_x = xx;
  float shift_y = yy;



  pos(shift_x + 6.66,shift_y + 5.73);
  pen_dn();
  delay(1000);
  pen_up();
  pos(shift_x + 6.66,shift_y + 14.33);
  pen_dn();
  delay(1000);
  pen_up();

}


void  eight(float xx,float yy){

  float shift_x = xx;
  float shift_y = yy;

  int i;
  pen_dn();
  float u[17]= {
    3.2,9.98,13.32,13.32,9.98,3.32,0,0,3.32,9.98,13.32,13.32,9.98,3.32,0,0,3.32                                                  };
  float v[17]= {
    0,0,3.33,6.66,10,10,13.33,16.66,20,20,16.66,13.32,10,10,6.66,3.32,0                                                  };

  for (i = 0; i < 17; i = i + 1) {
    float x_pos = shift_x  + u[i];
    float y_pos = shift_y  + v[i];
    pos(x_pos,y_pos);
  }
  pen_up();

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
  pen_up();
}

void onee(float xx,float yy){

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
  pen_up();
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
  pen_up();
}


void three(float xx,float yy){

  float shift_x = xx;
  float shift_y = yy;
  int i;

  pen_dn();

  float u[11]={
    3.33,10,13.3,13.3,10,6.6,10,13.3,13.3,10,3.3

  };
  float v[11]={
    0,0,3.3,6.66,10,10,10,13.3,16.6,20,20

  };


  for (i = 0; i < 11; i = i + 1) {
    float x_pos = shift_x  + u[i];
    float y_pos = shift_y  + v[i];
    pos(x_pos,y_pos);
  }
  pen_up();
}

void five(float xx,float yy){

  float shift_x = xx;
  float shift_y = yy;
  int i;
  pen_dn();
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
  pen_dn();
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
  pen_up();
}

void zerro(float xx,float yy){

  float shift_x = xx;
  float shift_y = yy;
  int i;
  pen_dn();
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
  pen_up();
}

void seven(float xx,float yy){

  float shift_x = xx;
  float shift_y = yy;
  int i;
  pen_dn();
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
  pen_dn();
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
  pen_up();
}









void erase(float xx,float yy){

  float shift_x = xx;
  float shift_y = yy;
  int i;
  pen_up();



  float u[14]={
    0,13.33,0,13.3,0,13,0,13,0,13,13,0,0,0

  };
  float v[14]={
    0,0,5,5,10,10,15,15,20,20,0,0,20,0

  };


  for (i = 0; i < 14; i = i + 1) {

    float x_pos = shift_x  + u[i];
    float y_pos = shift_y  + v[i];
    pos(x_pos,y_pos);
    erase_dn();
  }
  erase_up();
}













void pen_dn(){
  // digitalWrite(pen_enable,HIGH);
  digitalWrite(write_pa,HIGH);
  digitalWrite(write_pb,LOW);

}
void pen_up(){
  //digitalWrite(pen_enable,HIGH);
  digitalWrite(write_pa,LOW);
  digitalWrite(write_pb,HIGH);
  // push_pen();

}
void erase_dn(){
  //digitalWrite(pen_enable,HIGH);
  digitalWrite(erase_pa,HIGH);
  digitalWrite(erase_pb,LOW);
}
void  erase_up(){
  //digitalWrite(pen_enable,HIGH);
  digitalWrite(erase_pa,LOW);
  digitalWrite(erase_pb,HIGH);
}
void push_pen(){
  erase_dn();
  delay(10);
  erase_up();
  delay(10);

}


void set_zero(){
  x_homestate = false;
  y_homestate = false;

}





void mov_test(long xx,long yy){

  float current_x = stepper_x.currentPosition();
  float current_y = stepper_y.currentPosition();
  int bac_x = 0;
  int bac_y = 0;

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
  int cur_pos = angle_offset * 88.89;
  stepper_x.setCurrentPosition(cur_pos);
  Serial.println(stepper_x.currentPosition());
}
void home_xfind(){
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
    stepper_x.move(100);
    stepper_x.run();
  }
  int cur_pos = angle_offset * 88.89;
  stepper_x.setCurrentPosition(cur_pos);
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

  digitalWrite(write_pa,LOW);
  digitalWrite(write_pb,LOW);
  digitalWrite(erase_pa,LOW);
  digitalWrite(erase_pb,LOW);

}



void pos ( float x,float y) // function to convert a x,y co-ordinate into corresponding servo angles .... used in putline function to plot a line

{
  float L1 = 85;//80.4; // the length of the shoulder
  float L2 = 88; // the length of the elbow
  //float c2 = sq(x);
  //float c2 = (sq(x) + sq(y) - sq(l1) - sq (l2));
  double h = sqrt((x*x)+(y*y));
  double Ang_A = acos((sq(L1)+sq(L2)-(sq(h)))/(2*L1*L2));
  double Ang_D = atan(x/y);
  double Ang_B = 180-rtod(Ang_A);
  double Ang_C = acos((sq(L1)-sq(L2)+sq(x)+sq(y))/(2*L1*h));





  double elbow_ang = 90-(rtod(Ang_C)+rtod(Ang_D)- Ang_B);
  double shoulder_ang = elbow_ang-Ang_B;

  double  y_pos = int(shoulder_ang/0.01125) ;
  double  x_pos = int(elbow_ang/0.01125) ;
  mov_test(x_pos,y_pos);
  Serial.println(x_pos);
  Serial.println(y_pos);
}











double rtod(double fradians)
{
  return(fradians * 180.0 / PI);
}
















































