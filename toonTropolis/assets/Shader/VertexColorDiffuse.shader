//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Diffuse VertexColor" {

Properties {
    _Color ("Main Color", Color) = (1,1,1,1)
    _SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
    _Shininess ("Shininess", Range (0.01, 1)) = 0.078125
    _MainTex ("Base (RGB)", 2D) = "white" {}
    _BumpMap ("Bump (RGB)", 2D) = "bump" {}
}
 
SubShader {
    // Use standard pixel-lighting blending: first pass is opaque, further passes additive
    Blend AppSrcAdd AppDstAdd
  
   
   
   
   
    // This pass is always drawn.
    // It draws base texture multipled by per-vertex colors, multiplied by material's color
    Pass {
        Tags {"LightMode" = "Always"} // always draw this pass
        Lighting Off
	
        BindChannels {
            Bind "Vertex", vertex
            Bind "TexCoord", texcoord
            Bind "Color", color
        }
        SetTexture [_MainTex] {
            Combine primary * texture // multiply vertex color by texture
        }
        SetTexture [_MainTex] {
            constantColor [_Color]
            Combine previous * constant // ...and multiply by material's color
        }
    }
	
	
	Pass {
		Tags {"LightMode" = "Always"} 
		Lighting On
		 //Material {
		 //Ambient [_Color]
		// }
		ColorMaterial AmbientAndDiffuse
		 SetTexture [_MainTex]
		 {
			Combine texture * primary DOUBLE
		 }
	}

    //This pass is drawn when there are vertex-lit lights. This is just standard
    //lighting*texture*2 pass, that adds onto baked lighting pass
    Pass {
         Tags {"LightMode" = "Vertex"} // draw this pass when there are vertex-lit lights
        // setup vertex lighting
        Material {
            //AmbientAndDiffuse [_Color]
			//Ambient [_Color]
			//Emission [_PPLAmbient]
			Diffuse [_Color]
            Shininess [_Shininess]
            Specular [_SpecColor]
        }
		//ColorMaterial AmbientAndDiffuse
	Lighting On
       SeperateSpecular On
       ColorMask RGB
		
       SetTexture [_MainTex] { combine texture * primary DOUBLE }
	   //SetTexture [_MainTex] {constantColor [_Color]  Combine texture * primary, texture * constant}
		//SetTexture [_MainTex] {constantColor [_Color] Combine previous * constant DOUBLE, previous}
    }
	
	
	
	
	UsePass "Bumped Specular/PPL"

    
	
	
}

Fallback "VertexLit"
}