   anim	      MatrixP                                                                                MatrixV                                                                                MatrixW                                                                                SAMPLER    +         LIGHTMAP_WORLD_EXTENTS                                TINT_ADD                             	   TINT_MULT                                PARAMS                                FILM_PARAMS                                anim.vs_  #ifdef SKINNED
uniform mat4 pv;
uniform mat4 fastanim_xform;
uniform vec4 fastanim_bones[64];
#else
uniform mat4 MatrixP;
uniform mat4 MatrixV;
uniform mat4 MatrixW;
#endif

attribute vec3 POSITION;
attribute vec3 TEXCOORD0;

varying vec3 PS_TEXCOORD;
varying vec3 PS_POS;
varying vec3 PS_SPOS;

#if defined( FADE_OUT )
    uniform mat4 STATIC_WORLD_MATRIX;
    varying vec2 FADE_UV;
#endif

void main()
{
#ifdef SKINNED
	int matrix_index = int(POSITION.z + 0.5);
	float _a = fastanim_bones[matrix_index*2].x;
	float _b = fastanim_bones[matrix_index*2].y;
	float _c = fastanim_bones[matrix_index*2].z;
	float _d = fastanim_bones[matrix_index*2].w;
	float tx = fastanim_bones[matrix_index*2+1].x;
	float ty = fastanim_bones[matrix_index*2+1].y;

	mat4 matWorld = mat4(_a,_b, 0, 0,
						 _c,_d, 0, 0,
						 0, 0, 1, 0,
						 tx, ty, 0, 1); // Column-major!

	mat4 mat = fastanim_xform * matWorld;
	mat4 pvw = pv * mat;

	vec3 _aPosition = vec3(POSITION.x,POSITION.y,0.0);	
	gl_Position = pvw * vec4(_aPosition, 1.0); 

	vec4 world_pos = mat * vec4( _aPosition, 1.0 );

	PS_TEXCOORD = TEXCOORD0;
	PS_POS = world_pos.xyz;
	PS_SPOS = gl_Position.xyz;
#else
	mat4 mtxPVW = MatrixP * MatrixV * MatrixW;
	gl_Position = mtxPVW * vec4( POSITION.xyz, 1.0 );

	vec4 world_pos = MatrixW * vec4( POSITION.xyz, 1.0 );

	PS_TEXCOORD = TEXCOORD0;
	PS_POS = world_pos.xyz;
	PS_SPOS = gl_Position.xyz;
#endif

#if defined( FADE_OUT )
	vec4 static_world_pos = STATIC_WORLD_MATRIX * vec4( POSITION.xyz, 1.0 );
    vec3 forward = normalize( vec3( MatrixV[2][0], 0.0, MatrixV[2][2] ) );
    float d = dot( static_world_pos.xyz, forward );
    vec3 pos = static_world_pos.xyz + ( forward * -d );
    vec3 left = cross( forward, vec3( 0.0, 1.0, 0.0 ) );

    FADE_UV = vec2( dot( pos, left ) / 4.0, static_world_pos.y / 8.0 );
#endif
}

    anim.ps�  #if defined( GL_ES )
precision mediump float;
#endif

uniform sampler2D SAMPLER[5];

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


varying vec3 PS_TEXCOORD;
varying vec3 PS_SPOS;

uniform vec4 TINT_ADD;
uniform vec4 TINT_MULT;
uniform vec4 PARAMS;
uniform vec4 FILM_PARAMS;

#define ALPHA_TEST PARAMS.x
#define LIGHT_OVERRIDE PARAMS.y

#if defined( FADE_OUT )
	uniform vec3 EROSION_PARAMS; 
    varying vec2 FADE_UV;

	#define ERODE_SAMPLER SAMPLER[2]
	#define EROSION_MIN EROSION_PARAMS.x
	#define EROSION_RANGE EROSION_PARAMS.y
	#define EROSION_LERP EROSION_PARAMS.z
#endif

#define SCRATCH_SAMPLER SAMPLER[4]


