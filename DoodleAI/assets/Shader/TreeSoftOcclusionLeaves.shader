//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Nature/Tree Soft Occlusion Leaves" {
Properties {
 _Color ("Main Color", Color) = (1,1,1,1)
 _MainTex ("Main Texture", 2D) = "white" {}
 _Cutoff ("Alpha cutoff", Range(0.25,0.9)) = 0.5
 _BaseLight ("Base Light", Range(0,1)) = 0.35
 _AO ("Amb. Occlusion", Range(0,10)) = 2.4
 _Occlusion ("Dir Occlusion", Range(0,20)) = 7.5
 _Scale ("Scale", Vector) = (1,1,1,1)
 _SquashAmount ("Squash", Float) = 1
}
SubShader { 
 Tags { "QUEUE"="Transparent-99" "IGNOREPROJECTOR"="True" "RenderType"="TreeTransparentCutout" }
 Pass {
  Tags { "QUEUE"="Transparent-99" "IGNOREPROJECTOR"="True" "RenderType"="TreeTransparentCutout" }
  Lighting On
  Cull Off
  ColorMask RGB
Program "vp" {
SubProgram "opengl " {
Bind "vertex" Vertex
Bind "color" Color
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
Matrix 9 [_TerrainEngineBendTree]
Matrix 13 [_CameraToWorld]
Vector 30 [_Scale]
Vector 31 [_SquashPlaneNormal]
Float 32 [_SquashAmount]
Float 33 [_Occlusion]
Float 34 [_AO]
Float 35 [_BaseLight]
Vector 36 [_Color]
Float 37 [_HalfOverCutoff]
"!!ARBvp1.0
# 100 ALU
PARAM c[38] = { { 0, 1, 0.5 },
		state.light[0].diffuse,
		state.light[0].position,
		state.light[0].attenuation,
		state.light[1].diffuse,
		state.light[1].position,
		state.light[1].attenuation,
		state.light[2].diffuse,
		state.light[2].position,
		program.local[9..16],
		state.light[2].attenuation,
		state.light[3].diffuse,
		state.light[3].position,
		state.light[3].attenuation,
		state.lightmodel.ambient,
		state.matrix.modelview[0],
		state.matrix.mvp,
		program.local[30..37] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R0.xyz, vertex.position, c[30];
MOV R0.w, c[0].x;
MOV R1.w, c[0].y;
DP4 R1.z, R0, c[11];
DP4 R1.x, R0, c[9];
DP4 R1.y, R0, c[10];
ADD R1.xyz, R1, -R0;
MAD R1.xyz, vertex.color.w, R1, R0;
DP3 R0.x, R1, c[31];
ADD R0.x, R0, c[31].w;
MUL R0.xyz, R0.x, c[31];
ADD R1.xyz, -R0, R1;
MAD R1.xyz, R0, c[32].x, R1;
DP4 R3.z, R1, c[24];
DP4 R3.x, R1, c[22];
DP4 R3.y, R1, c[23];
MAD R0.xyz, -R3, c[8].w, c[8];
MAD R2.xyz, -R3, c[2].w, c[2];
MOV R0.z, -R0;
DP3 R2.w, R0, R0;
RSQ R0.w, R2.w;
MUL R4.xyz, R0.w, R0;
DP3 R0.z, R4, c[15];
DP3 R0.y, R4, c[14];
DP3 R0.x, R4, c[13];
MOV R2.z, -R2;
DP3 R4.x, R2, R2;
RSQ R3.w, R4.x;
MUL R2.xyz, R3.w, R2;
MUL R0.xyz, R0, c[33].x;
MOV R0.w, c[34].x;
DP4 R3.w, vertex.attrib[14], R0;
MAX R3.w, R3, c[0].x;
DP3 R0.z, R2, c[15];
DP3 R0.y, R2, c[14];
DP3 R0.x, R2, c[13];
MUL R0.xyz, R0, c[33].x;
MOV R0.w, c[34].x;
DP4 R0.x, vertex.attrib[14], R0;
MUL R0.y, R4.x, c[3].z;
ADD R2.x, R0.y, c[0].y;
MAX R0.x, R0, c[0];
ADD R0.w, R0.x, c[35].x;
MAD R0.xyz, -R3, c[5].w, c[5];
RCP R4.x, R2.x;
MOV R2.xy, R0;
MOV R2.z, -R0;
MUL R0.x, R0.w, R4;
DP3 R4.w, R2, R2;
RSQ R0.w, R4.w;
MUL R4.xyz, R0.w, R2;
MUL R0.xyz, R0.x, c[1];
ADD R2.xyz, R0, c[21];
DP3 R0.z, R4, c[15];
DP3 R0.x, R4, c[13];
DP3 R0.y, R4, c[14];
MUL R0.xyz, R0, c[33].x;
MOV R0.w, c[34].x;
DP4 R0.x, vertex.attrib[14], R0;
MUL R0.w, R2, c[17].z;
MUL R4.x, R4.w, c[6].z;
ADD R0.y, R4.x, c[0];
MAX R0.x, R0, c[0];
ADD R2.w, R0, c[0].y;
RCP R0.y, R0.y;
ADD R0.x, R0, c[35];
MUL R0.x, R0, R0.y;
MAD R0.xyz, R0.x, c[4], R2;
MAD R2.xyz, -R3, c[19].w, c[19];
MOV R2.z, -R2;
DP3 R0.w, R2, R2;
RCP R3.x, R2.w;
RSQ R2.w, R0.w;
MUL R2.xyz, R2.w, R2;
ADD R3.w, R3, c[35].x;
MUL R3.x, R3.w, R3;
MAD R0.xyz, R3.x, c[7], R0;
DP3 R3.x, R2, c[13];
DP3 R3.z, R2, c[15];
DP3 R3.y, R2, c[14];
MUL R2.xyz, R3, c[33].x;
MUL R3.x, R0.w, c[20].z;
MOV R2.w, c[34].x;
DP4 R0.w, vertex.attrib[14], R2;
ADD R2.x, R3, c[0].y;
MAX R0.w, R0, c[0].x;
RCP R2.x, R2.x;
ADD R0.w, R0, c[35].x;
MUL R0.w, R0, R2.x;
MAD R0.xyz, R0.w, c[18], R0;
MUL result.color.xyz, R0, c[36];
DP4 R0.x, R1, c[28];
MOV result.position.z, R0.x;
MOV result.fogcoord.x, R0;
MOV R0.x, c[0].z;
DP4 result.position.w, R1, c[29];
DP4 result.position.y, R1, c[27];
DP4 result.position.x, R1, c[26];
MOV result.texcoord[0], vertex.texcoord[0];
MUL result.color.w, R0.x, c[37].x;
END
# 100 instructions, 5 R-regs
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "color" Color
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [_TerrainEngineBendTree]
Matrix 12 [_CameraToWorld]
Vector 16 [glstate_light0_diffuse]
Vector 17 [glstate_light0_position]
Vector 18 [glstate_light0_attenuation]
Vector 19 [glstate_light1_diffuse]
Vector 20 [glstate_light1_position]
Vector 21 [glstate_light1_attenuation]
Vector 22 [glstate_light2_diffuse]
Vector 23 [glstate_light2_position]
Vector 24 [glstate_light2_attenuation]
Vector 25 [glstate_light3_diffuse]
Vector 26 [glstate_light3_position]
Vector 27 [glstate_light3_attenuation]
Vector 28 [glstate_lightmodel_ambient]
Vector 29 [_Scale]
Vector 30 [_SquashPlaneNormal]
Float 31 [_SquashAmount]
Float 32 [_Occlusion]
Float 33 [_AO]
Float 34 [_BaseLight]
Vector 35 [_Color]
Float 36 [_HalfOverCutoff]
"vs_2_0
; 100 ALU
def c37, 0.00000000, 1.00000000, 0.50000000, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_color0 v2
dcl_texcoord0 v3
mul r0.xyz, v0, c29
mov r0.w, c37.x
mov r1.w, c37.y
dp4 r1.z, r0, c10
dp4 r1.x, r0, c8
dp4 r1.y, r0, c9
add r1.xyz, r1, -r0
mad r1.xyz, v2.w, r1, r0
dp3 r0.x, r1, c30
add r0.x, r0, c30.w
mul r0.xyz, r0.x, c30
add r1.xyz, -r0, r1
mad r1.xyz, r0, c31.x, r1
dp4 r3.z, r1, c2
dp4 r3.x, r1, c0
dp4 r3.y, r1, c1
mad r0.xyz, -r3, c23.w, c23
mad r2.xyz, -r3, c17.w, c17
mov r0.z, -r0
dp3 r2.w, r0, r0
rsq r0.w, r2.w
mul r4.xyz, r0.w, r0
dp3 r0.z, r4, c14
dp3 r0.y, r4, c13
dp3 r0.x, r4, c12
mov r2.z, -r2
dp3 r4.x, r2, r2
rsq r3.w, r4.x
mul r2.xyz, r3.w, r2
mul r0.xyz, r0, c32.x
mov r0.w, c33.x
dp4 r3.w, v1, r0
max r3.w, r3, c37.x
dp3 r0.z, r2, c14
dp3 r0.y, r2, c13
dp3 r0.x, r2, c12
mul r0.xyz, r0, c32.x
mov r0.w, c33.x
dp4 r0.x, v1, r0
mul r0.y, r4.x, c18.z
add r2.x, r0.y, c37.y
max r0.x, r0, c37
add r0.w, r0.x, c34.x
mad r0.xyz, -r3, c20.w, c20
rcp r4.x, r2.x
mov r2.xy, r0
mov r2.z, -r0
mul r0.x, r0.w, r4
dp3 r4.w, r2, r2
rsq r0.w, r4.w
mul r4.xyz, r0.w, r2
mul r0.xyz, r0.x, c16
add r2.xyz, r0, c28
dp3 r0.z, r4, c14
dp3 r0.x, r4, c12
dp3 r0.y, r4, c13
mul r0.xyz, r0, c32.x
mov r0.w, c33.x
dp4 r0.x, v1, r0
mul r0.w, r2, c24.z
mul r4.x, r4.w, c21.z
add r0.y, r4.x, c37
max r0.x, r0, c37
add r2.w, r0, c37.y
rcp r0.y, r0.y
add r0.x, r0, c34
mul r0.x, r0, r0.y
mad r0.xyz, r0.x, c19, r2
mad r2.xyz, -r3, c26.w, c26
mov r2.z, -r2
dp3 r0.w, r2, r2
rcp r3.x, r2.w
rsq r2.w, r0.w
mul r2.xyz, r2.w, r2
add r3.w, r3, c34.x
mul r3.x, r3.w, r3
mad r0.xyz, r3.x, c22, r0
dp3 r3.x, r2, c12
dp3 r3.z, r2, c14
dp3 r3.y, r2, c13
mul r2.xyz, r3, c32.x
mul r3.x, r0.w, c27.z
mov r2.w, c33.x
dp4 r0.w, v1, r2
add r2.x, r3, c37.y
max r0.w, r0, c37.x
rcp r2.x, r2.x
add r0.w, r0, c34.x
mul r0.w, r0, r2.x
mad r0.xyz, r0.w, c25, r0
mul oD0.xyz, r0, c35
dp4 r0.x, r1, c6
mov oPos.z, r0.x
mov oFog, r0.x
mov r0.x, c36
dp4 oPos.w, r1, c7
dp4 oPos.y, r1, c5
dp4 oPos.x, r1, c4
mov oT0, v3
mul oD0.w, c37.z, r0.x
"
}
}
Program "fp" {
SubProgram "opengl " {
Float 0 [_Cutoff]
SetTexture 0 [_MainTex] 2D
"!!ARBfp1.0
# 6 ALU, 1 TEX
PARAM c[2] = { program.local[0],
		{ 2 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
SLT R1.x, R0.w, c[0];
MOV result.color.w, R0;
KIL -R1.x;
MUL R1.xyz, fragment.color.primary, c[1].x;
MUL result.color.xyz, R0, R1;
END
# 6 instructions, 2 R-regs
"
}
SubProgram "d3d9 " {
Float 0 [_Cutoff]
SetTexture 0 [_MainTex] 2D
"ps_2_0
; 6 ALU, 2 TEX
dcl_2d s0
def c1, 2.00000000, 0.00000000, 1.00000000, 0
dcl t0.xy
dcl v0.xyz
texld r0, t0, s0
add_pp r1.x, r0.w, -c0
cmp r1.x, r1, c1.y, c1.z
mov_pp r1, -r1.x
texkill r1.xyzw
mul r1.xyz, v0, c1.x
mul_pp r0.xyz, r0, r1
mov_pp oC0, r0
"
}
}
 }
 Pass {
  Name "SHADOWCASTER"
  Tags { "LIGHTMODE"="SHADOWCASTER" "QUEUE"="Transparent-99" "IGNOREPROJECTOR"="True" "RenderType"="TreeTransparentCutout" }
  ZTest Less
  Cull Off
  Fog { Mode Off }
  ColorMask RGB
  Offset 1, 1
Program "vp" {
SubProgram "opengl " {
Keywords { "SHADOWS_DEPTH" }
Bind "vertex" Vertex
Bind "color" Color
Bind "texcoord" TexCoord0
Matrix 5 [_TerrainEngineBendTree]
Vector 9 [unity_LightShadowBias]
Vector 10 [_Scale]
Vector 11 [_SquashPlaneNormal]
Float 12 [_SquashAmount]
"!!ARBvp1.0
# 23 ALU
PARAM c[13] = { { 0, 1 },
		state.matrix.mvp,
		program.local[5..12] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.position, c[10];
MOV R1.w, c[0].x;
DP4 R0.z, R1, c[7];
DP4 R0.x, R1, c[5];
DP4 R0.y, R1, c[6];
ADD R0.xyz, R0, -R1;
MAD R0.xyz, vertex.color.w, R0, R1;
DP3 R0.w, R0, c[11];
ADD R0.w, R0, c[11];
MUL R1.xyz, R0.w, c[11];
ADD R0.xyz, -R1, R0;
MAD R0.xyz, R1, c[12].x, R0;
MOV R0.w, c[0].y;
DP4 R1.x, R0, c[4];
DP4 R1.y, R0, c[3];
ADD R1.y, R1, c[9].x;
SLT R1.w, R1.y, -R1.x;
ADD R1.z, -R1.x, -R1.y;
MAD result.position.z, R1, R1.w, R1.y;
MOV result.position.w, R1.x;
DP4 result.position.y, R0, c[2];
DP4 result.position.x, R0, c[1];
MOV result.texcoord[1].xy, vertex.texcoord[0];
END
# 23 instructions, 2 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "SHADOWS_DEPTH" }
Bind "vertex" Vertex
Bind "color" Color
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_TerrainEngineBendTree]
Vector 8 [unity_LightShadowBias]
Vector 9 [_Scale]
Vector 10 [_SquashPlaneNormal]
Float 11 [_SquashAmount]
"vs_2_0
; 26 ALU
def c12, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_color0 v1
dcl_texcoord0 v2
mul r1.xyz, v0, c9
mov r1.w, c12.x
dp4 r0.z, r1, c6
dp4 r0.x, r1, c4
dp4 r0.y, r1, c5
add r0.xyz, r0, -r1
mad r1.xyz, v1.w, r0, r1
dp3 r0.x, r1, c10
add r0.x, r0, c10.w
mul r0.xyz, r0.x, c10
add r1.xyz, -r0, r1
mad r1.xyz, r0, c11.x, r1
mov r1.w, c12.y
dp4 r0.x, r1, c2
slt r0.y, r0.x, -c8.x
max r0.y, -r0, r0
slt r0.y, c12.x, r0
add r0.z, r0.x, c8.x
add r0.x, -r0.y, c12.y
mul r0.z, r0.x, r0
dp4 r0.w, r1, c3
dp4 r0.x, r1, c0
dp4 r0.y, r1, c1
mov oPos, r0
mov oT0, r0
mov oT1.xy, v2
"
}
SubProgram "opengl " {
Keywords { "SHADOWS_CUBE" }
Bind "vertex" Vertex
Bind "color" Color
Bind "texcoord" TexCoord0
Matrix 5 [_Object2World]
Matrix 9 [_TerrainEngineBendTree]
Vector 13 [_LightPositionRange]
Vector 14 [_Scale]
Vector 15 [_SquashPlaneNormal]
Float 16 [_SquashAmount]
"!!ARBvp1.0
# 22 ALU
PARAM c[17] = { { 0, 1 },
		state.matrix.mvp,
		program.local[5..16] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.position, c[14];
MOV R1.w, c[0].x;
DP4 R0.z, R1, c[11];
DP4 R0.x, R1, c[9];
DP4 R0.y, R1, c[10];
ADD R0.xyz, R0, -R1;
MAD R1.xyz, vertex.color.w, R0, R1;
DP3 R0.x, R1, c[15];
ADD R0.x, R0, c[15].w;
MUL R0.xyz, R0.x, c[15];
ADD R1.xyz, -R0, R1;
MAD R1.xyz, R0, c[16].x, R1;
MOV R1.w, c[0].y;
DP4 R0.z, R1, c[7];
DP4 R0.x, R1, c[5];
DP4 R0.y, R1, c[6];
ADD result.texcoord[0].xyz, R0, -c[13];
DP4 result.position.w, R1, c[4];
DP4 result.position.z, R1, c[3];
DP4 result.position.y, R1, c[2];
DP4 result.position.x, R1, c[1];
MOV result.texcoord[1].xy, vertex.texcoord[0];
END
# 22 instructions, 2 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "SHADOWS_CUBE" }
Bind "vertex" Vertex
Bind "color" Color
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_TerrainEngineBendTree]
Vector 12 [_LightPositionRange]
Vector 13 [_Scale]
Vector 14 [_SquashPlaneNormal]
Float 15 [_SquashAmount]
"vs_2_0
; 22 ALU
def c16, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_color0 v1
dcl_texcoord0 v2
mul r1.xyz, v0, c13
mov r1.w, c16.x
dp4 r0.z, r1, c10
dp4 r0.x, r1, c8
dp4 r0.y, r1, c9
add r0.xyz, r0, -r1
mad r1.xyz, v1.w, r0, r1
dp3 r0.x, r1, c14
add r0.x, r0, c14.w
mul r0.xyz, r0.x, c14
add r1.xyz, -r0, r1
mad r1.xyz, r0, c15.x, r1
mov r1.w, c16.y
dp4 r0.z, r1, c6
dp4 r0.x, r1, c4
dp4 r0.y, r1, c5
add oT0.xyz, r0, -c12
dp4 oPos.w, r1, c3
dp4 oPos.z, r1, c2
dp4 oPos.y, r1, c1
dp4 oPos.x, r1, c0
mov oT1.xy, v2
"
}
}
Program "fp" {
SubProgram "opengl " {
Keywords { "SHADOWS_DEPTH" }
Float 0 [_Cutoff]
SetTexture 0 [_MainTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 4 ALU, 1 TEX
PARAM c[2] = { program.local[0],
		{ 0 } };
TEMP R0;
TEX R0.w, fragment.texcoord[1], texture[0], 2D;
SLT R0.x, R0.w, c[0];
MOV result.color, c[1].x;
KIL -R0.x;
END
# 4 instructions, 1 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "SHADOWS_DEPTH" }
Float 0 [_Cutoff]
SetTexture 0 [_MainTex] 2D
"ps_2_0
; 7 ALU, 2 TEX
dcl_2d s0
def c1, 0.00000000, 1.00000000, 0, 0
dcl t0.xyzw
dcl t1.xy
texld r0, t1, s0
add_pp r0.x, r0.w, -c0
cmp r0.x, r0, c1, c1.y
mov_pp r0, -r0.x
texkill r0.xyzw
rcp r0.x, t0.w
mul r0.x, t0.z, r0
mov r0, r0.x
mov oC0, r0
"
}
SubProgram "opengl " {
Keywords { "SHADOWS_CUBE" }
Vector 0 [_LightPositionRange]
Float 1 [_Cutoff]
SetTexture 0 [_MainTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 10 ALU, 1 TEX
PARAM c[4] = { program.local[0..1],
		{ 1, 255, 65025, 1.6058138e+008 },
		{ 0.0039215689 } };
TEMP R0;
TEX R0.w, fragment.texcoord[1], texture[0], 2D;
SLT R0.x, R0.w, c[1];
KIL -R0.x;
DP3 R0.x, fragment.texcoord[0], fragment.texcoord[0];
RSQ R0.x, R0.x;
RCP R0.x, R0.x;
MUL R0.x, R0, c[0].w;
MUL R0, R0.x, c[2];
FRC R0, R0;
MAD result.color, -R0.yzww, c[3].x, R0;
END
# 10 instructions, 1 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "SHADOWS_CUBE" }
Vector 0 [_LightPositionRange]
Float 1 [_Cutoff]
SetTexture 0 [_MainTex] 2D
"ps_2_0
; 13 ALU, 2 TEX
dcl_2d s0
def c2, 0.00000000, 1.00000000, 0.00392157, 0
def c3, 1.00000000, 255.00000000, 65025.00000000, 160581376.00000000
dcl t0.xyz
dcl t1.xy
texld r0, t1, s0
add_pp r0.x, r0.w, -c1
cmp r0.x, r0, c2, c2.y
mov_pp r0, -r0.x
texkill r0.xyzw
dp3 r0.x, t0, t0
rsq r0.x, r0.x
rcp r0.x, r0.x
mul r0.x, r0, c0.w
mul r0, r0.x, c3
frc r1, r0
mov r0.z, -r1.w
mov r0.xyw, -r1.yzxw
mad r0, r0, c2.z, r1
mov oC0, r0
"
}
}
 }
}
SubShader { 
 Tags { "QUEUE"="Transparent-99" "IGNOREPROJECTOR"="True" "RenderType"="TreeTransparentCutout" }
 Pass {
  Tags { "QUEUE"="Transparent-99" "IGNOREPROJECTOR"="True" "RenderType"="TreeTransparentCutout" }
  Lighting On
  Cull Off
  AlphaTest GEqual [_Cutoff]
  ColorMask RGB
Program "vp" {
SubProgram "opengl " {
Bind "vertex" Vertex
Bind "color" Color
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
Matrix 9 [_TerrainEngineBendTree]
Matrix 13 [_CameraToWorld]
Vector 30 [_Scale]
Vector 31 [_SquashPlaneNormal]
Float 32 [_SquashAmount]
Float 33 [_Occlusion]
Float 34 [_AO]
Float 35 [_BaseLight]
Vector 36 [_Color]
Float 37 [_HalfOverCutoff]
"!!ARBvp1.0
# 100 ALU
PARAM c[38] = { { 0, 1, 0.5 },
		state.light[0].diffuse,
		state.light[0].position,
		state.light[0].attenuation,
		state.light[1].diffuse,
		state.light[1].position,
		state.light[1].attenuation,
		state.light[2].diffuse,
		state.light[2].position,
		program.local[9..16],
		state.light[2].attenuation,
		state.light[3].diffuse,
		state.light[3].position,
		state.light[3].attenuation,
		state.lightmodel.ambient,
		state.matrix.modelview[0],
		state.matrix.mvp,
		program.local[30..37] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R0.xyz, vertex.position, c[30];
MOV R0.w, c[0].x;
MOV R1.w, c[0].y;
DP4 R1.z, R0, c[11];
DP4 R1.x, R0, c[9];
DP4 R1.y, R0, c[10];
ADD R1.xyz, R1, -R0;
MAD R1.xyz, vertex.color.w, R1, R0;
DP3 R0.x, R1, c[31];
ADD R0.x, R0, c[31].w;
MUL R0.xyz, R0.x, c[31];
ADD R1.xyz, -R0, R1;
MAD R1.xyz, R0, c[32].x, R1;
DP4 R3.z, R1, c[24];
DP4 R3.x, R1, c[22];
DP4 R3.y, R1, c[23];
MAD R0.xyz, -R3, c[8].w, c[8];
MAD R2.xyz, -R3, c[2].w, c[2];
MOV R0.z, -R0;
DP3 R2.w, R0, R0;
RSQ R0.w, R2.w;
MUL R4.xyz, R0.w, R0;
DP3 R0.z, R4, c[15];
DP3 R0.y, R4, c[14];
DP3 R0.x, R4, c[13];
MOV R2.z, -R2;
DP3 R4.x, R2, R2;
RSQ R3.w, R4.x;
MUL R2.xyz, R3.w, R2;
MUL R0.xyz, R0, c[33].x;
MOV R0.w, c[34].x;
DP4 R3.w, vertex.attrib[14], R0;
MAX R3.w, R3, c[0].x;
DP3 R0.z, R2, c[15];
DP3 R0.y, R2, c[14];
DP3 R0.x, R2, c[13];
MUL R0.xyz, R0, c[33].x;
MOV R0.w, c[34].x;
DP4 R0.x, vertex.attrib[14], R0;
MUL R0.y, R4.x, c[3].z;
ADD R2.x, R0.y, c[0].y;
MAX R0.x, R0, c[0];
ADD R0.w, R0.x, c[35].x;
MAD R0.xyz, -R3, c[5].w, c[5];
RCP R4.x, R2.x;
MOV R2.xy, R0;
MOV R2.z, -R0;
MUL R0.x, R0.w, R4;
DP3 R4.w, R2, R2;
RSQ R0.w, R4.w;
MUL R4.xyz, R0.w, R2;
MUL R0.xyz, R0.x, c[1];
ADD R2.xyz, R0, c[21];
DP3 R0.z, R4, c[15];
DP3 R0.x, R4, c[13];
DP3 R0.y, R4, c[14];
MUL R0.xyz, R0, c[33].x;
MOV R0.w, c[34].x;
DP4 R0.x, vertex.attrib[14], R0;
MUL R0.w, R2, c[17].z;
MUL R4.x, R4.w, c[6].z;
ADD R0.y, R4.x, c[0];
MAX R0.x, R0, c[0];
ADD R2.w, R0, c[0].y;
RCP R0.y, R0.y;
ADD R0.x, R0, c[35];
MUL R0.x, R0, R0.y;
MAD R0.xyz, R0.x, c[4], R2;
MAD R2.xyz, -R3, c[19].w, c[19];
MOV R2.z, -R2;
DP3 R0.w, R2, R2;
RCP R3.x, R2.w;
RSQ R2.w, R0.w;
MUL R2.xyz, R2.w, R2;
ADD R3.w, R3, c[35].x;
MUL R3.x, R3.w, R3;
MAD R0.xyz, R3.x, c[7], R0;
DP3 R3.x, R2, c[13];
DP3 R3.z, R2, c[15];
DP3 R3.y, R2, c[14];
MUL R2.xyz, R3, c[33].x;
MUL R3.x, R0.w, c[20].z;
MOV R2.w, c[34].x;
DP4 R0.w, vertex.attrib[14], R2;
ADD R2.x, R3, c[0].y;
MAX R0.w, R0, c[0].x;
RCP R2.x, R2.x;
ADD R0.w, R0, c[35].x;
MUL R0.w, R0, R2.x;
MAD R0.xyz, R0.w, c[18], R0;
MUL result.color.xyz, R0, c[36];
DP4 R0.x, R1, c[28];
MOV result.position.z, R0.x;
MOV result.fogcoord.x, R0;
MOV R0.x, c[0].z;
DP4 result.position.w, R1, c[29];
DP4 result.position.y, R1, c[27];
DP4 result.position.x, R1, c[26];
MOV result.texcoord[0], vertex.texcoord[0];
MUL result.color.w, R0.x, c[37].x;
END
# 100 instructions, 5 R-regs
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "color" Color
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [_TerrainEngineBendTree]
Matrix 12 [_CameraToWorld]
Vector 16 [glstate_light0_diffuse]
Vector 17 [glstate_light0_position]
Vector 18 [glstate_light0_attenuation]
Vector 19 [glstate_light1_diffuse]
Vector 20 [glstate_light1_position]
Vector 21 [glstate_light1_attenuation]
Vector 22 [glstate_light2_diffuse]
Vector 23 [glstate_light2_position]
Vector 24 [glstate_light2_attenuation]
Vector 25 [glstate_light3_diffuse]
Vector 26 [glstate_light3_position]
Vector 27 [glstate_light3_attenuation]
Vector 28 [glstate_lightmodel_ambient]
Vector 29 [_Scale]
Vector 30 [_SquashPlaneNormal]
Float 31 [_SquashAmount]
Float 32 [_Occlusion]
Float 33 [_AO]
Float 34 [_BaseLight]
Vector 35 [_Color]
Float 36 [_HalfOverCutoff]
"vs_2_0
; 100 ALU
def c37, 0.00000000, 1.00000000, 0.50000000, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_color0 v2
dcl_texcoord0 v3
mul r0.xyz, v0, c29
mov r0.w, c37.x
mov r1.w, c37.y
dp4 r1.z, r0, c10
dp4 r1.x, r0, c8
dp4 r1.y, r0, c9
add r1.xyz, r1, -r0
mad r1.xyz, v2.w, r1, r0
dp3 r0.x, r1, c30
add r0.x, r0, c30.w
mul r0.xyz, r0.x, c30
add r1.xyz, -r0, r1
mad r1.xyz, r0, c31.x, r1
dp4 r3.z, r1, c2
dp4 r3.x, r1, c0
dp4 r3.y, r1, c1
mad r0.xyz, -r3, c23.w, c23
mad r2.xyz, -r3, c17.w, c17
mov r0.z, -r0
dp3 r2.w, r0, r0
rsq r0.w, r2.w
mul r4.xyz, r0.w, r0
dp3 r0.z, r4, c14
dp3 r0.y, r4, c13
dp3 r0.x, r4, c12
mov r2.z, -r2
dp3 r4.x, r2, r2
rsq r3.w, r4.x
mul r2.xyz, r3.w, r2
mul r0.xyz, r0, c32.x
mov r0.w, c33.x
dp4 r3.w, v1, r0
max r3.w, r3, c37.x
dp3 r0.z, r2, c14
dp3 r0.y, r2, c13
dp3 r0.x, r2, c12
mul r0.xyz, r0, c32.x
mov r0.w, c33.x
dp4 r0.x, v1, r0
mul r0.y, r4.x, c18.z
add r2.x, r0.y, c37.y
max r0.x, r0, c37
add r0.w, r0.x, c34.x
mad r0.xyz, -r3, c20.w, c20
rcp r4.x, r2.x
mov r2.xy, r0
mov r2.z, -r0
mul r0.x, r0.w, r4
dp3 r4.w, r2, r2
rsq r0.w, r4.w
mul r4.xyz, r0.w, r2
mul r0.xyz, r0.x, c16
add r2.xyz, r0, c28
dp3 r0.z, r4, c14
dp3 r0.x, r4, c12
dp3 r0.y, r4, c13
mul r0.xyz, r0, c32.x
mov r0.w, c33.x
dp4 r0.x, v1, r0
mul r0.w, r2, c24.z
mul r4.x, r4.w, c21.z
add r0.y, r4.x, c37
max r0.x, r0, c37
add r2.w, r0, c37.y
rcp r0.y, r0.y
add r0.x, r0, c34
mul r0.x, r0, r0.y
mad r0.xyz, r0.x, c19, r2
mad r2.xyz, -r3, c26.w, c26
mov r2.z, -r2
dp3 r0.w, r2, r2
rcp r3.x, r2.w
rsq r2.w, r0.w
mul r2.xyz, r2.w, r2
add r3.w, r3, c34.x
mul r3.x, r3.w, r3
mad r0.xyz, r3.x, c22, r0
dp3 r3.x, r2, c12
dp3 r3.z, r2, c14
dp3 r3.y, r2, c13
mul r2.xyz, r3, c32.x
mul r3.x, r0.w, c27.z
mov r2.w, c33.x
dp4 r0.w, v1, r2
add r2.x, r3, c37.y
max r0.w, r0, c37.x
rcp r2.x, r2.x
add r0.w, r0, c34.x
mul r0.w, r0, r2.x
mad r0.xyz, r0.w, c25, r0
mul oD0.xyz, r0, c35
dp4 r0.x, r1, c6
mov oPos.z, r0.x
mov oFog, r0.x
mov r0.x, c36
dp4 oPos.w, r1, c7
dp4 oPos.y, r1, c5
dp4 oPos.x, r1, c4
mov oT0, v3
mul oD0.w, c37.z, r0.x
"
}
}
  SetTexture [_MainTex] { combine primary * texture double, texture alpha }
 }
}
SubShader { 
 Tags { "QUEUE"="Transparent-99" "IGNOREPROJECTOR"="True" "RenderType"="TransparentCutout" }
 Pass {
  Tags { "LIGHTMODE"="Vertex" "QUEUE"="Transparent-99" "IGNOREPROJECTOR"="True" "RenderType"="TransparentCutout" }
  Lighting On
  Material {
   Ambient [_Color]
   Diffuse [_Color]
  }
  Cull Off
  AlphaTest GEqual [_Cutoff]
  ColorMask RGB
  SetTexture [_MainTex] { combine primary * texture double, texture alpha }
 }
}
Dependency "BillboardShader" = "Hidden/Nature/Tree Soft Occlusion Leaves Rendertex"
Fallback Off
}