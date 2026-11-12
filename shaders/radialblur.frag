#define nsamples 5

const number blurstart = 1.0; // 0 to 1
const number blurwidth = -0.02; // -1 to 1


vec4 effect(vec4 vcolor, Image texture, vec2 texture_coords, vec2 pixel_coords)
{
	vec4 c = vec4(0.0, 0.0, 0.0, 1.0);
	
	for (int i = 0; i < nsamples; i++)
	{
		number scale = blurstart + blurwidth * (float(i) / float(nsamples-1));
		c.rgb += Texel(texture, texture_coords * scale).rgb;
	}
	
	c.rgb /= float(nsamples);
	
	return c;
}