vec3 Overlay (vec3 src, vec3 dst)
{
	// if (dst <= 0.5) then: 2 * src * dst
	// if (dst > 0.5) then: 1 - 2 * (1 - dst) * (1 - src)
	return vec3((dst.x <= 0.5) ? (2.0 * src.x * dst.x) : (1.0 - 2.0 * (1.0 - dst.x) * (1.0 - src.x)),
			(dst.y <= 0.5) ? (2.0 * src.y * dst.y) : (1.0 - 2.0 * (1.0 - dst.y) * (1.0 - src.y)),
			(dst.z <= 0.5) ? (2.0 * src.z * dst.z) : (1.0 - 2.0 * (1.0 - dst.z) * (1.0 - src.z)));
}

void main()
{
	vec4 colour;
	if( PS_TEXCOORD.z < 0.5 )
	{
		colour.rgba = texture2D( SAMPLER[0], PS_TEXCOORD.xy );
	}
	else
	{
		colour.rgba = texture2D( SAMPLER[1], PS_TEXCOORD.xy );
	}

	if( colour.a >= ALPHA_TEST )
	{
		gl_FragColor.rgba = colour.rgba;

//		gl_FragColor.rgb *= (TINT_MULT.rgb * TINT_MULT.a);
//		gl_FragColor.a *= TINT_MULT.a;
//		gl_FragColor.rgb += (TINT_ADD.rgb * colour.a * TINT_ADD.a);
//		gl_FragColor.rgb = clamp(gl_FragColor.rgb, 0.0, 1.0);		// or the light override may bring back detail!

		float randomValue = PARAMS.z;
		float randomValue2 = PARAMS.w;

		float desaturation = FILM_PARAMS.x;
		float sepiaStrength = FILM_PARAMS.y;
		float filmGrainScaleValue = FILM_PARAMS.z;
		float filmGrainStrength = FILM_PARAMS.w;

		if ((desaturation != 0.0) || (sepiaStrength != 0.0))
		{
			float gray = (colour.x + colour.y + colour.z) / 3.0;	// Well, okay, that's not quite true but it'll do
    	    vec3 grayscale = vec3(gray);
			gl_FragColor.rgb = mix(gl_FragColor.rgb, vec3(gray, gray, gray), desaturation);  

			vec3 sepia = vec3(112.0 / 255.0, 66.0 / 255.0, 20.0 / 255.0);
		    vec3 finalColour = Overlay(sepia, grayscale);
			gl_FragColor.rgb = gl_FragColor.rgb + sepiaStrength * (finalColour - grayscale);
		}

		if (filmGrainStrength != 0.0)
		{
			vec2 spos = PS_SPOS.xy;
			vec2 origin = vec2(randomValue, randomValue2);
			spos /= filmGrainScaleValue;		
			vec4 scratch;
			scratch.rgba = texture2D( SCRATCH_SAMPLER, spos.xy + origin );
			scratch.rgb = mix(vec3(1,1,1), scratch.rgb, filmGrainStrength); 
			gl_FragColor.rgb *= scratch.rgb;
		}

		gl_FragColor.rgb *= (TINT_MULT.rgb * TINT_MULT.a);
		gl_FragColor.a *= TINT_MULT.a;
		gl_FragColor.rgb += (TINT_ADD.rgb * colour.a * TINT_ADD.a * TINT_MULT.a);
		gl_FragColor.rgb = clamp(gl_FragColor.rgb, 0.0, 1.0);		// or the light override may bring back detail!

#if defined( FADE_OUT )
		float height = texture2D( ERODE_SAMPLER, FADE_UV.xy ).a;
		float erode_val = clamp( ( height - EROSION_MIN ) / EROSION_RANGE, 0.0, 1.0 );
		gl_FragColor.rgba = mix( gl_FragColor.rgba, gl_FragColor.rgba * erode_val, EROSION_LERP );
#endif

		vec3 light = CalculateLightingContribution();
		gl_FragColor.rgb *= max( light.rgb, vec3( LIGHT_OVERRIDE, LIGHT_OVERRIDE, LIGHT_OVERRIDE ) );
	}
	else
	{
		discard;
	}
}

                                   