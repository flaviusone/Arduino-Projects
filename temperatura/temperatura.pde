#include <OneWire.h>
#include <DallasTemperature.h>

#define ONE_WIRE_BUS 5
#define TEMPERATURE_PRECISION 9

OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature sensors(&oneWire);

void setup(void) {
  Serial.begin(9600);
  pinMode(7, OUTPUT); 
  pinMode(6, OUTPUT);

  
  sensors.begin();
  DeviceAddress insideThermometer = { 0x10, 0x9A, 0xCF, 0x41, 0x01, 0x08, 0x00, 0x7A };
  DeviceAddress outsideThermometer   = { 0x28, 0xA8, 0xF9, 0x8D, 0x02, 0x00, 0x00, 0xBD };  
 
  sensors.setResolution(insideThermometer, 9);
  sensors.setResolution(outsideThermometer, 9);
}  
  void loop() 
{
   DeviceAddress insideThermometer = { 0x10, 0x9A, 0xCF, 0x41, 0x01, 0x08, 0x00, 0x7A };
  DeviceAddress outsideThermometer   = { 0x28, 0xA8, 0xF9, 0x8D, 0x02, 0x00, 0x00, 0xBD };
   sensors.requestTemperatures();
  float tempC = sensors.getTempC(insideThermometer);
  
  Serial.println(tempC);
  
   tempC = sensors.getTempC(outsideThermometer);
  
 Serial.println(tempC);
}
