int speakerPin = 9;
int length = 15; // the number of notes
char notes[] = "cFFEFaABAaFECFFEFaACAaCFFEFaABAaFEAFABAaF"; // a space represents a rest
int beats[] = { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,1, 1, 1, 1, 1, 1, 1,1,1,1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,1, 1, 1, 1,1,1, 1, 1,1,1,1};
int tempo = 300;
void playTone(int tone, int duration) {
for (long i = 0; i < duration * 1000L; i += tone * 2) {
digitalWrite(speakerPin, HIGH);
delayMicroseconds(tone);
digitalWrite(speakerPin, LOW);
delayMicroseconds(tone);
}
}
void playNote(char note, int duration) {
char names[] = { 'A', 'D', 'E', 'F', 'G', 'a','C', 'B' };
int tones[] = { 200, 294, 370, 330, 392, 250, 554, 150 };
// play the tone corresponding to the note name
for (int i = 0; i < 8; i++) {
if (names[i] == note) {
playTone(tones[i], duration);
}
}
}
void setup() {
pinMode(speakerPin, OUTPUT);
}
void loop() {
for (int i = 0; i < length; i++) {
if (notes[i] == ' ') {
delay(beats[i] * tempo); // rest
} else {
playNote(notes[i], beats[i] * tempo);
}
// pause between notes
delay(tempo / 2);
}
}
