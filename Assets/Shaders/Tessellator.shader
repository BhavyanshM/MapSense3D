Shader "Custom/Tessellation"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_factor("Tessellation scale",Range(1.0,64.0)) = 1.0
	}
	SubShader
	{
		//Cull Off
		Pass
		{
			GLSLPROGRAM
			#version 460     
			uniform float _factor;
			uniform sampler2D _MainTex;
			
			#ifdef VERTEX
				in  vec4 in_POSITION0;
				void main()
				{
					gl_Position =  in_POSITION0;
				}
			#endif

			#ifdef HULL          //GLSL Tessellation Control Shader

				layout (vertices = 4) out;
				void main()
				{
					if (gl_InvocationID == 0)
					{
						float tessLevel = 16.0;
						gl_TessLevelInner[0] = tessLevel;   //Inside tessellation factor
						gl_TessLevelInner[1] = tessLevel;   //Inside tessellation factor

						gl_TessLevelOuter[0] = tessLevel;   //Edge tessellation factor
						gl_TessLevelOuter[1] = tessLevel;   //Edge tessellation factor
						gl_TessLevelOuter[2] = tessLevel;   //Edge tessellation factor
						gl_TessLevelOuter[3] = tessLevel;   //Edge tessellation factor
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


					// Quad
					//vec4 p1 = mix(c, e, u);
				    //vec4 p2 = mix(b, f, u);
				    //vec3 n0 = cross(c.xyz-e.xyz,e.xyz-d.xyz);
				    //vec3 n1 = cross(b.xyz-c.xyz,e.xyz-f.xyz);
				    //vec3 n2 = cross(c.xyz-d.xyz,f.xyz-a.xyz);

				    // QuadPlane
					vec4 p1 = mix(b, a, u);
				    vec4 p2 = mix(c, d, u);
				    vec3 n0 = cross(b.xyz-a.xyz,b.xyz-c.xyz);
				    vec3 n1 = cross(b.xyz-c.xyz,e.xyz-f.xyz);
				    vec3 n2 = cross(c.xyz-d.xyz,f.xyz-a.xyz);

				    // Plane
					//vec4 p1 = mix(a, c, u);
					//vec4 p2 = mix(a, b, u);		
					//vec3 n0 = cross(a.xyz-b.xyz,b.xyz-c.xyz);		    


				    vec4 normal = vec4(normalize(n0),1);

				    float scale = 0.001;

				    float x = u*10 - 5;
				    float y = v*10 - 5;

				    vec4 plow = texture(_MainTex, vec2(a.x, a.y));
				    vec4 phigh= texture(_MainTex, vec2(48+a.x, a.y));

				    float height = scale * (
				    	plow.x*pow(x,3)  +
				    	plow.y*pow(x,2)  +
				    	plow.z*pow(x,1)  + 
				    	plow.w*pow(y,3)  + 
				    	phigh.x*pow(y,2) +
				    	phigh.y*pow(y,1) +
				    	phigh.z
				    );

				    vec4 pos = mix(p1, p2, v) + normal*height;

				    gl_Position = gl_ModelViewProjectionMatrix * pos;
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