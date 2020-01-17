Shader "Custom/CurveShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Geometry"}
        LOD 100

        Pass
        {
        	Cull Off

            CGPROGRAM
            #include "UnityCG.cginc"

   
            #pragma vertex vert
            #pragma geometry geom
            #pragma fragment frag


            sampler2D _MainTex;
            float4 _MainTex_ST;


            struct v2g { 
            	float4 position 	: SV_POSITION;
            	float3 normal 		: NORMAL;
            	float2 uv			: TEXCOORD0;
            };

            struct g2f {
            	float4 position		: SV_POSITION;
            	float3 normal 		: NORMAL;
            	float2 uv			: TEXCOORD0;
            };

            v2g vert (appdata_full v)
            {
                v2g o;
                o.position = v.vertex;
                o.normal = v.normal;
                o.uv = v.texcoord ;
                return o;
            }

            [maxvertexcount(3)]
            void geom(triangle v2g IN[3], inout TriangleStream<g2f> triStream){
            	float4 normal = UnityObjectToClipPos(
            						normalize(
            								cross(
            								IN[2].position-IN[1].position,
            								IN[0].position-IN[1].position)));

            	g2f OUT[3];

            	float shift = 0.2;

            	OUT[0].normal = IN[0].normal;
            	OUT[0].position = UnityObjectToClipPos(IN[0].position) + normal*shift;
            	OUT[0].uv = IN[0].uv;

            	OUT[1].normal = IN[1].normal;
            	OUT[1].position = UnityObjectToClipPos(IN[1].position) + normal*shift;
            	OUT[1].uv = IN[1].uv;
            	
            	OUT[2].normal = IN[2].normal;
            	OUT[2].position = UnityObjectToClipPos(IN[2].position) + normal*shift;
            	OUT[2].uv = IN[2].uv;

            	triStream.Append(OUT[0]);
            	triStream.Append(OUT[1]);
            	triStream.Append(OUT[2]);

            }

            fixed4 frag (g2f v) : SV_Target
            {

                float4 col = tex2D(_MainTex, v.uv);
                
                return col;
            }
            ENDCG
        }
    }
}
