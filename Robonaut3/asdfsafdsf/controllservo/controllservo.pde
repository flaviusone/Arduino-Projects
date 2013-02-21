// Sweep
// by BARRAGAN <http://barraganstudio.com> 

#include <Servo.h> 
 #include <MeetAndroid.h>
Servo servostanga;  
Servo servodreapta;
MeetAndroid meetAndroid(error);

void error(uint8_t flag, uint8_t values){
  Serial.print("ERROR: ");
  Serial.print(flag);
}
    
void setup() 
{ 
   Serial.begin(57600); 
   meetAndroid.registerFunction(compass, 'B');
  
  servostanga.attach(5);  
  servodreapta.attach(6);
  pinMode(4,INPUT) ;
  pinMode(2,INPUT) ;
} 
 
 
void loop() 
{
  
 meetAndroid.receive();
  if (valori[2] > 20) {
    servostanga.write(105);   
    servodreapta.write(110);
      }else if (valori[2] < -20){
         servostanga.write(180);   
         servodreapta.write(180);
            }else if (valori[1] > 20){
                 servostanga.write(180);   
                 servodreapta.write(0);
                  }else if (valori[1] < -20){
                    servostanga.write(180);   
                    servodreapta.write(0); 
                  }
 
       
}

void compass(byte flag, byte numOfValues)
{
  int valori[numOfValues];
  meetAndroid.getIntValues(valori);
  Serial.println(valori[1]);

  Serial.println(valori[2]);
  Serial.flush();
  // we use getInt(), since we know only data between 0 and 360 will be sent
  // silly, you should have better ideas
}


