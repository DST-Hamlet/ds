   postprocessbloom_blur      SAMPLER    +         POST_PARAMS                            BLUR_PARAMS                                postprocess.vs�  #define ENABLE_BLOOM
#define ENABLE_BLUR
attribute vec3 POSITION;
attribute vec2 TEXCOORD0;

varying vec2 PS_TEXCOORD0;
varying vec2 PS_TEXCOORD1;

uniform vec3 POST_PARAMS;
#if defined( ENABLE_DISTORTION )
	#define TIME POST_PARAMS.x
#endif 

void main()
{
	gl_Position = vec4( POSITION.xyz, 1.0 );
	PS_TEXCOORD0.xy = TEXCOORD0.xy;
	 
#if defined( ENABLE_DISTORTION )
	float range = 0.00625;
	float time_scale = 50.0;
	vec2 offset_vec = vec2( cos( TIME * time_scale + 0.25 ), sin( TIME * time_scale ) );
	vec2 small_uv = TEXCOORD0.xy * ( 1.0 - 2.0 * range ) + range;
	PS_TEXCOORD1.xy = small_uv + offset_vec * range;
#endif

}

    postprocess.ps   #define ENABLE_BLOOM
#define ENABLE_BLUR
#if defined( GL_ES )
precision highp float;
#endif

// This is just here so that I don't need a jungle of ifdefs when defining the sampler indices.
// Angle is REALLY anal about this. You can't enable a sampler
// that you aren't going to use or it very quietly asserts in the
// dll with a spectacularly less than informative assert.

#if defined( ENABLE_BLOOM )
	#define BLOOM_SAMPLER_COUNT	1
#else
	#define BLOOM_SAMPLER_COUNT	0
#endif
#if defined( ENABLE_BLUR )
	#define BLUR_SAMPLER_COUNT	1
#else
	#define BLUR_SAMPLER_COUNT	0
#endif

#define SAMPLERCOUNT (2 + BLUR_SAMPLER_COUNT + BLOOM_SAMPLER_COUNT)

// Angle is REALLY anal about this. You can't enable a sampler
// that you aren't going to use or it very quietly asserts in the
// dll with a spectacularly less than informative assert.
uniform sampler2D SAMPLER[SAMPLERCOUNT];

uniform vec3 POST_PARAMS;

#define TIME                POST_PARAMS.x
#define INTENSITY_MODIFIER  POST_PARAMS.y

#define SRC_IMAGE        SAMPLER[0]
#define COLOUR_CUBE      SAMPLER[1]
#define BLUR_BUFFER      SAMPLER[2]
#define BLOOM_BUFFER     SAMPLER[2 + BLUR_SAMPLER_COUNT]

varying vec2 PS_TEXCOORD0;
#if defined( ENABLE_DISTORTION )
varying vec2 PS_TEXCOORD1;
#endif

#define CUBE_DIMENSION 32.0
#define CUBE_WIDTH  ( CUBE_DIMENSION * CUBE_DIMENSION )
#define CUBE_HEIGHT ( CUBE_DIMENSION )

#define TEXEL_WIDTH   ( 1.0 / CUBE_WIDTH )
#define TEXEL_HEIGHT  ( 1.0 / CUBE_HEIGHT)
#define HALF_TEXEL_WIDTH  ( TEXEL_WIDTH  * 0.5 )
#define HALF_TEXEL_HEIGHT ( TEXEL_HEIGHT * 0.5 )

#if defined( ENABLE_DISTORTION )
	uniform vec3 DISTORTION_PARAMS;

	#define DISTORTION_FACTOR			DISTORTION_PARAMS.x
	#define DISTORTION_INNER_RADIUS		DISTORTION_PARAMS.y
	#define DISTORTION_OUTER_RADIUS		DISTORTION_PARAMS.z
#endif

#if defined( ENABLE_BLUR)
	uniform vec4 BLUR_PARAMS;
#endif

vec3 ApplyColourCube(vec3 colour)
{
	vec3 intermediate = colour.rgb * vec3( CUBE_DIMENSION - 1.0, CUBE_DIMENSION, CUBE_DIMENSION - 1.0 );
	vec2 floor_uv = vec2( ( min( intermediate.r + 0.5, 31.0 ) + floor( intermediate.b ) * CUBE_DIMENSION ) / CUBE_WIDTH,1.0 - ( min( intermediate.g, 31.0 ) / CUBE_HEIGHT ) );
	vec2 ceil_uv = vec2( ( min( intermediate.r + 0.5, 31.0 ) + ceil( intermediate.b ) * CUBE_DIMENSION ) / CUBE_WIDTH,1.0 - ( min( intermediate.g, 31.0 ) / CUBE_HEIGHT ) );
	vec3 floor_col = texture2D( COLOUR_CUBE, floor_uv.xy ).rgb;
	vec3 ceil_col = texture2D( COLOUR_CUBE, ceil_uv.xy ).rgb;
	return mix(floor_col, ceil_col, intermediate.b - floor(intermediate.b) );	
}

void main()
{
	vec3 base_colour = texture2D( SRC_IMAGE, PS_TEXCOORD0.xy ).rgb; // rgb all 0:1 - colour space

#if defined( ENABLE_BLUR )
	vec3 blur_colour = texture2D( BLUR_BUFFER, PS_TEXCOORD0.xy ).rgb; // rgb all 0:1 - colour space

	float dist = distance(PS_TEXCOORD0.xy, vec2(BLUR_PARAMS.x, BLUR_PARAMS.y));
	dist -= BLUR_PARAMS.z;
    dist *= BLUR_PARAMS.w;
	dist = clamp(dist,0.0,1.0);
	base_colour = mix(base_colour, blur_colour, dist);
#endif

#if defined( ENABLE_BLOOM )
	vec3 bloom = texture2D( BLOOM_BUFFER, PS_TEXCOORD0.xy ).rgb;
	base_colour.rgb += bloom.rgb;
#endif

#if defined( ENABLE_DISTORTION )

	// Offset comes from vert shader
	vec2 offset_uv = PS_TEXCOORD1.xy;
	
	// rotation amount
	vec3 distorted_colour = texture2D( SRC_IMAGE, offset_uv ).xyz;


#if defined( ENABLE_BLUR )
	vec3 blur_distorted_colour = texture2D( BLUR_BUFFER, offset_uv ).rgb;

	float distort_dist = distance(offset_uv, vec2(BLUR_PARAMS.x, BLUR_PARAMS.y));
	distort_dist -= BLUR_PARAMS.z;
    distort_dist *= BLUR_PARAMS.w;
	distort_dist = clamp(distort_dist,0.0,1.0);
	distorted_colour = mix(distorted_colour, blur_distorted_colour, distort_dist);
#endif

	#if defined( ENABLE_BLOOM ) 
		distorted_colour.rgb += texture2D( BLOOM_BUFFER, offset_uv ).rgb;
	#endif

	float distortion_mask = clamp( ( 1.0 - distance( PS_TEXCOORD0.xy, vec2( 0.5, 0.5 ) ) - DISTORTION_INNER_RADIUS ) / ( DISTORTION_OUTER_RADIUS - DISTORTION_INNER_RADIUS ), 0.0, 1.0 );
	distorted_colour.rgb = mix( distorted_colour, base_colour, DISTORTION_FACTOR );
	base_colour.rgb = mix( distorted_colour, base_colour, distortion_mask );
#endif
 
	vec3 cc = ApplyColourCube(base_colour.rgb);	

    cc *= INTENSITY_MODIFIER;

    gl_FragColor = vec4( cc, 1.0 );
}

                  