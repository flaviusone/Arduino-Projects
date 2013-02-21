/******** tun_servo: *********/
#define tun_pin 9 //pinul(cu PWM) al servoului
#define servo_refresh 700//ms ii trebuie servoului sa ajunga la capat
#define tun_servo_min  20
#define tun_servo_max 170

#include <Servo.h>
Servo tun;
byte tun_min=tun_servo_min;
byte tun_max=tun_servo_max;  //0:180, unde scaneaza tunul. Se pot schimba, pt maxim tun_insist (ms)
unsigned long tun_change;    //var. careia trebuie sa ii dai =millis() cand schimbi unghiurile
#define  tun_insist  1500  
/****************************/




#define led_pin 13
//#define 


//var globale
volatile unsigned long last_pulse=0;  //var globala
volatile boolean dead=false;          // true cand am fost loviti de laser 

void lasertag_setup(){
  pinMode(led_pin,OUTPUT);
  digitalWrite(led_pin,HIGH);
  digitalWrite(fire_pin,HIGH);
  
  
  tun.attach(tun_pin);
  attachInterrupt(0,tsop,FALLING); //digital pin 2
  
}

void lasertag(){
  //Serial.println("Lasertag");
  
  update_servo();
  update_linie();
  update_Sharp();
  //update_tsl();
  if (tsl_info==1) Serial.print(tsl_info);
  //curca_beata();
  cautare();
  //lasert();
  
  
    if(dead){
        drive(0,0);
        detachInterrupt(0);
        tun.write(tun.read()); //stop tun
        digitalWrite(fire_pin,LOW);
        digitalWrite(led_pin,LOW);
        drive(0,0);
        
        
        delay(5000);
        
        
        digitalWrite(fire_pin,HIGH);
        unsigned long m1=millis();
        while(millis()-m1<1900){  //invulnerabilitate
            update_servo();
            drive(-motor_max, motor_max);
        }
            
        drive(0,0);
        delay(199);
        digitalWrite(led_pin,HIGH);
        attachInterrupt(0,tsop,FALLING);
        dead=false;
    }//..and we're back
        
        
 
  
  
}//lasertag()

void update_tsl() {
  int foto;
  static int iterator=0;
  static int medie=0;
  static int last_light=0;
  foto=analogRead(fotodioda_pin);
  medie+=foto;
  iterator++;
  if (iterator==5) {
    iterator=0;
    medie/=5;
    if (millis()-last_light>5000) {tsl_info=0; fotodioda_mediu=medie; } 
    if (medie<fotodioda_mediu-10) {tsl_info=1; last_light=millis(); }
    else tsl_info=0;
    medie=0;
  }
}
  


void update_servo(){
  static unsigned long last_updated=0;  //"ora" ultimei apelari
  if (tsl_info==1) {
    tun_change=millis();
    tun_min=70;
    tun_max=110;
  };
  if(millis()-tun_change > tun_insist){
    tun_min=tun_servo_min;
    tun_max=tun_servo_max;
  }
  
  if(millis()-last_updated > servo_refresh) {           //daca e timpul sa schimbe unghiul
      if(tun.read()!=tun_min && tun.read()!=tun_max){      //atunci tunul are alte limite, noi
          tun.write(tun_max);
          last_updated=millis();
          return;
      }else{
          if(tun.read()==tun_min) tun.write(tun_max);    
                      else        tun.write(tun_min);
          last_updated=millis();
          return;
      }
                      
    
  }
  
}//update_servo()


void tsop(){  //functia se executa la fiecare trecere 1->0 a senzorului
   if(!dead)
   if( micros()-last_pulse < 2100 )
     dead=true;

   last_pulse=micros(); 
}

void curca_beata() {
  static int comanda;
  static unsigned long timp_comanda=0;
  static int frica_fata=18;
  static int frica_spate=10;
  if (millis()>timp_comanda) {
    timp_comanda=millis()+random(1000,5000);
    comanda=random(4);
  }
  if (comanda==0) {
    if ( (linie[0]) || (linie[1]) || (distanta[0]<frica_fata) || (distanta[1]<frica_fata) ) {
     timp_comanda=0;
     return;
    }
    drive(motor_max,motor_max);
  }
  if (comanda==1) {
    if ( (linie[2]) || (linie[3]) || (distanta[2]<frica_spate) || (distanta[3]<frica_spate) ) {
     timp_comanda=0;
     return;
    }
    drive(-motor_max,-motor_max);
  }
  if (comanda==2) {
    drive(motor_max,-motor_max);
  }
  if (comanda==3) {
    drive(-motor_max,motor_max);
  }
}

