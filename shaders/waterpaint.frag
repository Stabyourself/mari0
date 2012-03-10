/*
     Themaister's Waterpaint shader

     Placed in the public domain. 

     (From this thread: http://board.byuu.org/viewtopic.php?p=30483#p30483 
     PD declaration here: http://board.byuu.org/viewtopic.php?p=30542#p30542 )
     
     modified by slime73 for use with love2d and mari0
*/

 
vec4 compress(vec4 in_color, float threshold, float ratio)
{
	vec4 diff = in_color - vec4(threshold);
	diff = clamp(diff, 0.0, 100.0);
	return in_color - (diff * (1.0 - 1.0/ratio));
}
 
extern vec2 textureSize;
 
vec4 effect(vec4 vcolor, Image texture, vec2 tex, vec2 pixel_coords)
{
	float x = 0.5 * (1.0 / textureSize.x);
	float y = 0.5 * (1.0 / textureSize.y);
	
	vec2 dg1 = vec2( x, y);
	vec2 dg2 = vec2(-x, y);
	vec2 dx = vec2(x, 0.0);
	vec2 dy = vec2(0.0, y);
	 	
	vec3 c00 = Texel(texture, tex - dg1).xyz;
	vec3 c01 = Texel(texture, tex - dx).xyz;
	vec3 c02 = Texel(texture, tex + dg2).xyz;
	vec3 c10 = Texel(texture, tex - dy).xyz;
	vec3 c11 = Texel(texture, tex).xyz;
	vec3 c12 = Texel(texture, tex + dy).xyz;
	vec3 c20 = Texel(texture, tex - dg2).xyz;
	vec3 c21 = Texel(texture, tex + dx).xyz;
	vec3 c22 = Texel(texture, tex + dg1).xyz;

	vec2 texsize = textureSize;
	
	vec3 first = mix(c00, c20, fract(tex.x * texsize.x + 0.5));
	vec3 second = mix(c02, c22, fract(tex.x * texsize.x + 0.5));
	
	vec3 mid_horiz = mix(c01, c21, fract(tex.x * texsize.x + 0.5));
	vec3 mid_vert = mix(c10, c12, fract(tex.y * texsize.y + 0.5));
	
	vec3 res = mix(first, second, fract(tex.y * texsize.y + 0.5));
	vec4 final = vec4(0.26 * (res + mid_horiz + mid_vert) + 3.5 * abs(res - mix(mid_horiz, mid_vert, 0.5)), 1.0);
	
	final = compress(final, 0.8, 5.0);
	final.a = 1.0;
	
	return final;
}
