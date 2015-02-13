
import ddf.minim.analysis.*;
import ddf.minim.*;


class Spectrum 
{
	PApplet applet;
	String song;
	int num;
	int blur;
	float bendPow;
	boolean visible = true;
	
	Minim minim;
	AudioPlayer sound;
	FFT fft;

	float dropoff = 0.95;
	float[] energies;
	float[] spectrum;
	int specSize;

	Spectrum(PApplet applet, String song, int num, int blur, int bendPow)
	{
		this.applet = applet;
		this.num = num;
		this.blur = blur;
		this.bendPow = bendPow;
		// initialize
		energies = new float[num / 2];
		spectrum = new float[num / 2];
		for (int i = 0; i < num / 2; i++){
			energies[i] = spectrum[i] = 0.0;
		}
		minim = new Minim(this.applet);
		sound = minim.loadFile(song, num);
		sound.loop();	
		fft = new FFT(sound.bufferSize(), sound.sampleRate());
		specSize = fft.specSize() - 1;
	}

	Spectrum(PApplet applet, String song, int num, int blur)
	{
		this(applet, song, num, blur, 12);
	}

	Spectrum(PApplet applet, String song, int num)
	{
		this(applet, song, num, 4);
	}

	Spectrum(PApplet applet, String song)
	{
		this(applet, song, 1024);
	}

	void draw()
	{
		if (!visible) return; // draw only if visible
		// init
		dropoff = 0.5;
		noFill();
		strokeWeight(2);
		fft.forward(sound.mix);
		for (int i = 0; i < specSize; i++){
			float p = i * 1.0 / (specSize - 1);
			float val = fft.getBand(i) * 2 / num * log2_45(i + 1.0);
			float l = log45(val);
			energies[i] *= dropoff; // dropoff
			if (l > energies[i]){
				energies[i] = l;
			}
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
				//blurred[i] += spectrum[e] * conv[c + conv.length / 2];
				float f = sum > 0 ? (blur - abs(c)) / sum : 1;
				blurred[i] += spectrum[e] * f;
			}
		}


		float x = 0;
		
		/* draw spectrum */
		stroke(255, 0, 128);
		strokeWeight(10);
		for (int i = 0; i < specSize; i++){
			float p = i * 1.0 / (specSize - 1);
			line(x, height - height * spectrum[i], p * width, height - height * spectrum[i]);
			x = p * width;
		}
		x = 0;

		// /* draw blurred */
		stroke(0, 255, 255);
		strokeWeight(1);
		for (int i = 0; i < specSize - 1; i++){
			float p = i * 1.0 / (specSize - 1);
			line(x, height - height * blurred[i], p * width, height - height * blurred[i + 1]);
			x = p * width;
		}

		//show bend correction curve
		// stroke(255, 0, 0);
		// for (int i = 0; i < w; i++){
		// 	float a = bend(i * 1.0 / w, bendPow);
		// 	//a = i * 1.0 / w;
		// 	line(i, h - h * a, i + 1, h - h * a);
		// }
		//

		//updateChannels(blur);
	}

	float log45(float v)
	{
		return (log(v * 2.71828) + 4.0) / 5.0;
	}

	float log2(float v)
	{
		return (log(v) / log(2)); 
	}

	float log2_45(float v)
	{
		return (log2(v) + 4.0) / 5.0; 
	}

	float bend(float a, float f)
	{
		return 1.0 - pow(1.0 - a, f);
	}

	float bend(float a)
	{
		return bend(a, 2);
	}

	void cue(float position)
	{
		sound.cue((int)map(position, 0.0, 1.0, 0, sound.length()));
	}

	float time()
	{
		return sound.position() * 1.0 / sound.length();
	}
}