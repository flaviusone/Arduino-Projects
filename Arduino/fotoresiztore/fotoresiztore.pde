#define LED 13 
#define LED 12// the pin for the LED
int val = 0;
int val2 = 0;// variable used to store the value
// coming from the sensor
void setup() {
pinMode(LED, OUTPUT); // LED is as an OUTPUT
// Note: Analogue pins are
// automatically set as inputs
Serial.begin(9600);
}
void loop() {
val = analogRead(0);
val2 = analogRead(1);
Serial.println(val);

Serial.println(val2);
Serial.println();
if (val > val2) 
{
digitalWrite(12,LOW);
digitalWrite(13, HIGH);
delay(1000);
}
else
{
digitalWrite(12, HIGH);
digitalWrite(13, LOW);
delay(1000);
}
}
