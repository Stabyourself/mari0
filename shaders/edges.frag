/*
    Edge shader
    Author: Themaister
    License: Public domain.
    
    modified by slime73 for use with love2d and mari0
*/


extern vec2 textureSize;

vec3 grayscale(vec3 color)
{
	return vec3(dot(color, vec3(0.3, 0.59, 0.11)));
}
 
vec4 effect(vec4 vcolor, Image texture, vec2 tex, vec2 pixel_coords)
{
	vec4 texcolor = Texel(texture, tex);
	
	float x = 0.5 / textureSize.x;
	float y = 0.5 / textureSize.y;
	vec2 dg1 = vec2( x, y);
	vec2 dg2 = vec2(-x, y);
	
	vec3 c00 = Texel(texture, tex - dg1).xyz;
	vec3 c02 = Texel(texture, tex + dg2).xyz;
	vec3 c11 = texcolor.xyz;
	vec3 c20 = Texel(texture, tex - dg2).xyz;
	vec3 c22 = Texel(texture, tex + dg1).xyz;
	
	vec2 texsize = textureSize;
	
	vec3 first = mix(c00, c20, fract(tex.x * texsize.x + 0.5));
	vec3 second = mix(c02, c22, fract(tex.x * texsize.x + 0.5));
	
	vec3 res = mix(first, second, fract(tex.y * texsize.y + 0.5));
	vec4 final = vec4(5.0 * grayscale(abs(res - c11)), 1.0);
	return clamp(final, 0.0, 1.0);
}


