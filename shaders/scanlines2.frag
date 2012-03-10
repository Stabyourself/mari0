/*
    Scanline shader
    Author: Themaister
    This code is hereby placed in the public domain.
*/
// modified by slime73 for use with love pixeleffects


extern vec2 textureSize;
extern vec2 inputSize;
extern vec2 outputSize;

const float base_brightness = 0.95;
const vec2 sine_comp = vec2(0.05, 0.15);

vec4 effect(vec4 vcolor, Image texture, vec2 texture_coords, vec2 pixel_coords)
{
	vec2 omega = vec2(3.1415 * outputSize.x * textureSize.x / inputSize.x, 2.0 * 3.1415 * textureSize.y);
	vec4 c11 = Texel(texture, texture_coords);

	vec4 scanline = c11 * (base_brightness + dot(sine_comp * sin(texture_coords * omega), vec2(1.0)));
	return clamp(vec4(scanline.rgb, c11.a), 0.0, 1.0);
}
