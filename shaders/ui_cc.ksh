   ui_cc   	   MatrixPVW                                                                                SAMPLER    +         IMAGE_PARAMS                                PosUVColour.vsg  uniform mat4 MatrixPVW;

attribute vec3 POSITION;
attribute vec2 TEXCOORD0;
attribute vec4 DIFFUSE;

varying vec2 PS_TEXCOORD;
varying vec4 PS_COLOUR;

void main()
{
	gl_Position = MatrixPVW * vec4( POSITION.xyz, 1.0 );
	PS_TEXCOORD.xy = TEXCOORD0.xy;
	PS_COLOUR.rgba = vec4( DIFFUSE.rgb * DIFFUSE.a, DIFFUSE.a ); // premultiply the alpha
}

    ui_cc.ps�  #if defined( GL_ES )
precision mediump float;
#endif

uniform sampler2D SAMPLER[2];
varying vec2 PS_TEXCOORD;
varying vec4 PS_COLOUR;

uniform vec4 IMAGE_PARAMS;

#define COLOUR_CUBE      SAMPLER[1]

#define CUBE_DIMENSION 32.0
#define CUBE_WIDTH  ( CUBE_DIMENSION * CUBE_DIMENSION )
#define CUBE_HEIGHT ( CUBE_DIMENSION )

#define TEXEL_WIDTH   ( 1.0 / CUBE_WIDTH )
#define TEXEL_HEIGHT  ( 1.0 / CUBE_HEIGHT)
#define HALF_TEXEL_WIDTH  ( TEXEL_WIDTH  * 0.5 )
#define HALF_TEXEL_HEIGHT ( TEXEL_HEIGHT * 0.5 )

vec2 GetCCUV( vec3 colour )
{
    vec3 intermediate = colour.rgb * vec3( CUBE_DIMENSION - 1.0, CUBE_DIMENSION, CUBE_DIMENSION - 1.0 / CUBE_WIDTH ); // rgb all 0:31 - cube space
	vec2 uv = vec2( ( min( intermediate.r + 0.5, 31.0 ) + floor( intermediate.b ) * CUBE_DIMENSION ) / CUBE_WIDTH,
                          1.0 - ( min( intermediate.g, 31.0 ) / CUBE_HEIGHT ) );

	return uv;
}

vec3 texture2DBilinear( sampler2D textureSampler, vec2 uv )
{
    // in vertex shaders you should use texture2DLod instead of texture2D
    vec3 tl = texture2D(textureSampler, uv).rgb;
    vec3 tr = texture2D(textureSampler, uv + vec2(TEXEL_WIDTH,	0			)).rgb;
    vec3 bl = texture2D(textureSampler, uv + vec2(0,			TEXEL_HEIGHT)).rgb;
    vec3 br = texture2D(textureSampler, uv + vec2(TEXEL_WIDTH , TEXEL_HEIGHT)).rgb;
    vec2 f = fract( uv.xy * vec2(CUBE_WIDTH,CUBE_HEIGHT) ); // get the decimal part
    vec3 tA = mix( tl, tr, f.x ); // will interpolate the red dot in the image
    vec3 tB = mix( bl, br, f.x ); // will interpolate the blue dot in the image
    return mix( tA, tB, f.y ); // will interpolate the green dot in the image
}


void main()
{
    vec4 colour = texture2D( SAMPLER[0], PS_TEXCOORD.xy );
	colour.rgba *= PS_COLOUR.rgba;
	colour.rgba *= IMAGE_PARAMS.rgba;
    
	
	// 0:1 - uv space
    vec2 base_cc_uv = GetCCUV( colour.rgb );
	
    //Manually apply bilinear filtering to the colour cube, to prevent anistropic "red outline" filtering bug
    vec3 cc = texture2DBilinear( COLOUR_CUBE, base_cc_uv.xy - vec2(HALF_TEXEL_WIDTH, HALF_TEXEL_HEIGHT)).rgb;
    
    //cc *= INTENSITY_MODIFIER;
	
	
	gl_FragColor = vec4( cc.r, cc.g, cc.b, colour.a);
}

                 