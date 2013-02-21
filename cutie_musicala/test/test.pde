int potpin = 0;
int valoare;
void setup()
{
  pinMode(1, OUTPUT);
  pinMode(2, OUTPUT);
  pinMode(3, OUTPUT);
  pinMode(4, OUTPUT);
  pinMode(5, OUTPUT);
  pinMode(6, OUTPUT);
  pinMode(7, OUTPUT);
  pinMode(8, OUTPUT);
  pinMode(9, OUTPUT);
  pinMode(10, OUTPUT);
 
     }
void loop()
{
  valoare = analogRead(potpin);            
  valoare = map(valoare, 0, 1023, 1, 10);
 

for (int i=1; i <= 10; i++){
if (valoare == i) {
  digitalWrite(i,   HIGH);
}
else
{
  digitalWrite(i,   LOW);
}
}
 
   //for (int i=0; i <= 12; i++){
 //     digitalWrite(i,   LOW);
 //     delay(10);
 //  } 
//  for (int i=12; i >= 1; i--){
 //     digitalWrite(i,   HIGH);
 //     delay(10);
//   } 


 
 
 
  
}
