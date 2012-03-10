// originally from a repository of BSNES shaders
// modified by slime73 for use with love pixeleffects

extern vec2 textureSize;

#define round(x) floor( (x) + 0.5 )

vec4 effect(vec4 vcolor, Image texture, vec2 texcoord, vec2 pixel_coords)
{
	vec2 texelSize = 1.0 / textureSize;

	vec2 range;
	range.x = dFdx(texcoord.x) / 2.0 * 0.99;
	range.y = dFdy(texcoord.y) / 2.0 * 0.99;

	float left   = texcoord.x - range.x;
	float top    = texcoord.y + range.y;
	float right  = texcoord.x + range.x;
	float bottom = texcoord.y - range.y;

	vec4 topLeftColor     = Texel(texture, (floor(vec2(left, top)     / texelSize) + 0.5) * texelSize);
	vec4 bottomRightColor = Texel(texture, (floor(vec2(right, bottom) / texelSize) + 0.5) * texelSize);
	vec4 bottomLeftColor  = Texel(texture, (floor(vec2(left, bottom)  / texelSize) + 0.5) * texelSize);
	vec4 topRightColor    = Texel(texture, (floor(vec2(right, top)    / texelSize) + 0.5) * texelSize);

	vec2 border = clamp(
		round(texcoord / texelSize) * texelSize,
		vec2(left, bottom),
		vec2(right, top)
	);

	float totalArea = 4.0 * range.x * range.y;

	vec4 averageColor;
	averageColor  = ((border.x - left)  * (top - border.y)    / totalArea) * topLeftColor;
	averageColor += ((right - border.x) * (border.y - bottom) / totalArea) * bottomRightColor;
	averageColor += ((border.x - left)  * (border.y - bottom) / totalArea) * bottomLeftColor;
	averageColor += ((right - border.x) * (top - border.y)    / totalArea) * topRightColor;
	
	averageColor.a = 1.0;

	return averageColor;
}
