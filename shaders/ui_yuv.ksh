   ui_yuv   	   MatrixPVW                                                                                SAMPLER    +         PosUVColour.vsg  uniform mat4 MatrixPVW;

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

 	   ui_yuv.ps�  #if defined( GL_ES )
precision mediump float;
#endif

uniform sampler2D SAMPLER[3];
varying vec2 PS_TEXCOORD;
varying vec4 PS_COLOUR;

const vec3 offset = vec3(-0.0625, -0.5, -0.5);
const vec3 Rcoeff = vec3(1.164,  0.000,  1.596);
const vec3 Gcoeff = vec3(1.164, -0.391, -0.813);
const vec3 Bcoeff = vec3(1.164,  2.018,  0.000);


void main()
{
	vec3 yuv;
    yuv.x = texture2D( SAMPLER[0], PS_TEXCOORD.xy ).a;
    yuv.y = texture2D( SAMPLER[1], PS_TEXCOORD.xy ).a;
    yuv.z = texture2D( SAMPLER[2], PS_TEXCOORD.xy ).a;
	yuv += offset;
	
	vec4 rgba;
	rgba.r = dot(yuv, Rcoeff);
	rgba.g = dot(yuv, Gcoeff);
	rgba.b = dot(yuv, Bcoeff);
	rgba.a = 1.0;
	
	rgba *= PS_COLOUR.rgba;
    
	gl_FragColor = rgba;
}

              