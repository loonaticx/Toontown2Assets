//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Diffuse VertexColor" {
Properties {
 _Color ("Main Color", Color) = (1,1,1,1)
 _SpecColor ("Specular Color", Color) = (0.5,0.5,0.5,1)
 _Shininess ("Shininess", Range(0.01,1)) = 0.078125
 _MainTex ("Base (RGB)", 2D) = "white" {}
 _BumpMap ("Bump (RGB)", 2D) = "bump" {}
}
SubShader { 
 Pass {
  Tags { "LIGHTMODE"="Always" }
  BindChannels {
   Bind "vertex", Vertex
   Bind "color", Color
   Bind "texcoord", TexCoord
  }
  SetTexture [_MainTex] { combine primary * texture }
  SetTexture [_MainTex] { ConstantColor [_Color] combine previous * constant }
 }
 Pass {
  Tags { "LIGHTMODE"="Always" }
  Lighting On
  ColorMaterial AmbientAndDiffuse
  SetTexture [_MainTex] { combine texture * primary double }
 }
 Pass {
  Tags { "LIGHTMODE"="Vertex" }
  Lighting On
  SeparateSpecular On
  Material {
   Diffuse [_Color]
   Specular [_SpecColor]
   Shininess [_Shininess]
  }
  ColorMask RGB
  SetTexture [_MainTex] { combine texture * primary double }
 }
 UsePass "Bumped Specular/PPL"
}
Fallback "VertexLit"
}