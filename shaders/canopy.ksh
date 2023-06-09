   canopy      MatrixP                                                                                MatrixV                                                                                MatrixW                                                                                SAMPLER    +         CANOPY                             	   canopy.vs�  uniform mat4 MatrixP;
uniform mat4 MatrixV;
uniform mat4 MatrixW;

attribute vec3 POSITION;
attribute vec2 TEXCOORD0;

//varying vec4 PS_POS;

//varying vec3 PS_POS;
varying vec2 PS_TEXCOORD;

void main()
{
	mat4 mtxPVW = MatrixP * MatrixV * MatrixW;

	gl_Position = mtxPVW * vec4( POSITION.xyz, 1.0 );

	vec4 world_pos = MatrixW * vec4( POSITION.xyz, 1.0 );

	//PS_POS.xyz = world_pos.xyz;
	PS_TEXCOORD.xy = TEXCOORD0.xy;
}

 	   canopy.psf  #if defined( GL_ES )
precision highp float;
#endif


uniform sampler2D SAMPLER[1];

#define BASE_TEXTURE SAMPLER[0]

// xy = min, zw = max
uniform vec4 CANOPY;

varying vec2 PS_TEXCOORD;

#define CLOUD_COVER 0.5

void main()
{
	vec4 base_colour = texture2D( BASE_TEXTURE, PS_TEXCOORD.xy );
	//gl_FragColor = vec4(base_colour.r, 0, 0, 1);
	//base_colour *= 1.0 - base_colour * 0.3;
	// Multiply with the ambient term
#if 0
	float term = base_colour.r;
	float delta = 1.0 - term;
	delta *= 0.3;
	base_colour = vec4(1.0 - delta, 1.0 - delta, 1.0 - delta, 1.0 - term);
#endif
	float delta;
	float term;

	float soften = CANOPY.w;

	term = base_colour.r;
	delta = 1.0 - term;
	delta *= soften;
	base_colour.r = 1.0 - delta;

	term = base_colour.g;
	delta = 1.0 - term;
	delta *= soften;
	base_colour.g = 1.0 - delta;

	term = base_colour.b;
	delta = 1.0 - term;
	delta *= soften;
	base_colour.b = 1.0 - delta;

	vec3 ambient = vec3(0.5,1.0,1.0);
	ambient.r = CANOPY.r;
	ambient.g = CANOPY.g;
	ambient.b = CANOPY.b;

	base_colour.rgb *= ambient;
	gl_FragColor = base_colour;
}                       