#include <Fat16.h>
#include <Fat16util.h>
SdCard card;
Fat16 f;

#include <NewSoftSerial.h>
NewSoftSerial mySerial(2, 3);

#define led1Pin 7
#define led2Pin 6

void setup()  
{
//  Serial.begin(9600);
//  Serial.println("Goodnight moon!");

  // set the data rate for the NewSoftSerial port
  mySerial.begin(9600);
  
  pinMode(led1Pin, OUTPUT);
  pinMode(led2Pin, OUTPUT);
  
  card_init();
}
#define isdigit(x) ( x >= '0' && x <= '9')

#define BUFSIZE 90
#define LOG_RMC_FIXONLY 0



char c;
char buffer[BUFSIZE];
int k=0,fix,i;

void loop()
{
  
  if (mySerial.available() ) 
  {   c=mySerial.read();
      if (k == 0)
           { while (c != '$' )
                {c = mySerial.read();
                 if ( !mySerial.available() ) return;  //GPS was disconnected
                }
                
           }
      buffer[k]=c;
      
      if (c == '\n')
           {buffer[k+1]=0;
            k=0;
            if( strstr(buffer,"GPRMC") )
                 { //Serial.print(buffer);
                   decodeRMC(buffer);
                   //Serial.print('\t');
                   //Serial.print(buffer);
                   card_write( buffer, 62);
                 } 
            return;
           }
           
           
           
      k++;
      
      if (k == BUFSIZE-1)
            { //Serial.println("\t BUFFER OVERFLOW!");
              k=0;
              return;
            } 
            
  }
  
}



