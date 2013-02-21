import processing.serial.*;

String buff = "";
int val = 0;
int NEWLINE = 10;
int xPos,yPos,zPos = 0;
int displaySize = 1;
int an1, an2, an3;
//an1 pot; an2 ir;

Serial port;

void setup(){
background(80);
size(800,600);
smooth();

port = new Serial(this, Serial.list()[1], 9600);
}

void draw(){
// new background over old
fill(80,5);
noStroke();
rect(0,0,width,height);

// wipe out a small area in front of the new data
fill(80);
rect(xPos+displaySize,0,50,height);

// check for serial, and process
while (port.available() > 0) {
serialEvent(port.read());
}

}


void serialEvent(int serial) {
//print("A"); //header variable, so we know which sensor value is which
//println(an1); //send as a ascii encoded number - we'll turn it back into a number at the other end
//Serial.print(10, BYTE); //terminating character

print("B"); //header variable, so we know which sensor value is which
println(an2); //send as a ascii encoded number - we'll turn it back into a number at the other end
//Serial.print(10, BYTE); //terminating character


if(serial != '\n') {
buff += char(serial);
}
else {
int curX = buff.indexOf("X");
int curY = buff.indexOf("Y");


if(curX >=0){
String val = buff.substring(curX+1);
an1 = Integer.parseInt(val.trim());

xPos++;
if(xPos > width) xPos = 0;

sensorTic1(xPos,an1);
}
if(curY >=0){
String val = buff.substring(curY+1);
an2 = Integer.parseInt(val.trim());

yPos++;
if(yPos > width) yPos = 0;



sensorTic2(yPos,an2);
}

// Clear the value of "buff"
buff = "";
}
}

void sensorTic1(int x, int y){
stroke(0,0,255);
fill(0,0,255);
ellipse(x,y,displaySize,displaySize);
}

void sensorTic2(int x, int y){
stroke(255,0,0);
fill(255,0,0);
ellipse(x,y,displaySize,displaySize);
} 
