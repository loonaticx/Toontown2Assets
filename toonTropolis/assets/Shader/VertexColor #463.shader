//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader  " Vertex Colored" {

Properties {
    _Color ("Main Color", Color) = (1,1,1,1)
    _SpecColor ("Spec Color", Color) = (1,1,1,1)
    _Emission ("Emmisive Color", Color) = (0,0,0,0)
    _Shininess ("Shininess", Range (0.01, 1)) = 0.7
    _MainTex ("Base (RGB)", 2D) = "white" {}
	//_BumpMap ("Bump (RGB)", 2D) = "bump" {}
}

SubShader {

	//Blend AppSrcAdd AppDstAdd
    Pass {
        Material {
            Shininess [_Shininess]
            Specular [_SpecColor]
            Emission [_Emission]   
        }
        ColorMaterial AmbientAndDiffuse
        Lighting On
        SeperateSpecular On
        SetTexture [_MainTex] {
            Combine texture * primary, texture * primary
        }
        SetTexture [_MainTex] {
            constantColor [_Color]
            Combine previous * constant DOUBLE, previous * constant
        }
    }
	
	
	//UsePass "Bumped Specular/PPL"
	
}

Fallback " VertexLit", 1
}