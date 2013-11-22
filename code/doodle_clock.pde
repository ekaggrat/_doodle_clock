
// doodle clock
// copyright ekeggrat singh kalsi 2012

// the below code calculates the time in the arduino itself... I did this for simplicity ... if needed the code could be extended to get time from a RTC chip
// the digits are all plotted diagonally .. if needed the code can be rewritten to plot them straight


#include <math.h>
#include <Servo.h> 
#include <Time.h> 

Servo myservo1;  // create servo object to control a servo 
Servo myservo2;             
Servo myservo3; 
Servo myservo4; 


int disp_m1 = minute()/10;
int disp_m2 = minute()%10;
int hh = hour();


int disp_h = hh;

int disp_h1 = disp_h / 10;
int disp_h2 = disp_h % 10;

int disp_h12 =abs( hh - 12);
int disp_h1_12 = disp_h12 / 10;
int disp_h2_12 = disp_h12 % 10;


// variable to store the servo position 
double x =0;
double y =0;

//float dist = 0;

float ax = 25;
float ay = 125;
float bx = 75;
float by = 125;
float cx = 80;
float cy = 148;
float dx = 30;
float dy = 148;

int del_let(500); // delay between letters
int del_er(50); // delay between eraser
void setup() 
{ 
  setTime(9,05,00,12,02,2012);
  hom();
  myservo1.attach(8);
  myservo2.attach(5);
  myservo3.attach(7);
  myservo4.attach(6);
  //Serial.begin(9600);


  int disp_m1 = minute()/10;
  int disp_m2 = minute()%10;
  int hh = hour();


  starttime();
  hom();
} 

void starttime() // function to plot time the first time .. still needs improvement
{
  //erase_all();

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

  /*   Serial.println(disp_h);
   Serial.println(disp_h12);
   Serial.print(disp_m1);
   Serial.println(disp_m2);
   */


}

void hom() // function to home servos
{
  myservo3.write(170);
  myservo4.write(45);
  myservo1.write(20);
  myservo2.write(140);
}


void loop() 
{ 

//penup();
//delay(500);
//pendn();
//delay(500);

  idle();
  printtime();
  penup();
 
  hom();

}


void idle()// function to move pen up and down to idle between minutes ... can be removed if found annoying
{
  pendn();
  delay(1000);
  penup();
  delay(1000);

}

void erase_all() // function to clean board
{
  fasterase(-5,120);
  delay(1000);


  fasterase(11,120);
  delay(1000);

  fasterase(37,126);
  delay(1000);

  fasterase(55,128);
  delay(1000);

}








void penup()
{
  myservo3.write(170);
}

void pendn()
{
  myservo3.write(80);
}

void eraserup()
{
  myservo4.write(45);
}

void eraserdn()
{
  myservo4.write(10);

}

void fasterase(float xp, float yp)//function to erase in a line ...
{
  pos(0 + xp,0 + yp);
  delay(del_let);
  eraserdn();
  delay(del_let);

  for ( int repeat= 0 ; repeat < 7; repeat ++)
  {
    pos(0 + xp,0 + yp);
    eraseline(0+ xp,0 +yp,7 +xp,30 + yp);
    delay(del_er);

    eraseline(7+ xp,30 +yp,0 +xp,0 + yp);
    delay(del_er);

    pos(7 + xp,0 + yp);
    eraseline(7+ xp,0 +yp,14 +xp,30 + yp);
    delay(del_er);

    eraseline(14+ xp,30 +yp,7 +xp,0 + yp);
    delay(del_er);



  }
  eraserup();

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
        delay(2);

      }
    }
    else if (xi > xd){
      for(float xaxis = xi; xaxis > xd; xaxis -= 0.5)
      {
        //for(float yaxis = yi; yaxis < yd; yaxis += 0.5)
        // {

        pos(xaxis,yi);
        delay(2);

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
        delay(5);
      }
    }
    else if ( yi > yd ){
      for(float yaxis = yi; yaxis > yd; yaxis -= 0.5)
      {
        pos(xi,yaxis);
        delay(5);
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
    delay(5);

    //Serial.print(xpoint,DEC);
    //Serial.println(ypoint,DEC);

  }
}



