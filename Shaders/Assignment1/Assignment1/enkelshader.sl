
surface enkelshader(color blue = (0.0,0.0,1.0); color yellow = (1.0,1.0,0.0);float freq=8.0;
color white = (1.0,1.0,1.0);float lightIntensity = 0.1;color speccolor=(1.0,1.0,0.7);
float bumpdepth=0.5;float nFreq = 5.0;)
{
	
	
	float f = mod(u*freq, 2.0);
	float g = f;
	float b = v*10;
	
	f = smoothstep(0.0, 0.25, f);
	g = smoothstep(1.0, 1.25, g);
	f = f-g;
	
	point myPoint = P;

	myPoint += f*noise(mod(u*v*20, 0.5)*nFreq)*N*bumpdepth;
	
	N = calculatenormal(myPoint);
	normal n=normalize(N);
	vector V = normalize(-I);

	b = smoothstep(0.75, 1.0, b);
	color yr = mix(yellow, blue, f);
	yr = mix(white, yr, b);

	color dcolor = yr*diffuse(n);
	color scolor = speccolor*specular(n, V, lightIntensity);
	
	Ci = dcolor + scolor;
	Oi = Os;
} 
