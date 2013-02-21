
//#include "sumo” si “lasertag” nu sunt necesari
#include <avr/pgmspace.h>  //biblioteca pentru PROGMEM (sa memorez vectorul pe flash)

#define fotodioda_pin A4

//pini pe arduino la care sunt conectati
#define alege 16      //Switch care comuta intre programe. Se leaga la masa.
#define start_pin 3  //(preferabil) switch, care da startul cand e comutat/apasat (adica legat la masa)

//pinii pt controlul motoarelor. S-ar putea schimba, in functie de driverul folosit.
#define motorSt_dir  10    
#define motorSt_pwm  11
#define motorDr_dir 6    //directie
#define motorDr_pwm 5    //pwm, pt viteza

//pinii pt multiplexor
#define pinA 4
#define pinB 7
#define pinC 8

//Lungimile maxime vazute de senzorii Sharp
#define max_Sharp_lung 60
#define max_Sharp_scurt 36

#define fire_pin 19 //laser start
int tsl_info=0;
int fotodioda_mediu;

//Variabile globale:
boolean linie[4];
byte distanta[4];

void setup(){
   //implicit totul e INPUT
   motor_init();
   pinMode(pinA, OUTPUT);
   pinMode(pinB, OUTPUT);
   pinMode(pinC, OUTPUT);
   
   pinMode(fire_pin, OUTPUT);
   digitalWrite(fire_pin, LOW);
      
   digitalWrite(alege, HIGH);       //turn-on pull-up resistor
   digitalWrite(start_pin, HIGH);   //turn-on pull-up resistor

   int aux=0;
   for(int i=0;i<10;i++) aux+=analogRead(fotodioda_pin);
   fotodioda_mediu=aux/10;
   
   

   Serial.begin(9600);//pt debuging
   Serial.println("Booting up!");

   
   if (digitalRead(start_pin) == HIGH) {
     while(digitalRead(start_pin)==HIGH);  //asteapta o apasare pe buton/schimbarea butonului
     delay(5000); //5 sec.
   }//in caz ca se reseteaza, nu mai trece prin delay()
   
     
}//setup()


void loop(){
  
  if (digitalRead(alege) == HIGH)  {
          while(1)   {//Serial.println("Sumo");
                      sumo();  }
  } else {Serial.println("Lasertag");
          lasertag_setup();
          while(1)   lasertag();
  }
  
  
}


void motor_init() {
   pinMode(motorSt_dir, OUTPUT);    //pinii motoarelor sunt de iesire
   pinMode(motorSt_pwm, OUTPUT);
   pinMode(motorDr_dir, OUTPUT);
   pinMode(motorDr_pwm, OUTPUT);
   
   digitalWrite(motorSt_dir, LOW);  //oprim toate motoarele
   digitalWrite(motorSt_pwm, LOW);
   digitalWrite(motorDr_dir, LOW);
   digitalWrite(motorDr_pwm, LOW);
}

#define motor_max 80     //%
#define motor_speed 255  //0-255
#define motor_delay 100  //intervalul min ce treb sa treaca inainte sa schimbam directia
/*
void drive(int m2, int m1) {
  static unsigned long last_St=0,last_Dr=0;
  
if(millis()-last_St > motor_delay){
  last_St=millis();
  if (m1<0) {
             digitalWrite(motorSt_dir, HIGH);   //reverse
             analogWrite(motorSt_pwm, motor_speed);
            }
  
  else  if(m1>0) {
             digitalWrite(motorSt_dir, LOW);    //go forward
             analogWrite(motorSt_pwm, motor_speed); 
            }
     
   else digitalWrite(motorSt_pwm, LOW);
}
if(m1==0) {digitalWrite(motorSt_pwm, LOW);
           last_St=millis();
          }
        
        

if(millis()-last_Dr > motor_delay){
  last_Dr=millis();    
  if (m2<0) {
             digitalWrite(motorDr_dir, HIGH);   //reverse
             analogWrite(motorDr_pwm, motor_speed);
            }
  
  else  if(m2>0) {
             digitalWrite(motorDr_dir, LOW);    //go forward
             analogWrite(motorDr_pwm, motor_speed); 
            }
     
   else digitalWrite(motorDr_pwm, LOW);
}
if(m2==0) {digitalWrite(motorDr_pwm, LOW);
           last_Dr=millis();
          }
            
  
}//drive() */

