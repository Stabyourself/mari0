extern vec2 redoffset = vec2(2.0, 0.0);
extern vec2 greenoffset = vec2(0.0, 0.0);
extern vec2 blueoffset = vec2(-2.0, 0.0);

extern vec2 textureSize;


vec4 effect(vec4 vcolor, Image texture, vec2 texture_coords, vec2 pixel_coords)
{		
	vec2 redzoomtvec = mod((texture_coords) + redoffset/textureSize, 1.0);
	vec2 greezoomvec = mod((texture_coords) + greenoffset/textureSize, 1.0);
	vec2 bluezoomvec = mod((texture_coords) + blueoffset/textureSize, 1.0);
	
	vec4 redinput = Texel(texture, redzoomtvec);
	vec4 greeninput = Texel(texture, greezoomvec);
	vec4 blueinput = Texel(texture, bluezoomvec);
	
	return vec4(redinput.r, greeninput.g, blueinput.b, 1.0);
}


