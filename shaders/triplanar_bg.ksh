   triplanar_bg      MatrixP                                                                                MatrixV                                                                                MatrixW                                                                                SAMPLER    +         TEXTURESIZE                        LIGHTMAP_WORLD_EXTENTS                                triplanar.vs#	  uniform mat4 MatrixP;
uniform mat4 MatrixV;
uniform mat4 MatrixW;

attribute vec3 POSITION;
attribute vec3 NORMAL;
attribute vec2 TEXCOORD0;
attribute vec2 TEXCOORD1;


varying vec2 PS_TEXCOORD0;
varying vec2 PS_TEXCOORD1;
varying vec2 PS_TEXCOORD2;

varying vec3 PS_NORMAL;
//varying vec3 PS_POSITION;
varying vec3 PS_POS;

//varying float TILE_TYPE;
varying vec4 TILE_UV;

varying float PS_DEPTH;



void main ()
{
    float texure_scale = 0.125;

    TILE_UV  = vec4(TEXCOORD0.xy,TEXCOORD1.xy);

    // CEILING
    PS_TEXCOORD0 = POSITION.xz*texure_scale;

    PS_TEXCOORD1 = POSITION.zy*texure_scale;
    PS_TEXCOORD2 = POSITION.xy*texure_scale;

    //PS_POSITION = POSITION;
    PS_NORMAL = abs(NORMAL);
    
	mat4 mtxPVW = MatrixP * MatrixV * MatrixW;
	gl_Position = mtxPVW * vec4( POSITION.xyz, 1.0 );
 
    PS_DEPTH = float(1.0-((gl_Position.z/gl_Position.w)));

	vec4 world_pos = MatrixW * vec4( POSITION.xyz, 1.0 );
	PS_POS.xyz = world_pos.xyz;
}

    // PS_TEXCOORD0 = GetAtlasUV(POSITION.xz*texure_scale, TILE_UV0, TILE_UV1);
    // PS_TEXCOORD1 = GetAtlasUV(POSITION.zy*texure_scale, TILE_UV0, TILE_UV1);
    // PS_TEXCOORD2 = GetAtlasUV(POSITION.xy*texure_scale, TILE_UV0, TILE_UV1); // Y - CEILING

// vec2 GetAtlasUV(vec2 uv, float material, float numMatsX, float numMatsY)
// {
//    // First make sure u/v are between 0 and 1.
//    while (uv.x > 1.0)
//    {
//       uv.x -= 1.0;
//    }

//    while (uv.x < 0.0)
//    {
//       uv.x += 1.0;
//    }

//    while (uv.y > 1.0)
//    {
//       uv.y -= 1.0;
//    }

//    while (uv.y < 0.0)
//    {
//       uv.y += 1.0;
//    }

//    // Divide by the number of materials to get proper texture UV coordinates
//    uv.x /= numMatsX;
//    uv.y /= numMatsY;

//    float yPos = 0.0;

//    while (material >= numMatsX)
//    {
//       yPos += 1.0;
//       material -= numMatsX;
//    }

//    uv.x += 1.0 / numMatsX * material;
//    uv.y += 1.0 / numMatsY * yPos;

//    return uv;
// }

// vec2 GetAtlasUV(vec2 uv, vec2 uv1, vec2 uv2)
// {
//    uv = mod(abs(uv), 1.0);

//    // Divide by the number of materials to get proper texture UV coordinates
//    uv.x = uv1.x + (uv.x*(uv2.x-uv1.x));
//    uv.y = uv1.y + (uv.y*(uv2.y-uv1.y));

//    return uv;
// }    triplanar_bg.ps�  #if defined( GL_ES )
precision mediump float;
#endif

uniform sampler2D SAMPLER[5]; 
//                          SAMPLER[0] used in atlas.h
//                          SAMPLER[3] used in lighting.h
//                          SAMPLER[4] used in player_cutout.h

// Already defined by atlas.h
// varying vec2 PS_TEXCOORD0;
// varying vec2 PS_TEXCOORD1;
// varying vec2 PS_TEXCOORD2;
// varying vec3 PS_NORMAL;
// varying vec4 TILE_UV;

#ifdef GL_OES_standard_derivatives
#extension GL_OES_standard_derivatives:enable
#endif

#ifdef GL_EXT_shader_texture_lod
#extension GL_EXT_shader_texture_lod:enable
#endif

#define ATLAS_TEXTURE_0     SAMPLER[0]

