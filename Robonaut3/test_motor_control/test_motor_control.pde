int dirA = 12;
int dirB = 13;  // not used in this example
int speedA = 10;
int speedB = 11; // not used in this example


void setup() { 
pinMode (dirA, OUTPUT);
pinMode (dirB, OUTPUT);
pinMode (speedA, OUTPUT);
pinMode (speedB, OUTPUT);
}


void loop() { 
digitalWrite (13, LOW);
digitalWrite (12, HIGH);
analogWrite (speedA,255 ); 

delay (200);
digitalWrite (12,LOW);
digitalWrite (13, HIGH);
analogWrite (speedA,255);

delay (200); 

} 
