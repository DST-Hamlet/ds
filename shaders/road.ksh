   road   	   MatrixPVW                                                                                MatrixW                                                                                SAMPLER    +         GROUND_REPEAT_VEC                        BLEND_FACTOR                            GROUND_COL0                                GROUND_COL1                                GROUND_COL2                                TINT_ADD                             	   TINT_MULT                                LIGHTMAP_WORLD_EXTENTS                                PosUV_WorldPos.vs_  uniform mat4 MatrixPVW;
uniform mat4 MatrixW;

attribute vec3 POSITION;
attribute vec2 TEXCOORD0;

varying vec2 PS_TEXCOORD;
varying vec3 PS_POS;

void main()
{
	gl_Position = MatrixPVW * vec4( POSITION.xyz, 1.0 );
	PS_TEXCOORD.xy = TEXCOORD0;

	vec4 world_pos = MatrixW * vec4( POSITION.xyz, 1.0 );
	PS_POS.xyz = world_pos.xyz;
}

    road.ps�  #if defined( GL_ES )
precision mediump float;
#endif

uniform sampler2D SAMPLER[4]; // SAMPLER[3] used in lighting.h

#define BASE_TEXTURE SAMPLER[0]
#define NOISE_TEXTURE SAMPLER[1]
#define MULTILAYER_TEXTURE SAMPLER[2]

uniform vec2 GROUND_REPEAT_VEC;
uniform vec3 BLEND_FACTOR;

varying vec2 PS_TEXCOORD;

uniform vec4 GROUND_COL0;
uniform vec4 GROUND_COL1;
uniform vec4 GROUND_COL2;

// Already defined by lighting.h
// varying vec3 PS_POS

uniform vec4 TINT_ADD;
uniform vec4 TINT_MULT;

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
	vec2 noise_uv = PS_POS.xz / GROUND_REPEAT_VEC.x;
	vec2 world_noise_uv = PS_POS.xz / GROUND_REPEAT_VEC.y;

	vec4 noise = texture2D( NOISE_TEXTURE, noise_uv );

	vec4 base_colour = texture2D( BASE_TEXTURE, PS_TEXCOORD.xy );
	base_colour.rgb /= base_colour.a;
	base_colour.rgb *= noise.rgb;

	vec3 layers = texture2D( MULTILAYER_TEXTURE, world_noise_uv ).rgb;
	layers *= BLEND_FACTOR;

	vec3 colour;
	colour.rgb = layers.r * GROUND_COL0.a * ( GROUND_COL0.rgb ) + ( 1.0 - layers.r * GROUND_COL0.a ) * base_colour.rgb;
	colour.rgb = layers.g * GROUND_COL1.a * ( GROUND_COL1.rgb ) + ( 1.0 - layers.g * GROUND_COL1.a ) * colour.rgb;
	colour.rgb = layers.b * GROUND_COL2.a * ( GROUND_COL2.rgb ) + ( 1.0 - layers.b * GROUND_COL2.a ) * colour.rgb;

	base_colour.a *= TINT_MULT.a;
	colour.rgb += (TINT_ADD.rgb * base_colour.a * TINT_ADD.a * TINT_MULT.a);
	colour.rgb = clamp(colour.rgb, 0.0, 1.0);		

	gl_FragColor.rgb = colour.rgb * CalculateLightingContribution();
	gl_FragColor.a = noise.a * base_colour.a;
	gl_FragColor.rgb *= gl_FragColor.a;
}

           	                        	   
   