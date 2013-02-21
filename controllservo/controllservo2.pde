// Sweep
// by BARRAGAN <http://barraganstudio.com> 

#include <Servo.h> 
 
Servo servostanga;  
Servo servodreapta;
int val; 
    
void setup() 
{ 
  servostanga.attach(5);  
  servodreapta.attach(6);
  Serial.begin(9600);
} 
 
 
void loop() 
{
  val=0;
  servostanga.write(109);   
  servodreapta.write(114);
  if (Serial.available() > 0) {
		

  val= Serial.read();
  }
  if (val=='1'){
    servostanga.write(180);   
    servodreapta.write(180);
    delay(1000);
}
  if (val=='2'){
    servostanga.write(0);   
    servodreapta.write(0);
    delay(1000);
  } 
  if (val=='3'){
    servostanga.write(180);   
    servodreapta.write(0);
    delay(100);
  }
   if (val=='4'){
    servostanga.write(0);   
    servodreapta.write(180);
    delay(100);
  }
}