void decodeRMC(char buffer[])
{ char *p = buffer;
 
        p = strchr(p, ',')+1;
        p = strchr(p, ',')+1;       // skip to 3rd item ( Void OR Active data? )
        
        if (p[0] == 'V') { digitalWrite(led1Pin, LOW);
                           fix = 0; }
                    else { digitalWrite(led1Pin, HIGH);
                           fix = 1; }
      
      
#if LOG_RMC_FIXONLY
      if (!fix) {//Serial.println("\t NO FIX YET");
                 return; } 
#endif
      // ready. lets print it!
  
      // time to clean up the string
 // find time
      p = buffer;
      
      p = strchr(p, ',')+1;
      buffer[0] = p[0];
      buffer[1] = p[1];
      buffer[2] = ':';
      buffer[3] = p[2];
      buffer[4] = p[3];
      buffer[5] = ':';
      buffer[6] = p[4];
      buffer[7] = p[5];
      // we ignore milliseconds
      buffer[8] = ',';
      
      p = strchr(buffer+8, ',')+1;
      // skip past 'active' flag, we already found out if we have a fix
      p = strchr(p, ',')+1;
// find lat
      p = strchr(p, ',')+1;

      buffer[9] = '+';
      buffer[10] = p[0];
      buffer[11] = p[1];
      buffer[12] = ' ';
      strncpy(buffer+13, p+2, 7);
      buffer[20] = ',';
      
      p = strchr(buffer+21, ',')+1;
      if (p[0] == 'S')
        buffer[9] = '-';
      
// find long
      p = strchr(p, ',')+1;
      buffer[21] = '+';
      buffer[22] = p[0];
      buffer[23] = p[1];
      buffer[24] = p[2];
      buffer[25] = ' ';
      strncpy(buffer+26, p+3, 7);
      buffer[33] = ',';
      
      p = strchr(buffer+34, ',')+1;
      if (p[0] == 'W')
        buffer[21] = '-';
      
// find speed
      p = strchr(p, ',')+1;
    unsigned int  tmp = 0;
      if (p[0] != ',') {
        // ok there is some sort of speed
        while (p[0] != '.' && p[0] != ',') {
          tmp *= 10;
          tmp += p[0] - '0';
          p++;       
        }
        tmp *= 10;
        if (isdigit(p[1])) 
          tmp += p[1] - '0'; // tenths
        tmp *= 10;
        if (isdigit(p[2])) 
        tmp += p[2] - '0'; // hundredths
        
        // tmp is knots * 100
        // convert to mph (1.15 mph = 1 knot)
        tmp *= 185;
        // -OR- convert km/h 
        // tmp *= 185
      } 
      tmp /= 100;
      
      buffer[34] = (tmp / 10000) + '0';
      tmp %= 10000;
      buffer[35] = (tmp / 1000) + '0';
      tmp %= 1000;
      buffer[36] = (tmp / 100) + '0';
      tmp %= 100;
      buffer[37] = '.';
      buffer[38] = (tmp / 10) + '0';
      tmp %= 10;
      buffer[39] = tmp + '0'; 
      buffer[40] = ',';
      
//bearing      
      p = strchr(p, ',')+1;
      tmp=0;
      if (p[0] != ',') {
        // ok there is some sort of bearing
        while (p[0] != '.' && p[0] != ',') {
          tmp *= 10;
          tmp += p[0] - '0';
          p++;       
        }
        tmp *= 10;
        if (isdigit(p[1])) 
          tmp += p[1] - '0'; // tenths
        tmp *= 10;
        if (isdigit(p[2])) 
        tmp += p[2] - '0'; // hundredths
      }
      buffer[41] = (tmp / 10000) + '0';
      tmp %= 10000;
      buffer[42] = (tmp / 1000) + '0';
      tmp %= 1000;
      buffer[43] = (tmp / 100) + '0';
      tmp %= 100;
      buffer[44] = '.';
      buffer[45] = (tmp / 10) + '0';
      tmp %= 10;
      buffer[46] = tmp + '0'; 
      buffer[47] = ',';
      
        
      p = strchr(p, ',')+1;
      // get date into 31/01/2001 style 
      buffer[48] = p[0];
      buffer[49] = p[1];
      buffer[50] =  '/';
      buffer[51] = p[2];
      buffer[52] = p[3];
      buffer[53] =  '/';
      buffer[54] =  '2';
      buffer[55] =  '0';
      buffer[56] = p[4];
      buffer[57] = p[5];
      buffer[58] =  ',';
      buffer[59] = '1' ;      if( !fix ) buffer[59] = '0';
      buffer[60] =  ',';
      
      buffer[61] ='\n'; //old: buffer[66] = '\n';
      buffer[62] = 0;   //old: buffer[67] = 0;
      
}

void card_init()
{ 
  if ( !card.init()        )   ;//Serial.println("\t Card init. failed!");   
  if ( !Fat16::init(&card) )   ;//Serial.println("\t No partition!"); 
  strcpy(buffer, "GPSLOG00.CSV");
  for (i = 0; i < 100; i++) {
    buffer[6] = '0' + i/10;
    buffer[7] = '0' + i%10;
    // create if does not exist, do not open existing, write
    if (f.open(buffer, O_CREAT | O_EXCL | O_WRITE)) break;
  }
  
  if(!f.isOpen()) { //Serial.print("/t Couldnt create "); 
                    //Serial.println(buffer);
                  }
  //Serial.print("writing to "); Serial.println(buffer);
  //Serial.println("ready!");

  // write header
  strncpy_P(buffer, PSTR("time,lat,long,speed,course,date,fix"), 35);
  //Serial.println(buffer);
  // clear write error
  f.writeError = false;
  f.println(buffer);
  if (f.writeError || !f.sync())   ;//Serial.println("\t Can't write header!");
  }
  
  
void card_write(char buffer[], int size)
{
   if(f.write((uint8_t*) buffer, size) != size) {
         //Serial.println("\t Can't write GPS data!");
	 return;
      }

      // clear write error
      f.writeError = false;      
      //f.println();
      
      if (f.writeError || !f.sync() )     //Serial.println("can't write data!");
      
}
