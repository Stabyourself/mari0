extern vec2 inputSize;
extern vec2 textureSize;


#define distortion 0.2

/*
#define f 0.6
#define ox 0.5
#define oy 0.5
#define scale 0.8
#define k1 0.7
#define k2 -0.5

vec2 barrelDistort(vec2 coord)
{	
	vec2 xy = (coord - vec2(ox, oy))/vec2(f) * scale;
	
	vec2 r = vec2(sqrt(dot(xy, xy)));
	
	float r2 = float(r*r);
	
	float r4 = r2*r2;
	
	float coeff = (k1*r2 + k2*r4);
	
	return ((xy+xy*coeff) * f) + vec2(ox, oy);
}
*/
vec2 radialDistortion(vec2 coord, const vec2 ratio)
{
	float offsety = 1.0 - ratio.y;
	coord.y -= offsety;
	coord /= ratio;
	
	vec2 cc = coord - 0.5;
	float dist = dot(cc, cc) * distortion;
	vec2 result = coord + cc * (1.0 + dist) * dist;
	
	result *= ratio;
	result.y += offsety;
	
	return result;
}
/*
vec4 checkTexelBounds(Image texture, vec2 coords, vec2 bounds)
{
	vec4 color = Texel(texture, coords) * 
	
	vec2 ss = step(coords, vec2(bounds.x, 1.0)) * step(vec2(0.0, bounds.y), coords);
	
	color.rgb *= ss.x * ss.y;
	color.a = step(color.a, ss.x * ss.y);
	
	return color;
}*/

vec4 checkTexelBounds(Image texture, vec2 coords, vec2 bounds)
{
	vec2 ss = step(coords, vec2(bounds.x, 1.0)) * step(vec2(0.0, bounds.y), coords);
	return Texel(texture, coords) * ss.x * ss.y;
}

/*
vec4 checkTexelBounds(Image texture, vec2 coords)
{
	vec2 bounds = vec2(inputSize.x / textureSize.x, 1.0 - inputSize.y / textureSize.y);
	
	vec4 color;
	if (coords.x > bounds.x || coords.x < 0.0 || coords.y > 1.0 || coords.y < bounds.y)
		color = vec4(0.0, 0.0, 0.0, 1.0);
	else
		color = Texel(texture, coords);
		
	return color;
}
*/

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
{
	vec2 coords = radialDistortion(texture_coords, inputSize / textureSize);
	
	vec4 texcolor = checkTexelBounds(texture, coords, vec2(inputSize.x / textureSize.x, 1.0 - inputSize.y / textureSize.y));
	texcolor.a = 1.0;
	
	return texcolor;
}

