/*
   Plain (and obviously inaccurate) phosphor.
   Author: Themaister
   License: Public Domain
*/
// modified by slime73 for use with love pixeleffects


extern vec2 textureSize;

vec3 to_focus(float pixel)
{
	pixel = mod(pixel + 3.0, 3.0);
	if (pixel >= 2.0) // Blue
		return vec3(pixel - 2.0, 0.0, 3.0 - pixel);
	else if (pixel >= 1.0) // Green
		return vec3(0.0, 2.0 - pixel, pixel - 1.0);
	else // Red
		return vec3(1.0 - pixel, pixel, 0.0);
}

vec4 effect(vec4 vcolor, Image texture, vec2 texture_coords, vec2 pixel_coords)
{
	float y = mod(texture_coords.y * textureSize.y, 1.0);
	float intensity = exp(-0.2 * y);

	vec2 one_x = vec2(1.0 / (3.0 * textureSize.x), 0.0);

	vec3 color = Texel(texture, texture_coords - 0.0 * one_x).rgb;
	vec3 color_prev = Texel(texture, texture_coords - 1.0 * one_x).rgb;
	vec3 color_prev_prev = Texel(texture, texture_coords - 2.0 * one_x).rgb;

	float pixel_x = 3.0 * texture_coords.x * textureSize.x;

	vec3 focus = to_focus(pixel_x - 0.0);
	vec3 focus_prev = to_focus(pixel_x - 1.0);
	vec3 focus_prev_prev = to_focus(pixel_x - 2.0);

	vec3 result =
		0.8 * color * focus +
		0.6 * color_prev * focus_prev +
		0.3 * color_prev_prev * focus_prev_prev;

	result = 2.3 * pow(result, vec3(1.4));

	return vec4(intensity * result, 1.0);
}

