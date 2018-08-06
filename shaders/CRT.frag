/*
    CRT shader

    Copyright (C) 2010, 2011 cgwg, Themaister and DOLLS

    This program is free software; you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by the Free
    Software Foundation; either version 2 of the License, or (at your option)
    any later version.

    (cgwg gave their consent to have the original version of this shader
    distributed under the GPL in this message:

        http://board.byuu.org/viewtopic.php?p=26075#p26075

        "Feel free to distribute my shaders under the GPL. After all, the
        barrel distortion code was taken from the Curvature shader, which is
        under the GPL."
    )

    modified by slime73 for use with love2d and mari0
*/

extern vec2 inputSize;
extern vec2 outputSize;
extern vec2 textureSize;


#define SCANLINES

// Comment the next line to disable interpolation in linear gamma (and gain speed).
#define LINEAR_PROCESSING

// Compensate for 16-235 level range as per Rec. 601.
#define REF_LEVELS

// Enable screen curvature.
#define CURVATURE

// Controls the intensity of the barrel distortion used to emulate the
// curvature of a CRT. 0.0 is perfectly flat, 1.0 is annoyingly
// distorted, higher values are increasingly ridiculous.
#define distortion 0.2

// Simulate a CRT gamma of 2.4.
#define inputGamma  2.4

// Compensate for the standard sRGB gamma of 2.2.
#define outputGamma 2.2

// Macros.
#define FIX(c) max(abs(c), 1e-5);
#define PI 3.141592653589

#ifdef REF_LEVELS
# 	define LEVELS(c) max((c - 16.0 / 255.0) * 255.0 / (235.0 - 16.0), 0.0)
#else
#	define LEVELS(c) c
#endif

#ifdef LINEAR_PROCESSING
#	define TEX2D(c) pow(LEVELS(checkTexelBounds(texture, (c))), vec4(inputGamma))
#else
#	define TEX2D(c) LEVELS(checkTexelBounds(texture, (c)))
#endif


vec2 bounds = vec2(inputSize.x / textureSize.x, 1.0 - inputSize.y / textureSize.y);


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

#ifdef CURVATURE
vec4 checkTexelBounds(Image texture, vec2 coords)
{
	vec2 ss = step(coords, vec2(bounds.x, 1.0)) * step(vec2(0.0, bounds.y), coords);

	return Texel(texture, coords) * ss.x * ss.y;
	// return texcolor;
}
#else
vec4 checkTexelBounds(Image texture, vec2 coords)
{
	return Texel(texture, coords);
}
#endif


// Calculate the influence of a scanline on the current pixel.
//
// 'distance' is the distance in texture coordinates from the current
// pixel to the scanline in question.
// 'color' is the colour of the scanline at the horizontal location of
// the current pixel.
vec4 scanlineWeights(float distance, vec4 color)
{
	// The "width" of the scanline beam is set as 2*(1 + x^4) for
	// each RGB channel.
	vec4 wid = 2.0 + 2.0 * pow(color, vec4(4.0));

	// The "weights" lines basically specify the formula that gives
	// you the profile of the beam, i.e. the intensity as
	// a function of distance from the vertical center of the
	// scanline. In this case, it is gaussian if width=2, and
	// becomes nongaussian for larger widths. Ideally this should
	// be normalized so that the integral across the beam is
	// independent of its width. That is, for a narrower beam
	// "weights" should have a higher peak at the center of the
	// scanline than for a wider beam.
	vec4 weights = vec4(distance / 0.3);
	return 1.4 * exp(-pow(weights * inversesqrt(0.5 * wid), wid)) / (0.6 + 0.2 * wid);
}

