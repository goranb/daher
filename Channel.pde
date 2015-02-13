
import ddf.minim.analysis.*;
import ddf.minim.*;


class Channel
{

	float value = 0.0;
	int valueNum = 0;
	float threshold = 0.5;
	boolean active = false;
	boolean hover = false;

	Channel()
	{

	}

	void draw(int channel, int channels, float x, float y)
	{
		pushStyle();
			noStroke();

		if (active)
		{
			fill(255, hover ? 0 : 255, 0, 64);
			rect(width * channel / channels, height * threshold, width / channels, height - height * threshold);
		}

		if (hover)
		{
			fill(255, 32);
			rect(width * channel / channels, height * y, width / channels, height - height * y);
		}

		popStyle();
	}

	void resetValue()
	{
		value = 0.0;
		valueNum = 0;
	}

	float getValue()
	{
		if (valueNum > 0)
		{
			return value / valueNum;
		}
		else
		{
			return value;
		}
	}

	void addValue(float v)
	{
		value += v;
	}
}