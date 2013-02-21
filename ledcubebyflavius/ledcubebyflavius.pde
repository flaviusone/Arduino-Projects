#include <LedCube.h>

byte levelPins[] = {11,12,13};
byte colPins[] = {2,3,4,5,6,7,8,9,10};



void setup ()
{
  pinMode(11, OUTPUT);
  pinMode(12, OUTPUT);
  pinMode(13, OUTPUT);
  pinMode(10, OUTPUT);
  pinMode(2, OUTPUT);
}

void loop ()
{
  
digitalWrite(11,HIGH);
digitalWrite(12,HIGH);
digitalWrite(13,HIGH);
digitalWrite(10,HIGH);
digitalWrite(2,HIGH);

}