vec4 effect(vec4 vcolor, Image texture, vec2 texCoord, vec2 pixel_coords)
{
	vec2 one = 1.0 / textureSize;
	float mod_factor = texCoord.x * textureSize.x * outputSize.x / inputSize.x;

	// Here's a helpful diagram to keep in mind while trying to
	// understand the code:
	//
	//  |      |      |      |      |
	// -------------------------------
	//  |      |      |      |      |
	//  |  01  |  11  |  21  |  31  | <-- current scanline
	//  |      | @    |      |      |
	// -------------------------------
	//  |      |      |      |      |
	//  |  02  |  12  |  22  |  32  | <-- next scanline
	//  |      |      |      |      |
	// -------------------------------
	//  |      |      |      |      |
	//
	// Each character-cell represents a pixel on the output
	// surface, "@" represents the current pixel (always somewhere
	// in the bottom half of the current scan-line, or the top-half
	// of the next scanline). The grid of lines represents the
	// edges of the texels of the underlying texture.

	// Texture coordinates of the texel containing the active pixel.
#ifdef CURVATURE
	vec2 xy = radialDistortion(texCoord, inputSize / textureSize);
#else
	vec2 xy = texCoord;
#endif

#ifdef SCANLINES

	// Of all the pixels that are mapped onto the texel we are
	// currently rendering, which pixel are we currently rendering?
	vec2 ratio_scale = xy * textureSize - 0.5;
	vec2 uv_ratio = fract(ratio_scale);

	// Snap to the center of the underlying texel.
	xy = (floor(ratio_scale) + 0.5) / textureSize;

	// Calculate Lanczos scaling coefficients describing the effect
	// of various neighbour texels in a scanline on the current
	// pixel.
	vec4 coeffs = PI * vec4(1.0 + uv_ratio.x, uv_ratio.x, 1.0 - uv_ratio.x, 2.0 - uv_ratio.x);

	// Prevent division by zero.
	coeffs = FIX(coeffs);

	// Lanczos2 kernel.
	coeffs = 2.0 * sin(coeffs) * sin(coeffs / 2.0) / (coeffs * coeffs);

	// Normalize.
	coeffs /= dot(coeffs, vec4(1.0));

	// Calculate the effective colour of the current and next
	// scanlines at the horizontal location of the current pixel,
	// using the Lanczos coefficients above.
	vec4 col  = clamp(mat4(
		TEX2D(xy + vec2(-one.x, 0.0)),
		TEX2D(xy),
		TEX2D(xy + vec2(one.x, 0.0)),
		TEX2D(xy + vec2(2.0 * one.x, 0.0))) * coeffs,
		0.0, 1.0);
	vec4 col2 = clamp(mat4(
		TEX2D(xy + vec2(-one.x, one.y)),
		TEX2D(xy + vec2(0.0, one.y)),
		TEX2D(xy + one),
		TEX2D(xy + vec2(2.0 * one.x, one.y))) * coeffs,
		0.0, 1.0);

#ifndef LINEAR_PROCESSING
        col  = pow(col , vec4(inputGamma));
        col2 = pow(col2, vec4(inputGamma));
#endif

	// Calculate the influence of the current and next scanlines on
	// the current pixel.
	vec4 weights  = scanlineWeights(uv_ratio.y, col);
	vec4 weights2 = scanlineWeights(1.0 - uv_ratio.y, col2);

	vec4 mul_res_f = (col * weights + col2 * weights2);
	vec3 mul_res = mul_res_f.rgb;


#else

	vec4 mul_res_f = TEX2D(xy);
	vec3 mul_res = mul_res_f.rgb;

#endif


	// dot-mask emulation:
	// Output pixels are alternately tinted green and magenta.
	vec3 dotMaskWeights = mix(
		vec3(1.0, 0.7, 1.0),
		vec3(0.7, 1.0, 0.7),
		floor(mod(mod_factor, 2.0))
	);

	mul_res *= dotMaskWeights;

	// Convert the image gamma for display on our output device.
	mul_res = pow(mul_res, vec3(1.0 / outputGamma));

	// Color the texel.
	return vec4(mul_res * 1.0, 1.0);
}

