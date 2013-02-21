// Sweep
// by BARRAGAN <http://barraganstudio.com> 

#include <Servo.h> 
 
Servo servostanga;  
Servo servodreapta;
    
void setup() 
{ 
  servostanga.attach(5);  
  servodreapta.attach(6);
  pinMode(4,INPUT) ;
  pinMode(2,INPUT) ;
} 
 
 
void loop() 
{
  
  
  if (digitalRead(4) == 0) {
    servostanga.write(105);   
    servodreapta.write(110);
  }else{
     servostanga.write(180);   
 servodreapta.write(180);
 delay(500);
 servostanga.write(180);   
 servodreapta.write(0);
 delay(500);   
       
}
}


