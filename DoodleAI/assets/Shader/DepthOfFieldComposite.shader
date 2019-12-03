//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Hidden/DOF Composite" {
Properties {
 _MainTex ("", 2D) = "white" {}
 _BlurTex1 ("", 2D) = "white" {}
 _BlurTex2 ("", 2D) = "white" {}
 _DepthTex ("", 2D) = "white" {}
}
SubShader { 
 Pass {
  ZTest Always
  ZWrite Off
  Cull Off
  Fog { Mode Off }
Program "fp" {
SubProgram "opengl " {
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BlurTex1] 2D
SetTexture 2 [_BlurTex2] 2D
SetTexture 3 [_DepthTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 11 ALU, 4 TEX
PARAM c[1] = { { 1, 0.70019531, 1.5, 0.75 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R3.x, fragment.texcoord[3], texture[3], 2D;
TEX R1.xyz, fragment.texcoord[1], texture[1], 2D;
TEX R2.xyz, fragment.texcoord[2], texture[2], 2D;
MUL R1.xyz, R1, c[0].xxyw;
MAD R2.xyz, R2, c[0].yyxw, -R1;
MAD_SAT R1.w, R3.x, c[0].z, -c[0];
MAD R1.xyz, R1.w, R2, R1;
ADD R1.xyz, R1, -R0;
MAD result.color.xyz, R3.x, R1, R0;
MOV result.color.w, R0;
END
# 11 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BlurTex1] 2D
SetTexture 2 [_BlurTex2] 2D
SetTexture 3 [_DepthTex] 2D
"ps_2_0
; 12 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c0, 1.00000000, 0.70019531, 1.50000000, -0.75000000
dcl t0.xy
dcl t1.xy
dcl t2.xy
dcl t3.xy
texld r0, t2, s2
texld r1, t0, s0
texld r4, t3, s3
texld r2, t1, s1
mov r3.z, c0.y
mov r3.xy, c0.x
mul_pp r3.xyz, r2, r3
mov r2.xy, c0.y
mov r2.z, c0.x
mad_pp r0.xyz, r0, r2, -r3
mad_sat r2.x, r4, c0.z, c0.w
mad_pp r0.xyz, r2.x, r0, r3
add_pp r0.xyz, r0, -r1
mov_pp r0.w, r1
mad_pp r0.xyz, r4.x, r0, r1
mov_pp oC0, r0
"
}
}
 }
}
Fallback Off
}