
class Recorder
{
	static final float UI = 10.0;
	static final int channelNum = 10;

	boolean recording = false;
	boolean shift = false;
	boolean ctrl = false;

	Channel[] channels = new Channel[channelNum];
	Channel channel;

	Spectrum spectrum;

	ArrayList<Record> records;
	ArrayList<Particles> particles;

	float lastTime = 0.0;

	PGraphics pg;

	Recorder(Spectrum s)
	{
		spectrum = s;
		pg = createGraphics(w, h, JAVA2D);
		for (int i = 0; i < channelNum; i++)
		{
			channels[i] = new Channel();
		}
		records = new ArrayList<Record>();
		particles = new ArrayList<Particles>();
	}

	void draw()
	{
		// recorded
		float currentTime = spectrum.time();
		for(Record record : records)
		{
			if (record.time >= lastTime && record.time <= currentTime)
			{
				particles.add(new Particles(record.x, record.y, 10));
			}
		}
		lastTime = currentTime;

		// draw
		pg.beginDraw();
		pg.noStroke();
		pg.fill(0, 64);
		pg.rect(0, 0, w, h);
		pg.noFill();
		pg.stroke(255);
		for(Particles p : particles)
		{
			p.draw(pg);
		}
		pg.endDraw();

		noSmooth();
		image(pg, 0, 0, w * f, h * f);
		smooth();


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

	void saveRecord()
	{
		String[] data = new String[records.size()];
		int counter = 0;
		for(Record record : records)
		{
			data[counter++] = record.time + " " + record.x + " " + record.y;
		}
		saveStrings("data.txt", data);
		println("Saved.");
	}

	void loadRecord()
	{
		String[] data = loadStrings("data.txt");
		records.clear();
		for(int i = 0; i < data.length; i++)
		{
			String[] elements = split(data[i], ' ');
			float time = Float.parseFloat(elements[0]);
			float x = Float.parseFloat(elements[1]);
			float y = Float.parseFloat(elements[2]);
			records.add(new Record(time, x, y));
		}
		println("Loaded.");
	}

	void rewind()
	{
		spectrum.cue(0);
		lastTime = spectrum.time();
		println("Rewinded.");
	}

	void truncateRecord()
	{
		records.clear();
		println("Truncated.");
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

			case 's': // save current record
				saveRecord();
				break;

			case 'l': // load saved record
				loadRecord();
				break;

			case 't': // truncate current record
				truncateRecord();
				break;

			case '1': // rewind
				rewind();
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
		records.add(new Record(spectrum.time(), x, y));
	}

	void shiftCtrlMousePressed(float x, float y)
	{

	}

	void shiftMousePressed(float x, float y)
	{
		spectrum.cue(x);
		lastTime = spectrum.time();
	}

	void ctrlMousePressed(float x, float y)
	{
		Channel c = channels[(int)(x * channelNum)];
		c.active = !c.active;
		c.threshold = y;
	}
}