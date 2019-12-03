//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////



Shader "Vertex Colors" {
   SubShader {
   	//Fog {Mode off}
    //Fog {Mode Linear}
   	//Fog {Range 40, 200}
   	
      BindChannels {
         Bind "Color", color
         Bind "Vertex", vertex
         Bind "TexCoord", texcoord
         
         
      }
      Pass {
      }
   }
}






