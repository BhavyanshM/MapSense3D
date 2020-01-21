Shader "Custom/Tessellation"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_factor("Tessellation scale",Range(1.0,64.0)) = 4.0
	}
	SubShader
	{
		Pass
		{
			GLSLPROGRAM
			#version 460     
			uniform float _factor;
			
			#ifdef VERTEX
				in  vec4 in_POSITION0;
				void main()
				{
					gl_Position =  gl_ModelViewProjectionMatrix * in_POSITION0;
				}
			#endif

			#ifdef HULL          //GLSL Tessellation Control Shader
				layout (vertices = 3) out;
				void main()
				{
					if (gl_InvocationID == 0)
					{
						gl_TessLevelInner[0] = _factor;   //Inside tessellation factor
						gl_TessLevelOuter[0] = _factor;   //Edge tessellation factor
						gl_TessLevelOuter[1] = _factor;   //Edge tessellation factor
						gl_TessLevelOuter[2] = _factor;   //Edge tessellation factor
					} 
					gl_out[gl_InvocationID].gl_Position = gl_in[gl_InvocationID].gl_Position;
				}
			#endif

			#ifdef DOMAIN        //GLSL Tessellation Evaluation Shader
				layout (triangles, equal_spacing, cw) in;
				void main()
				{ 
					gl_Position=(gl_TessCoord.x*gl_in[0].gl_Position+gl_TessCoord.y*gl_in[1].gl_Position+gl_TessCoord.z*gl_in[2].gl_Position);
				}
			#endif

			#ifdef GEOMETRY      //geometry shader for rendering wireframe
				layout(triangles) in;
				layout(line_strip, max_vertices = 3) out;
				void main()
				{
					for(int i = 0; i < gl_in.length(); ++i)
					{
						gl_Position = gl_in[i].gl_Position;
						EmitVertex();
					}
					gl_Position = gl_in[0].gl_Position;
					EmitVertex();  
					EndPrimitive();
				}    
			#endif
                   
			#ifdef FRAGMENT
				out vec4 color;
				void main()
				{
					color = vec4(1,1,1,1);
				}
			#endif
           
			ENDGLSL
			}
	}
}