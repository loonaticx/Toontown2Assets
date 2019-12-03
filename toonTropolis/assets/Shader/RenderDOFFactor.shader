//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Hidden/Render DOF Factor" {
Properties {
	_MainTex ("Base", 2D) = "white" {}
	_Cutoff ("Cutoff", float) = 0.5
}

// Helper code used in all of the below subshaders	
#LINE 37


Category {
	Fog { Mode Off }
	
	// regular opaque objects
	SubShader {
		Tags { "RenderType"="Opaque" }
		Pass {
		
Program "" {
// Vertex combos: 1
//   opengl - ALU: 6 to 6
//   d3d9 - ALU: 6 to 6
// Fragment combos: 1
//   opengl - ALU: 5 to 5, TEX: 0 to 0
//   d3d9 - ALU: 7 to 7
SubProgram "opengl " {
Keywords { }
Bind "vertex", Vertex
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
Keywords { }
Bind "vertex", Vertex
Matrix 0, [glstate_matrix_modelview0]
Matrix 4, [glstate_matrix_mvp]
"vs_1_1
; 6 ALU
dcl_position v0
dp4 r0.x, v0, c2
dp4 oPos.w, v0, c7
dp4 oPos.z, v0, c6
dp4 oPos.y, v0, c5
dp4 oPos.x, v0, c4
mov oT0.x, -r0
"
}

SubProgram "opengl " {
Keywords { }
Local 0, [_FocalParams]
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
Keywords { }
Local 0, [_FocalParams]
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
#LINE 57

		}
	} 
	
	// transparent cutout objects
	SubShader {
		Tags { "RenderType"="TransparentCutout" }
		Pass {
			Cull Off
		
Program "" {
// Vertex combos: 1
//   opengl - ALU: 7 to 7
//   d3d9 - ALU: 7 to 7
// Fragment combos: 1
//   opengl - ALU: 8 to 8, TEX: 1 to 1
//   d3d9 - ALU: 10 to 10, TEX: 2 to 2
SubProgram "opengl " {
Keywords { }
Bind "vertex", Vertex
Bind "texcoord", TexCoord0
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
Keywords { }
Bind "vertex", Vertex
Bind "texcoord", TexCoord0
Matrix 0, [glstate_matrix_modelview0]
Matrix 4, [glstate_matrix_mvp]
"vs_1_1
; 7 ALU
dcl_position v0
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

SubProgram "opengl " {
Keywords { }
Local 0, [_FocalParams]
Local 1, ([_Cutoff],0,0,0)
SetTexture [_MainTex] {2D}
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
Keywords { }
Local 0, [_FocalParams]
Local 1, ([_Cutoff],0,0,0)
SetTexture [_MainTex] {2D}
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
#LINE 78


		}
	} 
	
	// terrain tree bark
	SubShader {
		Tags { "RenderType"="TreeOpaque" }
		Pass {
		
Program "" {
// Vertex combos: 1
//   opengl - ALU: 13 to 13
//   d3d9 - ALU: 13 to 13
// Fragment combos: 1
//   opengl - ALU: 5 to 5, TEX: 0 to 0
//   d3d9 - ALU: 7 to 7
SubProgram "opengl " {
Keywords { }
Bind "vertex", Vertex
Bind "color", Color
Local 5, [_Scale]
Matrix 1, [_TerrainEngineBendTree]
"!!ARBvp1.0
# 13 ALU
PARAM c[14] = { program.local[0..5],
		state.matrix.modelview[0],
		state.matrix.mvp };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.position, c[5];
MOV R0.w, vertex.position;
DP3 R0.z, R1, c[3];
DP3 R0.x, R1, c[1];
DP3 R0.y, R1, c[2];
ADD R0.xyz, R0, -R1;
MAD R0.xyz, vertex.color.w, R0, R1;
DP4 R1.x, R0, c[8];
DP4 result.position.w, R0, c[13];
DP4 result.position.z, R0, c[12];
DP4 result.position.y, R0, c[11];
DP4 result.position.x, R0, c[10];
MOV result.texcoord[0].x, -R1;
END
# 13 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex", Vertex
Bind "color", Color
Local 12, [_Scale]
Matrix 0, [_TerrainEngineBendTree]
Matrix 4, [glstate_matrix_modelview0]
Matrix 8, [glstate_matrix_mvp]
"vs_1_1
; 13 ALU
dcl_position v0
dcl_color v1
mul r1.xyz, v0, c12
mov r0.w, v0
dp3 r0.z, r1, c2
dp3 r0.x, r1, c0
dp3 r0.y, r1, c1
add r0.xyz, r0, -r1
mad r0.xyz, v1.w, r0, r1
dp4 r1.x, r0, c6
dp4 oPos.w, r0, c11
dp4 oPos.z, r0, c10
dp4 oPos.y, r0, c9
dp4 oPos.x, r0, c8
mov oT0.x, -r1
"
}

SubProgram "opengl " {
Keywords { }
Local 0, [_FocalParams]
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
Keywords { }
Local 0, [_FocalParams]
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
#LINE 104

		}
	}
	
	// terrain tree leaves
	SubShader {
		Tags { "RenderType"="TreeTransparentCutout" }
		Pass {
			Cull Off
		
Program "" {
// Vertex combos: 1
//   opengl - ALU: 14 to 14
//   d3d9 - ALU: 14 to 14
// Fragment combos: 1
//   opengl - ALU: 8 to 8, TEX: 1 to 1
//   d3d9 - ALU: 10 to 10, TEX: 2 to 2
SubProgram "opengl " {
Keywords { }
Bind "vertex", Vertex
Bind "color", Color
Bind "texcoord", TexCoord0
Local 5, [_Scale]
Matrix 1, [_TerrainEngineBendTree]
"!!ARBvp1.0
# 14 ALU
PARAM c[14] = { program.local[0..5],
		state.matrix.modelview[0],
		state.matrix.mvp };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.position, c[5];
MOV R0.w, vertex.position;
DP3 R0.z, R1, c[3];
DP3 R0.x, R1, c[1];
DP3 R0.y, R1, c[2];
ADD R0.xyz, R0, -R1;
MAD R0.xyz, vertex.color.w, R0, R1;
DP4 R1.x, R0, c[8];
DP4 result.position.w, R0, c[13];
DP4 result.position.z, R0, c[12];
DP4 result.position.y, R0, c[11];
DP4 result.position.x, R0, c[10];
MOV result.texcoord[1].x, -R1;
MOV result.texcoord[0].xy, vertex.texcoord[0];
END
# 14 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex", Vertex
Bind "color", Color
Bind "texcoord", TexCoord0
Local 12, [_Scale]
Matrix 0, [_TerrainEngineBendTree]
Matrix 4, [glstate_matrix_modelview0]
Matrix 8, [glstate_matrix_mvp]
"vs_1_1
; 14 ALU
dcl_position v0
dcl_color v1
dcl_texcoord0 v2
mul r1.xyz, v0, c12
mov r0.w, v0
dp3 r0.z, r1, c2
dp3 r0.x, r1, c0
dp3 r0.y, r1, c1
add r0.xyz, r0, -r1
mad r0.xyz, v1.w, r0, r1
dp4 r1.x, r0, c6
dp4 oPos.w, r0, c11
dp4 oPos.z, r0, c10
dp4 oPos.y, r0, c9
dp4 oPos.x, r0, c8
mov oT1.x, -r1
mov oT0.xy, v2
"
}

SubProgram "opengl " {
Keywords { }
Local 0, [_FocalParams]
Local 1, ([_Cutoff],0,0,0)
SetTexture [_MainTex] {2D}
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
Keywords { }
Local 0, [_FocalParams]
Local 1, ([_Cutoff],0,0,0)
SetTexture [_MainTex] {2D}
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
#LINE 132

		}
	}
	
	// terrain tree billboards
	SubShader {
		Tags { "RenderType"="TreeBillboard" }
		Pass {
			Cull Off
		
Program "" {
// Vertex combos: 1
//   opengl - ALU: 14 to 14
//   d3d9 - ALU: 17 to 17
// Fragment combos: 1
//   opengl - ALU: 8 to 8, TEX: 1 to 1
//   d3d9 - ALU: 10 to 10, TEX: 2 to 2
SubProgram "opengl " {
Keywords { }
Bind "vertex", Vertex
Bind "texcoord", TexCoord0
Bind "texcoord1", TexCoord1
Local 1, [_TreeBillboardCameraRight]
Local 2, [_TreeBillboardCameraUp]
Local 3, [_TreeBillboardCameraPos]
Local 4, [_TreeBillboardDistances]
"!!ARBvp1.0
# 14 ALU
PARAM c[13] = { program.local[0..4],
		state.matrix.modelview[0],
		state.matrix.mvp };
TEMP R0;
TEMP R1;
ADD R0.xyz, vertex.position, -c[3];
DP3 R0.x, R0, R0;
SLT R0.x, c[4], R0;
MAD R1.xy, -vertex.texcoord[1], R0.x, vertex.texcoord[1];
MAD R0.xyz, R1.x, c[1], vertex.position;
MOV R0.w, vertex.position;
MAD R0.xyz, R1.y, c[2], R0;
DP4 R1.x, R0, c[7];
DP4 result.position.w, R0, c[12];
DP4 result.position.z, R0, c[11];
DP4 result.position.y, R0, c[10];
DP4 result.position.x, R0, c[9];
MOV result.texcoord[1].x, -R1;
MOV result.texcoord[0].xy, vertex.texcoord[0];
END
# 14 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex", Vertex
Bind "texcoord", TexCoord0
Bind "texcoord1", TexCoord1
Local 8, [_TreeBillboardCameraRight]
Local 9, [_TreeBillboardCameraUp]
Local 10, [_TreeBillboardCameraPos]
Local 11, [_TreeBillboardDistances]
Matrix 0, [glstate_matrix_modelview0]
Matrix 4, [glstate_matrix_mvp]
"vs_1_1
; 17 ALU
def c12, 0.00000000, 1.00000000, 0, 0
dcl_position v0
dcl_texcoord0 v1
dcl_texcoord1 v2
add r0.xyz, v0, -c10
dp3 r0.x, r0, r0
slt r0.x, c11, r0
max r0.x, -r0, r0
slt r0.x, c12, r0
add r0.x, -r0, c12.y
mul r1.xy, r0.x, v2
mad r0.xyz, r1.x, c8, v0
mov r0.w, v0
mad r0.xyz, r1.y, c9, r0
dp4 r1.x, r0, c2
dp4 oPos.w, r0, c7
dp4 oPos.z, r0, c6
dp4 oPos.y, r0, c5
dp4 oPos.x, r0, c4
mov oT1.x, -r1
mov oT0.xy, v1
"
}

SubProgram "opengl " {
Keywords { }
Local 0, [_FocalParams]
SetTexture [_MainTex] {2D}
"!!ARBfp1.0
# 8 ALU, 1 TEX
PARAM c[2] = { program.local[0],
		{ 4, 0.5 } };
TEMP R0;
TEX R0.w, fragment.texcoord[0], texture[0], 2D;
SLT R0.x, R0.w, c[1].y;
KIL -R0.x;
ADD R0.x, fragment.texcoord[1], -c[0];
MUL R0.y, R0.x, c[1].x;
CMP R0.x, R0, R0.y, R0;
ABS R0.x, R0;
MUL_SAT result.color, R0.x, c[0].w;
END
# 8 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Local 0, [_FocalParams]
SetTexture [_MainTex] {2D}
"ps_2_0
; 10 ALU, 2 TEX
dcl_2d s0
def c1, -0.50000000, 0.00000000, 1.00000000, 4.00000000
dcl t0.xy
dcl t1.x
texld r0, t0, s0
add_pp r0.x, r0.w, c1
cmp r0.x, r0, c1.y, c1.z
mov_pp r0, -r0.x
texkill r0.xyzw
add r0.x, t1, -c0
mul r1.x, r0, c1.w
cmp r0.x, r0, r0, r1
abs r0.x, r0
mul_sat r0.x, r0, c0.w
mov_pp r0, r0.x
mov_pp oC0, r0
"
}

}
#LINE 165

		}
	}
	
	// terrain grass billboards
	SubShader {
		Tags { "RenderType"="GrassBillboard" }
		Pass {
			Cull Off
		
Program "" {
// Vertex combos: 2
//   opengl - ALU: 15 to 37
//   d3d9 - ALU: 18 to 46
// Fragment combos: 2
//   opengl - ALU: 8 to 8, TEX: 1 to 1
//   d3d9 - ALU: 10 to 10, TEX: 2 to 2
SubProgram "opengl " {
Keywords { "NO_INTEL_GMA_X3100_WORKAROUND" }
Bind "vertex", Vertex
Bind "texcoord", TexCoord0
Bind "texcoord1", TexCoord1
Local 1, [_WaveAndDistance]
Local 2, [_CameraPosition]
Local 3, [_CameraRight]
Local 4, [_CameraUp]
"!!ARBvp1.0
# 37 ALU
PARAM c[19] = { { 1.2, 2, 1.6, 4.8000002 },
		program.local[1..4],
		state.matrix.modelview[0],
		state.matrix.mvp,
		{ 0.5, 0.0060000001, 0.02, 0.050000001 },
		{ 0.012, 0.02, 0.059999999, 0.024 },
		{ 6.4088488, 3.1415927, -0.00019840999, 0.0083333002 },
		{ -0.16161616 },
		{ 0.0060000001, 0.02, -0.02, 0.1 },
		{ 0.024, 0.039999999, -0.12, 0.096000001 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
ADD R0.xyz, vertex.position, -c[2];
DP3 R0.x, R0, R0;
SLT R0.x, c[1].w, R0;
MAD R0.xy, -vertex.texcoord[1], R0.x, vertex.texcoord[1];
ADD R0.x, R0, -c[13];
MAD R1.xyz, R0.x, c[3], vertex.position;
MAD R3.xyz, R0.y, c[4], R1;
MUL R0.x, R3.z, c[1].y;
MUL R0.xyz, R0.x, c[13].yzww;
MUL R0.w, R3.x, c[1].y;
MAD R1, R0.w, c[14], R0.xyyz;
MOV R0, c[0];
MAD R0, R0, c[1].x, R1;
FRC R0, R0;
MAD R0, R0, c[15].x, -c[15].y;
MUL R1, R0, R0;
MUL R2, R1, R0;
MAD R0, R2, c[16].x, R0;
MUL R2, R2, R1;
MUL R1, R2, R1;
MAD R0, R2, c[15].w, R0;
MAD R0, R1, c[15].z, R0;
MUL R0, R0, R0;
MUL R0, R0, R0;
MUL R0, R0, vertex.texcoord[1].y;
DP4 R1.x, R0, c[18];
DP4 R1.y, R0, c[17];
MAD R0.xz, -R1.xyyw, c[1].z, R3;
MOV R0.w, vertex.position;
MOV R0.y, R3;
DP4 R1.x, R0, c[7];
DP4 result.position.w, R0, c[12];
DP4 result.position.z, R0, c[11];
DP4 result.position.y, R0, c[10];
DP4 result.position.x, R0, c[9];
MOV result.texcoord[1].x, -R1;
MOV result.texcoord[0].xy, vertex.texcoord[0];
END
# 37 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "NO_INTEL_GMA_X3100_WORKAROUND" }
Bind "vertex", Vertex
Bind "texcoord", TexCoord0
Bind "texcoord1", TexCoord1
Local 8, [_WaveAndDistance]
Local 9, [_CameraPosition]
Local 10, [_CameraRight]
Local 11, [_CameraUp]
Matrix 0, [glstate_matrix_modelview0]
Matrix 4, [glstate_matrix_mvp]
"vs_1_1
; 46 ALU
def c12, 0.00000000, 1.00000000, -0.50000000, -0.16161616
def c13, 0.00600000, 0.02000000, 0.05000000, 0.00833330
def c14, 0.01200000, 0.02000000, 0.06000000, 0.02400000
def c15, 1.20000005, 2.00000000, 1.60000002, 4.80000019
def c16, 6.40884876, -3.14159274, -0.00019841, 0
def c17, 0.00600000, 0.02000000, -0.02000000, 0.10000000
def c18, 0.02400000, 0.04000000, -0.12000000, 0.09600000
dcl_position v0
dcl_texcoord0 v1
dcl_texcoord1 v2
add r0.xyz, v0, -c9
dp3 r0.x, r0, r0
slt r0.x, c8.w, r0
max r0.x, -r0, r0
slt r0.x, c12, r0
add r0.x, -r0, c12.y
mul r0.xy, r0.x, v2
add r0.x, r0, c12.z
mad r1.xyz, r0.x, c10, v0
mad r3.xyz, r0.y, c11, r1
mul r0.x, r3.z, c8.y
mov r1.x, c8
mul r0.xyz, r0.x, c13
mul r0.w, r3.x, c8.y
mad r0, r0.w, c14, r0.xyyz
mad r0, c15, r1.x, r0
frc r1.xy, r0.zwzw
mov r0.zw, r1.xyxy
frc r0.xy, r0
mad r0, r0, c16.x, c16.y
mul r1, r0, r0
mul r2, r1, r0
mad r0, r2, c12.w, r0
mul r2, r2, r1
mul r1, r2, r1
mad r0, r2, c13.w, r0
mad r0, r1, c16.z, r0
mul r0, r0, r0
mul r0, r0, r0
mul r0, r0, v2.y
dp4 r1.x, r0, c18
dp4 r1.y, r0, c17
mad r0.xz, -r1.xyyw, c8.z, r3
mov r0.w, v0
mov r0.y, r3
dp4 r1.x, r0, c2
dp4 oPos.w, r0, c7
dp4 oPos.z, r0, c6
dp4 oPos.y, r0, c5
dp4 oPos.x, r0, c4
mov oT1.x, -r1
mov oT0.xy, v1
"
}

SubProgram "opengl " {
Keywords { "INTEL_GMA_X3100_WORKAROUND" }
Bind "vertex", Vertex
Bind "texcoord", TexCoord0
Bind "texcoord1", TexCoord1
Local 1, [_WaveAndDistance]
Local 2, [_CameraPosition]
Local 3, [_CameraRight]
Local 4, [_CameraUp]
"!!ARBvp1.0
# 15 ALU
PARAM c[13] = { { 0.5 },
		program.local[1..4],
		state.matrix.modelview[0],
		state.matrix.mvp };
TEMP R0;
TEMP R1;
ADD R0.xyz, vertex.position, -c[2];
DP3 R0.x, R0, R0;
SLT R0.x, c[1].w, R0;
MAD R1.xy, -vertex.texcoord[1], R0.x, vertex.texcoord[1];
ADD R0.x, R1, -c[0];
MAD R0.xyz, R0.x, c[3], vertex.position;
MOV R0.w, vertex.position;
MAD R0.xyz, R1.y, c[4], R0;
DP4 R1.x, R0, c[7];
DP4 result.position.w, R0, c[12];
DP4 result.position.z, R0, c[11];
DP4 result.position.y, R0, c[10];
DP4 result.position.x, R0, c[9];
MOV result.texcoord[1].x, -R1;
MOV result.texcoord[0].xy, vertex.texcoord[0];
END
# 15 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "INTEL_GMA_X3100_WORKAROUND" }
Bind "vertex", Vertex
Bind "texcoord", TexCoord0
Bind "texcoord1", TexCoord1
Local 8, [_WaveAndDistance]
Local 9, [_CameraPosition]
Local 10, [_CameraRight]
Local 11, [_CameraUp]
Matrix 0, [glstate_matrix_modelview0]
Matrix 4, [glstate_matrix_mvp]
"vs_1_1
; 18 ALU
def c12, 0.00000000, 1.00000000, -0.50000000, 0
dcl_position v0
dcl_texcoord0 v1
dcl_texcoord1 v2
add r0.xyz, v0, -c9
dp3 r0.x, r0, r0
slt r0.x, c8.w, r0
max r0.x, -r0, r0
slt r0.x, c12, r0
add r0.x, -r0, c12.y
mul r1.xy, r0.x, v2
add r0.x, r1, c12.z
mad r0.xyz, r0.x, c10, v0
mov r0.w, v0
mad r0.xyz, r1.y, c11, r0
dp4 r1.x, r0, c2
dp4 oPos.w, r0, c7
dp4 oPos.z, r0, c6
dp4 oPos.y, r0, c5
dp4 oPos.x, r0, c4
mov oT1.x, -r1
mov oT0.xy, v1
"
}

SubProgram "opengl " {
Keywords { "NO_INTEL_GMA_X3100_WORKAROUND" }
Local 0, [_FocalParams]
Local 1, ([_Cutoff],0,0,0)
SetTexture [_MainTex] {2D}
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
Keywords { "NO_INTEL_GMA_X3100_WORKAROUND" }
Local 0, [_FocalParams]
Local 1, ([_Cutoff],0,0,0)
SetTexture [_MainTex] {2D}
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

SubProgram "opengl " {
Keywords { "INTEL_GMA_X3100_WORKAROUND" }
Local 0, [_FocalParams]
Local 1, ([_Cutoff],0,0,0)
SetTexture [_MainTex] {2D}
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
Keywords { "INTEL_GMA_X3100_WORKAROUND" }
Local 0, [_FocalParams]
Local 1, ([_Cutoff],0,0,0)
SetTexture [_MainTex] {2D}
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
#LINE 193

		}
	}
	
	// terrain grass non-billboards
	SubShader {
		Tags { "RenderType"="Grass" }
		Pass {
			Cull Off
		
Program "" {
// Vertex combos: 2
//   opengl - ALU: 7 to 31
//   d3d9 - ALU: 7 to 36
// Fragment combos: 2
//   opengl - ALU: 8 to 8, TEX: 1 to 1
//   d3d9 - ALU: 10 to 10, TEX: 2 to 2
SubProgram "opengl " {
Keywords { "NO_INTEL_GMA_X3100_WORKAROUND" }
Bind "vertex", Vertex
Bind "color", Color
Bind "texcoord", TexCoord0
Local 1, [_WaveAndDistance]
"!!ARBvp1.0
# 31 ALU
PARAM c[15] = { { 1.2, 2, 1.6, 4.8000002 },
		program.local[1],
		state.matrix.modelview[0],
		state.matrix.mvp,
		{ 0.012, 0.02, 0.059999999, 0.024 },
		{ 0.0060000001, 0.02, 0.050000001, 6.4088488 },
		{ 3.1415927, -0.00019840999, 0.0083333002, -0.16161616 },
		{ 0.0060000001, 0.02, -0.02, 0.1 },
		{ 0.024, 0.039999999, -0.12, 0.096000001 } };
TEMP R0;
TEMP R1;
TEMP R2;
MUL R0.x, vertex.position.z, c[1].y;
MUL R1.xyz, R0.x, c[11];
MUL R0.x, vertex.position, c[1].y;
MAD R1, R0.x, c[10], R1.xyyz;
MOV R0, c[0];
MAD R0, R0, c[1].x, R1;
FRC R0, R0;
MUL R0, R0, c[11].w;
ADD R0, R0, -c[12].x;
MUL R1, R0, R0;
MUL R2, R1, R0;
MAD R0, R2, c[12].w, R0;
MUL R2, R2, R1;
MUL R1, R2, R1;
MAD R0, R2, c[12].z, R0;
MAD R0, R1, c[12].y, R0;
MUL R0, R0, R0;
MUL R1.x, vertex.color.w, c[1].z;
MUL R0, R0, R0;
MUL R0, R0, R1.x;
DP4 R1.x, R0, c[14];
DP4 R1.y, R0, c[13];
MAD R0.xz, -R1.xyyw, c[1].z, vertex.position;
MOV R0.yw, vertex.position;
DP4 R1.x, R0, c[4];
DP4 result.position.w, R0, c[9];
DP4 result.position.z, R0, c[8];
DP4 result.position.y, R0, c[7];
DP4 result.position.x, R0, c[6];
MOV result.texcoord[1].x, -R1;
MOV result.texcoord[0].xy, vertex.texcoord[0];
END
# 31 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "NO_INTEL_GMA_X3100_WORKAROUND" }
Bind "vertex", Vertex
Bind "color", Color
Bind "texcoord", TexCoord0
Local 8, [_WaveAndDistance]
Matrix 0, [glstate_matrix_modelview0]
Matrix 4, [glstate_matrix_mvp]
"vs_1_1
; 36 ALU
def c9, 0.00600000, 0.02000000, 0.05000000, -0.16161616
def c10, 0.01200000, 0.02000000, 0.06000000, 0.02400000
def c11, 1.20000005, 2.00000000, 1.60000002, 4.80000019
def c12, 6.40884876, -3.14159274, 0.00833330, -0.00019841
def c13, 0.00600000, 0.02000000, -0.02000000, 0.10000000
def c14, 0.02400000, 0.04000000, -0.12000000, 0.09600000
dcl_position v0
dcl_color v1
dcl_texcoord0 v2
mul r0.x, v0.z, c8.y
mul r1.xyz, r0.x, c9
mul r0.x, v0, c8.y
mad r1, r0.x, c10, r1.xyyz
mov r0.x, c8
mad r0, c11, r0.x, r1
frc r1.xy, r0.zwzw
mov r0.zw, r1.xyxy
frc r0.xy, r0
mad r0, r0, c12.x, c12.y
mul r1, r0, r0
mul r2, r1, r0
mad r0, r2, c9.w, r0
mul r2, r2, r1
mul r1, r2, r1
mad r0, r2, c12.z, r0
mad r0, r1, c12.w, r0
mul r0, r0, r0
mul r1.x, v1.w, c8.z
mul r0, r0, r0
mul r0, r0, r1.x
dp4 r1.x, r0, c14
dp4 r1.y, r0, c13
mad r0.xz, -r1.xyyw, c8.z, v0
mov r0.yw, v0
dp4 r1.x, r0, c2
dp4 oPos.w, r0, c7
dp4 oPos.z, r0, c6
dp4 oPos.y, r0, c5
dp4 oPos.x, r0, c4
mov oT1.x, -r1
mov oT0.xy, v2
"
}

SubProgram "opengl " {
Keywords { "INTEL_GMA_X3100_WORKAROUND" }
Bind "vertex", Vertex
Bind "texcoord", TexCoord0
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
Keywords { "INTEL_GMA_X3100_WORKAROUND" }
Bind "vertex", Vertex
Bind "texcoord", TexCoord0
Matrix 0, [glstate_matrix_modelview0]
Matrix 4, [glstate_matrix_mvp]
"vs_1_1
; 7 ALU
dcl_position v0
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

SubProgram "opengl " {
Keywords { "NO_INTEL_GMA_X3100_WORKAROUND" }
Local 0, [_FocalParams]
Local 1, ([_Cutoff],0,0,0)
SetTexture [_MainTex] {2D}
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
Keywords { "NO_INTEL_GMA_X3100_WORKAROUND" }
Local 0, [_FocalParams]
Local 1, ([_Cutoff],0,0,0)
SetTexture [_MainTex] {2D}
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

SubProgram "opengl " {
Keywords { "INTEL_GMA_X3100_WORKAROUND" }
Local 0, [_FocalParams]
Local 1, ([_Cutoff],0,0,0)
SetTexture [_MainTex] {2D}
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
Keywords { "INTEL_GMA_X3100_WORKAROUND" }
Local 0, [_FocalParams]
Local 1, ([_Cutoff],0,0,0)
SetTexture [_MainTex] {2D}
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
#LINE 220

		}
	}
	
}
}