varying vec2 PS_TEXCOORD0;
varying vec2 PS_TEXCOORD1;
varying vec2 PS_TEXCOORD2;

varying vec3 PS_NORMAL;
varying vec4 TILE_UV;

// BACKUP PLAN:
// Make tall textures that dont need modulous

// http://hacksoflife.blogspot.ca/2011/01/derivatives-i-discontinuities-and.html
// http://hacksoflife.blogspot.ca/2011/01/derivatives-ii-conditional-texture.html
// http://aras-p.info/blog/2010/01/07/screenspace-vs-mip-mapping/

vec2 GetAtlasUV(vec2 uv, vec2 uv1, vec2 uv2)
{ 
   //uv = fract(uv);
   uv = mod(uv, 1.0);

   //uv.x = uv1.x + (uv.x*(uv2.x-uv1.x));
   //uv.y = uv1.y + (uv.y*(uv2.y-uv1.y));
   uv = uv1 + (uv*(uv2-uv1));

   return uv;
}

vec2 GetAtlasUVMaterial(vec2 uv, float material, float numMatsX, float numMatsY)
{
   // First make sure u/v are between 0 and 1. This makes the textre discontinious
   while (uv.x > 1.0)
   {
      uv.x -= 1.0;
   }

   while (uv.x < 0.0)
   {
      uv.x += 1.0;
   }

   while (uv.y > 1.0)
   {
      uv.y -= 1.0;
   }

   while (uv.y < 0.0)
   {
      uv.y += 1.0;
   }

   // Divide by the number of materials to get proper texture UV coordinates
   uv.x /= numMatsX;
   uv.y /= numMatsY;

   float yPos = 0.0;

   while (material >= numMatsX)
   {
      yPos += 1.0;
      material -= numMatsX;
   }

   uv.x += 1.0 / numMatsX * material;
   uv.y += 1.0 / numMatsY * yPos;

   return uv;
}

vec4 GetTexture(vec3 weighting)
{
    vec2 Z_TEXCOORD = GetAtlasUV(PS_TEXCOORD2, TILE_UV.xy, TILE_UV.zw);
    vec2 X_TEXCOORD = GetAtlasUV(PS_TEXCOORD1, TILE_UV.xy, TILE_UV.zw);
    vec2 Y_TEXCOORD = GetAtlasUV(PS_TEXCOORD0, TILE_UV.xy, TILE_UV.zw); // Y - CEILING

    vec4 tempColor = vec4(0.0, 0.0, 0.0, 1.0);

#ifdef GL_EXT_shader_texture_lod//GL_OES_standard_derivatives //
    // tempColor =  weighting.z * texture2DGradEXT(ATLAS_TEXTURE_0, Z_TEXCOORD, dFdx(Z_TEXCOORD), dFdy(Z_TEXCOORD));
    // tempColor += weighting.x * texture2DGradEXT(ATLAS_TEXTURE_0, X_TEXCOORD, dFdx(X_TEXCOORD), dFdy(X_TEXCOORD));
    // tempColor += weighting.y * texture2DGradEXT(ATLAS_TEXTURE_0, Y_TEXCOORD, dFdx(Y_TEXCOORD), dFdy(Y_TEXCOORD));
    tempColor =  weighting.z * texture2D(ATLAS_TEXTURE_0, Z_TEXCOORD+ dFdy(Z_TEXCOORD),0.0);
    tempColor += weighting.x * texture2D(ATLAS_TEXTURE_0, X_TEXCOORD+ dFdx(X_TEXCOORD),0.0);
    tempColor += weighting.y * texture2D(ATLAS_TEXTURE_0, Y_TEXCOORD);// dFdy(Y_TEXCOORD),0.0);
#else    
    tempColor =  weighting.z * texture2D(ATLAS_TEXTURE_0, Z_TEXCOORD);
    tempColor += weighting.x * texture2D(ATLAS_TEXTURE_0, X_TEXCOORD);
    tempColor += weighting.y * texture2D(ATLAS_TEXTURE_0, Y_TEXCOORD);
#endif

    return tempColor;
}

vec4 GetAtlasedTexture ()
{          
    // this comes from the gpu gems 3 article:
    // generating complex procedural terrains using the gpu
    // used to determine how much of each planar lookup to use
    // for each texture
    vec3 weighting = PS_NORMAL- 0.2679;//(weighting - 0.2) * 7.0; //
    weighting = max(weighting, vec3(0.0, 0.0, 0.0));
    weighting /= weighting.x + weighting.y + weighting.z;

    return GetTexture(weighting);      
} 
    
