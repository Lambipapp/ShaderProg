

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
float RidgedMultifractal(point p; uniform float octaves, lacunarity, gain, H, sharpness, threshold)
{
	float result, signal, weight, i, exponent;
	varying point PP=p;

	for( i=0; i<octaves; i += 1 ) {
       	if ( i == 0) {
          		signal = snoise( PP );
          		if ( signal < 0.0 ) signal = -signal;
          		signal = gain - signal;
          		signal = pow( signal, sharpness );
          		result = signal;
          		weight = 1.0;
        	}else{
          		exponent = pow( lacunarity, (-i*H) );
			PP = PP * lacunarity;
          		weight = signal * threshold;
          		weight = clamp(weight,0,1)    ;    		
          		signal = snoise( PP );
          		signal = abs(signal);
          		signal = gain - signal;
          		signal = pow( signal, sharpness );
          		signal *= weight;
          		result += signal * exponent;
       		}
		}
		return(result);
}

surface mountain (float Ka = 0, Kd = 1; float waterLevel = 9;)
{
	float d = 1-exp(-length(I)/1400);
	color outCol = (0.2,0.5,0.3);
	color grassColor = (0.3, 0.5, 0.4);
	float magnitude = (RidgedMultifractal((P+32)*0.002, 7, 2.5, 0.9, 1.2, 5,8)*120);

	float mountainAtt=distance(zcomp(P),100)/1000.0;
	
	//SEALEVEL
	magnitude = clamp(magnitude, waterLevel, 100);	
	//SEALEVEL END
	
    P += magnitude*mountainAtt*normalize(N);
    N = calculatenormal(P);
    normal Nf = faceforward (normalize(N),I);
		
	//BEACHCOLOR
	float beachSel = ycomp(normalize(N));	
	color sandC =(0.9,0.9,0.7);
	beachSel = smoothstep(0.85, 0.9, beachSel);
	//BEACHCOLOR END
	
	//SEACOLOR
	color lakeBlue = (0.0,0.3,0.8);
	float lakeSel = ycomp(normalize(N));
	lakeSel = smoothstep(0.93, 0.935, lakeSel);
	//SEACOLOR END
	
	//MOUNTAINTOP
	float peaksel = ycomp(normalize(N));
	peaksel = step(0.2, peaksel);
	float trans = smoothstep(0.6, 0.9, v);
	color mountainPeakColor = (0.2,0.2,0.2);
	outCol = mix(outCol, mountainPeakColor, peaksel*(1-trans));
	//MOUNTAINTOP END
	
	//SNOWBOI
	float snowsel = ycomp(normalize(N));
	snowsel = step(0.5, snowsel);
	float trans = smoothstep(0.3, 0.7, v);
	color snowC = (1.0,1.0,1.0);
	//SNOWBOI END
	
	//GRASS
	float grassFreq = 15;
	//float bumpdepth = 1.0;
	float grassNoise = noise(P* grassFreq);
	outCol = mix(outCol, grassColor*grassNoise, outCol);
	//GRASS END
    
	float waves = fBm(P/8, 6, 1.6, 0.5);
	
		outCol = mix(outCol, snowC, snowsel*(1-trans));
		outCol = mix(outCol, sandC, beachSel);
	//	outCol = mix(outCol,lakeBlue,lakeSel);
		outCol = (mix(outCol,lakeBlue * (1-waves ),lakeSel) + mix(outCol,(1.0,1.0,1.0) * waves ,lakeSel))/2;
		
		color Diffuse=Cs*(Kd * diffuse(Nf));
        
    Ci = Diffuse*outCol;
    Oi = Os;  
	Ci = mix(Ci, color(0,0.8,1) ,d);
	Oi = mix(Oi, color(1,1,1),d);
    
}
