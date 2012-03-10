
extern vec2 textureSize;

const float pixel_w = 2.0;
const float pixel_h = 2.0;

vec4 effect(vec4 vcolor, Image texture, vec2 uv, vec2 pixel_coords)
{
	float dx = pixel_w*(1.0/textureSize.x);
	float dy = pixel_h*(1.0/textureSize.y);
	vec2 coord = vec2(dx*floor(uv.x/dx), dy*floor(uv.y/dy));
	return Texel(texture, coord);
}
