int tempPin = 1;
void setup()
{
    Serial.begin(9600);  //Begin serial communcation
}

void loop()
{
float tempC = analogRead(tempPin);  
//Serial.println(tempC);
tempC = (5 * tempC * 100)/1024.0;  
//int temp=tempC*10; 
Serial.print(tempC);      
Serial. print("\t"); 
Serial.println(analogRead(5));
delay(1000);
}

