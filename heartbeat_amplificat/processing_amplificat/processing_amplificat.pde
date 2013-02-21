import processing.serial.*;


Serial port; // Create object from Serial class

int val; // Data received from the serial port

int WIDTH=800; // set width

int number=0;

int num[] = new int[3];

int points[]= new int[WIDTH]; // points to be drawn from incoming data

char beat=' ';

int beats=0;

int dropNum[] = new int[4]; // array used to compare data not needed

void setup()
{
println(Serial.list());
size(WIDTH, 700);
frameRate(30);
// Open the port that the board is connected to and use the same speed (9600 bps)
port = new Serial(this,Serial.list()[1], 9600);
}

void draw()
{
background(0);// to erase
port.write('a');
if (2 < port.available()) { // wait for three bytes
for (int i=0;i<3;i++){
num[i] = port.read(); // read them into an array
}
//println( num[0]);
//println( num[1]);
number = (num[0] << 8)+num[1]; // num range add two incoming bytes together after shifting
beat = (char) num[2]; // look to see if there is a 'b' to signal a beat
println(beats);
}
stroke(0,255,100); // color stroke
if (beat == 'b'){// sent from arduino
beats++;
}
// draw heart beat data
strokeWeight(1);
points[(WIDTH/2)] = number; // strat drawing half way accross screen give current reading to array
//goes through all points and draws a line between consecutive ones
for (int i=1 ;i<points.length-1;i++){
points[i]= points[i+1];
line(i,height-points[i-1]-40,i,height-points[i]-40); 
}
}


