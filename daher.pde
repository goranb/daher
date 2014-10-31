
import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AudioPlayer jingle;
FFT			fft;

//String song = "shifting.wav"; // thunder
//String song = "ho.wav"; /// roni size
//String song = "hbrk.wav"; // instrumental
//String song = "dripdown.wav";
String song = "cyclicity.wav";
float bpm = 108;
float shift = 1.2; // in sec


int num = 512;
int w = 1024;
int h = 512;
float[] tops;
float dropoff = 0.99;

void setup(){
	size(w, h, P3D);
	frameRate(30);
	tops = new float[num / 2];
	for (int i = 0; i < num / 2; i++){
		tops[i] = 0;
	}
	minim = new Minim(this);
	jingle = minim.loadFile(song, num);
	jingle.loop();	
	fft = new FFT( jingle.bufferSize(), jingle.sampleRate() );
}


void draw(){
	background(0);
	fill(32);
	fft.forward( jingle.mix );
	float x = 0;
	for (int i = 0; i < fft.specSize() - 1; i++){
		float val = 1 - pow(1 - fft.getBand(i) * 2 / num, i * w / num);
		tops[i] *= dropoff; // dropoff
		tops[i] = max(tops[i], val);
		float p = 1 - pow(1 - i * 2.0 / num, 1.0 + mouseX * 10.0 / w);
		noStroke();
		rect(x, h, p * w - x, val * -h);
		stroke(255);
		line(x, h - h * tops[i], p * w, h - h * tops[i]);
		x = p * w;
	}
}