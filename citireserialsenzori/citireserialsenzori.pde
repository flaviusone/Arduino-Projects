/*
  AnalogReadSerial
 Reads an analog input on pin 0, prints the result to the serial monitor 
 
 This example code is in the public domain.
 */

void setup() {
  Serial.begin(9600);
  pinMode(1,OUTPUT);
  pinMode(3,OUTPUT);
  pinMode(2,OUTPUT);
  pinMode(4,OUTPUT);
  pinMode(5,OUTPUT);
  digitalWrite(1,HIGH);
digitalWrite(2,HIGH);
digitalWrite(4,HIGH);
  digitalWrite(3,HIGH);
  digitalWrite(5,HIGH);
  digitalWrite(13,HIGH);
}

void loop() {
         float aer=(4.88 * analogRead(5)) / 33 ;
         Serial.print(aer);
         Serial.print(' ');
////////////////////////////////////////////////////////////////////////////// 
          Serial.print(analogRead(1)/10);
         Serial.print(' '); // afisam umiditatea solului in procente
//////////////////////////////////////////////////////////////////////////////          
         float voltage = 5.0 * (analogRead(2) / 1024.0);
         float resistance = (10.0 * 5.0) / voltage - 10.0;
         float illuminance = 255.84 * pow(resistance, -10/9);
          Serial.print(illuminance);  // afisam nivelul de iluminare in lux 
          Serial.print(' ');
/////////////////////////////////////////////////////////////////////////////////////////
         float j=0;
         float tempC=0;
          for (int i=0;i<10;i++){
           tempC = analogRead(3);  
           j=j+tempC;
          }
          tempC = j / 10; 
          tempC = (5.0 * tempC * 100.0)/1024.0; //calculam temperatura prin citiri repetate si afisam in grade C
          Serial.print(tempC);
          Serial.println(' ');
          delay(1000);
}
