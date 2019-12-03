//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "HeatDistort" {
Properties {
 _BumpAmt ("Distortion", Range(0,128)) = 10
 _MainTex ("Tint Color (RGB)", 2D) = "white" {}
 _BumpMap ("Bumpmap (RGB)", 2D) = "bump" {}
}
SubShader { 
 Tags { "QUEUE"="Transparent" }
 GrabPass {
  Name "BASE"
  Tags { "LIGHTMODE"="Always" }
 }
 Pass {
  Name "BASE"
  Tags { "LIGHTMODE"="Always" "QUEUE"="Transparent" }
Program "fp" {
SubProgram "opengl " {
Float 0 [_BumpAmt]
SetTexture 0 [_GrabTexture] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_MainTex] 2D
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
TXP R0, R0.xyzz, texture[0], 2D;
MUL result.color, R0, R1;
END
# 8 instructions, 2 R-regs
"
}
SubProgram "d3d9 " {
Vector 0 [_GrabTexture_TexelSize]
Float 1 [_BumpAmt]
SetTexture 0 [_GrabTexture] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_MainTex] 2D
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
  SetTexture [_GrabTexture] { combine texture, texture alpha }
  SetTexture [_BumpMap] { combine texture, texture alpha }
  SetTexture [_MainTex] { combine texture, texture alpha }
 }
}
SubShader { 
 Tags { "QUEUE"="Transparent" }
 Pass {
  Name "BASE"
  Tags { "QUEUE"="Transparent" }
  Blend DstColor Zero
  SetTexture [_MainTex] { combine texture }
 }
}
}