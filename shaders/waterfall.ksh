	   waterfall   	   MatrixPVW                                                                                MatrixW                                                                                UV_OFFSET_LAYER_01                        UV_OFFSET_LAYER_02                        SAMPLER    +         LIGHTMAP_WORLD_EXTENTS                                TINT_ADD                             	   TINT_MULT                             
   anim_uv.vs�  uniform mat4 MatrixPVW;
uniform mat4 MatrixW;
uniform vec2 UV_OFFSET_LAYER_01;
uniform vec2 UV_OFFSET_LAYER_02;

attribute vec3 POSITION;
attribute vec2 TEXCOORD0;

varying vec2 PS_TEXCOORD_LAYER_01;
varying vec2 PS_TEXCOORD_LAYER_02;
varying vec3 PS_POS;

void main()
{
	gl_Position = MatrixPVW * vec4( POSITION.xyz, 1.0 );
	PS_TEXCOORD_LAYER_01.x = TEXCOORD0.x + UV_OFFSET_LAYER_01.x;
	PS_TEXCOORD_LAYER_01.y = TEXCOORD0.y + UV_OFFSET_LAYER_01.y;
	PS_TEXCOORD_LAYER_02.x = TEXCOORD0.x + UV_OFFSET_LAYER_02.x;
	PS_TEXCOORD_LAYER_02.y = TEXCOORD0.y + UV_OFFSET_LAYER_02.y;

	vec4 world_pos = MatrixW * vec4( POSITION.xyz, 1.0 );
	PS_POS.xyz = world_pos.xyz;
}

    waterfall.ps  #if defined( GL_ES )
precision mediump float;
#endif

uniform sampler2D SAMPLER[4];
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


varying vec2 PS_TEXCOORD_LAYER_01;
varying vec2 PS_TEXCOORD_LAYER_02;

uniform vec4 TINT_ADD;
uniform vec4 TINT_MULT;

// Already defined by lighting.h
// varying vec3 PS_POS

void main()
{
	// The same texture is sampled twice at different uv positions...
	vec4 rgba_01 = texture2D(SAMPLER[0], PS_TEXCOORD_LAYER_01.xy);
	vec4 rgba_02 = texture2D(SAMPLER[0], PS_TEXCOORD_LAYER_02.xy);

	// ...and then interpolated together to create a layered effect in the falling water.
    gl_FragColor.rgba = mix(rgba_01, rgba_02, 0.5);

	vec4 colour = gl_FragColor;
	gl_FragColor.rgb *= (TINT_MULT.rgb * TINT_MULT.a);
	//gl_FragColor.a *= TINT_MULT.a;
	gl_FragColor.rgb += (TINT_ADD.rgb * colour.a * TINT_ADD.a * TINT_MULT.a);
	gl_FragColor.rgb = clamp(gl_FragColor.rgb, 0.0, 1.0);		// or the light override may bring back detail!


	gl_FragColor.rgb *= CalculateLightingContribution();

	// Mapping the height of the waterfall (0.0 at the top and -2.0 at the bottom) between PI/2.0 and 0.0,
	// then plugging that mapping into the sin function to create the drop off in alpha of the waterfall.
	// The water becomes more transparent as it gets closer to the bottom of the falls.
	gl_FragColor.a = sin(clamp((PS_POS.y + 2.0) * 3.14159265359 * 0.25, 0.0, 3.14159265359 * 0.5) * TINT_MULT.a);
}

                                