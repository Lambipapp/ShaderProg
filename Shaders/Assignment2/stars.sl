#define snoise(p) (2 * (float noise(p)) - 1)
void voronoi_f1f2_2d (float ss, tt; output float f1; output float spos1, tpos1;
output float f2; output float spos2, tpos2;)
{
  float jitter=1.0;
  float sthiscell = floor(ss)+0.5;
  float tthiscell = floor(tt)+0.5;
  f1 = f2 = 1000;
  uniform float i, j;
  for (i = -1;  i <= 1;  i += 1) {
    float stestcell = sthiscell + i;
    for (j = -1;  j <= 1;  j += 1) {
      float ttestcell = tthiscell + j;
      float spos = stestcell + jitter * (cellnoise(stestcell, ttestcell) - 0.5);
      float tpos = ttestcell + jitter * (cellnoise(stestcell+23, ttestcell-87) - 0.5);
      float soffset = spos - ss;
      float toffset = tpos - tt;
      float dist = soffset*soffset + toffset*toffset;
      if (dist < f1) { 
        f2 = f1;
        spos2 = spos1;
        tpos2 = tpos1;
        f1 = dist;
        spos1 = spos;
        tpos1 = tpos;
      } else if (dist < f2) {
        f2 = dist;
        spos2 = spos;
        tpos2 = tpos;
      }
    }
  }
  f1 = sqrt(f1);  f2 = sqrt(f2);
}

float turbulence(point p; uniform float octaves, lacunarity, gain)
{
  uniform float amp = 1;
  varying point pp = p;
  varying float sum = 0;
  uniform float i;
  
  for (i = 0;  i < octaves;  i += 1) {
    sum += abs(amp * snoise (pp));
    amp *= gain;
    pp *= lacunarity;
  }
  return sum;
}


surface stars(float freqMultiplier = 0.2; color starColor = (0.2,0.1,0.03);
color black = (0,0,0); color blue = (0,0,0.5); float cloud2ColorIntensity = 0.3;
float cloud1ColorIntensity = 1.0; color yellow = (1.0,1.0,0);)
{
	point pp = P;
				// stjarnhimmel start
	float f1, ss = s*freqMultiplier, tt = t*freqMultiplier;
	voronoi_f1f2_2d (ss, tt, f1, 0,0,0,0,0);
	f1 = smoothstep(0.01, 0.05, f1);
	f1 += 0.01;
	color outcolor = starColor / f1;
				//Stjarnhimmel slutt
				
	float cloud0 = turbulence(pp/100, 6, 1.6, 0.5);
	float cloud1 = turbulence((pp+37)/100, 8, 1.6, 0.2 );
	color blueCloud = blue*cloud0 * cloud1ColorIntensity;
	color yellowCloud = yellow * cloud1 * cloud2ColorIntensity;	
	Ci = outcolor + blueCloud + yellowCloud;
	Oi = Os;
} 
