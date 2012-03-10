/*
WhateverMan's Bloom Shader
Copyright (c) 2010 WhateverMan

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/
// modified by slime73 for use with love pixeleffects


#define glarebasesize 0.896
#define power 0.50

#define pi 3.14159

extern vec2 textureSize;

vec4 effect(vec4 vcolor, Image texture, vec2 texcoord, vec2 pixel_coords)
{
	vec4 texcolor = Texel(texture, texcoord);
	
	vec4 sum = vec4(0.0);
	vec4 bum = vec4(0.0);

	vec2 glaresize = vec2(glarebasesize) / textureSize;

	int j;
	int i;

	for (i = -2; i < 2; i++)
	{
		for (j = -1; j < 1; j++)
		{
			sum += Texel(texture, texcoord + vec2(-i, j)*glaresize) * power;
			bum += Texel(texture, texcoord + vec2(j, i)*glaresize) * power;            
		}
	}
	
	vec4 finalcolor;

	if (texcolor.r < 2.0)
	{
		finalcolor = sum*sum*sum*0.001+bum*bum*bum*0.0080 + texcolor;
	}
	else
	{
		finalcolor = vec4(0.0, 0.0, 0.0, 1.0);
	}

	finalcolor.a = 1.0;
	
	return finalcolor;
}

