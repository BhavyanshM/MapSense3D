Shader "Custom/Tessellator"
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

   			#pragma require geometry
   			#pragma require tessellation tessHW

            #pragma vertex vert
            #pragma hull hull
            #pragma domain dom
            #pragma geometry geom
            #pragma fragment frag


            sampler2D _MainTex;
            float4 _MainTex_ST;


            struct VertexData { 
            	float4 vertex 		: POSITION;
            	float3 normal 		: NORMAL;
            	float4 tangent 		: TANGENT;
            	float2 uv			: TEXCOORD0;
            	float2 uv1 			: TEXCOORD1;
            	float2 uv2 			: TEXCOORD2;
            };

            struct g2f {
            	float4 position		: SV_POSITION;
            	float3 normal 		: NORMAL;
            	float2 uv			: TEXCOORD0;
            };

            struct TessellationFactors {
            	float edge[3] : SV_TessFactor;
            	float inside : SV_InsideTessFactor;
            };


            struct TessControlPoint {
            	float4 vertex : INTERNALTESSPOS;
            	float3 normal : NORMAL;
            	float4 tangent : TANGENT;
            	float2 uv : TEXCOORD0;
            	float2 uv1 : TEXCOORD1;
            	float2 uv2 : TEXCOORD2;
            };

            TessellationFactors pcfunc(InputPatch<TessControlPoint, 3> patch){
            	TessellationFactors f;
            	f.edge[0] = 1;
            	f.edge[1] = 1;
            	f.edge[2] = 1;
            	f.inside = 1;
            	return f;
            }

            TessControlPoint tessVert(VertexData v){
            	TessControlPoint p;
            	p.vertex = v.vertex;
            	p.normal = v.normal;
            	p.tangent = v.tangent;
            	p.uv = v.uv;
            	p.uv1 = v.uv1;
            	p.uv2 = v.uv2;
            	return p;
            }

            VertexData vert (appdata_full v)
            {
                VertexData o;
                o.vertex = v.vertex;
                o.normal = v.normal;
                o.uv = v.texcoord ;
                return o;
            }

            [domain("tri")]
            [outputcontrolpoints(3)]
            [outputtopology("triangle_cw")]
            [partitioning("integer")]
            [patchconstantfunc("pcfunc")]
            TessControlPoint hull(InputPatch<TessControlPoint, 3> patch, uint id : SV_OutputControlPointID){
            	return patch[id];
            }



            [domain("tri")]
            void dom(TessellationFactors factors, OutputPatch<VertexData, 3> patch, float3 barycentricCoordinates : SV_DomainLocation){
            	VertexData data;
	            #define DOMAIN_INTERP(fieldName) data.fieldName = \
	            					patch[0].fieldName * barycentricCoordinates.x + \
	            					patch[1].fieldName * barycentricCoordinates.y + \
	            					patch[2].fieldName * barycentricCoordinates.z; 
            	DOMAIN_INTERP(vertex)
            	DOMAIN_INTERP(normal)
            	DOMAIN_INTERP(tangent)
            	DOMAIN_INTERP(uv)
            	DOMAIN_INTERP(uv1)
            	DOMAIN_INTERP(uv2)

            }

            [maxvertexcount(3)]
            void geom(triangle VertexData IN[3], inout TriangleStream<VertexData> triStream){
            	float4 normal = UnityObjectToClipPos(
            						normalize(
            								cross(
            								IN[2].vertex-IN[1].vertex,
            								IN[0].vertex-IN[1].vertex)));

            	VertexData OUT[3];
            	OUT = IN;

            	float shift = 0.2;

            	OUT[0].normal = IN[0].normal;
            	OUT[0].vertex = UnityObjectToClipPos(IN[0].vertex) + normal*shift;
            	OUT[0].uv = IN[0].uv;

            	OUT[1].normal = IN[1].normal;
            	OUT[1].vertex = UnityObjectToClipPos(IN[1].vertex) + normal*shift;
            	OUT[1].uv = IN[1].uv;
            	
            	OUT[2].normal = IN[2].normal;
            	OUT[2].vertex = UnityObjectToClipPos(IN[2].vertex) + normal*shift;
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
