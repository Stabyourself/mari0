extern float exposure = 0.7;
extern float brightness = 1.0;
extern vec3 lumacomponents = vec3(1.0, 1.0, 1.0);


// luma 
//const vec3 lumcoeff = vec3(0.299,0.587,0.114);
const vec3 lumcoeff = vec3(0.212671, 0.715160, 0.072169);

vec4 effect(vec4 vcolor, Image texture, vec2 texcoord, vec2 pixel_coords)
{	
	vec4 input0 = Texel(texture, texcoord);
		
	//exposure knee	
	input0 *= (exp2(input0)*vec4(exposure));
	
	vec4 lumacomponents = vec4(lumcoeff * lumacomponents, 0.0 );
	
	float luminance = dot(input0,lumacomponents);
	
	vec4 luma = vec4(luminance);

	return vec4(luma.rgb * brightness, 1.0);
} 