// Already defined by player_cutout.h
// varying vec4 PS_DEPTH
#define DEPTH_TEXTURE       SAMPLER[4]


//varying vec4 PS_DEPTH;
varying float PS_DEPTH;
uniform vec2 TEXTURESIZE;

#define BG_WALL_PASS        0.0
#define ALPHA_WALL_PASS     1.0
#define ALPHA_CEILING_PASS  2.0

#define PLAYER_MASK_SIZE    300.0*300.0//90000.0 // WTF? doing the mult adds an op?!?

#define RGBA_2              1.0/255.0
#define RGBA_3              1.0/65025.0
#define RGBA_4              1.0/160581375.0

float DecodeFloatRGBA( vec4 rgba ) 
{
//  return dot( rgba, vec4(1.0, 1.0/255.0, 1.0/65025.0, 1.0/160581375.0) );
  return dot( rgba, vec4(1.0, RGBA_2, RGBA_3, RGBA_4) );
}


float DoCut_BG()
{
    vec2 pos = gl_FragCoord.xy - TEXTURESIZE*0.5;
    float dist_squared = dot(pos, pos);

    float computed_depth = PS_DEPTH;//float computed_depth = float(1.0-((PS_DEPTH.z/PS_DEPTH.w)));
    vec2 depth_coord = vec2(gl_FragCoord.xy/TEXTURESIZE.xy);
    vec4 intValue = texture2D(DEPTH_TEXTURE, depth_coord);
    float depthmask = DecodeFloatRGBA(intValue);

    // If we are withing the kill radius
    if (dist_squared < PLAYER_MASK_SIZE && depthmask>0.0 && depthmask<computed_depth)
    {
        // Is the wall within the cone and infront of the player?
        discard;
    }

    return 1.0;
}


float DoCut_ALPHA_WALL()
{    
    vec2 offset = gl_FragCoord.xy - TEXTURESIZE*0.5; // CANT DO THIS.. needs it below at full size
    float dist_squared = dot(offset, offset);

    // If we are withing the kill radius
    if (dist_squared < PLAYER_MASK_SIZE )
    {
        //float computed_depth = PS_DEPTH;//float(1.0-((PS_DEPTH.z/PS_DEPTH.w)));
        //float computed_depth = float(1.0-((PS_DEPTH.z/PS_DEPTH.w)));
        //vec2 depth_coord = vec2(gl_FragCoord.x/TEXTURESIZE.x, gl_FragCoord.y/TEXTURESIZE.y);
        vec2 depth_coord = vec2(gl_FragCoord.xy/TEXTURESIZE.xy);
        vec4 intValue = texture2D(DEPTH_TEXTURE, depth_coord);
        float depthmask = DecodeFloatRGBA(intValue);

        if (depthmask<PS_DEPTH+0.2 || depthmask<0.0|| depthmask>PS_DEPTH)
        {
            discard;
        }  
        else
        {
            // If it is on the alpha wall pass and within the cone... and infront of the player
            // alpha it out
            return  dist_squared / PLAYER_MASK_SIZE;
        }      
    }
    else
    {
      // If it is the alpha pass but outside the circle, discard it
      discard;
    }    

    return 1.0;
}

float DoCut_ALPHA_CEILING()
{
    vec2 pos = gl_FragCoord.xy - TEXTURESIZE*0.5;
    float dist_squared = dot(pos, pos);

    // If we are withing the kill radius
    if (dist_squared < PLAYER_MASK_SIZE )
    {
        float computed_depth = PS_DEPTH;//float computed_depth = float(1.0-((PS_DEPTH.z/PS_DEPTH.w)));
        vec2 depth_coord = vec2(gl_FragCoord.xy/TEXTURESIZE.xy);
        vec4 intValue = texture2D(DEPTH_TEXTURE, depth_coord);
        float depthmask = DecodeFloatRGBA(intValue);

        // If it is on the alpha wall pass and within the cone... and infront of the player
        // alpha it out
        if (depthmask>0.0 && depthmask<computed_depth)
        {
            return dist_squared / (PLAYER_MASK_SIZE);
        }   
    }

    return 1.0;
}

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



void main (void)
{          
    vec4 final_colour = vec4(0.0, 0.0, 0.0, 1.0);

    final_colour += GetAtlasedTexture();      
    
    final_colour.a = DoCut_BG();

    final_colour.rgb *= CalculateLightingContribution(); 

    gl_FragColor = final_colour;
} 
                            