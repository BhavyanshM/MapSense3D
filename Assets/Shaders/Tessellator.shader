Shader "Custom/Tessellation"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_factor("Tessellation scale",Range(1.0,64.0)) = 1.0
	}
	SubShader
	{
		Cull Off
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

				layout (vertices = 6) out;
				void main()
				{
					if (gl_InvocationID == 0)
					{
						gl_TessLevelInner[0] = _factor;   //Inside tessellation factor
						gl_TessLevelInner[1] = _factor;   //Inside tessellation factor

						gl_TessLevelOuter[0] = _factor;   //Edge tessellation factor
						gl_TessLevelOuter[1] = _factor;   //Edge tessellation factor
						gl_TessLevelOuter[2] = _factor;   //Edge tessellation factor
						gl_TessLevelOuter[3] = _factor;   //Edge tessellation factor
					} 
					gl_out[gl_InvocationID].gl_Position = gl_in[gl_InvocationID].gl_Position;
				}
			#endif

			#ifdef DOMAIN        //GLSL Tessellation Evaluation Shader
				layout (quads) in;
				void main()
				{ 	
					vec4 a = gl_in[0].gl_Position;
					vec4 b = gl_in[1].gl_Position;
					vec4 c = gl_in[2].gl_Position;
					vec4 d = gl_in[3].gl_Position;
					vec4 e = gl_in[4].gl_Position;
					vec4 f = gl_in[5].gl_Position;

					float u = gl_TessCoord.x;
					float v = gl_TessCoord.y;

					vec4 p1 = mix(c, e, u);
				    vec4 p2 = mix(b, f, u);

				    vec3 n0 = cross(a.xyz-b.xyz,b.xyz-c.xyz);
				    vec3 n1 = cross(a.xyz-b.xyz,b.xyz-e.xyz);
				    vec3 n2 = cross(a.xyz-e.xyz,e.xyz-f.xyz);

				    vec3 normal = normalize(n0);

				    vec4 pos = mix(p1, p2, v);

				    gl_Position = pos + (3*pow(u-0.5,3) - 10*pow(v-0.5,2))*vec4(normal*2.5,1);
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