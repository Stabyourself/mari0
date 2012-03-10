/*
	caligari's scanlines

	Copyright (C) 2011 caligari

	This program is free software; you can redistribute it and/or modify it
	under the terms of the GNU General Public License as published by the Free
	Software Foundation; either version 2 of the License, or (at your option)
	any later version.

	(caligari gave their consent to have this shader distributed under the GPL
	in this message:

		http://board.byuu.org/viewtopic.php?p=36219#p36219

		"As I said to Hyllian by PM, I'm fine with the GPL (not really a bi
		deal...)"
   )
*/

extern vec2 textureSize;


// 0.5 = the spot stays inside the original pixel
// 1.0 = the spot bleeds up to the center of next pixel
#define PHOSPHOR_WIDTH  0.9
#define PHOSPHOR_HEIGHT 0.65

// Used to counteract the desaturation effect of weighting.
#define COLOR_BOOST 1.9

// Constants used with gamma correction.
#define InputGamma 2.4
#define OutputGamma 2.2

// Uncomment to only draw every third pixel, which highlights the shape
// of individual (remaining) spots.
// #define DEBUG

// Uncomment one of these to choose a gamma correction method.
// If none are uncommented, no gamma correction is done.
// #define REAL_GAMMA
#define FAKE_GAMMA
// #define FAKER_GAMMA

#ifdef REAL_GAMMA
#define GAMMA_IN(color)     pow(color, vec4(InputGamma))
#define GAMMA_OUT(color)    pow(color, vec4(1.0 / OutputGamma))

#elif defined FAKE_GAMMA
/*
 * Approximations:
 * for 1<g<2 : x^g ~ ax + bx^2
 *             where   a=6/(g+1)-2  and b=1-a
 * for 2<g<3 : x^g ~ ax^2 + bx^3
 *             where   a=12/(g+1)-3 and b=1-a
 * for 1<g<2 : x^(1/g) ~ (sqrt(a^2+4bx)-a)
 *             where   a=6/(g+1)-2  and b=1-a
 * for 2<g<3 : x^(1/g) ~ (a sqrt(x) + b sqrt(sqrt(x)))
 *             where   a = 6 - 15g / 2(g+1)  and b = 1-a
 */
vec4 A_IN = vec4( 12.0/(InputGamma+1.0)-3.0 );
vec4 B_IN = vec4(1.0) - A_IN;
vec4 A_OUT = vec4(6.0 - 15.0 * OutputGamma / 2.0 / (OutputGamma+1.0));
vec4 B_OUT = vec4(1.0) - A_OUT;
#define GAMMA_IN(color)     ( (A_IN + B_IN * color) * color * color )
#define GAMMA_OUT(color)    ( A_OUT * sqrt(color) + B_OUT * sqrt( sqrt(color) ) )

#elif defined FAKER_GAMMA
vec4 A_IN = vec4(6.0/( InputGamma/OutputGamma + 1.0 ) - 2.0);
vec4 B_IN = vec4(1.0) - A_IN;
#define GAMMA_IN(color)     ( (A_IN + B_IN * color) * color )
#define GAMMA_OUT(color)    color

#else // No gamma correction
#define GAMMA_IN(color) color
#define GAMMA_OUT(color) color
#endif

#ifdef DEBUG
vec4 grid_color( vec2 coords )
{
		vec2 snes = floor( coords * textureSize );
		if ( (mod(snes.x, 3.0) == 0.0) && (mod(snes.y, 3.0) == 0.0) )
				return texture2D(_tex0_, coords);
		else
				return vec4(0.0);
}
#define TEX2D(coords)   GAMMA_IN( grid_color( coords ) )

#else // DEBUG
#define TEX2D(coords)   GAMMA_IN( texture2D(_tex0_, coords) )

#endif // DEBUG

vec2 onex = vec2( 1.0/textureSize.x, 0.0 );
vec2 oney = vec2( 0.0, 1.0/textureSize.y );

vec4 effect(vec4 vcolor, Image texture, vec2 texCoord, vec2 pixel_coords)
{
	vec2 coords = (texCoord * textureSize);
	vec2 pixel_start = floor(coords);
	coords -= pixel_start;
	vec2 pixel_center = pixel_start + vec2(0.5);
	vec2 texture_coords = pixel_center / textureSize;

	vec4 color = vec4(0.0);
	vec4 pixel;
	vec3 centers = vec3(-0.25,-0.5,-0.75);
	vec3 posx = vec3(coords.x);
	vec3 hweight;
	float vweight;
	float dx,dy;
	float w;

	float i,j;

	for (j = -1.0; j<=1.0; j++) {
			// Vertical weight
			dy = abs(coords.y - 0.5 - j );
			vweight = smoothstep(1.0,0.0, dy / PHOSPHOR_HEIGHT);

			if (vweight !=0.0 ) {
					for ( i = -1.0; i<=1.0; i++ ) {
							pixel = TEX2D(
									texture_coords
									+ i * onex
									+ j * oney
							);

							/* Evaluate the distance (in x) from
							 * the pixel (posx) to the RGB centers
							 * (~centers):
							 *      x_red = 0.25
							 *      x_green = 0.5
							 *      x_blue = 0.75
							 * if the distance > PHOSPHOR_WIDTH,
							 * this pixel doesn't contribute
							 * otherwise, smoothstep gives the
							 * weight of the contribution
							 */
							hweight = smoothstep(
									1.0, 0.0,
									abs((posx + centers - vec3(i))
											/ vec3(PHOSPHOR_WIDTH))
							);
							color.rgb +=
								pixel.rgb *
								hweight *
								vec3(vweight);
					}
			}
	}

	color *= vec4(COLOR_BOOST);
	color.a = 1.0;

	return clamp(GAMMA_OUT(color), 0.0, 1.0);
}
