   interior_walls   	   MatrixPVW                                                                                MatrixW                                                                                InteriorTexFactor                     SAMPLER    +         TINT_ADD                             	   TINT_MULT                                LIGHTMAP_WORLD_EXTENTS                                interior_walls.vs�  uniform mat4 MatrixPVW;
uniform mat4 MatrixW;
uniform float InteriorTexFactor;

attribute vec3 POSITION;
attribute vec2 TEXCOORD0;

varying vec2 PS_TEXCOORD;
varying vec3 PS_POS;

void main()
{
	gl_Position = MatrixPVW * vec4( POSITION.xyz, 1.0 );
	PS_TEXCOORD.x = TEXCOORD0.x * InteriorTexFactor;
	PS_TEXCOORD.y = TEXCOORD0.y;

	vec4 world_pos = MatrixW * vec4( POSITION.xyz, 1.0 );
	PS_POS.xyz = world_pos.xyz;
}

    interior_walls.ps�  #if defined( GL_ES )
precision mediump float;
#endif

uniform sampler2D SAMPLER[4]; // SAMPLER[3] used in lighting.h

#define BASE_TEXTURE SAMPLER[0]
#define NOISE_TEXTURE SAMPLER[1]
#define MULTILAYER_TEXTURE SAMPLER[2]

varying vec2 PS_TEXCOORD;

uniform vec4 TINT_ADD;
uniform vec4 TINT_MULT;

// Already defined by lighting.h
// varying vec3 PS_POS

#ifndef LIGHTING_H
#define LIGHTING_H

// Lighting
varying vec3 PS_POS;

// xy = min, zw = max
uniform vec4 LIGHTMAP_WORLD_EXTENTS;

#define LIGHTMAP_TEXTURE SAMPLER[3]

#ifndef LIGHTMAP_TEXTURE
	#error If you use lighting, you must #define the sampler that the lightmap belongs to
#endif

vec3 CalculateLightingContribution()
{
	vec2 uv = ( PS_POS.xz - LIGHTMAP_WORLD_EXTENTS.xy ) * LIGHTMAP_WORLD_EXTENTS.zw;

	vec3 colour = texture2D( LIGHTMAP_TEXTURE, uv.xy ).rgb;

	return clamp( colour.rgb, vec3( 0, 0, 0 ), vec3( 1, 1, 1 ) );
}

vec3 CalculateLightingContribution( vec3 normal )
{
	return vec3( 1, 1, 1 );
}

#endif //LIGHTING.h


void main()
{
	vec4 base_colour = texture2D( BASE_TEXTURE, PS_TEXCOORD );
	vec3 colour = base_colour.rgb;

	colour.rgb *= (TINT_MULT.rgb * TINT_MULT.a);
	base_colour.a *= TINT_MULT.a;
	colour.rgb += (TINT_ADD.rgb * base_colour.a * TINT_ADD.a * TINT_MULT.a);
	colour.rgb = clamp(colour.rgb, 0.0, 1.0);		// or the light override may bring back detail!

	colour.rgb *= CalculateLightingContribution();

	gl_FragColor = vec4( colour.rgb, 1.0 );
}
                             