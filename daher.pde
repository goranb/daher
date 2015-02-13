

static final int w = 96;
static final int h = 54;
static final int f = 6;

Spectrum s;
Recorder r;

String song = "hbrk.wav"; // instrumental

boolean shift = false;
boolean ctrl = false;
boolean alt = false;

void setup()
{
	size(w * f, h * f, JAVA2D);
	s = new Spectrum(this, song);
	r = new Recorder(s);
	frameRate(30);
}

void draw()
{
	background(0);
	r.draw();
	s.draw();
}

void mousePressed()
{
	r.mousePressed(
		map(mouseX, 0, width, 0.0, 1.0),
		map(mouseY, 0, height, 0.0, 1.0)
	);
}

void mouseMoved()
{
	r.mouseMoved(
		map(mouseX, 0, width, 0.0, 1.0),
		map(mouseY, 0, height, 0.0, 1.0)
	);
}

void keyPressed()
{	
	if (key == CODED) 
	{	
		switch(keyCode)
		{
			case SHIFT:
				r.shiftPressed();
				break;

			case CONTROL:
				r.ctrlPressed();
				break;

			case UP:
			case DOWN:
			case LEFT:
			case RIGHT:
				r.cursorPressed(keyCode);
				break;

			default:
				print("[UNDEFINED KEY]");
				print("CODED: " + "[" + key + "]");
		}				
	} 
	else 
	{
		r.keyPressed(key);
	}
}

void keyReleased()
{	
	if (key == CODED) 
	{	
		switch(keyCode)
		{
			case SHIFT:
				r.shiftReleased();
				break;

			case CONTROL:
				r.ctrlReleased();
				break;
		}				
	}
}