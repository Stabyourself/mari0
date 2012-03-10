vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
{
	vec4 rgb = Texel(texture, texture_coords);
	vec4 intens = smoothstep(0.2,0.8,rgb) + normalize(vec4(rgb.xyz, 1.0));

	if (fract(pixel_coords.y * 0.5) > 0.5) intens = rgb * 0.8;
	intens.a = 1.0;
    return intens;
}