// drive pt puntile H
#define motor_speed_dr 191
void drive(int m1, int m2) {  
   static unsigned long last_St=0,last_Dr=0;
  
if(millis()-last_St > motor_delay){
  last_St=millis();
  if(m1==-motor_max) {digitalWrite(motorSt_dir,HIGH);
                      digitalWrite(motorSt_pwm,LOW);
                      //analogWrite(motorSt_pwm,motor_speed);
                     }
     else                
  if(m1== motor_max) {//analogWrite(motorSt_dir,255-motor_speed);
                      digitalWrite(motorSt_dir,LOW);
                      digitalWrite(motorSt_pwm,HIGH);
                     }
     else           
                    {digitalWrite(motorSt_dir,LOW);
                     digitalWrite(motorSt_pwm,LOW);
                    }
}
if(m1==0) {digitalWrite(motorSt_dir,LOW);
           digitalWrite(motorSt_pwm,LOW);
          }


if(millis()-last_Dr > motor_delay){
  last_Dr=millis();    
  
  if(m2==-motor_max) {digitalWrite(motorDr_dir,LOW);
                      //digitalWrite(motorDr_pwm,HIGH);
                      analogWrite(motorDr_pwm,motor_speed_dr);
                     }
     else                
  if(m2== motor_max) {
                      digitalWrite(motorDr_pwm,LOW);
                      //digitalWrite(motorDr_dir,HIGH);
                      analogWrite(motorDr_dir,motor_speed_dr);
                     }
     else           
                    {digitalWrite(motorDr_dir,LOW);
                     digitalWrite(motorDr_pwm,LOW);
                    }
}

if(m2==0) {digitalWrite(motorDr_dir,LOW);
           digitalWrite(motorDr_pwm,LOW);
          }
}//drive() punti H */



/* PWM control
void drive(int m1, int m2) {
  if (m1<0) {
         m1=-m1;
         digitalWrite(motorSt_dir, LOW);   //reverse
  } else digitalWrite(motorSt_dir, HIGH);    //go forward
  
  if (m2<0) {
         m2=-m2;
         digitalWrite(motorDr_dir, LOW);
  } else digitalWrite(motorDr_dir, HIGH);
  
  //if(m1>100) m1=100;  //de testat daca e necesar
  //if(m2>100) m2=100;
  
  if (m1<2) analogWrite(motorSt_pwm, 0);           //in caz ca ajunge 1, de la vreo impartire
     else   analogWrite(motorSt_pwm, m1*255/100);  //pwm merge 0:255, noi folosim 0:100
  if (m2<2) analogWrite(motorDr_pwm, 0);
     else   analogWrite(motorDr_pwm, m2*255/100);
    
}//drive() */


#define nr_valori 4          //facem media a ultimelor xx masuratori
void update_Sharp() { //face update la vectorul global cu distante(cm) citite de senzorii Sharp

  
  static int citiri[4][nr_valori]={0}, i=0; 
  static int suma[4]={0,0,0,0};
  static int temp;
  
  digitalWrite(pinC, LOW); //intrarea C de la multiplexor--e mereu LOW pt iesirile 0-3
  
  static byte c; //contor  
  for (c=0; c<=3; c++) {

    digitalWrite(pinA, (c) & 0x01);
    digitalWrite(pinB, (c>>1) & 0x01);
    
    suma[c]=suma[c]-citiri[c][i];  //scad valoarea veche
    citiri[c][i]=analogRead(A0);   //pun una mai actuala
    suma[c]=suma[c]+citiri[c][i];
    
    //if(suma[c]<15) Serial.println(suma[c]/nr_valori);
    temp=analog_to_cm((suma[c]/nr_valori), c/2?0:1);   //al doilea argument e tipul senzorului: 1 pt senzori de departare, 0 - de apropiere
    
    if ( (c==0) || (c==1) )
      if ( (temp>17) && (temp<136) ) distanta[c]=temp;
    if ( (c==2) || (c==3) )
      if ( (temp>3) && (temp<42) ) distanta[c]=temp;
      
    //Serial.print(" v");
    //if(analog_to_cm(analogRead(A0), c/2?0:1)>40)Serial.print(analogRead(A0), DEC);Serial.print(" ");
    //Serial.print(analog_to_cm(analogRead(A0), c/2?0:1),DEC);
    //Serial.print(distanta[c],DEC);  Serial.print("\t");
  }
  i++;
  if(i>=nr_valori) i=0;
  //Serial.println();
  
}//update_Sharp()



