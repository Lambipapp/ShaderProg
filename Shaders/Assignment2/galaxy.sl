#define snoise(p) (2 * (float noise(p)) - 1)

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


surface galaxy(float spinMultiplier = 7.0;float cloudFreq = 10)
{
	float vc=(v-0.1)*1.5;
	float uSpin = ((u-0.5)*spinMultiplier)/(1.0-vc);
	float vSpin = ((v-0.5)*spinMultiplier)/(1.0-vc);
	point p1 = point (uSpin,vSpin,0);
	point p2 = point (0,0,0);
	float dist = distance (p1, p2);

	color whitepoint = mix((1.0,1.0,1.0),(0.0,0.0,0.0),dist /8);
	
	float rays = smoothstep(0.0, 0.7,mod(atan(uSpin,vSpin)*2+dist,1.57));
	float rays2 = smoothstep(1.0, 1.7, mod(atan(uSpin,vSpin)*2+dist, 1.57));	
	rays = rays-rays2;
	
	float distTone = smoothstep(0.5, 3.0, dist);
	rays = rays - distTone;
	point p3 = point(dist,atan(uSpin,vSpin)+dist,0);
	float backg = abs(turbulence(p3*cloudFreq,12,1.8,0.6));
	
	color yl = (0.0,0.5,0.9);

	color galaxi = rays + (backg + whitepoint)- distTone;

	color colOut = galaxi*yl*0.8+(1-distTone)*0.4;
	colOut = clamp(colOut, 0, 1000);
	
	Ci = colOut;
	Oi = Os * Ci;
}