#define timp_rotatie_90 820
#define timp_detect_loop 10000


void lasert(){
	
static int state=13;
static long int last_time;

// CHECK FOR LOOP

if (last_time + timp_detect_loop < millis()) {
	state =  8;
	last_time = millis();
}

// ATAC

if (tsl_info == 1) {
	state = 10;
	last_time = millis();
}

if (tsl_info == 2) {
	state = 11;
	last_time = millis();
}

if (tsl_info == 3) {
	state = 12;
	last_time = millis();
}

if(tsl_info == 4) {
	state = 1;
	last_time = millis();
	tsl_info = 0;
}

// ATENTIE LA LINIE

if (state != 2 || state != 3){
	if (linie[0] == 1 || linie[3] == 1 ) {
		drive(motor_max, 0);
	}
	else
	if (linie[2] == 1 || linie[3] == 1) {
			drive(motor_max, motor_max);
	}
	else {
		state = 1;
		last_time = millis();
	}
}

if (state != 5 || state != 8 || state != 6 || state != 9) {
	if (linie[0] == 1 || linie[1] == 1) {
		state = 9;
		last_time = millis();
	}
	else
	if (linie[1] == 1 || linie[2] == 1) {
		drive(0, motor_max);
	}	
	else {
		state = 1;
		last_time = millis();
	}
}

// CAZURI

switch (state) {
	case 0: {
		if(last_time > millis()){
			drive(-motor_max, motor_max);
		}
		else {
			state++;
			last_time = millis();
		}

	}
	break;
	
	case 1: {
		if (distanta[0] > 128) {
			drive(-motor_max, motor_max);
		}
		else 
		if (distanta[0] < 128 && distanta[0] < distanta[1] - 30 && linie[0] == 0) {
			drive(motor_max, motor_max);
		}
		else {
			state++;
			last_time = millis();
		}
	}	
		break;
		
	case 2: {
		if (linie[0] == 1 && linie[3] == 0) {
			drive(motor_max, 0);
		}
		else {
			state++;
			last_time = millis();
		}
	}
		break;
		
	case 3: {
		if (linie[3] == 1) {
			drive(motor_max, motor_max);
		}
		else {
			state++;
			last_time = millis();
		}
	}
		break;
		
	case 4: {
		if (distanta[0] > 128 && distanta[1] > 128 && last_time + timp_rotatie_90 - 200 > millis()) {
			drive(0, motor_max);
		} 
		else {
			state++;
			last_time = millis();
		}
	}
		break;
		
	case 5: {
		if (linie[0] == 0 || linie[1] == 0) {
			drive(motor_max, motor_max);
		}
		else {
			state++;
			last_time = millis(); 
		}
	}
		break;
		
	case 6: {
		if ( (linie[0] == 1 || linie[1] == 1) && last_time + 100 > millis()) {
			drive(-motor_max, -motor_max);
		}
		else {
			state++;
			last_time = millis();
		}
	}
		break;
		
	case 7: {
		if (last_time + timp_rotatie_90 > millis()) {
			drive(-motor_max, motor_max);
		}
		else {
			state++;
			last_time = millis();
		}
	}
		break;

	case 8: {
		if (linie[0] == 0 || linie[1] == 0) {
			drive(motor_max, motor_max);
		}
		else {
			state++;
			last_time = millis(); 
		}
	}
		break;
		
	case 9: {
		if ( (linie[0] == 1 || linie[1] == 1) && last_time + 100 > millis()) {
			drive(-motor_max, -motor_max);
		}
		else {
			state = 1;
			last_time = millis();
		}
	}
		break;

		
// CAZURI SPECIALE:
	
	case 10:{
		if (tsl_info != 4 && ( linie[0] == 0 || linie[1] == 0 ||  distanta[0] > 16 || distanta[1] > 16) ) {
			drive(motor_max, motor_max);
		}
		else {
			state = 1;
			last_time = millis();
		}
	}		
		break;
	
	case 11:{
		if (last_time + timp_rotatie_90 > millis()) {
			drive(-motor_max, motor_max);
		}
		else {
			state = 10;
			last_time = millis();
		}
	}
		break;
		
	case 12:{
		if (last_time + timp_rotatie_90 > millis()) {
			drive(motor_max, -motor_max);
		}
		else {
			state = 10;
			last_time = millis();
		}
	}
		break;
		
		
	case 13:{
		last_time = millis() + timp_rotatie_90 * 4;
		state = 0;
	}
		break;
	
}

}
