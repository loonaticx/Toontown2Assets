//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
// Per pixel bumped refraction.
// Uses a normal map to distort the image behind, and
// an additional texture to tint the color.

Shader "HeatDistort" {
Properties {
	_BumpAmt  ("Distortion", range (0,128)) = 10
	_MainTex ("Tint Color (RGB)", 2D) = "white" {}
	_BumpMap ("Bumpmap (RGB)", 2D) = "bump" {}
}

Category {

	// We must be transparent, so other objects are drawn before this one.
	Tags { "Queue" = "Transparent" }
	
	// ------------------------------------------------------------------
	//  ARB fragment program
	
	SubShader {

		// This pass grabs the screen behind the object into a texture.
		// We can access the result in the next pass as _GrabTexture
		GrabPass {							
			Name "BASE"
			Tags { "LightMode" = "Always" }
 		}
 		
 		// Main pass: Take the texture grabbed above and use the bumpmap to perturb it
 		// on to the screen
		Pass {
			Name "BASE"
			Tags { "LightMode" = "Always" }
			
Program "" {
// Fragment combos: 1
//   opengl - ALU: 8 to 8, TEX: 3 to 3
//   d3d9 - ALU: 7 to 7, TEX: 3 to 3
SubProgram "opengl " {
Keywords { }
Local 0, ([_BumpAmt],0,0,0)
SetTexture [_GrabTexture] {RECT}
SetTexture [_BumpMap] {2D}
SetTexture [_MainTex] {2D}
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
OPTION ARB_fog_exp2;
# 8 ALU, 3 TEX
PARAM c[2] = { program.local[0],
		{ 2, 1 } };
TEMP R0;
TEMP R1;
TEX R0.xy, fragment.texcoord[1], texture[1], 2D;
TEX R1, fragment.texcoord[2], texture[2], 2D;
MAD R0.xy, R0, c[1].x, -c[1].y;
MUL R0.xy, R0, c[0].x;
MAD R0.xy, R0, fragment.texcoord[0].z, fragment.texcoord[0];
MOV R0.z, fragment.texcoord[0].w;
TXP R0, R0.xyzz, texture[0], RECT;
MUL result.color, R0, R1;
END
# 8 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Local 0, [_GrabTexture_TexelSize]
Local 1, ([_BumpAmt],0,0,0)
SetTexture [_GrabTexture] {RECT}
SetTexture [_BumpMap] {2D}
SetTexture [_MainTex] {2D}
"ps_2_0
; 7 ALU, 3 TEX
dcl_2d s1
dcl_2d s0
dcl_2d s2
def c2, 2.00000000, -1.00000000, 0, 0
dcl t0
dcl t1.xy
dcl t2.xy
texld r0, t1, s1
mad r0.xy, r0, c2.x, c2.y
mul r0.xy, r0, c1.x
mul r0.xy, r0, c0
mad r1.xy, r0, t0.z, t0
mov r1.w, t0
texld r0, t2, s2
texldp r1, r1, s0
mul_pp r0, r1, r0
mov_pp oC0, r0
"
}

}
#LINE 70

			// Set up the textures for this pass
			SetTexture [_GrabTexture] {}	// Texture we grabbed in the pass above
			SetTexture [_BumpMap] {}		// Perturbation bumpmap
			SetTexture [_MainTex] {}		// Color tint
		}
	}
	
	// ------------------------------------------------------------------
	//  Radeon 9000
	
	SubShader {

		GrabPass {							
			Name "BASE"
			Tags { "LightMode" = "Always" }
 		}
 		
		Pass {
			Name "BASE"
			Tags { "LightMode" = "Always" }
			
			Program "" {
				SubProgram {
				Local 0, ([_BumpAmt],0,0,0.001)
"!!ATIfs1.0
StartConstants;
	CONSTANT c0 = program.local[0];
EndConstants;

StartPrelimPass;
	PassTexCoord r0, t0.stq_dq;	# refraction position
	SampleMap r1, t1.str;		# bumpmap
	MAD r0, r1.2x.bias, c0.r, r0;
EndPass;

StartOutputPass;
	SampleMap r0, r0.str;	# sample modified refraction texture
	SampleMap r2, t2.str;		# Get main color texture
	
	MUL r0, r0, r2;
EndPass; 
"
#LINE 112

				}
			}
			SetTexture [_GrabTexture] {}
			SetTexture [_BumpMap] {}
			SetTexture [_MainTex] {}
		}
	}
	
	// ------------------------------------------------------------------
	// Fallback for older cards and Unity non-Pro
	
	SubShader {
		Blend DstColor Zero
		Pass {
			Name "BASE"
			SetTexture [_MainTex] {	combine texture }
		}
	}
}

}
