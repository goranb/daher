

int w = 1024;
int h = 512;

Recorder r;
Spectrum s;

String song = "hbrk.wav"; // instrumental
//String song = "sweep.wav"; 
//String song = "pluk10c.wav"; // 10 c notes from 12
//String song = "tone8a.wav"; // 8 notes from 55hz (A)

boolean shift = false;
boolean ctrl = false;
boolean alt = false;

void setup(){
	size(w, h, P3D);
	//r = new Recorder();
	frameRate(30);
	s = new Spectrum(this, song);
}

void draw(){
	s.draw();
}

void mousePressed(){
	s.mousePressed();
}

void keyPressed(){
	// special keys
	if (key == CODED) {
		print("CODED: " + "[" + key + "]");
		switch(keyCode){
			case SHIFT:
				shift = true;
				break;
			case CONTROL:
				ctrl = true;
				break;
			case ALT:
				alt = true;
				break;
			case UP:
				print("[UP]");
				break;
			case DOWN:
				print("[DOWN]");
				break;
			case LEFT:
				print("[LEFT]");
				break;
			case RIGHT:
				print("[RIGHT]");
				break;
			default:
				print("[UNDEFINED]");
		}
		println((shift ? "SHIFT" : "     ") + (ctrl ? "CTRL" : "    ") + (alt ? "ALT" : "   "));
				
	} else {
		//r.record(key);
	}
}