//conversie analogic -> cm
byte analog_to_cm(int valoare_analog, boolean tip_senzor) {
  //valoare_analog - valoarea primita de la senzor
  //tip_senzor - 0 pentru senzor de apropiere sau 1 pentru cel de departare
  // algoritmul este destul de imprecis dar foarte rapid

  static PROGMEM prog_uchar distanta_lunga[]={131,126,120,116,111,107,103,99,96,93,90,87,84,82,79,77,75,73,71,69,67,66,64,63,61,60,58,57,56,55,53,52,51,50,49,48,47,47,46,45,44,43,43,42,41,40,40,39,38,38,37,37,36,36,35,35,34,34,33,33,32,32,31,31,31,30,30,29,29,29,28,28,28,27,27,27,26,26,26,25,25,25,25,24,24,24,24,23,23,23,23,22,22,22,22,22,21,21,21,21,21,20,20,20,20,20,19,19,19,19,19};
  static PROGMEM prog_uchar distanta_scurta[]={39,37,35,33,31,30,29,27,26,25,24,23,22,22,21,20,19,19,18,18,17,17,16,16,15,15,15,14,14,14,13,13,13,12,12,12,12,11,11,11,11,10,10,10,10,10,10,9,9,9,9,9,9,8,8,8,8,8,8,8,8,7,7,7,7,7,7,7,7,7,7,6,6,6,6,6,6,6,6,6,6,6,6,6,6,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,4,4,4,4,4,4};
  
  // in cei doi vectori am precalculat distantele pentru diferite tensiuni
  //vectorii au fiecare 111 elemente, pot sa-i maresc usor daca vreti pentru a marii precizia 
  //primul vector e pentru senzorul de distanta iar cel de-a doilea e pentru cel de apropiere
  //Serial.print(valoare_analog,DEC); Serial.print("\t"); Serial.println(tip_senzor,DEC);
  if (tip_senzor){ //pentru senzorul de departare
    if (valoare_analog<105) return 132; //daca iese din raza de actiune returnez 132 cm
    if (valoare_analog>550) return 18;  //daca se apropie prea tare returnez 18 cm
    return( pgm_read_byte_near(distanta_lunga + (valoare_analog-105)/4  -1 ) ); //returneaza valoarea din vector corespunzatoare tensiunii
  }
  else{
    if (valoare_analog<80) return 40;  //daca iese din raza de actiune returneaza 40 cm
    if (valoare_analog>600) return 3;  //daca se apropie prea tare returneaza 3 cm
    return( pgm_read_byte_near(distanta_scurta + (valoare_analog-80)/4  -1) ); //returneaza valoarea din vector corespunzatoare tensiunii
  }
};//analog_to_cm(,)






#define white_limit 380
void update_linie(){
  
  digitalWrite(pinC, HIGH); //pinul C este HIGH pt intrarile 4-7

     digitalWrite(pinA, LOW);
     digitalWrite(pinB, LOW);

     linie[3] = (analogRead(A0) < white_limit);
     //Serial.print("2.");
     //Serial.print(analogRead(A0));
     //Serial.print("\t");
     
     

     digitalWrite(pinA, LOW);
     digitalWrite(pinB, HIGH);

     linie[2] = (analogRead(A0) < white_limit);
     //Serial.print("1.");
     //Serial.print(analogRead(A0));
     //Serial.print("\t");
     
     

     digitalWrite(pinA, HIGH);
     digitalWrite(pinB, LOW);

     linie[1] = (analogRead(A0) < white_limit);
     //Serial.print("0.");
     //Serial.print(analogRead(A0));
     //Serial.print("\t");
     
     

     digitalWrite(pinA, HIGH);
     digitalWrite(pinB, HIGH);


     linie[0] = (analogRead(A0) < white_limit);
     //Serial.print("3.");
     //Serial.print(analogRead(A0));
     //Serial.print("\t");
    
}//update_linie()

