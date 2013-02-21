#include <Fat16.h>
#include <Fat16util.h> 

#include <OneWire.h>
#include <DallasTemperature.h>

#define ONE_WIRE_BUS 5
#define TEMPERATURE_PRECISION 9

OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature sensors(&oneWire);

SdCard card;
Fat16 file;

#define error(s) error_P(PSTR(s))


void error_P(const char* str) {
  PgmPrint("error: ");
  SerialPrintln_P(str);
  if (card.errorCode) {
    PgmPrint("SD error: ");
    Serial.println(card.errorCode, HEX);
  }
  while(1);
}

void writeNumber(int n) {
  uint8_t buf[10];
  uint8_t i = 0;
  if(n<0)
  {
    file.write("-");
    n=n*(-1);
  }
  do {
    i++;
    buf[sizeof(buf) - i] = n%10 + '0';
    n /= 10;
  } while (n);
  file.write(&buf[sizeof(buf) - i], i-2); //partea intreaga
  file.write(".");
  file.write(&buf[8],2); //partea zecimala 
}

void printTemperature(DeviceAddress deviceAddress)
{
  float tempC = sensors.getTempC(deviceAddress);
  file.write("Temp C: ");
  writeNumber(tempC*100);
  file.write("\r\n");
}

void setup(void) {
  Serial.begin(9600);
  pinMode(7, OUTPUT); 
  pinMode(6, OUTPUT);
  digitalWrite(6, HIGH);  
  
  sensors.begin();
  
  if (!card.init()) error("card.init");
  if (!Fat16::init(&card)) error("Fat16::init");
  
  //if (!sensors.getAddress(insideThermometer, 0)) Serial.println("Unable to find address for Device 0"); 
  //if (!sensors.getAddress(outsideThermometer, 1)) Serial.println("Unable to find address for Device 1"); 
  
  DeviceAddress insideThermometer = { 0x10, 0x9A, 0xCF, 0x41, 0x01, 0x08, 0x00, 0x7A };
  DeviceAddress outsideThermometer   = { 0x28, 0xA8, 0xF9, 0x8D, 0x02, 0x00, 0x00, 0xBD };

  
  sensors.setResolution(insideThermometer, 9);
  sensors.setResolution(outsideThermometer, 9);
  
  char name[] = "WRITE00.TXT";
  for (uint8_t i = 0; i < 100; i++) {
    name[5] = i/10 + '0';
    name[6] = i%10 + '0';
    // O_CREAT - create the file if it does not exist
    // O_EXCL - fail if the file exists
    // O_WRITE - open for write
    if (file.open(name, O_CREAT | O_EXCL | O_WRITE)) break;
  }
  PgmPrint("Writing to: ");
  Serial.println(name);

  for(int j=0;j<100;j++)
  {
   //delay(1000);
   sensors.requestTemperatures();
  float tempC = sensors.getTempC(insideThermometer);
  
  Serial.println(tempC);
  
   tempC = sensors.getTempC(outsideThermometer);
  
  Serial.println(tempC);
  // file.write("1: ");
   //printTemperature(insideThermometer);
  // file.write("2: ");
   //printTemperature(outsideThermometer);
  }
  file.close();
  digitalWrite(6, LOW);
  digitalWrite(7, HIGH);
  
}

void loop() 
{

}
