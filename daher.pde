
int w = 1024;
int h = 512;

Spectrum s;

//String song = "shifting.wav"; // thunder
//String song = "ho.wav"; /// roni size
//String song = "hbrk.wav"; // instrumental
//String song = "dripdown.wav"; //dj bahati?
String song = "cyclicity.wav"; // 8bit explosion
//String song = "sweep.wav"; 
//String song = "pluk10c.wav"; // 10 c notes from 12
//String song = "tone8a.wav"; // 8 notes from 55hz (A)

void setup(){
	size(w, h, P3D);
	frameRate(30);
	s = new Spectrum(this, song);
}

void draw(){
	s.draw();
}

void mousePressed(){
	s.mousePressed();
}