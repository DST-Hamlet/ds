   particle   	   MatrixPVW                                                                                MatrixW                                                                                SAMPLER    +         LIGHTMAP_WORLD_EXTENTS                                particle.vs�  uniform mat4 MatrixPVW;
uniform mat4 MatrixW;

attribute vec3 POSITION;
attribute vec2 TEXCOORD0;
attribute vec4 DIFFUSE;

varying vec3 PS_POS;
varying vec2 PS_TEXCOORD;
varying vec4 PS_COLOUR;

void main()
{
	gl_Position = MatrixPVW * vec4( POSITION.xyz, 1.0 );

	vec4 world_pos = MatrixW * vec4( POSITION.xyz, 1.0 );
	PS_POS.xyz = world_pos.xyz;

	PS_TEXCOORD.xy = TEXCOORD0.xy;
	PS_COLOUR = DIFFUSE;
	PS_COLOUR.rgb *= PS_COLOUR.a;
}

    particle.ps  #if defined( GL_ES )
precision mediump float;
#endif

uniform sampler2D SAMPLER[4];

varying vec2 PS_TEXCOORD;
varying vec4 PS_COLOUR;

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
	vec4 colour = texture2D( SAMPLER[0], PS_TEXCOORD.xy );
	gl_FragColor = vec4( colour.rgb * PS_COLOUR.rgb, colour.a * PS_COLOUR.a );
	gl_FragColor.rgb *= CalculateLightingContribution();
}

                    