// Sweep
// by BARRAGAN <http://barraganstudio.com> 

#include <Servo.h> 
 
Servo servostanga;  
Servo servodreapta;
int val; 
    
void setup() 
{ 
  servostanga.attach(5);  
  servodreapta.attach(11);
  Serial.begin(9600);
} 
 
 
void loop() 
{ 
  Serial.println(val);
  val = analogRead(0);
  if (val > 200)
{
  servostanga.write(180);   
    servodreapta.write(180);
}
else
{
  
      servostanga.write(114);   
    servodreapta.write(109);
   delay(1000) ;
}

    
     
      
   // servostanga.write(180);   
   // servodreapta.write(180); 
   //  servostanga.write(114);   
  //  servodreapta.write(119);
   // delay(500);

   // delay(1000);
  // servostanga.write(102);   
   // servodreapta.write(107); 
   // servostanga.write(0);   
   // servodreapta.write(1800);
   // delay(500);

} 
