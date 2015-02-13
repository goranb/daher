
class Particles
{
	float number;
	float time = 0;
	Particle[] particles;

	Particles(float x, float y, int number)
	{
		this.number = number;
		particles = new Particle[number];
		for (int i = 0; i < number; i++)
		{
			particles[i] = new Particle(x, y, random(0, TWO_PI), random(0.004, 0.009));
		}
	}

	void draw(PGraphics pg)
	{
		for (int i = 0; i < number; i++)
		{
			particles[i].draw(pg);
		}	
	}
}

class Particle
{
	PVector p, v, g;
	color c;
	int a = 255;
	Particle(float x, float y, float dir, float speed)
	{
		p = new PVector(x, y);
		v = new PVector(cos(dir), sin(dir));
		v.setMag(speed);
		g = new PVector(0, 0.0002);
		c = color(int(random(128, 256)), int(random(128, 256)), int(random(128, 256)));
	}

	void draw(PGraphics pg)
	{
		if (a < 0) return;
		v.add(g);
		p.add(v);
		pg.stroke(c, a);
		pg.point(p.x * w, p.y * h);
		a -= 5;
	}
}