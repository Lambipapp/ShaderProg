#define snoise(p) (2 * (float noise(p)) - 1)

float fBm (point p; uniform float octaves, lacunarity, gain)
{
  uniform float amp = 1;
  varying point pp = p;
  varying float sum = 0;
  uniform float i;
  
  for (i = 0;  i < octaves;  i += 1) {
    sum += amp * snoise (pp);
    amp *= gain;
    pp *= lacunarity;
  }
  return sum;
}
surface mountainsky(color startcolor = (0.3,0.7,0.8); color hazecolor = (0.7,1.0,1.0);  float seed = 32; float cloudO = 3;float sunSize = 4;)
{
	
	color zerocol=color (0,0,0);
	
	float basecol=1-clamp((ycomp(P)-200)/500,0,1);
	color outcol = mix(zerocol, startcolor, basecol);

	float hazecol=pow(1-clamp((ycomp(P)-200)/300,0,1),3);
	outcol += mix(zerocol, hazecolor, hazecol);
	
	//SunniBoi
	point sunCenter = (0, 0, 0);
	point sunEdge = ((u-0.67), (v-0.5)*0.25, 0);
	point bottomV = (0,v,0);
	
	float dist1 = distance(sunCenter, sunEdge)*sunSize;
	
	dist1 = smoothstep(0.3, 0.4, dist1);
	dist1 = clamp(dist1, 0.01, 1.0); 
	
	color orange = (1, 0.6, 0);
	//EndOfSunniBoi
	
	//Moln
	float vc=(v+0.1)*1.7;

	float uCord=((u-0.67)*1.3)/(1.0-vc);
	float vCord=((vc-0.6)/(1.0-vc));

	point pp=point(uCord,vCord,0);
	float clouds = abs(fBm(pp+seed,3,2,0.2));
	//endOfMoln

	outcol = mix(orange, outcol, dist1)+  orange*(1-dist1);
	
	
			
	Ci = outcol * clouds +  (0.7, 0.7, 0.7) * (1-clouds);
	Oi = Os;
	
} 

