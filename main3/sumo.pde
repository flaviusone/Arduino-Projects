
void sumo(){
  static byte c=0;  //aici numar 100cicluri
  unsigned long m1; //ms, pt contorizarea celor 100cicluri
  

  update_linie();
  update_Sharp();
  //distanta[2]=distanta[3]=40;
  
  if(!atac()) cautare();
  /*if(Serial.available()){
  char c=Serial.read();
  drive(motor_max, motor_max);
  delay(c*10);
  Serial.println(c*10,DEC);
  drive(0,0);
  }
  */
if(c>=70){
  
  m1=millis()-m1;
  //print linie (boolean)
  byte i;
  for(i=0; i<4; i++) {
    Serial.print(linie[i],DEC);
    Serial.print("\t");
  }
  
  Serial.print("\t\t");
  
  //Print Sharp (cm)
  for(i=0; i<4; i++) {
    Serial.print(distanta[i],DEC);
    Serial.print("\t");
  }  
  
  Serial.print(m1);
  Serial.println();
  //delay(300);
  //Serial.println("Sumo");
  
  c=0;
  m1=millis();
}//numarare
else c++;

}



#define timp_atac 3000 //ms-- cat timp algoritmul ar trebui sa mai incerce sa caute singur

boolean atac() {  //returnez daca algoritmul vrea sa renunte
  
  //Serial.print("Atac!!");
  digitalWrite(13, HIGH);
  static unsigned long last_attack=0,timeout;
  static byte last_seen,epsilon=50,obiect_aproape_fata=22,obiect_aproape_spate=10;
  static byte epsilon2=15;
  long minim=distanta[0],p=0;;
  
  if (timeout>millis())  return 0;
 
  for(int i=0;i<=1;i++) {  
    if (minim>distanta[i])  {
      minim=distanta[i]; 
      p=i;
    }
    if (linie[i]) { 
       timeout=millis()+timp_atac;
        return 0;
    }
  }
    
    
   for(int i=2;i<=3;i++) { 
    if ( (minim>distanta[i]) && (distanta[i]<max_Sharp_scurt-10) ) {
      minim=distanta[i]; 
      p=i;
    }
      if  (linie[i])   {
        timeout=millis()+timp_atac;
        return 0;
      }
    }
   
    
    
  if ((p==0) && (distanta[0]<max_Sharp_lung)) {
    if (abs(distanta[1]-distanta[0])<epsilon) {drive(motor_max,motor_max); last_attack=millis(); return 1;}
    else { drive(0,motor_max);           last_attack=millis();  last_seen=0; return 1;}
  };
  if ((p==1) && (distanta[1]<max_Sharp_lung)) {
    if (abs(distanta[1]-distanta[0])<epsilon) {drive(motor_max,motor_max); last_attack=millis(); return 1;}
    else { drive(motor_max,0);           last_attack=millis();  last_seen=1; return 1;}
  };
  if ((p==2) && (distanta[2]<max_Sharp_scurt)) {
    if (abs(distanta[3]-distanta[2])<epsilon2) {drive(-motor_max,-motor_max); last_attack=millis(); return 1;}
    else { drive(0,-motor_max);           last_attack=millis();  last_seen=2; return 1;}
  };
  if ((p==3) && (distanta[3]<max_Sharp_scurt)) {
    if (abs(distanta[3]-distanta[2])<epsilon2) {drive(-motor_max,-motor_max); last_attack=millis(); return 1;}
    else { drive(-motor_max,0);           last_attack=millis();  last_seen=3; return 1;}
  };
    
  if(millis()-last_attack < timp_atac){
    if (last_seen==0 && !linie[0] ) { drive(motor_max,0);  return 1;}
    if (last_seen==1 && !linie[1] ) { drive(0,motor_max);  return 1;}
    if (last_seen==2 && !linie[2] ) { drive(-motor_max,0); return 1;}
    if (last_seen==3 && !linie[3] ) { drive(0,-motor_max); return 1;}
  }
  
  
  drive(0,0);
  return 0; // renunt

}




#define timp_rotatie_170 1220
#define timp_rotatie_100 830
#define timp_miscare      320  // 1200

void cautare(){
  
  digitalWrite(13,LOW);

 //Serial.println("Caut");
static unsigned long run_time = 0;//millis(); //+ timp_miscare; // run_time = pana cand va dura primul caz in timp
static int x = 6; //cazul de start; va trece imediat in cazul 1; --pt start cu run_time corect

//evitare, in functie de unde apare linia.
if	( (linie[0] == 1) || (linie[1] == 1) ) {   
	x = 5;  //cu spatele
}

if	( (linie[0] == 1) && (linie[3] == 1) ) {
	x = 4;  //rasucire
}

if	( (linie[1] == 1) && (linie[2] == 1) ) {
	x = 6; //rasucire
}

if	( (linie[2] == 1) || (linie[3] == 1) ) {
	x = 1;  //cu fata
}


switch (x) {
	case 1:																			// Cazul 1: 
		if (run_time > millis()) {													//	Robotul va inainta
			drive(motor_max, motor_max);
		} 
		else {
			x++;
			run_time = ( millis() + random(timp_rotatie_100, timp_rotatie_170) );
		}
		break;

	case 2:																			// Cazul 2:
		if (run_time > millis()) {													//	Robotul se va intoarce
			drive(0, motor_max);													//	cu 100-170 grade la stanga
		}
		else {
			x++;
			run_time = ( millis() + timp_miscare * 2 );
		}
		break;
		
	case 3:																			// Cazul 3:
		if (run_time > millis()) {													//	Robotul va inapoia
			drive(-motor_max,-motor_max);
		}
		else {
			x++;
			run_time = ( millis() + random(timp_rotatie_100, timp_rotatie_170) );
		}
		break;

	case 4:																			// Cazul 4:
		if (run_time > millis()) {													//	Robotul se va intoarce
			drive(-motor_max, 0);													//	cu 100-170 grade la stanga
		}																//	cu spatele
		else {
			x++;
			run_time = ( millis() + timp_miscare );
			}
		break;
			
	case 5:																			// Cazul 5:
		if (run_time > millis()) {													//	Robotul va inapoia
			drive(-motor_max,-motor_max);
			}
		else {
			x++;
			run_time = ( millis() + random(timp_rotatie_100, timp_rotatie_170) );
		}
		break;
							
	case 6:																			// Cazul 6:
		if (run_time > millis()) {													//	Robotul se va intoarce
			drive(-motor_max, 0);													//	cu 100-170 grade la stanga
		}																//	cu spatele apoi va reveni 
		else {																//	la cazul 1
			x=1;
			run_time = ( millis() + timp_miscare );
		}
		break;  
    }//switch(x)
    
}//cautare()

