 /*
   Theremin
  
  Plays tones based on a sensor reading
  
  circuit:
  * photoresistor from +5V to analog in 0
  * photoresistor from analog pin 0 to ground
  * 8-ohm speaker on digital pin 8
  
  created 10 Sep 2009
  modified 8 Feb 2009
  by Tom Igoe 
  */


 void setup() {

 }

 void loop() {
   // get a sensor reading:
   int sensorReading = analogRead(0);
   // map the results from the sensor reading's range
   // to the desired pitch range:
   int pitch = map(sensorReading, 200, 900, 100, 1000);
   // change the pitch, play for 10 ms:
   tone(8, pitch, 10)
 }

