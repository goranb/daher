
class Recorder {

	static final float UI = 10.0;
	static final int channelNum = 10;

	boolean recording = false;
	boolean shift = false;
	boolean ctrl = false;

	Channel[] channels = new Channel[channelNum];
	Channel channel;

	Spectrum spectrum;
	
	Recorder(Spectrum s)
	{
		spectrum = s;
		for (int i = 0; i < channelNum; i++)
		{
			channels[i] = new Channel();
		}
	}

	void draw()
	{
		// UI
		if (shift || ctrl)
		{
			pushStyle();
			strokeWeight(UI);
			noFill();

			if (shift && ctrl)
			{
				stroke(255, 0, 255);
			}
			else if (shift)
			{
				stroke(255, 0, 0);
			}
			else if (ctrl)
			{
				stroke(255, 255, 255);
			}

			rect(UI / 2, UI / 2, width - UI, height - UI);	
			popStyle();
		}

		// channels
		if (ctrl)
		{
			for (int i = 0; i < channelNum; i++)
			{
				channels[i].draw(i, channelNum, mouseX * 1.0 / width, mouseY * 1.0 / height);
			}
		}
	}

	void shiftPressed()
	{
		shift = true;
	}

	void shiftReleased()
	{
		shift = false;
	}

	void ctrlPressed()
	{
		ctrl = true;
	}

	void ctrlReleased()
	{
		ctrl = false;
	}

	void keyPressed(char key)
	{
		if (shift && ctrl)
		{
			shiftCtrlKeyPressed(key);
		}
		else if (shift)
		{
			shiftKeyPressed(key);
		}
		else if (ctrl)
		{
			ctrlKeyPressed(key);
		}
		else
		{
			onlyKeyPressed(key);
		}
	}

	void onlyKeyPressed(char key)
	{
		switch(key)
		{
			case ' ': // show/hide spectrum
				spectrum.visible = !spectrum.visible;
				break;
		}
	}

	void shiftKeyPressed(char key)
	{

	}

	void ctrlKeyPressed(char key)
	{

	}

	void shiftCtrlKeyPressed(char key)
	{

	}

	void cursorPressed(int keyCode)
	{
		if (shift && ctrl)
		{
			shiftCtrlCursorPressed(keyCode);
		}
		else if (shift)
		{
			shiftCursorPressed(keyCode);
		}
		else if (ctrl)
		{
			ctrlCursorPressed(keyCode);
		}
		else
		{
			onlyCursorPressed(keyCode);
		}
	}

	void onlyCursorPressed(int keyCode)
	{
		
	}

	void shiftCtrlCursorPressed(int keyCode)
	{

	}

	void shiftCursorPressed(int keyCode)
	{
		
	}

	void ctrlCursorPressed(int keyCode)
	{
		
	}

	void mouseMoved(float x, float y)
	{
		for (int i = 0; i < channelNum; i++)
		{
			channels[i].hover = (int)(x * channelNum) == i;
		}
	}

	void mousePressed(float x, float y)
	{
		if (shift && ctrl)
		{
			shiftCtrlMousePressed(x, y);
		}
		else if (shift)
		{
			shiftMousePressed(x, y);
		}
		else if (ctrl)
		{
			ctrlMousePressed(x, y);
		}
		else
		{
			onlyMousePressed(x, y);
		}
	}

	void onlyMousePressed(float x, float y)
	{

	}

	void shiftCtrlMousePressed(float x, float y)
	{
		
	}

	void shiftMousePressed(float x, float y)
	{
		spectrum.cue(x);	
	}

	void ctrlMousePressed(float x, float y)
	{
		Channel c = channels[(int)(x * channelNum)];
		c.active = !c.active;
		c.threshold = y;
	}
}