void eraseline (float xi,float yi,float xd, float yd) // function to erase in a line...
{
  float distt = sqrt(sq(xd - xi) + sq(yd - yi));
  int numpart = distt / 0.5;
  float ddx = (xd - xi) / numpart;
  float l_slope = (yd - yi)/(xd - xi);

  int ln_del = .5;



  if (yi == yd){
    // Serial.println("horizontal line");
    if (xi < xd){


      for(float xaxis = xi; xaxis < xd; xaxis += 0.5)
      {
        pos(xaxis,yi);
        delay(ln_del);

      }
    }
    else if (xi > xd){
      for(float xaxis = xi; xaxis > xd; xaxis -= 0.5)
      {
        //for(float yaxis = yi; yaxis < yd; yaxis += 0.5)
        // {

        pos(xaxis,yi);
        delay(ln_del);

        //Serial.print(xaxis,DEC);
        //Serial.println(yi,DEC);
      }
    }
  }
  else if (xi == xd){
    //Serial.println("vertical line");
    if (yi < yd) {


      for(float yaxis = yi; yaxis < yd; yaxis += 0.5)
      {
        pos(xi,yaxis);
        delay(ln_del);
      }
    }
    else if ( yi > yd ){
      for(float yaxis = yi; yaxis > yd; yaxis -= 0.5)
      {
        pos(xi,yaxis);
        delay(ln_del);
      }
      //Serial.print(xi,DEC);
    } //Serial.println(yaxis,DEC);

  }
  else 

    //Serial.println("diagonalline");

  for (float point = 1; point < numpart; point += 0.5)
  {
    float xpoint = xi + (ddx * point );
    float ypoint = l_slope * (xpoint - xi) + yi;
    pos(xpoint , ypoint);
    delay(ln_del);

    //Serial.print(xpoint,DEC);
    //Serial.println(ypoint,DEC);

  }
}




void pos ( float x,float y) // function to convert a x,y co-ordinate into corresponding servo angles .... used in putline function to plot a line

{
  float l1 = 80.4; // the length of the shoulder
  float l2 = 96; // the length of the elbow
  //float c2 = sq(x);
  //float c2 = (sq(x) + sq(y) - sq(l1) - sq (l2));
  double cb2 = 2*l1*l2;

  double c2 = (sq(x) + sq(y) - sq(l1) - sq (l2)) / cb2;
  double s2 = sqrt(1-sq(c2));
  double k1 = (l1 + l2 * c2);
  double k2 = (l2 * s2);

  double base_ang = rtod((atan2(y,x) - atan2(k2,k1)));
  double elbow_ang = rtod(atan2(s2,c2)) + 90;

  myservo1.write(base_ang);
  myservo2.write(elbow_ang);


}

double rtod(double fradians)
{
  return(fradians * 180.0 / PI);
}



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
  fasterase(-5, 120);
  hour1();
}

void update_h2()// update hour2 digit
{
  fasterase(11, 120);
  hour2();
}

void update_m1()// update minute1 digit
{
  fasterase(37, 126);
  min1();
}

void update_m2()// update minute2 digit
{
  fasterase(58, 128);
  min2();
  
  penup();
  delay(500);
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

  digit(h1, 4, 127);
  penup();
}

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

  digit(h2, 26, 127);
  penup();
}

void min1()//calcuate minute 1
{
  int m = minute();
  int m1 = m/ 10;
  Serial.println("m1");
  Serial.println(m1);
  digit(m1, 52, 127);
  penup();
}

