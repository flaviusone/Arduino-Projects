#define LED 9 // the pin for the LED
int i = 0;
int potpin = 0; 
int val; // We’ll use this to count up and down
void setup() {
pinMode(LED, OUTPUT); // tell Arduino LED is an output
}
void loop(){
for (i = 0; i < 255; i++) { 
  // loop from 0 to 254 (fade in)
analogWrite(LED, i);
val = analogRead(potpin);            // reads the value of the potentiometer (value between 0 and 1023) 
  val = map(val, 0, 1023, 1, 3000);// set the LED brightness
delayMicroseconds(val); // Wait 10ms because analogWrite
// is instantaneous and we would
// not see any change
}
for (i = 255; i > 0; i--) { // loop from 255 to 1 (fade out)
analogWrite(LED, i); // set the LED brightness
val = analogRead(potpin);            // reads the value of the potentiometer (value between 0 and 1023) 
  val = map(val, 0, 1023, 1, 3000);// set the LED brightness
delayMicroseconds(val);
}
}
