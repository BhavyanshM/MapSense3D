//Enable option "Keep quads" in model import settings.
//source: https://forum.unity3d.com/threads/my-own-terrane-shader-is-not-working.283406/
Shader "Custom/QuadTessellationHLSL" 
{
    Properties{
        _MainTex ("Texture", 2D) = "white" {}
    }
	SubShader 
	{
		Pass 
		{ 
			Cull Off
			CGPROGRAM
			
			//float Params0[20];
			
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

            // This is the Entry Point
			ControlPoint TessellationVertexProgram(appdata v){
				ControlPoint p;
				p.vertex = v.vertex;
				p.uv = v.uv;
				return p;			
			};
			
 
			hsConstOut hull_constant_function(InputPatch<ControlPoint, 4> patch, uint PatchID : SV_PrimitiveID)
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
			ControlPoint HullProgram(InputPatch<ControlPoint, 4> patch, uint id: SV_OutputControlPointID)
			{
				return patch[id];
			}
 
 
                sampler2D_float _MainTex;
				[domain("quad")]
			v2f DomainProgram(hsConstOut factors, 
								const OutputPatch<ControlPoint, 4> patch,
								float2 UV:SV_DomainLocation,
								uint id: SV_PrimitiveID)
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

				float scale = 0.0001;

				float x = UV.x*10 - 5;
				float y = UV.y*10 - 5;

				//float height = scale * (pow(x,3) + pow(y,3));
				float4 h = tex2Dlod (_MainTex, float4(patch[0].uv,0,0));

				int i = int(a.x*800 + 7); // 800
				int j = int(a.y*800 + 6);


				//float height0 = Params1[i*12+j]*pow(x,3);
				
                float height = (pow(x,2) + pow(y,2))*scale*h.r;

				//float height = Params5[i*12 + j]*pow(x,2)*scale;

                //float height = (    (pow(x,2) + pow(y,2))*2       +    (pow(i-8,2) + pow(j-6,2))*10    )*scale*0.1;

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