#include <Servo.h> 
Servo servostanga;  
Servo servodreapta;
float s=0,d=0;
int stanga=114;
int dreapta=108;
int x=200;
void setup() 
{
  Serial.begin(9600);
}
void loop(){
  delay(4000);
  scanare();
}
void scanare(){
  servodreapta.attach(10);
  servostanga.attach(11); 
  citire();
  afisare();
  if ( s > x) {
    for(;;){
      rotirestanga();
      citire();
     afisare();
      if((s>x) && (d> x))break;
    }
    atac();
  }
  else{
    for(;;){

      rotiredreapta();
      citire();
     afisare();
      if ((s>x) && (d>x)) break;
    }
    atac();
  }


}
void atac(){
  for(;;){
//    delay(100);
    servostanga.write(stanga - 86);
    servodreapta.write(dreapta - 92);
    citire();
 //   afisare();
    if( (s<x) || (d<x) ) break;
  }
  scanare();
}   
void citire(){
  s=0;d=0;
  for(int i=0; i<5 ;i++){
    s=s+ analogRead(0);
    d=d+ analogRead(1);
  }
  s=s/5;
  d=d/5;
}
void rotirestanga(){
 // delay(100);
  servostanga.write(stanga + 86);
  servodreapta.write(dreapta - 92); 
} 
void rotiredreapta(){
//  delay(100);
  servostanga.write(stanga - 86);
  servodreapta.write(dreapta + 92); 
} 

void afisare(){
	static unsigned long last_millis =0;

  if(millis()>last_millis+1000){ //o data pe secunda
  Serial.print(s);
  Serial.print("\t");
  Serial.print(d);
  Serial.println("\t");
	last_millis=millis();
  }
}






