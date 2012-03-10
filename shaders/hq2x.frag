// originally from a repository of BSNES shaders
// modified by slime73 for use with love2d and mari0

extern vec2 textureSize;

const float mx = 0.325;      // start smoothing wt.
const float k = -0.250;      // wt. decrease factor
const float max_w = 0.25;    // max filter weight
const float min_w =-0.05;    // min filter weight
const float lum_add = 0.25;  // effects smoothing

vec4 effect(vec4 vcolor, Image texture, vec2 texture_coords, vec2 pixel_coords)
{
	float x = 0.5 * (1.0 / textureSize.x);
	float y = 0.5 * (1.0 / textureSize.y);
	vec2 dg1 = vec2( x, y);
	vec2 dg2 = vec2(-x, y);
	vec2 dx = vec2(x, 0.0);
	vec2 dy = vec2(0.0, y);
	
	vec4 texcolor = Texel(texture, texture_coords);
	
	vec3 c00 = Texel(texture, texture_coords - dg1).xyz; 
	vec3 c10 = Texel(texture, texture_coords - dy).xyz;
	vec3 c20 = Texel(texture, texture_coords - dg2).xyz;
	vec3 c01 = Texel(texture, texture_coords - dx).xyz;
	vec3 c11 = texcolor.xyz;
	vec3 c21 = Texel(texture, texture_coords + dx).xyz;
	vec3 c02 = Texel(texture, texture_coords + dg2).xyz;
	vec3 c12 = Texel(texture, texture_coords + dy).xyz;
	vec3 c22 = Texel(texture, texture_coords + dg1).xyz;
	vec3 dt = vec3(1.0, 1.0, 1.0);

	float md1 = dot(abs(c00 - c22), dt);
	float md2 = dot(abs(c02 - c20), dt);

	float w1 = dot(abs(c22 - c11), dt) * md2;
	float w2 = dot(abs(c02 - c11), dt) * md1;
	float w3 = dot(abs(c00 - c11), dt) * md2;
	float w4 = dot(abs(c20 - c11), dt) * md1;

	float t1 = w1 + w3;
	float t2 = w2 + w4;
	float ww = max(t1, t2) + 0.0001;

	c11 = (w1 * c00 + w2 * c20 + w3 * c22 + w4 * c02 + ww * c11) / (t1 + t2 + ww);

	float lc1 = k / (0.12 * dot(c10 + c12 + c11, dt) + lum_add);
	float lc2 = k / (0.12 * dot(c01 + c21 + c11, dt) + lum_add);

	w1 = clamp(lc1 * dot(abs(c11 - c10), dt) + mx, min_w, max_w);
	w2 = clamp(lc2 * dot(abs(c11 - c21), dt) + mx, min_w, max_w);
	w3 = clamp(lc1 * dot(abs(c11 - c12), dt) + mx, min_w, max_w);
	w4 = clamp(lc2 * dot(abs(c11 - c01), dt) + mx, min_w, max_w);

	return vec4(w1 * c10 + w2 * c21 + w3 * c12 + w4 * c01 + (1.0 - w1 - w2 - w3 - w4) * c11, 1.0);
}

