//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Hidden/Nature/Tree Soft Occlusion Bark Rendertex" {
Properties {
 _Color ("Main Color", Color) = (1,1,1,0)
 _MainTex ("Main Texture", 2D) = "white" {}
 _BaseLight ("Base Light", Range(0,1)) = 0.35
 _AO ("Amb. Occlusion", Range(0,10)) = 2.4
 _Scale ("Scale", Vector) = (1,1,1,1)
 _SquashAmount ("Squash", Float) = 1
}
SubShader { 
 Pass {
  Lighting On
  Fog { Mode Off }
Program "vp" {
SubProgram "opengl " {
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
Matrix 9 [_TerrainEngineBendTree]
Vector 6 [_Scale]
Vector 7 [_SquashPlaneNormal]
Float 8 [_SquashAmount]
Float 13 [_AO]
Float 14 [_BaseLight]
Vector 15 [_Color]
Vector 16 [_TerrainTreeLightDirections0]
Vector 17 [_TerrainTreeLightDirections1]
Vector 18 [_TerrainTreeLightDirections2]
Vector 19 [_TerrainTreeLightDirections3]
Vector 20 [_TerrainTreeLightColors0]
Vector 21 [_TerrainTreeLightColors1]
Vector 22 [_TerrainTreeLightColors2]
Vector 23 [_TerrainTreeLightColors3]
"!!ARBvp1.0
# 41 ALU
PARAM c[24] = { { 0, 1 },
		state.lightmodel.ambient,
		state.matrix.mvp,
		program.local[6..23] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.position, c[6];
MOV R1.w, c[0].x;
DP4 R0.z, R1, c[11];
DP4 R0.x, R1, c[9];
DP4 R0.y, R1, c[10];
ADD R0.xyz, R0, -R1;
MAD R0.xyz, vertex.color.w, R0, R1;
DP3 R0.w, R0, c[7];
ADD R0.w, R0, c[7];
MUL R1.xyz, R0.w, c[7];
ADD R0.xyz, -R1, R0;
MAD R0.xyz, R1, c[8].x, R0;
MOV R0.w, c[0].y;
DP4 R1.x, R0, c[4];
DP3 R1.z, vertex.normal, c[18];
DP4 result.position.w, R0, c[5];
DP4 result.position.y, R0, c[3];
DP4 result.position.x, R0, c[2];
MUL R0.x, vertex.attrib[14].w, c[13];
DP3 R0.y, vertex.normal, c[16];
DP3 R0.w, vertex.normal, c[17];
ADD R1.y, R0.x, c[14].x;
MAX R0.y, R0, c[0].x;
MUL R0.x, R1.y, R0.y;
MUL R0.xyz, R0.x, c[20];
MAX R0.w, R0, c[0].x;
MAX R1.z, R1, c[0].x;
ADD R0.xyz, R0, c[1];
MUL R0.w, R1.y, R0;
MAD R0.yzw, R0.w, c[21].xxyz, R0.xxyz;
DP3 R0.x, vertex.normal, c[19];
MUL R1.z, R1.y, R1;
MAX R0.x, R0, c[0];
MAD R0.yzw, R1.z, c[22].xxyz, R0;
MUL R0.x, R0, R1.y;
MAD R0.xyz, R0.x, c[23], R0.yzww;
MOV result.position.z, R1.x;
MOV result.fogcoord.x, R1;
MUL result.color.xyz, R0, c[15];
MOV result.texcoord[0], vertex.texcoord[0];
MOV result.color.w, c[0].y;
END
# 41 instructions, 2 R-regs
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [_TerrainEngineBendTree]
Vector 12 [glstate_lightmodel_ambient]
Vector 13 [_Scale]
Vector 14 [_SquashPlaneNormal]
Float 15 [_SquashAmount]
Float 16 [_AO]
Float 17 [_BaseLight]
Vector 18 [_Color]
Vector 19 [_TerrainTreeLightDirections0]
Vector 20 [_TerrainTreeLightDirections1]
Vector 21 [_TerrainTreeLightDirections2]
Vector 22 [_TerrainTreeLightDirections3]
Vector 23 [_TerrainTreeLightColors0]
Vector 24 [_TerrainTreeLightColors1]
Vector 25 [_TerrainTreeLightColors2]
Vector 26 [_TerrainTreeLightColors3]
"vs_2_0
; 41 ALU
def c27, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_color0 v3
dcl_texcoord0 v4
mul r1.xyz, v0, c13
mov r1.w, c27.x
dp4 r0.z, r1, c10
dp4 r0.x, r1, c8
dp4 r0.y, r1, c9
add r0.xyz, r0, -r1
mad r0.xyz, v3.w, r0, r1
dp3 r0.w, r0, c14
add r0.w, r0, c14
mul r1.xyz, r0.w, c14
add r0.xyz, -r1, r0
mad r0.xyz, r1, c15.x, r0
mov r0.w, c27.y
dp4 r1.x, r0, c6
dp3 r1.z, v2, c21
dp4 oPos.w, r0, c7
dp4 oPos.y, r0, c5
dp4 oPos.x, r0, c4
mul r0.x, v1.w, c16
dp3 r0.y, v2, c19
dp3 r0.w, v2, c20
add r1.y, r0.x, c17.x
max r0.y, r0, c27.x
mul r0.x, r1.y, r0.y
mul r0.xyz, r0.x, c23
max r0.w, r0, c27.x
max r1.z, r1, c27.x
add r0.xyz, r0, c12
mul r0.w, r1.y, r0
mad r0.yzw, r0.w, c24.xxyz, r0.xxyz
dp3 r0.x, v2, c22
mul r1.z, r1.y, r1
max r0.x, r0, c27
mad r0.yzw, r1.z, c25.xxyz, r0
mul r0.x, r0, r1.y
mad r0.xyz, r0.x, c26, r0.yzww
mov oPos.z, r1.x
mov oFog, r1.x
mul oD0.xyz, r0, c18
mov oT0, v4
mov oD0.w, c27.y
"
}
}
Program "fp" {
SubProgram "opengl " {
SetTexture 0 [_MainTex] 2D
"!!ARBfp1.0
# 4 ALU, 1 TEX
PARAM c[1] = { { 2 } };
TEMP R0;
TEX R0.xyz, fragment.texcoord[0], texture[0], 2D;
MUL R0.xyz, R0, c[0].x;
MUL result.color.xyz, fragment.color.primary, R0;
MOV result.color.w, fragment.color.primary;
END
# 4 instructions, 1 R-regs
"
}
SubProgram "d3d9 " {
SetTexture 0 [_MainTex] 2D
"ps_2_0
; 4 ALU, 1 TEX
dcl_2d s0
def c0, 2.00000000, 0, 0, 0
dcl t0.xy
dcl v0
texld r0, t0, s0
mul r0.xyz, r0, c0.x
mov_pp r0.w, v0
mul_pp r0.xyz, v0, r0
mov_pp oC0, r0
"
}
}
 }
}
SubShader { 
 Pass {
  Lighting On
  Fog { Mode Off }
Program "vp" {
SubProgram "opengl " {
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
Matrix 9 [_TerrainEngineBendTree]
Vector 6 [_Scale]
Vector 7 [_SquashPlaneNormal]
Float 8 [_SquashAmount]
Float 13 [_AO]
Float 14 [_BaseLight]
Vector 15 [_Color]
Vector 16 [_TerrainTreeLightDirections0]
Vector 17 [_TerrainTreeLightDirections1]
Vector 18 [_TerrainTreeLightDirections2]
Vector 19 [_TerrainTreeLightDirections3]
Vector 20 [_TerrainTreeLightColors0]
Vector 21 [_TerrainTreeLightColors1]
Vector 22 [_TerrainTreeLightColors2]
Vector 23 [_TerrainTreeLightColors3]
"!!ARBvp1.0
# 41 ALU
PARAM c[24] = { { 0, 1 },
		state.lightmodel.ambient,
		state.matrix.mvp,
		program.local[6..23] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.position, c[6];
MOV R1.w, c[0].x;
DP4 R0.z, R1, c[11];
DP4 R0.x, R1, c[9];
DP4 R0.y, R1, c[10];
ADD R0.xyz, R0, -R1;
MAD R0.xyz, vertex.color.w, R0, R1;
DP3 R0.w, R0, c[7];
ADD R0.w, R0, c[7];
MUL R1.xyz, R0.w, c[7];
ADD R0.xyz, -R1, R0;
MAD R0.xyz, R1, c[8].x, R0;
MOV R0.w, c[0].y;
DP4 R1.x, R0, c[4];
DP3 R1.z, vertex.normal, c[18];
DP4 result.position.w, R0, c[5];
DP4 result.position.y, R0, c[3];
DP4 result.position.x, R0, c[2];
MUL R0.x, vertex.attrib[14].w, c[13];
DP3 R0.y, vertex.normal, c[16];
DP3 R0.w, vertex.normal, c[17];
ADD R1.y, R0.x, c[14].x;
MAX R0.y, R0, c[0].x;
MUL R0.x, R1.y, R0.y;
MUL R0.xyz, R0.x, c[20];
MAX R0.w, R0, c[0].x;
MAX R1.z, R1, c[0].x;
ADD R0.xyz, R0, c[1];
MUL R0.w, R1.y, R0;
MAD R0.yzw, R0.w, c[21].xxyz, R0.xxyz;
DP3 R0.x, vertex.normal, c[19];
MUL R1.z, R1.y, R1;
MAX R0.x, R0, c[0];
MAD R0.yzw, R1.z, c[22].xxyz, R0;
MUL R0.x, R0, R1.y;
MAD R0.xyz, R0.x, c[23], R0.yzww;
MOV result.position.z, R1.x;
MOV result.fogcoord.x, R1;
MUL result.color.xyz, R0, c[15];
MOV result.texcoord[0], vertex.texcoord[0];
MOV result.color.w, c[0].y;
END
# 41 instructions, 2 R-regs
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [_TerrainEngineBendTree]
Vector 12 [glstate_lightmodel_ambient]
Vector 13 [_Scale]
Vector 14 [_SquashPlaneNormal]
Float 15 [_SquashAmount]
Float 16 [_AO]
Float 17 [_BaseLight]
Vector 18 [_Color]
Vector 19 [_TerrainTreeLightDirections0]
Vector 20 [_TerrainTreeLightDirections1]
Vector 21 [_TerrainTreeLightDirections2]
Vector 22 [_TerrainTreeLightDirections3]
Vector 23 [_TerrainTreeLightColors0]
Vector 24 [_TerrainTreeLightColors1]
Vector 25 [_TerrainTreeLightColors2]
Vector 26 [_TerrainTreeLightColors3]
"vs_2_0
; 41 ALU
def c27, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_color0 v3
dcl_texcoord0 v4
mul r1.xyz, v0, c13
mov r1.w, c27.x
dp4 r0.z, r1, c10
dp4 r0.x, r1, c8
dp4 r0.y, r1, c9
add r0.xyz, r0, -r1
mad r0.xyz, v3.w, r0, r1
dp3 r0.w, r0, c14
add r0.w, r0, c14
mul r1.xyz, r0.w, c14
add r0.xyz, -r1, r0
mad r0.xyz, r1, c15.x, r0
mov r0.w, c27.y
dp4 r1.x, r0, c6
dp3 r1.z, v2, c21
dp4 oPos.w, r0, c7
dp4 oPos.y, r0, c5
dp4 oPos.x, r0, c4
mul r0.x, v1.w, c16
dp3 r0.y, v2, c19
dp3 r0.w, v2, c20
add r1.y, r0.x, c17.x
max r0.y, r0, c27.x
mul r0.x, r1.y, r0.y
mul r0.xyz, r0.x, c23
max r0.w, r0, c27.x
max r1.z, r1, c27.x
add r0.xyz, r0, c12
mul r0.w, r1.y, r0
mad r0.yzw, r0.w, c24.xxyz, r0.xxyz
dp3 r0.x, v2, c22
mul r1.z, r1.y, r1
max r0.x, r0, c27
mad r0.yzw, r1.z, c25.xxyz, r0
mul r0.x, r0, r1.y
mad r0.xyz, r0.x, c26, r0.yzww
mov oPos.z, r1.x
mov oFog, r1.x
mul oD0.xyz, r0, c18
mov oT0, v4
mov oD0.w, c27.y
"
}
}
  SetTexture [_MainTex] { combine primary * texture double, primary alpha }
 }
}
Fallback Off
}