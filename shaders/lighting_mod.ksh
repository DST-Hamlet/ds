   lighting_mod      MatrixP                                                                                MatrixV                                                                                MatrixW                                                                             	   LIGHT_POS                            LIGHT_COLOUR                            LIGHT_PARAMETERS                            LIGHT_CONSTANTS                            lighting.vs^  #define MODULATE
uniform mat4 MatrixP;
uniform mat4 MatrixV;
uniform mat4 MatrixW;

attribute vec3 POSITION;

varying vec4 PS_POS;

void main()
{
	mat4 mtxPVW = MatrixP * MatrixV * MatrixW;

	gl_Position = mtxPVW * vec4( POSITION.xyz, 1.0 );

	vec4 world_pos = MatrixW * vec4( POSITION.xyz, 1.0 );
	PS_POS.xyz = world_pos.xyz;
}

    lighting.ps�  #define MODULATE
#if defined( GL_ES )
precision highp float;
#endif

varying vec4 PS_POS;

uniform vec3 LIGHT_POS;
uniform vec3 LIGHT_COLOUR;
uniform vec3 LIGHT_PARAMETERS;
uniform vec3 LIGHT_CONSTANTS;


#define FC LIGHT_PARAMETERS.x
#define RC LIGHT_PARAMETERS.y
#define S LIGHT_PARAMETERS.z

#define K0 LIGHT_CONSTANTS.x
#define K1 LIGHT_CONSTANTS.y

void main()
{
	
	float dist = distance(PS_POS.xz, LIGHT_POS.xz);
	float t = clamp( exp(K0* pow((dist/RC), -K1)), 0.0, 1.0);
#ifdef MODULATE
	vec3 colour = mix( vec3( 1, 1, 1 ), LIGHT_COLOUR.rgb, t );
#else
	vec3 colour = mix( vec3( 0, 0, 0 ), LIGHT_COLOUR.rgb, t );
#endif
	gl_FragColor = vec4( colour, 1 );
}

                             