#define mask 255 // kill top bits

int potPin = 0; // select the input pin for the pot

int ledPin = 13; // select the pin for the LED

int val = 16706; // variable to store the value coming from the sensor

int val2 =0;

int a =0;

int b =0;

int beats[]= {0,0,0,0,0};// to track last five reads for a pattern

boolean beated = false;

//function dec

boolean getBioData();


void setup() {
pinMode(ledPin, OUTPUT); // declare the ledPin as an OUTPUT
Serial.begin(9600);
}

void loop() {
char check=' ';
val = analogRead(potPin); // read the value from the sensor
if (Serial.read() =='a'){ // check buffer for an 'a'
val2 = val;
b= val & mask;
a =((val2>>8) & mask); //just in case mask
delay(20);
// Serial.print("b"); // debug
// Serial.print(b);
Serial.print(a,BYTE);
Serial.print(b,BYTE);
if (getBioData()){ // call bio function
Serial.print('b',BYTE);
}
else Serial.print('n',BYTE);
}
}
boolean getBioData(){
int beatVal = analogRead(potPin); // read the value from the sensor
beats[4] = beatVal; // put in back of array
int beatDif = beats[5 - 1] - beats[0];
for (int i = 0; i < 5;i++){
beats[i] = beats[i+1]; // push zero out front
}
// check for beat
if ( beatDif > 10 && (beated != true)){
beated = true;
return true;
}
else if( beatDif < 2 ){
beated = false;
return false;
}
else return false;
} 
