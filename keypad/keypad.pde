/* @file HelloKeypad.pde
|| @version 1.0
|| @author Alexander Brevig
|| @contact alexanderbrevig@gmail.com
||
|| @description
|| | Demonstrates the simplest use of the matrix Keypad library.
|| #
*/
#include <Keypad.h>
#include <Servo.h>
int ledPin =  13;  
int checker = 0;
char vector[6];
Servo servo;  
int i;
const byte ROWS = 4; //four rows
const byte COLS = 3; //three columns
char keys[ROWS][COLS] = {
  {'1','2','3'},
  {'4','5','6'},
  {'7','8','9'},
  {'#','0','*'}
};
byte rowPins[ROWS] = {2, 3, 4, 5}; //connect to the row pinouts of the keypad
byte colPins[COLS] = {8, 7, 6}; //connect to the column pinouts of the keypad

Keypad keypad = Keypad( makeKeymap(keys), rowPins, colPins, ROWS, COLS );

void setup(){
  pinMode(ledPin, OUTPUT);   
  Serial.begin(9600);
}
  
void loop(){
  i=0;
while(i < 6){
  char key = keypad.getKey();
   if (key != NO_KEY){
     tone(10,2000,300);
     digitalWrite(ledPin, HIGH);
     delay(400);
     digitalWrite(ledPin, LOW);
    Serial.print(key);
    vector[i]=key;
    i=i+1;
    if (i !=6){
    delay(800);
    }
      }
}

Serial.println()     ; 

for(i=0 ; i<6 ; i = i+1 ){
Serial.print(vector[i]);
}
Serial.println()     ;
 
if (vector[0]=='2' && vector[1]=='3' && vector[2]=='6' && vector[3]=='9'  && vector[4]=='8' && vector[5]=='7'  ) {
digitalWrite(ledPin, HIGH);

tone(10,100,100);
delay(100);
tone(10,500,100);
delay(100);
tone(10,1000,100);
delay(100);
tone(10,1500,100);
delay(100);
if (checker==0) {
  checker=1;
}
else if (checker==1) {
  checker=0;
}
if (checker==1 ){
servo.attach(11);
   servo.write(180);
  delay(165);
  servo.detach();
}
else 
{
   servo.attach(11);
     servo.write(50);
  delay(157);
  servo.detach();
}
}
else
{
  digitalWrite(ledPin, LOW);
  tone(10,100,100);
delay(100);
tone(10,200,100);
delay(100);
tone(10,200,100);
delay(100);
tone(10,100,100);
delay(100);
}
}
