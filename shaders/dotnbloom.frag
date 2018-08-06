/*
     Dot 'n bloom shader
     Author: Themaister
     License: Public domain
*/
// modified by slime73 for use with love pixeleffects


extern vec2 textureSize;

const float gamma = 2.4;
const float shine = 0.05;
const float blend = 0.65;

float dist(vec2 coord, vec2 source)
{
	vec2 delta = coord - source;
	return sqrt(dot(delta, delta));
}

float color_bloom(vec3 color)
{
	const vec3 gray_coeff = vec3(0.30, 0.59, 0.11);
	float bright = dot(color, gray_coeff);
	return mix(1.0 + shine, 1.0 - shine, bright);
}

vec3 lookup(Image texture, float offset_x, float offset_y, vec2 coord)
{
	vec2 offset = vec2(offset_x, offset_y);
	vec3 color = Texel(texture, coord).rgb;
	float delta = dist(fract(gl_TexCoord[0].xy * textureSize), offset + vec2(0.5));
	return color * exp(-gamma * delta * color_bloom(color));
}

vec4 effect(vec4 vcolor, Image texture, vec2 tex, vec2 pixel_coords)
{
	float dx = 1.0 / textureSize.x;
	float dy = 1.0 / textureSize.y;

	// number a = Texel(texture, tex).a;

	vec2 c00 = tex + vec2(-dx, -dy);
	vec2 c10 = tex + vec2(  0, -dy);
	vec2 c20 = tex + vec2( dx, -dy);
	vec2 c01 = tex + vec2(-dx,   0);
	vec2 c11 = tex + vec2(  0,   0);
	vec2 c21 = tex + vec2( dx,   0);
	vec2 c02 = tex + vec2(-dx,  dy);
	vec2 c12 = tex + vec2(  0,  dy);
	vec2 c22 = tex + vec2( dx,  dy);

	vec3 mid_color = lookup(texture, 0.0, 0.0, c11);
	vec3 color = vec3(0.0);
	color += lookup(texture, -1.0, -1.0, c00);
	color += lookup(texture,  0.0, -1.0, c10);
	color += lookup(texture,  1.0, -1.0, c20);
	color += lookup(texture, -1.0,  0.0, c01);
	color += mid_color;
	color += lookup(texture,  1.0,  0.0, c21);
	color += lookup(texture, -1.0,  1.0, c02);
	color += lookup(texture,  0.0,  1.0, c12);
	color += lookup(texture,  1.0,  1.0, c22);
	vec3 out_color = mix(1.2 * mid_color, color, blend);

	return vec4(out_color, 1.0);
}