void min2()//calcuate minute 2
{
  int m = minute();
  int m2 = m % 10;
  Serial.println("m1");
  Serial.println(m2);
  digit(m2, 70, 126.5);
  penup();
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






// digit coordinates ... the digits are plotted diagonally ... 

void onee ( float xp, float yp)

{
  penup();
  delay(del_let);
  pos(17 + xp,23 + yp);
  delay(del_let);
  pendn();
  delay(del_let);

  for ( int repeat= 0 ; repeat < 3; repeat ++)
  {

    putline(17+xp,23+yp,12+xp,0+yp);
    delay(del_let);
    putline(12+xp,0+yp,17+xp,23+yp);
    delay(del_let);
  }

  penup();
}



void toww(float xp,float yp)

{
  penup();
  delay(del_let);

  pos(5 + xp,23 + yp);
  delay(del_let);
  pendn();
  delay(del_let);

  for ( int repeat= 0 ; repeat < 3; repeat ++)
  {


    putline(5+xp,23+yp,16.5+xp,23+yp);
    delay(del_let);
    putline(16.5+xp,23+yp,14.5+xp,11.5+yp);
    delay(del_let);
    putline(14.5+xp,11.5+yp,2.5+xp,11.5+yp);
    delay(del_let);
    putline(2.5+xp,11.5+yp,0+xp,0+yp);
    delay(del_let);
    putline(0+xp,0+yp,12+xp,0+yp);
    delay(del_let);

    putline(12+xp,0+yp,0+xp,0+yp);
    delay(del_let);

    putline(0+xp,0+yp,2.5+xp,11.5+yp);
    delay(del_let);
    putline(2.5+xp,11.5+yp,14.5+xp,11.5+yp);
    delay(del_let);
    putline(14.5+xp,11.5+yp,16.5+xp,23+yp);
    delay(del_let);
    putline(16.5+xp,23+yp,5+xp,23+yp);
    delay(del_let);



  }
  penup();
  delay(del_let);

}

void three( float xp,float yp)
{

  penup();
  delay(del_let);

  pos(6 + xp,23 + yp);
  delay(del_let);
  pendn();
  delay(del_let);

  for ( int repeat= 0 ; repeat < 3; repeat ++)
  {


    putline(6 + xp,23+yp,17+xp,23+yp);
    delay(del_let);
    putline(17 +xp,23+yp,14.5+xp,11.5+yp);
    delay(del_let);
    putline(14.5+xp,11.5+yp,3.5+xp,11.5+yp);
    delay(del_let);
    putline(3.5+xp,11.5+yp,14.5+xp,11.5+yp);
    delay(del_let);
    putline(14.5+xp,11.5+yp,12 +xp,0 +yp);
    delay(del_let);
    putline(12+xp,0+yp,0 +xp,0 +yp);
    delay(del_let);

    putline(0+xp,0+yp,12 +xp,0 +yp);
    delay(del_let);
    putline(12+xp,0+yp,14.5 +xp,11.5 +yp);
    delay(del_let);
    putline(14.5+xp,11.5+yp,3.5+xp,11.5+yp);
    delay(del_let);
    putline(3.5+xp,11.5+yp,14.5+xp,11.5+yp);
    delay(del_let);
    putline(14.5+xp,11.5+yp,17+xp,23+yp);
    delay(del_let);
    putline(17+xp,23+yp,6+xp,23+yp);
    delay(del_let);



  }

  penup();

}

void four ( float xp,float yp)
{

  penup();
  delay(del_let);

  pos(6 + xp,23 + yp);
  delay(del_let);
  pendn();
  delay(del_let);

  for ( int repeat= 0 ; repeat < 3; repeat ++)
  {
    putline(6 + xp,23+yp,3.5+xp,11.5+yp);
    delay(del_let);
    putline(3.5 + xp,11.5+yp,14.5+xp,11.5+yp);
    delay(del_let);
    putline(14.5 + xp,11.5+yp,17+xp,23 + yp);
    delay(del_let);
    putline(17 + xp,23+yp,12 +xp,0 + yp);
    delay(del_let);
    putline(12 + xp,0+yp,14.5 +xp,11.5 + yp);
    delay(del_let);
    putline(14.5 + xp,11.5+yp,3.5 +xp,11.5 + yp);
    delay(del_let);
    putline(3.5 + xp,11.5+yp,6 +xp,23 + yp);
    delay(del_let);



  }


  penup();
}

void five (float xp, float yp)

{
  penup();
  delay(del_let);

  pos(17 + xp,23 + yp);
  delay(del_let);
  pendn();
  delay(del_let);

  for ( int repeat= 0 ; repeat < 2; repeat ++)
  {
    putline(17 + xp,23 +yp,6 +xp,23 + yp);
    delay(del_let);
    putline(6 + xp,23 +yp,3.5 +xp,11.5 + yp);
    delay(del_let);
    putline(3.5 + xp,11.5 +yp,14.5 +xp,11.5 + yp);
    delay(del_let);
    putline(14.5 + xp,11.5 +yp,12 +xp,0 + yp);
    delay(del_let);
    putline(12 + xp,0 +yp,1 +xp,0 + yp);
    delay(del_let);

    putline(1 + xp,0 +yp,12 +xp,0 + yp);
    delay(del_let);
    putline(12 + xp,0 +yp,14.5 +xp,11.5 + yp);
    delay(del_let);
    putline(14.5 + xp,11.5 +yp,3.5 +xp,11.5 + yp);
    delay(del_let);
    putline(3.5 + xp,11.5 +yp,6 +xp,23 + yp);
    delay(del_let);
    putline(6 + xp,23 +yp,17 +xp,23 + yp);
    delay(del_let);


  }

  penup();

}

void six ( float xp, float yp)
{
  penup();
  delay(del_let);

  pos(17 + xp,23 + yp);
  delay(del_let);
  pendn();
  delay(del_let);

  for ( int repeat= 0 ; repeat < 3; repeat ++)
  {

    putline(17 + xp,23 +yp,6 +xp,23 + yp);
    delay(del_let);
    putline(6 + xp,23 +yp,1 +xp,0 + yp);
    delay(del_let);
    putline(1 + xp,0 +yp,12 +xp,0 + yp);
    delay(del_let);
    putline(12 + xp,0 +yp,14.5 +xp,11.5 + yp);
    delay(del_let);
    putline(14.5 + xp,11.5 +yp,3.5 +xp,11.5 + yp);
    delay(del_let);

    putline(3.5 + xp,11.5 +yp,6 +xp,23 + yp);
    delay(del_let);
    putline(6 + xp,23 +yp,17 +xp,23 + yp);
    delay(del_let);



  }

  penup();

}


void seven ( float xp, float yp )
{

  penup();
  delay(del_let);

  pos(6 + xp,23 + yp);
  delay(del_let);
  pendn();
  delay(del_let);

  for ( int repeat= 0 ; repeat < 3; repeat ++)
  {


    putline(6+ xp,23 +yp,17 +xp,23 + yp);
    delay(del_let);
    putline(17+ xp,23 +yp,12 +xp,0 + yp);
    delay(del_let);

    putline(12+ xp,0 +yp,17 +xp,23 + yp);
    delay(del_let);
    putline(17+ xp,23 +yp,6 +xp,23 + yp);
    delay(del_let);



  }


  penup();

}

void eight ( float xp, float yp)

{
  penup();
  delay(del_let);

  pos(6 + xp,23 + yp);
  delay(del_let);
  pendn();
  delay(del_let);

  for ( int repeat= 0 ; repeat < 3; repeat ++)
  {


    putline(6+ xp,23 +yp,3.5 +xp,11.5 + yp);
    delay(del_let);
    putline(3.5+ xp,11.5 +yp,14.5 +xp,11.5 + yp);
    delay(del_let);
    putline(14.5+ xp,11.5 +yp,12 +xp,0 + yp);
    delay(del_let);
    putline(12+ xp,0 +yp,1 +xp,0 + yp);
    delay(del_let);
    putline(1+ xp,0 +yp,3.5 +xp,11.5 + yp);
    delay(del_let);
    putline(3.5+ xp,11.5 +yp,14.5 +xp,11.5 + yp);
    delay(del_let);
    putline(14.5+ xp,11.5 +yp,17 +xp,23 + yp);
    delay(del_let);
    putline(17+ xp,23 +yp,6 +xp,23 + yp);
    delay(del_let);


  }

  penup();

}


void nine ( float xp, float yp)

{
  penup();
  delay(del_let);

  pos(6 + xp,23 + yp);
  delay(del_let);
  pendn();
  delay(del_let);

  for ( int repeat= 0 ; repeat < 3; repeat ++)
  {


    putline(6+ xp,23 +yp,3.5 +xp,11.5 + yp);
    delay(del_let);
    putline(3.5+ xp,11.5 +yp,14.5 +xp,11.5 + yp);
    delay(del_let);
    putline(14.5+ xp,11.5 +yp,12 +xp,0 + yp);
    delay(del_let);
    putline(12+ xp,0 +yp,1 +xp,0 + yp);
    delay(del_let);

    putline(1 + xp,0 +yp,12 +xp,0 + yp);
    delay(del_let);
    putline(12+ xp,0 +yp,17 +xp,23 + yp);
    delay(del_let);
    putline(17+ xp,23 +yp,6 +xp,23 + yp);
    delay(del_let);



  }

  penup();



}


void zerro(float xp , float yp)
{

  penup();
  delay(del_let);

  pos(6+xp,23+yp);
  delay(del_let);
  pendn();
  delay(del_let);

  for ( int repeat= 0 ; repeat < 3; repeat ++)
  {
    putline(6+xp,23+yp,17+xp,23+yp);
    delay(del_let);
    putline(17+xp,23+yp,12+xp,0+yp);
    delay(del_let);
    putline(12+xp,0+yp,0+xp,0+yp);
    delay(del_let);
    putline(0+xp,0+yp,6+xp,23+yp);
    delay(del_let);
  }



  penup();

}



















































