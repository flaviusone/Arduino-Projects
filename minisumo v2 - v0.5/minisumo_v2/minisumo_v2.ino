static float s=0,d=0;
#define viteza 100
#define vitezainainte 196
#define repetari 5 //pt  repetarile din foru de la citirelinie()
#define stanga 114
#define dreapta 108
#define pragsharp 220
#define praglinie 400

//int valoarelinie=400;  
#define start_pin 8 
#define pin_stanga_inainte 6
#define pin_stanga_inapoi 5
#define pin_dreapta_inainte 11
#define pin_dreapta_inapoi 10
#define pin_linie_dreapta 3
#define pin_linie_stanga 2
#define sharpstanga 0
#define sharpdreapta 1
#define pin_motor_stanga_inainte 6
#define pin_motor_stanga_inapoi 5
#define valoare_delay_millis2 100
#define pin_sharp_digital_stanga 2
#define pin_sharp_digital_dreapta 3

#define pwm_minim 10 // daca pwm e mai mic, motoarele primesc 0.
#define pin_motor_stanga_inainte 10
#define pin_motor_stanga_inapoi 11

#define pin_motor_dreapta_inainte 6
#define pin_motor_dreapta_inapoi  5

int xprec,x,y;
int linie_stanga,linie_dreapta;
unsigned long previousMillis = 0;
unsigned long previousMillis2 = 0;
unsigned long previousMillis3 = 0;
void setup(){
  pinMode(start_pin, INPUT);
  digitalWrite(start_pin, HIGH);   //turn on pull-up resistor
  pinMode(2,INPUT); //rosu
  pinMode(3,INPUT); //rosu
  pinMode(4,OUTPUT); //rosu
  pinMode(9,OUTPUT); //albastru
  //pinMode(4,OUTPUT);
  pinMode(5,OUTPUT);
  pinMode(6,OUTPUT);

  pinMode(10,OUTPUT);
  pinMode(11,OUTPUT);
  digitalWrite(5,LOW);
  digitalWrite(6,LOW);
  digitalWrite(10,LOW);
  digitalWrite(11,LOW);
  // delay(4000);
  Serial.begin(9600);     //pt debuging
  //asta e pt butonu de pornire delay
   while(1){
   if (digitalRead(start_pin) == 0){
   delay(4900);
   break;
   }
   
   }
   
  y=0;//default
}//setup()


void loop () {
  citirelinie();
  citiresharp();
  cautare();

  
}


void cautare(){
  //evitare, in functie de unde apare linia.
  if    ( (linie_stanga < praglinie) || (linie_dreapta < praglinie) )   
    evitare(); //evitare
  else
    atac();
} //cautare

void evitare(){
  inapoi();
  delay(300);
  //da robotu inapoi cu delay
}//evitare()



void atac(){
  //4 ifuri pt sharpuri


  if (s>pragsharp && d>pragsharp) //inainte
    x=3;
  else if (s>pragsharp && d<pragsharp) //rotire stanga
    x=1;
  else if(s<pragsharp && d>pragsharp) //rotire dreapta
    x=2;
  else //default rotire stanga
  x=0;
  // if senzori sharp fa miscare timp de x secunde ???
/*
  if ( x != y){
    if (millis() - previousMillis2 > valoare_delay_millis2 ){
      y=x;
      previousMillis2=millis();
    }       
  }
*/
  if(digitalRead(pin_sharp_digital_stanga) == 0 ){
    x=4; xprec=4;
    //drive(-200,200);
    //return;
  }
  if(digitalRead(pin_sharp_digital_dreapta) == 0 ){
    x=5; xprec=5;
    //drive(200,-200);    
    //return;
  }
  
  if ( xprec == 2 ){
      if (millis() - previousMillis3 > valoare_delay_millis2 ){
        x=10;
        xprec=x;  
        previousMillis3=millis();
         } 
    else x=xprec;      
    }
    
    if ( xprec == 4 || xprec==5 ){
      if (millis() - previousMillis2 > valoare_delay_millis2 ){
        x=10;
        xprec=x;  
        previousMillis2=millis();
         } 
    else x=xprec;      
    }
  switch (x){
  case 1:
    rotirestanga();
    break;
  case 2:
    rotiredreapta();
    break;
  case 3:
    inainte();
    break;
  case 4:
    drive(-200,200);
    break;
  case 5:
    drive(200,-200);
    break;  
  default :
    rotirestanga();
    //drive(0,0);
  }
  //xprec=x;
}//atac()

void citiresharp(){
  if (millis() - previousMillis > 40 ){
    s = analogRead(sharpstanga);
    d = analogRead(sharpdreapta);
    //if (s>350) s = 350; alte incercari
    //if (d>350) d = 350;
    previousMillis=millis();
    Serial.print("stanga ");
    Serial.print(s);
    Serial.print("     dreapta ");
    Serial.println(d);
  }
}//citiresharp()

void citirelinie(){
  int i;
  linie_stanga=0;
  linie_dreapta=0;
  for ( i=0 ; i<repetari ; i++){
    linie_stanga += analogRead(pin_linie_stanga);
    linie_dreapta += analogRead(pin_linie_dreapta);  
  }
  linie_stanga=linie_stanga/repetari;
  linie_dreapta=linie_dreapta/repetari;
}//citirelinie() 



void rotiredreapta(){
  drive(viteza,-viteza);
} 
void rotirestanga(){
  drive(-viteza,viteza);
} 
void inainte(){
  drive(vitezainainte,vitezainainte);
}
void inapoi(){
  drive(-viteza,-viteza); 
}


void drive(int _stanga, int _dreapta){

  //Nu e neaparat nevoie, daca avem grija cum dam comenzile
  _stanga  = constrain(_stanga,  -255,255);
  _dreapta = constrain(_dreapta, -255,255);


  //#define compensare_stanga 25
  if(_stanga >= -pwm_minim && _stanga <= pwm_minim){
    digitalWrite(pin_motor_stanga_inapoi, LOW);
    digitalWrite(pin_motor_stanga_inainte, LOW);
  }
  else if(_stanga > 0) {
    analogWrite(pin_motor_stanga_inapoi,     0);
    analogWrite(pin_motor_stanga_inainte, _stanga ); //-25
  }
  else {
    analogWrite(pin_motor_stanga_inainte,    0);
    analogWrite(pin_motor_stanga_inapoi, -_stanga + 0);
  }


  //#define compensare_dreapta 0
  if(_dreapta >= -pwm_minim && _dreapta <= pwm_minim){
    digitalWrite(pin_motor_dreapta_inapoi, LOW);
    digitalWrite(pin_motor_dreapta_inainte, LOW);
  }
  else if(_dreapta > 0) {
    analogWrite(pin_motor_dreapta_inapoi,  0);
    analogWrite(pin_motor_dreapta_inainte, _dreapta - 0);
  }
  else{
    analogWrite(pin_motor_dreapta_inainte,  0);
    analogWrite(pin_motor_dreapta_inapoi, -(_dreapta )); //35
  }  
}//void drive(,)






