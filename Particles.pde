
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
			particles[i] = new Particle(x, y, random(0, TWO_PI), random(0.005, 0.01));
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
		g = new PVector(0, 0.0005);
		c = color(int(random(128, 256)), int(random(128, 256)), int(random(128, 256)));
	}

	void draw(PGraphics pg)
	{
		v.add(g);
		p.add(v);
		pg.stroke(c, a);
		pg.point(p.x * w, p.y * h);
		println(p.x, p.y);
		a -= 10;
	}
}