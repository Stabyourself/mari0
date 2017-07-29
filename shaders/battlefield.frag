#define power 0.5 // 0.50 is good

extern vec2 textureSize;

extern float time;

extern vec2 redoffset = vec2(2.0, 0.0);
extern vec2 greenoffset = vec2(0.0, 0.0);
extern vec2 blueoffset = vec2(-2.0, 0.0);

float intensity(){	
	float a = 0.042;
	float x = mod(time, 6.0);
	if (x <= 0.3) {
		a = (clamp(sin(x * 10 * 3.14159), 0.0, 1.0)+0.042);
	}
	return a;
}


vec4 effect(vec4 vcolor, Image texture, vec2 texture_coords, vec2 pixel_coords)
{
	vec4 input0 = Texel(texture, texture_coords);

		
	vec2 redzoomtvec = mod((texture_coords) + redoffset/textureSize, 1.0);
	vec2 greezoomvec = mod((texture_coords) + greenoffset/textureSize, 1.0);
	vec2 bluezoomvec = mod((texture_coords) + blueoffset/textureSize, 1.0);
	
	vec4 redinput = Texel(texture, redzoomtvec);
	vec4 greeninput = Texel(texture, greezoomvec);
	vec4 blueinput = Texel(texture, bluezoomvec);
	
	input0 = mix(input0, vec4(redinput.r, greeninput.g, blueinput.b, 1.0), intensity());
	
	if (((input0.r + input0.g + input0.b) / 3.0) >= 0.666) {
		input0.r = clamp((input0.r)*2.0, 0.0, 1.0);
		input0.g = clamp((input0.g)*2.0, 0.0, 1.0);
		input0.b = clamp((input0.b)*2.0, 0.0, 1.0);
	}
	if (input0.b >= 0.4) {
		input0.r = clamp((input0.r)*1.1, 0.0, 1.0);
		input0.g = clamp((input0.g)*1.1, 0.0, 1.0);
		input0.b = clamp((input0.b)*2.1, 0.0, 1.0);
	}
	
	//shamelessly stolen from heavybloom.frag
	
	vec4 sum = vec4(0.0);
	vec4 bum = vec4(0.0);
	
	int j;
	int i;

	vec2 glaresize = vec2(intensity()) / textureSize;

	for(i = -2; i < 2; i++){
		for (j = -2; j < 2; j++){
			sum += Texel(texture, texture_coords + vec2(-i, j)*glaresize) * power;
			bum += Texel(texture, texture_coords + vec2(j, i)*glaresize) * power;            
		}
	}
	
	vec4 texcolor = vec4(0.0);

	if (Texel(texture, texture_coords).r < 2.0)
	{
		texcolor = sum*sum*sum*0.001+bum*bum*bum*0.0080 + input0;
	}
	
	texcolor.a = 1.0;
	
	return texcolor;
}
