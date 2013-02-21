
float valori[3];
int dirA = 12;
int dirB = 13;
int speedB = 11;
 
 #include <MeetAndroid.h>
MeetAndroid meetAndroid(error);

void error(uint8_t flag, uint8_t values){
  Serial.print("ERROR: ");
  Serial.print(flag);
}
    
void setup() 
{ 
   Serial.begin(57600); 
   meetAndroid.registerFunction(compass, 'A');
  

  pinMode (dirA, OUTPUT);
  pinMode (dirB, OUTPUT);
  pinMode (speedB, OUTPUT);
} 
 
 
void loop() 
{
  
 meetAndroid.receive();

       if (valori[1] < -1) {
digitalWrite (13, LOW);
digitalWrite (12, HIGH);
analogWrite (speedB,155); 
    
    
      }else if (valori[1] > 1){
digitalWrite (12,LOW);
digitalWrite (13, HIGH);
analogWrite (speedB,155);
      }

}

void compass(byte flag, byte numOfValues)
{
  
  meetAndroid.getFloatValues(valori);
  Serial.flush();

}


