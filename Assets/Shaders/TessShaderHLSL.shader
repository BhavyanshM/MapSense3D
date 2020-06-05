//Enable option "Keep quads" in model import settings.
//source: https://forum.unity3d.com/threads/my-own-terrane-shader-is-not-working.283406/
Shader "Custom/QuadTessellationHLSL" 
{
	SubShader 
	{
		Pass 
		{ 
			Cull Off
			CGPROGRAM
			half Params[504];
			#pragma vertex TessellationVertexProgram
			#pragma hull HullProgram
			#pragma domain DomainProgram
			#pragma fragment FragmentProgram
			#pragma target 4.6
 
// ---------------------------------------------------------------- 

			struct appdata {
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};
			struct ControlPoint
			{
				float4 vertex : INTERNALTESSPOS;
				float2 uv : TEXCOORD0;
			};
			struct hsConstOut
			{
				float Edges[4] : SV_TessFactor;
				float Inside[2] : SV_InsideTessFactor;
			}; 
			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			}; 

// ---------------------------------------------------------------


			v2f VertexProgram(appdata v) // Not the primary vertex program.
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			ControlPoint TessellationVertexProgram(appdata v){
				ControlPoint p;
				p.vertex = v.vertex;
				p.uv = v.uv;
				return p;			
			};
			
 
			hsConstOut hull_constant_function(InputPatch<ControlPoint, 4> patch)
			{
				hsConstOut output;
				output.Edges[0] = output.Edges[1] = output.Edges[2] = output.Edges[3] = output.Inside[0] = output.Inside[1] = 16;  
				return output;
			}
 
				[domain("quad")]
				[partitioning("integer")]
				[outputtopology("triangle_cw")]
				[outputcontrolpoints(4)]
				[patchconstantfunc("hull_constant_function")]			
			ControlPoint HullProgram(InputPatch<ControlPoint, 4>patch, uint id: SV_OutputControlPointID)
			{
				return patch[id];
			}
 
				[domain("quad")]
			v2f DomainProgram(hsConstOut factors, 
								const OutputPatch<ControlPoint, 4>patch,
								float2 UV:SV_DomainLocation)
			{
				float4 a = patch[0].vertex;
				float4 b = patch[1].vertex;
				float4 c = patch[2].vertex;
				float4 d = patch[3].vertex;

				float4 v0 = lerp(a,b,UV.x);
				float4 v1 = lerp(d,c,UV.x);
				float4 vFinal = lerp(v0,v1,UV.y);

				float2 uv0 = lerp(a,b,UV.x);
				float2 uv1 = lerp(d,c,UV.x);
				float2 uvFinal = lerp(uv0,uv1,UV.y);

				float3 n0 = cross(a.xyz-b.xyz,a.xyz-d.xyz);
				float4 normal = float4(normalize(n0),1);

				float scale = 0.000001;

				float x = UV.x*10 - 5;
				float y = UV.y*10 - 5;

				//float height = scale * (pow(x,3) + pow(y,3));

				int i = int(a.x);
				int j = int(a.y);


				float height = (Params[0]*pow(x,3)
							+	Params[1]*pow(x,2)
							+	Params[2]*x
							+	Params[3]*pow(y,3)
							+	Params[4]*pow(y,2)
							+	Params[5]*y	
							+	Params[6]*1
														)*scale;


				//float height = Params[0]*scale;

				appdata data; 
			   	data.vertex = vFinal + height * normal;
			   	data.uv = uvFinal;

				return VertexProgram(data);
			}


			fixed4 FragmentProgram(v2f i) : SV_TARGET
			{  
				//float4 col = tex2D(_MainTex, i.uv);
				fixed4 col = fixed4(0.5,0.8,0.4,1.0);
				return col;
			}
 
			ENDCG
		}
	}
}