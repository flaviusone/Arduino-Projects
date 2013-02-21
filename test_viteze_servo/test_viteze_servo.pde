#include <Servo.h> 
Servo servostanga;  
Servo servodreapta;
void setup() 
{ 
  servodreapta.attach(11);
  servostanga.attach(10);
  Serial.begin(9600);
} 
void loop(){
  servostanga.write(114);
  servodreapta.write(108);
/*for(int i=0 ; i<180 ; i++){
servostanga.write(i);
Serial.println(i);
delay(100);
if(i>100 && i<140){
  delay(900);
}
} */ 
}

