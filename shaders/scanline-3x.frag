/*
    Scanline 3x Shader
	Copyright (C) 2011 hunterk

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

This shader works best at scale 3x or else the pixels don't match up correctly.
*/
// modified by slime73 for use with love pixeleffects


vec4 effect(vec4 vcolor, Image texture, vec2 texture_coords, vec2 pixel_coords)
{ 
	vec4 rgb = Texel(texture, texture_coords);
	vec4 intens;
	if (fract(gl_FragCoord.y * (0.5*4.0/3.0)) > 0.5)
		intens = vec4(0.0, 0.0, 0.0, 1.0);
	else
		intens = smoothstep(0.2,0.8,rgb) + normalize(vec4(rgb.xyz, 1.0));
	number level = (4.0-gl_TexCoord[0].z) * 0.19;
    return vec4((intens * (0.5-level) + rgb * 1.1).rgb, 1.0);
}
