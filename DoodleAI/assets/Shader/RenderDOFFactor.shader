//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Hidden/Render DOF Factor" {
Properties {
 _MainTex ("Base", 2D) = "white" {}
 _Cutoff ("Cutoff", Float) = 0.5
}
SubShader { 
 Tags { "RenderType"="Opaque" }
 Pass {
  Tags { "RenderType"="Opaque" }
  Fog { Mode Off }
Program "vp" {
SubProgram "opengl " {
Bind "vertex" Vertex
"!!ARBvp1.0
# 6 ALU
PARAM c[9] = { program.local[0],
		state.matrix.modelview[0],
		state.matrix.mvp };
TEMP R0;
DP4 R0.x, vertex.position, c[3];
DP4 result.position.w, vertex.position, c[8];
DP4 result.position.z, vertex.position, c[7];
DP4 result.position.y, vertex.position, c[6];
DP4 result.position.x, vertex.position, c[5];
MOV result.texcoord[0].x, -R0;
END
# 6 instructions, 1 R-regs
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
"vs_2_0
; 6 ALU
dcl_position0 v0
dp4 r0.x, v0, c2
dp4 oPos.w, v0, c7
dp4 oPos.z, v0, c6
dp4 oPos.y, v0, c5
dp4 oPos.x, v0, c4
mov oT0.x, -r0
"
}
}
Program "fp" {
SubProgram "opengl " {
Vector 0 [_FocalParams]
"!!ARBfp1.0
# 5 ALU, 0 TEX
PARAM c[2] = { program.local[0],
		{ 4 } };
TEMP R0;
ADD R0.x, fragment.texcoord[0], -c[0];
MUL R0.y, R0.x, c[1].x;
CMP R0.x, R0, R0.y, R0;
ABS R0.x, R0;
MUL_SAT result.color, R0.x, c[0].w;
END
# 5 instructions, 1 R-regs
"
}
SubProgram "d3d9 " {
Vector 0 [_FocalParams]
"ps_2_0
; 7 ALU
def c1, 4.00000000, 0, 0, 0
dcl t0.x
add r0.x, t0, -c0
mul r1.x, r0, c1
cmp r0.x, r0, r0, r1
abs r0.x, r0
mul_sat r0.x, r0, c0.w
mov_pp r0, r0.x
mov_pp oC0, r0
"
}
}
 }
}
SubShader { 
 Tags { "RenderType"="TransparentCutout" }
 Pass {
  Tags { "RenderType"="TransparentCutout" }
  Cull Off
  Fog { Mode Off }
Program "vp" {
SubProgram "opengl " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
"!!ARBvp1.0
# 7 ALU
PARAM c[9] = { program.local[0],
		state.matrix.modelview[0],
		state.matrix.mvp };
TEMP R0;
DP4 R0.x, vertex.position, c[3];
MOV result.texcoord[0].xy, vertex.texcoord[0];
DP4 result.position.w, vertex.position, c[8];
DP4 result.position.z, vertex.position, c[7];
DP4 result.position.y, vertex.position, c[6];
DP4 result.position.x, vertex.position, c[5];
MOV result.texcoord[1].x, -R0;
END
# 7 instructions, 1 R-regs
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
"vs_2_0
; 7 ALU
dcl_position0 v0
dcl_texcoord0 v1
dp4 r0.x, v0, c2
mov oT0.xy, v1
dp4 oPos.w, v0, c7
dp4 oPos.z, v0, c6
dp4 oPos.y, v0, c5
dp4 oPos.x, v0, c4
mov oT1.x, -r0
"
}
}
Program "fp" {
SubProgram "opengl " {
Vector 0 [_FocalParams]
Float 1 [_Cutoff]
SetTexture 0 [_MainTex] 2D
"!!ARBfp1.0
# 8 ALU, 1 TEX
PARAM c[3] = { program.local[0..1],
		{ 4 } };
TEMP R0;
TEX R0.w, fragment.texcoord[0], texture[0], 2D;
SLT R0.x, R0.w, c[1];
KIL -R0.x;
ADD R0.x, fragment.texcoord[1], -c[0];
MUL R0.y, R0.x, c[2].x;
CMP R0.x, R0, R0.y, R0;
ABS R0.x, R0;
MUL_SAT result.color, R0.x, c[0].w;
END
# 8 instructions, 1 R-regs
"
}
SubProgram "d3d9 " {
Vector 0 [_FocalParams]
Float 1 [_Cutoff]
SetTexture 0 [_MainTex] 2D
"ps_2_0
; 10 ALU, 2 TEX
dcl_2d s0
def c2, 0.00000000, 1.00000000, 4.00000000, 0
dcl t0.xy
dcl t1.x
texld r0, t0, s0
add r0.x, r0.w, -c1
cmp r0.x, r0, c2, c2.y
mov_pp r0, -r0.x
texkill r0.xyzw
add r0.x, t1, -c0
mul r1.x, r0, c2.z
cmp r0.x, r0, r0, r1
abs r0.x, r0
mul_sat r0.x, r0, c0.w
mov_pp r0, r0.x
mov_pp oC0, r0
"
}
}
 }
}
SubShader { 
 Tags { "RenderType"="TreeOpaque" }
 Pass {
  Tags { "RenderType"="TreeOpaque" }
  Fog { Mode Off }
Program "vp" {
SubProgram "opengl " {
Bind "vertex" Vertex
Bind "color" Color
Matrix 9 [_TerrainEngineBendTree]
Vector 13 [_Scale]
Vector 14 [_SquashPlaneNormal]
Float 15 [_SquashAmount]
"!!ARBvp1.0
# 19 ALU
PARAM c[16] = { { 0, 1 },
		state.matrix.modelview[0],
		state.matrix.mvp,
		program.local[9..15] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.position, c[13];
MOV R1.w, c[0].x;
DP4 R0.z, R1, c[11];
DP4 R0.x, R1, c[9];
DP4 R0.y, R1, c[10];
ADD R0.xyz, R0, -R1;
MAD R0.xyz, vertex.color.w, R0, R1;
DP3 R0.w, R0, c[14];
ADD R0.w, R0, c[14];
MUL R1.xyz, R0.w, c[14];
ADD R0.xyz, -R1, R0;
MAD R0.xyz, R1, c[15].x, R0;
MOV R0.w, c[0].y;
DP4 R1.x, R0, c[3];
DP4 result.position.w, R0, c[8];
DP4 result.position.z, R0, c[7];
DP4 result.position.y, R0, c[6];
DP4 result.position.x, R0, c[5];
MOV result.texcoord[0].x, -R1;
END
# 19 instructions, 2 R-regs
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "color" Color
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [_TerrainEngineBendTree]
Vector 12 [_Scale]
Vector 13 [_SquashPlaneNormal]
Float 14 [_SquashAmount]
"vs_2_0
; 19 ALU
def c15, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_color0 v1
mul r1.xyz, v0, c12
mov r1.w, c15.x
dp4 r0.z, r1, c10
dp4 r0.x, r1, c8
dp4 r0.y, r1, c9
add r0.xyz, r0, -r1
mad r0.xyz, v1.w, r0, r1
dp3 r0.w, r0, c13
add r0.w, r0, c13
mul r1.xyz, r0.w, c13
add r0.xyz, -r1, r0
mad r0.xyz, r1, c14.x, r0
mov r0.w, c15.y
dp4 r1.x, r0, c2
dp4 oPos.w, r0, c7
dp4 oPos.z, r0, c6
dp4 oPos.y, r0, c5
dp4 oPos.x, r0, c4
mov oT0.x, -r1
"
}
}
Program "fp" {
SubProgram "opengl " {
Vector 0 [_FocalParams]
"!!ARBfp1.0
# 5 ALU, 0 TEX
PARAM c[2] = { program.local[0],
		{ 4 } };
TEMP R0;
ADD R0.x, fragment.texcoord[0], -c[0];
MUL R0.y, R0.x, c[1].x;
CMP R0.x, R0, R0.y, R0;
ABS R0.x, R0;
MUL_SAT result.color, R0.x, c[0].w;
END
# 5 instructions, 1 R-regs
"
}
SubProgram "d3d9 " {
Vector 0 [_FocalParams]
"ps_2_0
; 7 ALU
def c1, 4.00000000, 0, 0, 0
dcl t0.x
add r0.x, t0, -c0
mul r1.x, r0, c1
cmp r0.x, r0, r0, r1
abs r0.x, r0
mul_sat r0.x, r0, c0.w
mov_pp r0, r0.x
mov_pp oC0, r0
"
}
}
 }
}
SubShader { 
 Tags { "RenderType"="TreeTransparentCutout" }
 Pass {
  Tags { "RenderType"="TreeTransparentCutout" }
  Cull Off
  Fog { Mode Off }
Program "vp" {
SubProgram "opengl " {
Bind "vertex" Vertex
Bind "color" Color
Bind "texcoord" TexCoord0
Matrix 9 [_TerrainEngineBendTree]
Vector 13 [_Scale]
Vector 14 [_SquashPlaneNormal]
Float 15 [_SquashAmount]
"!!ARBvp1.0
# 20 ALU
PARAM c[16] = { { 0, 1 },
		state.matrix.modelview[0],
		state.matrix.mvp,
		program.local[9..15] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.position, c[13];
MOV R1.w, c[0].x;
DP4 R0.z, R1, c[11];
DP4 R0.x, R1, c[9];
DP4 R0.y, R1, c[10];
ADD R0.xyz, R0, -R1;
MAD R0.xyz, vertex.color.w, R0, R1;
DP3 R0.w, R0, c[14];
ADD R0.w, R0, c[14];
MUL R1.xyz, R0.w, c[14];
ADD R0.xyz, -R1, R0;
MAD R0.xyz, R1, c[15].x, R0;
MOV R0.w, c[0].y;
DP4 R1.x, R0, c[3];
DP4 result.position.w, R0, c[8];
DP4 result.position.z, R0, c[7];
DP4 result.position.y, R0, c[6];
DP4 result.position.x, R0, c[5];
MOV result.texcoord[1].x, -R1;
MOV result.texcoord[0].xy, vertex.texcoord[0];
END
# 20 instructions, 2 R-regs
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "color" Color
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [_TerrainEngineBendTree]
Vector 12 [_Scale]
Vector 13 [_SquashPlaneNormal]
Float 14 [_SquashAmount]
"vs_2_0
; 20 ALU
def c15, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_color0 v1
dcl_texcoord0 v2
mul r1.xyz, v0, c12
mov r1.w, c15.x
dp4 r0.z, r1, c10
dp4 r0.x, r1, c8
dp4 r0.y, r1, c9
add r0.xyz, r0, -r1
mad r0.xyz, v1.w, r0, r1
dp3 r0.w, r0, c13
add r0.w, r0, c13
mul r1.xyz, r0.w, c13
add r0.xyz, -r1, r0
mad r0.xyz, r1, c14.x, r0
mov r0.w, c15.y
dp4 r1.x, r0, c2
dp4 oPos.w, r0, c7
dp4 oPos.z, r0, c6
dp4 oPos.y, r0, c5
dp4 oPos.x, r0, c4
mov oT1.x, -r1
mov oT0.xy, v2
"
}
}
Program "fp" {
SubProgram "opengl " {
Vector 0 [_FocalParams]
Float 1 [_Cutoff]
SetTexture 0 [_MainTex] 2D
"!!ARBfp1.0
# 8 ALU, 1 TEX
PARAM c[3] = { program.local[0..1],
		{ 4 } };
TEMP R0;
TEX R0.w, fragment.texcoord[0], texture[0], 2D;
SLT R0.x, R0.w, c[1];
KIL -R0.x;
ADD R0.x, fragment.texcoord[1], -c[0];
MUL R0.y, R0.x, c[2].x;
CMP R0.x, R0, R0.y, R0;
ABS R0.x, R0;
MUL_SAT result.color, R0.x, c[0].w;
END
# 8 instructions, 1 R-regs
"
}
SubProgram "d3d9 " {
Vector 0 [_FocalParams]
Float 1 [_Cutoff]
SetTexture 0 [_MainTex] 2D
"ps_2_0
; 10 ALU, 2 TEX
dcl_2d s0
def c2, 0.00000000, 1.00000000, 4.00000000, 0
dcl t0.xy
dcl t1.x
texld r0, t0, s0
add r0.x, r0.w, -c1
cmp r0.x, r0, c2, c2.y
mov_pp r0, -r0.x
texkill r0.xyzw
add r0.x, t1, -c0
mul r1.x, r0, c2.z
cmp r0.x, r0, r0, r1
abs r0.x, r0
mul_sat r0.x, r0, c0.w
mov_pp r0, r0.x
mov_pp oC0, r0
"
}
}
 }
}
}