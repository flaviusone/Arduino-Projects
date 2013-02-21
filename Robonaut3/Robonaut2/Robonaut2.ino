
int valori[3];
#include <Servo.h> 
#include <MeetAndroid.h>
#define pragstanga 90
#define pragdreapta 93
#define pinstanga 11
#define pindreapta 10
Servo servostanga;  
Servo servodreapta;
MeetAndroid meetAndroid(error);
static int b=0;
void error(uint8_t flag, uint8_t values){
  Serial.print("ERROR: ");
  Serial.print(flag);

}

void setup() 
{ 
  Serial.begin(115200); 
  meetAndroid.registerFunction(compass, 'A');
  meetAndroid.registerFunction(bul, 'B');
  pinMode(pinstanga,OUTPUT);
  pinMode(pindreapta,OUTPUT);
  pinMode(4,INPUT) ;
  pinMode(2,INPUT) ;

} 


void loop() 
{
  delay(100);

  meetAndroid.receive();
//  Serial.println(valori[1]);
//  Serial.println(valori[2]);
//  Serial.println(valori[3]);
  Serial.flush() ;

  servodreapta.attach(pindreapta);
  servostanga.attach(pinstanga);

  if ( b==1 ) //mod autonom
  {
    servodreapta.attach(pindreapta);
    servostanga.attach(pinstanga);
    servostanga.write(pragstanga-30);   
    servodreapta.write(pragdreapta+30);    
    if(analogRead(5) > 500)
    {
      servodreapta.attach(pindreapta);
      servostanga.attach(pinstanga);
      servostanga.write(pragstanga+30);   
      servodreapta.write(pragdreapta-30);
      delay(1000);
      servostanga.write(pragstanga-70);   
      servodreapta.write(pragdreapta-70+2);
      delay(500);
      servostanga.detach(); 
      servodreapta.detach();
      delay(1000);      
    }
  }

  else if (valori[1] > 3) {
    servodreapta.attach(pindreapta);
    servostanga.attach(pinstanga);
    servostanga.write(pragstanga+abs(valori[1]));   
    servodreapta.write(pragdreapta+abs(valori[1])-3);


  }
  else if (valori[1] < -3){
    servodreapta.attach(pindreapta);
    servostanga.attach(pinstanga);
    servostanga.write(pragstanga-abs(valori[1]));   
    servodreapta.write(pragdreapta-abs(valori[1])+2);
  }
  else if (valori[2] > 3){
    servodreapta.attach(pindreapta);
    servostanga.attach(pinstanga);
    servostanga.write(pragstanga+abs(valori[2]));   
    servodreapta.write(pragdreapta-abs(valori[2]));

  }
  else if (valori[2] < -3){
    servodreapta.attach(pindreapta);
    servostanga.attach(pinstanga);
    servostanga.write(pragstanga-abs(valori[2]));   
    servodreapta.write(pragdreapta+abs(valori[2]));

  }
  else {
    servostanga.detach(); 
    servodreapta.detach();
  }
}

void compass(byte flag, byte numOfValues)
{

  meetAndroid.getIntValues(valori);
  valori[1] = map (valori[1] , -pragstanga , pragstanga , -20 , 20);
  valori[2] = map (valori[2] , -60 , 60 , -20 , 20);
  Serial.flush();

}


void bul(byte flag, byte numOfValues)
{
  if (b==0) b=1;
  else if(b==1) b=0;
}


