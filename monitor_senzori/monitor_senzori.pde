// Sweep
// by BARRAGAN <http://barraganstudio.com> 

#include <Servo.h> 
Servo servostanga;  
Servo servodreapta;
float a,b,c,d;


void setup() 
{ 

  pinMode(4,INPUT) ;
  pinMode(2,INPUT) ;
  pinMode(3,INPUT);
  Serial.begin(9600);
  delay(1000);
} 

void loop() 
{
a=0,b=0;
c=0,d=0;
  for(int i=0; i<10 ;i++){
    a=a+ 12343.85 * pow(analogRead(1),-1.15);
    b=b+ 12343.85 * pow(analogRead(0),-1.15);
    c=c+ analogRead(1);
    d=d+ analogRead(0);
  }
  a=a/10;
  b=b/10;
  c=c/10;
  d=d/10;
  //int c=analogRead(2);
  //int d=analogRead(3);
  Serial.print(a);
  Serial.print("\t");
  Serial.print(b);
  Serial.print("\t");
  Serial.print(c);
  Serial.print("\t");
  Serial.println(d);
   
  delay(500);
}

