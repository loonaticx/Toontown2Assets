//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Reflective/BumpedSpecularSRC" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,0)
		_SpecColor ("Specular Color", Vector) = (0,0,0,0)
		_Shininess ("Shininess", Range (0.01, 1)) = 0.078125
		_ReflectColor ("Reflection Color", Color) = (1.0, 1.0, 1.0, 0)
		_MainTex ("Base (RGB) Gloss (A)", 2D) = "white"
		_BumpMap ("Bumpmap", 2D) = "bump" 
		_Cube ("cubemap", Cube) = "_Skybox"
	}
	Category {
		ZWrite Off
		Alphatest Greater 0
		Tags {Queue=Transparent}
		Fog { Color [_AddFog] }
		SubShader {
		UsePass "Alpha/Glossy/BASE"
		// ------------------------------------------------------
	 	// ARB_FP, Geforce3
	 	// ------------------------------------------------------
			UsePass "Reflective/Bumped Unlit/BASE" 
			Pass { 
				Name "BASE"
				Tags {"LightMode" = "Vertex"}
				Tags {"Queue" = "Transparent" }
				Blend SrcAlpha One
					Material {
						Diffuse [_Color]
						Ambient (1,1,1,1)
						Shininess 10
						Specular [_SpecColor]
					}
				Lighting On
				SeparateSpecular on
				SetTexture [_MainTex] { 
					constantColor [_Color] Combine texture * primary DOUBLE, constant
				}
			}
			UsePass "Alpha/BumpedSpecular/PPL"
		}
	}
	FallBack "Alpha/BumpedSpecular", 1
}