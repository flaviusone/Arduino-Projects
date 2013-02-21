const int pingPin = 1;
int val;
void setup () { 
    Serial.begin(9600);
    
    pinMode(pingPin, OUTPUT );
}
void loop (){
  
val = digitalRead(pingPin);
  Serial.print(val); 
 Serial.println(); 
  delay(100);
  
}

