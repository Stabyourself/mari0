#define nsamples 5

extern number blurstart = 1.0; // 0 to 1
extern number blurwidth = -0.02; // -1 to 1


vec4 effect(vec4 vcolor, Image texture, vec2 texture_coords, vec2 pixel_coords)
{
	vec4 c = vec4(0.0, 0.0, 0.0, 1.0);
	
	int i;
	for (i = 0; i < nsamples; i++)
	{
		number scale = blurstart + blurwidth * (i / float(nsamples-1));
		c.rgb += Texel(texture, texture_coords * scale).rgb;
	}
	
	c.rgb /= nsamples;
	
	return c;
}
