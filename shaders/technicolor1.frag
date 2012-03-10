extern number amount = 0.5;

const vec4 redfilter = vec4(1.0, 0.0, 0.0, 1.0);
const vec4 bluegreenfilter = vec4(0.0, 1.0, 0.7, 1.0);


vec4 effect(vec4 vcolor, Image texture, vec2 texture_coords, vec2 pixel_coords)
{
	vec4 input0 = Texel(texture, texture_coords);

	vec4 redrecord = input0 * redfilter;
	vec4 bluegreenrecord = input0 * bluegreenfilter;
	
	vec4 rednegative = vec4(redrecord.r);
	vec4 bluegreennegative = vec4((bluegreenrecord.g + bluegreenrecord.b)/2.0);

	vec4 redoutput = rednegative * redfilter;
	vec4 bluegreenoutput = bluegreennegative * bluegreenfilter;

	// additive 'projection"
	vec4 result = redoutput + bluegreenoutput;

	return vec4(mix(input0, result, amount).rgb, 1.0);
}
