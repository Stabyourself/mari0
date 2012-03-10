#define glarebasesize 0.896
#define power 0.50

extern vec2 textureSize;
extern vec2 outputSize;

extern float time;

const vec3 green = vec3(0.17, 0.62, 0.25);

float luminance(vec3 color)
{
	return (0.212671 * color.r) + (0.715160 * color.g) + (0.072169 * color.b);
}

float scanline(float ypos)
{

	float c = mod(time * 3.0 + ypos * 5.0, 15.0);	
	return 1.0 - smoothstep(0.0, 1.0, c);
}

vec4 effect(vec4 vcolor, Image texture, vec2 texcoord, vec2 pixel_coords)
{
	vec4 texcolor = Texel(texture, texcoord);
	
	vec4 sum = vec4(0.0);
	vec4 bum = vec4(0.0);

	vec2 glaresize = vec2(glarebasesize) / textureSize;
	
	float y_one = 1.0 / outputSize.y;
	
	int j;
	int i;

	for (i = -2; i < 2; i++)
	{
		for (j = -1; j < 1; j++)
		{
			sum += Texel(texture, texcoord + vec2(-i, j)*glaresize) * power;
			bum += Texel(texture, texcoord + vec2(j, i)*glaresize) * power;            
		}
	}
	
	float a = (scanline(texcoord.y) + scanline(texcoord.y + y_one * 1.5) + scanline(texcoord.y - y_one * 1.5)) / 3.0;
	
	vec4 finalcolor;

	if (texcolor.r < 2.0)
	{
		finalcolor = sum*sum*sum*0.001+bum*bum*bum*0.0080 * (0.8 + 0.05 * a) + texcolor;
	}
	else
	{
		finalcolor = vec4(0.0, 0.0, 0.0, 1.0);
	}
	
	float lum = pow(luminance(finalcolor.rgb), 1.4);
	
	finalcolor.rgb = lum * green + (a * 0.03);
	finalcolor.a = 1.0;
	
	return finalcolor;
}

