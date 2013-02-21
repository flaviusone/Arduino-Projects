int val = 0;

#define NUMREADINGS 10

int readings[NUMREADINGS];          
int index = 0;                          
int total = 0;                          
int average = 0;

void setup() {
  Serial.begin(9600);
for (int i = 0; i < NUMREADINGS; i++)
readings[i] = 0;  
pinMode(13, OUTPUT);
pinMode(12, OUTPUT);
pinMode(11, OUTPUT);
pinMode(10, OUTPUT);
pinMode(9, OUTPUT);
pinMode(8, OUTPUT);
}

void loop(){
total -= readings[index];          
readings[index] = analogRead(2);
total += readings[index];        
index = (index + 1);            

if (index >= NUMREADINGS)            
index = 0;    

average = total / NUMREADINGS; 


val = analogRead(0);
Serial.println(val);
delay(100);
if(average > val){
digitalWrite(13, HIGH);
} else{
digitalWrite(13, LOW);
}

if(average > val+10){
digitalWrite(12, HIGH);
digitalWrite(13, HIGH);
} else{
digitalWrite(12, LOW);
digitalWrite(13, LOW);
}

if(average > val+30){
digitalWrite(11, HIGH);
digitalWrite(12, HIGH);
digitalWrite(13, HIGH);
} else{
digitalWrite(11, LOW);
digitalWrite(12, LOW);
digitalWrite(13, LOW);
}

if(average > val+55){
digitalWrite(10, HIGH);
digitalWrite(11, HIGH);
digitalWrite(12, HIGH);
digitalWrite(13, HIGH);
} else{
digitalWrite(10, LOW);
digitalWrite(11, LOW);
digitalWrite(12, LOW);
digitalWrite(13, LOW);
}

if(average > val+80){
digitalWrite(9, HIGH);
digitalWrite(10, HIGH);
digitalWrite(11, HIGH);
digitalWrite(12, HIGH);
digitalWrite(13, HIGH);
} else{
digitalWrite(9, LOW);
digitalWrite(10, LOW);
digitalWrite(11, LOW);
digitalWrite(12, LOW);
digitalWrite(13, LOW);
}

if(average > val+100){
digitalWrite(8, HIGH);
digitalWrite(9, HIGH);
digitalWrite(10, HIGH);
digitalWrite(11, HIGH);
digitalWrite(12, HIGH);
digitalWrite(13, HIGH);
} else{
digitalWrite(8, LOW);
digitalWrite(9, LOW);
digitalWrite(10, LOW);
digitalWrite(11, LOW);
digitalWrite(12, LOW);
digitalWrite(13, LOW);
}

}
