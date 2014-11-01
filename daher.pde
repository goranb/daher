
import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AudioPlayer jingle;
FFT			fft;

//String song = "shifting.wav"; // thunder
//String song = "ho.wav"; /// roni size
String song = "hbrk.wav"; // instrumental
//String song = "dripdown.wav"; //dj bahati?
//String song = "cyclicity.wav"; // 8bit explosion
//String song = "sweep.wav"; 
//String song = "pluk10c.wav"; // 10 c notes from 12
//String song = "tone8a.wav"; // 8 notes from 55hz (A)

int num = 1024;
int w = 1024;
int h = 512;
float[] tops;
float[] energies;
float[] spectrum;
float dropoff = 0.95;
float bendPow = 12;
int blur = 10;
int specSize;


void setup(){
	size(w, h, P3D);
	frameRate(30);
	tops = new float[num / 2];
	energies = new float[num / 2];
	spectrum = new float[num / 2];
	for (int i = 0; i < num / 2; i++){
		tops[i] = energies[i] = spectrum[i] = 0.0;
	}
	minim = new Minim(this);
	jingle = minim.loadFile(song, num);
	jingle.loop();	
	fft = new FFT(jingle.bufferSize(), jingle.sampleRate());
	specSize = fft.specSize() - 1;
}

void draw(){
	dropoff = mouseX * 1.0 / w;
	background(0);
	//fill(0);
	noFill();
	strokeWeight(2);
	fft.forward(jingle.mix);
	float x = 0;
	//int specSize = fft.specSize() - 1;
	for (int i = 0; i < specSize; i++){
		float p = i * 1.0 / (specSize - 1);
		float val = fft.getBand(i) * 2 / num * log2_45(i + 1.0);
		float l = log45(val);
		energies[i] *= dropoff; // dropoff
		if (l > energies[i]){
			tops[i] = energies[i] = l;
		}
		tops[i] = max(tops[i], l);
		//noStroke();
		//rect(x, h, p * w - x, l * -h);
		stroke(255, 255 * energies[i]);
		line(x, h - h * tops[i], p * w, h - h * tops[i]);
		x = p * w;
	}
	for (int i = 0; i < specSize; i++){
		int s1 = floor(bend((i * 1.0) / specSize, bendPow) * specSize);
		int s2 = min(specSize, floor(bend((i * 1.0 + 1.0) / specSize, bendPow) * specSize));
		for(int e = s1; e < s2; e++){
			spectrum[e] = energies[i];
		}
	}

	// apply guassian blur
	float[] blurred = new float[specSize];
	// calculate sum
	float sum = 0.0;
	for(int s = 0; s < blur; s++){
		sum += s * 2;
	}
	sum += blur;
	for (int i = 0; i < specSize; i++){
		blurred[i] = 0.0;
		for (int c = -blur; c < blur + 1; c++){
			int e = min(specSize - 1, max(0, i + c)); // put into range
			// blurred[i] += spectrum[e] * conv[c + conv.length / 2];
			float f = (blur - abs(c)) / sum;
			blurred[i] += spectrum[e] * f;
		}
	}


	// draw spectrum
	// x = 0;
	// stroke(255, 255, 0);
	// for (int i = 0; i < specSize; i++){
	// 	float p = i * 1.0 / (specSize - 1);
	// 	line(x, h - h * spectrum[i], p * w, h - h * spectrum[i]);
	// 	x = p * w;
	// }

	// draw blurred
	x = 0;
	stroke(0, 255, 255);
	for (int i = 0; i < specSize; i++){
		float p = i * 1.0 / (specSize - 1);
		line(x, h - h * blurred[i], p * w, h - h * blurred[i]);
		x = p * w;
	}


	/* //show bend correction curve
	stroke(255, 0, 0);
	for (int i = 0; i < w; i++){
		float a = bend(i * 1.0 / w, bendPow);
		//a = i * 1.0 / w;
		line(i, h - h * a, i + 1, h - h * a);
	}
	//*/
}

float log45(float v){
	return (log(v * 2.71828) + 4.0) / 5.0;
}

float log2(float v){
	return (log(v) / log(2)); 
}

float log2_45(float v){
	return (log2(v) + 4.0) / 5.0; 
}

float bend(float a, float f){
	return 1.0 - pow(1.0 - a, f);
}

float bend(float a){
	return bend(a, 2);
}