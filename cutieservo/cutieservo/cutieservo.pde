// Sweep
// by BARRAGAN <http://barraganstudio.com> 

#include <Servo.h> 
 
Servo servo;  
int val;
    
void setup() 
{ 
   
  Serial.begin(9600);
} 
 
 
void loop() 
{
 val= Serial.read();
      if (val=='1'){
   servo.attach(11);
   servo.write(180);
  delay(165);
  servo.detach();
  }
 if (val=='2'){
   servo.attach(11);
     servo.write(50);
  delay(157);
  servo.detach();
    } 
    

}

