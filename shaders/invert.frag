vec4 effect(vec4 vcolor, Image texture, vec2 texture_coords, vec2 pixel_coords)
{	
	vec4 input0 = Texel(texture, texture_coords);
	
	input0.rgb *= clamp(sqrt(pow(texture_coords.x-0.5, 2)+pow(texture_coords.y-0.5, 2))/0.5, 0, 1);
	
	return vec4(input0.r, input0.g, input0.b, 1.0);
}