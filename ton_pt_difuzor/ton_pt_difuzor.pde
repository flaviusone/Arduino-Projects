int i;
void setup()   {  
}  

void loop()                     
{
      for ( i = 0 ; i<5001 ; i++) {
    tone(8,i,1000);
    delay(100);
  }
}
