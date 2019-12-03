//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Hidden/Nature/Tree Soft Occlusion Leaves Rendertex" {
Properties {
 _Color ("Main Color", Color) = (1,1,1,0)
 _MainTex ("Main Texture", 2D) = "white" {}
 _Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
 _HalfOverCutoff ("0.5 / Alpha cutoff", Range(0,1)) = 1
 _BaseLight ("Base Light", Range(0,1)) = 0.35
 _AO ("Amb. Occlusion", Range(0,10)) = 2.4
 _Occlusion ("Dir Occlusion", Range(0,20)) = 7.5
 _Scale ("Scale", Vector) = (1,1,1,1)
 _SquashAmount ("Squash", Float) = 1
}
SubShader { 
 Tags { "QUEUE"="Transparent-99" }
 Pass {
  Tags { "QUEUE"="Transparent-99" }
  Lighting On
  Cull Off
  Fog { Mode Off }
Program "vp" {
SubProgram "opengl " {
Bind "vertex" Vertex
Bind "color" Color
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
Matrix 9 [_TerrainEngineBendTree]
Vector 6 [_Scale]
Vector 7 [_SquashPlaneNormal]
Float 8 [_SquashAmount]
Float 13 [_Occlusion]
Float 14 [_AO]
Float 15 [_BaseLight]
Vector 16 [_Color]
Vector 17 [_TerrainTreeLightDirections0]
Vector 18 [_TerrainTreeLightDirections1]
Vector 19 [_TerrainTreeLightDirections2]
Vector 20 [_TerrainTreeLightDirections3]
Vector 21 [_TerrainTreeLightColors0]
Vector 22 [_TerrainTreeLightColors1]
Vector 23 [_TerrainTreeLightColors2]
Vector 24 [_TerrainTreeLightColors3]
Float 25 [_HalfOverCutoff]
"!!ARBvp1.0
# 49 ALU
PARAM c[26] = { { 0, 1, 0.5 },
		state.lightmodel.ambient,
		state.matrix.mvp,
		program.local[6..25] };
TEMP R0;
TEMP R1;
TEMP R2;
MUL R0.xyz, vertex.position, c[6];
MOV R0.w, c[0].x;
MOV R1.w, c[0].y;
DP4 R1.z, R0, c[11];
DP4 R1.x, R0, c[9];
DP4 R1.y, R0, c[10];
ADD R1.xyz, R1, -R0;
MAD R1.xyz, vertex.color.w, R1, R0;
DP3 R0.x, R1, c[7];
ADD R0.x, R0, c[7].w;
MUL R0.xyz, R0.x, c[7];
ADD R1.xyz, -R0, R1;
MAD R1.xyz, R0, c[8].x, R1;
DP4 R2.x, R1, c[4];
MOV R2.y, c[13].x;
DP4 result.position.w, R1, c[5];
DP4 result.position.y, R1, c[3];
DP4 result.position.x, R1, c[2];
MOV R0.w, c[14].x;
MUL R0.xyz, R2.y, c[17];
DP4 R0.x, vertex.attrib[14], R0;
MAX R0.x, R0, c[0];
ADD R1.x, R0, c[15];
MUL R0.xyz, R2.y, c[18];
MOV R0.w, c[14].x;
DP4 R0.w, vertex.attrib[14], R0;
MUL R0.xyz, R1.x, c[21];
MAX R0.w, R0, c[0].x;
ADD R0.xyz, R0, c[1];
ADD R0.w, R0, c[15].x;
MAD R1.xyz, R0.w, c[22], R0;
MOV R0.w, c[14].x;
MUL R0.xyz, R2.y, c[19];
DP4 R1.w, vertex.attrib[14], R0;
MUL R0.xyz, R2.y, c[20];
MOV R0.w, c[14].x;
DP4 R0.x, vertex.attrib[14], R0;
MAX R0.y, R1.w, c[0].x;
ADD R0.y, R0, c[15].x;
MAX R0.x, R0, c[0];
MAD R1.xyz, R0.y, c[23], R1;
ADD R0.x, R0, c[15];
MAD R0.xyz, R0.x, c[24], R1;
MUL result.color.xyz, R0, c[16];
MOV R0.x, c[0].z;
MOV result.position.z, R2.x;
MOV result.fogcoord.x, R2;
MOV result.texcoord[0], vertex.texcoord[0];
MUL result.color.w, R0.x, c[25].x;
END
# 49 instructions, 3 R-regs
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "color" Color
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [_TerrainEngineBendTree]
Vector 12 [glstate_lightmodel_ambient]
Vector 13 [_Scale]
Vector 14 [_SquashPlaneNormal]
Float 15 [_SquashAmount]
Float 16 [_Occlusion]
Float 17 [_AO]
Float 18 [_BaseLight]
Vector 19 [_Color]
Vector 20 [_TerrainTreeLightDirections0]
Vector 21 [_TerrainTreeLightDirections1]
Vector 22 [_TerrainTreeLightDirections2]
Vector 23 [_TerrainTreeLightDirections3]
Vector 24 [_TerrainTreeLightColors0]
Vector 25 [_TerrainTreeLightColors1]
Vector 26 [_TerrainTreeLightColors2]
Vector 27 [_TerrainTreeLightColors3]
Float 28 [_HalfOverCutoff]
"vs_2_0
; 52 ALU
def c29, 0.00000000, 1.00000000, 0.50000000, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_color0 v2
dcl_texcoord0 v3
mul r0.xyz, v0, c13
mov r0.w, c29.x
mov r1.w, c29.y
dp4 r1.z, r0, c10
dp4 r1.x, r0, c8
dp4 r1.y, r0, c9
add r1.xyz, r1, -r0
mad r1.xyz, v2.w, r1, r0
dp3 r0.x, r1, c14
add r0.x, r0, c14.w
mul r0.xyz, r0.x, c14
add r1.xyz, -r0, r1
mad r1.xyz, r0, c15.x, r1
dp4 r2.x, r1, c6
mov r0.xyz, c20
dp4 oPos.w, r1, c7
mul r0.xyz, c16.x, r0
mov r0.w, c17.x
dp4 r0.x, v1, r0
dp4 oPos.y, r1, c5
dp4 oPos.x, r1, c4
max r0.x, r0, c29
add r1.x, r0, c18
mov r0.xyz, c21
mul r1.xyz, r1.x, c24
mul r0.xyz, c16.x, r0
mov r0.w, c17.x
dp4 r0.x, v1, r0
max r0.x, r0, c29
add r0.x, r0, c18
add r1.xyz, r1, c12
mad r1.xyz, r0.x, c25, r1
mov r0.xyz, c22
mov r0.w, c17.x
mul r0.xyz, c16.x, r0
dp4 r1.w, v1, r0
mov r0.xyz, c23
mul r0.xyz, c16.x, r0
mov r0.w, c17.x
dp4 r0.x, v1, r0
max r0.y, r1.w, c29.x
add r0.y, r0, c18.x
max r0.x, r0, c29
mad r1.xyz, r0.y, c26, r1
add r0.x, r0, c18
mad r0.xyz, r0.x, c27, r1
mul oD0.xyz, r0, c19
mov r0.x, c28
mov oPos.z, r2.x
mov oFog, r2.x
mov oT0, v3
mul oD0.w, c29.z, r0.x
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
		{ 1, 2 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
SLT R0.w, R0, c[0].x;
MUL R1.xyz, fragment.color.primary, c[1].y;
MUL result.color.xyz, R0, R1;
MOV result.color.w, c[1].x;
KIL -R0.w;
END
# 6 instructions, 2 R-regs
"
}
SubProgram "d3d9 " {
Float 0 [_Cutoff]
SetTexture 0 [_MainTex] 2D
"ps_2_0
; 7 ALU, 2 TEX
dcl_2d s0
def c1, 2.00000000, 1.00000000, 0.00000000, 0
dcl t0.xy
dcl v0.xyz
texld r0, t0, s0
add_pp r1.x, r0.w, -c0
cmp r1.x, r1, c1.z, c1.y
mov_pp r1, -r1.x
mov_pp r0.w, c1.y
texkill r1.xyzw
mul r1.xyz, v0, c1.x
mul_pp r0.xyz, r0, r1
mov_pp oC0, r0
"
}
}
 }
}
SubShader { 
 Tags { "QUEUE"="Transparent-99" }
 Pass {
  Tags { "QUEUE"="Transparent-99" }
  Lighting On
  Cull Off
  Fog { Mode Off }
  AlphaTest GEqual 1
Program "vp" {
SubProgram "opengl " {
Bind "vertex" Vertex
Bind "color" Color
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
Matrix 9 [_TerrainEngineBendTree]
Vector 6 [_Scale]
Vector 7 [_SquashPlaneNormal]
Float 8 [_SquashAmount]
Float 13 [_Occlusion]
Float 14 [_AO]
Float 15 [_BaseLight]
Vector 16 [_Color]
Vector 17 [_TerrainTreeLightDirections0]
Vector 18 [_TerrainTreeLightDirections1]
Vector 19 [_TerrainTreeLightDirections2]
Vector 20 [_TerrainTreeLightDirections3]
Vector 21 [_TerrainTreeLightColors0]
Vector 22 [_TerrainTreeLightColors1]
Vector 23 [_TerrainTreeLightColors2]
Vector 24 [_TerrainTreeLightColors3]
Float 25 [_HalfOverCutoff]
"!!ARBvp1.0
# 49 ALU
PARAM c[26] = { { 0, 1, 0.5 },
		state.lightmodel.ambient,
		state.matrix.mvp,
		program.local[6..25] };
TEMP R0;
TEMP R1;
TEMP R2;
MUL R0.xyz, vertex.position, c[6];
MOV R0.w, c[0].x;
MOV R1.w, c[0].y;
DP4 R1.z, R0, c[11];
DP4 R1.x, R0, c[9];
DP4 R1.y, R0, c[10];
ADD R1.xyz, R1, -R0;
MAD R1.xyz, vertex.color.w, R1, R0;
DP3 R0.x, R1, c[7];
ADD R0.x, R0, c[7].w;
MUL R0.xyz, R0.x, c[7];
ADD R1.xyz, -R0, R1;
MAD R1.xyz, R0, c[8].x, R1;
DP4 R2.x, R1, c[4];
MOV R2.y, c[13].x;
DP4 result.position.w, R1, c[5];
DP4 result.position.y, R1, c[3];
DP4 result.position.x, R1, c[2];
MOV R0.w, c[14].x;
MUL R0.xyz, R2.y, c[17];
DP4 R0.x, vertex.attrib[14], R0;
MAX R0.x, R0, c[0];
ADD R1.x, R0, c[15];
MUL R0.xyz, R2.y, c[18];
MOV R0.w, c[14].x;
DP4 R0.w, vertex.attrib[14], R0;
MUL R0.xyz, R1.x, c[21];
MAX R0.w, R0, c[0].x;
ADD R0.xyz, R0, c[1];
ADD R0.w, R0, c[15].x;
MAD R1.xyz, R0.w, c[22], R0;
MOV R0.w, c[14].x;
MUL R0.xyz, R2.y, c[19];
DP4 R1.w, vertex.attrib[14], R0;
MUL R0.xyz, R2.y, c[20];
MOV R0.w, c[14].x;
DP4 R0.x, vertex.attrib[14], R0;
MAX R0.y, R1.w, c[0].x;
ADD R0.y, R0, c[15].x;
MAX R0.x, R0, c[0];
MAD R1.xyz, R0.y, c[23], R1;
ADD R0.x, R0, c[15];
MAD R0.xyz, R0.x, c[24], R1;
MUL result.color.xyz, R0, c[16];
MOV R0.x, c[0].z;
MOV result.position.z, R2.x;
MOV result.fogcoord.x, R2;
MOV result.texcoord[0], vertex.texcoord[0];
MUL result.color.w, R0.x, c[25].x;
END
# 49 instructions, 3 R-regs
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "color" Color
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [_TerrainEngineBendTree]
Vector 12 [glstate_lightmodel_ambient]
Vector 13 [_Scale]
Vector 14 [_SquashPlaneNormal]
Float 15 [_SquashAmount]
Float 16 [_Occlusion]
Float 17 [_AO]
Float 18 [_BaseLight]
Vector 19 [_Color]
Vector 20 [_TerrainTreeLightDirections0]
Vector 21 [_TerrainTreeLightDirections1]
Vector 22 [_TerrainTreeLightDirections2]
Vector 23 [_TerrainTreeLightDirections3]
Vector 24 [_TerrainTreeLightColors0]
Vector 25 [_TerrainTreeLightColors1]
Vector 26 [_TerrainTreeLightColors2]
Vector 27 [_TerrainTreeLightColors3]
Float 28 [_HalfOverCutoff]
"vs_2_0
; 52 ALU
def c29, 0.00000000, 1.00000000, 0.50000000, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_color0 v2
dcl_texcoord0 v3
mul r0.xyz, v0, c13
mov r0.w, c29.x
mov r1.w, c29.y
dp4 r1.z, r0, c10
dp4 r1.x, r0, c8
dp4 r1.y, r0, c9
add r1.xyz, r1, -r0
mad r1.xyz, v2.w, r1, r0
dp3 r0.x, r1, c14
add r0.x, r0, c14.w
mul r0.xyz, r0.x, c14
add r1.xyz, -r0, r1
mad r1.xyz, r0, c15.x, r1
dp4 r2.x, r1, c6
mov r0.xyz, c20
dp4 oPos.w, r1, c7
mul r0.xyz, c16.x, r0
mov r0.w, c17.x
dp4 r0.x, v1, r0
dp4 oPos.y, r1, c5
dp4 oPos.x, r1, c4
max r0.x, r0, c29
add r1.x, r0, c18
mov r0.xyz, c21
mul r1.xyz, r1.x, c24
mul r0.xyz, c16.x, r0
mov r0.w, c17.x
dp4 r0.x, v1, r0
max r0.x, r0, c29
add r0.x, r0, c18
add r1.xyz, r1, c12
mad r1.xyz, r0.x, c25, r1
mov r0.xyz, c22
mov r0.w, c17.x
mul r0.xyz, c16.x, r0
dp4 r1.w, v1, r0
mov r0.xyz, c23
mul r0.xyz, c16.x, r0
mov r0.w, c17.x
dp4 r0.x, v1, r0
max r0.y, r1.w, c29.x
add r0.y, r0, c18.x
max r0.x, r0, c29
mad r1.xyz, r0.y, c26, r1
add r0.x, r0, c18
mad r0.xyz, r0.x, c27, r1
mul oD0.xyz, r0, c19
mov r0.x, c28
mov oPos.z, r2.x
mov oFog, r2.x
mov oT0, v3
mul oD0.w, c29.z, r0.x
"
}
}
  SetTexture [_MainTex] { combine primary * texture double, primary alpha * texture alpha quad }
 }
}
Fallback Off
}