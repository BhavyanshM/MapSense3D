Shader "Custom/CurveShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _InternalTellellation("Internal Tessellation", Float) = 5
        _EdgeTessellation("Edge Tessellatoin", Float) = 5
        [Toggle]_HideWireframe("Hide Wireframe", Float) = 0
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
            #include "./UCLA GameLab Wireframe Functions.cginc"
            #include "./Bezier Curve Functions.cginc"

            #pragma require geometry
            #pragma require tessellation tessHW
            
            #pragma hull hull
            #pragma domain dom
            #pragma vertex vert
            #pragma geometry geom
            #pragma fragment frag

            // Quad
            #define MAX_POINTS 4

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _InternalTessellation;
            float _EdgeTessellation;
            float _HideWireframe;
            uniform StructuredBuffer<float3> _controlPoints;


            struct v2h { // VS_OUTPUT
            	float4 position 	: POSITION;
            	float2 uv			: TEXCOORD0;
            };

            struct h2d { // HS_OUTPUT
            	float3 position 	: BEZIERPOS;
            	float2 uv 			: TEXCOORD0;
            };

            struct hc2d { // HS_CONSTANT_OUTPUT
            	float Edges[4]		: SV_TessFactor;
            	float Inside[2]		: SV_InsideTessFactor;
            };

            struct d2g { // DS_OUTPUT
            	float4 position 	: POSITION;
            	float4 col 			: COLOR;
            	float2 uv 			: TEXCOORD0;
            };

            struct g2f { // GS_OUTPUT
            	float4 position 	: POSITION;
            	float4 col 			: COLOR;
            	float2 uv 			: TEXCOORD0;
            	float3 normal 		: NORMAL;
            	float3 dist 		: TEXCOORD1;
            };

            v2h vert (appdata_base v)
            {
                v2h o;
                o.position = v.vertex;
                o.uv = v.texcoord.xy;
                return o;
            }

            hc2d hsConstant (InputPatch<v2h, MAX_POINTS> ip, uint PatchID : SV_PrimitiveID ){
            	hc2d o;

            	float edge = _EdgeTessellation;
            	float inside = _InternalTessellation;

            	o.Edges[0] = edge;
            	o.Edges[1] = edge;
            	o.Edges[2] = edge;
            	o.Edges[3] = edge;

            	o.Inside[0] = inside;
            	o.Inside[1] = inside;

            	return o; 
            }

            [domain("quad")]
            [partitioning("fractional_even")]
            [outputtopology("triangle_cw")]
            [outputcontrolpoints(MAX_POINTS)]
            [patchconstantfunc("hsConstant")]
            h2d hull(InputPatch<v2h, MAX_POINTS> ip, uint i : SV_OutputControlPointID, uint PatchID : SV_PrimitiveID){
            	h2d o;
            	o.uv = ip[i].uv;
            	o.position = ip[i].position;
            	return o;
            }

            [domain("quad")]
            d2g dom(hc2d input, float2 UV : SV_DomainLocation, const OutputPatch<h2d, MAX_POINTS> patch){
            	d2g o;
            	float2 uv = UV;
            	uv*=0.9999998;
            	uv.x += 0.0000001;
            	uv.y += 0.0000001;

            	float4 pos = float4(SurfaceSolve(_controlPoints, uv),1);
            	o.position = pos;
            	o.uv = UV;
            	o.col = float4(1,1,1,1);
            	return o;
            }

            [maxvertexcount(6)]
            void geom(triangle d2g p[3], inout TriangleStream<g2f> triStream){
            	    float3 norm = cross(p[0].position - p[1].position, p[0].position - p[2].position);
                    norm = normalize(mul(unity_ObjectToWorld, float4(norm, 0))).xyz;

                    p[0].position = UnityObjectToClipPos(p[0].position);
                    p[1].position = UnityObjectToClipPos(p[1].position);
                    p[2].position = UnityObjectToClipPos(p[2].position);

                    float3 dist = UCLAGL_CalculateDistToCenter(p[0].position, p[1].position, p[2].position);

                    g2f i1, i2, i3;
                    
                    // Add the normal facing triangle
                    i1.position = p[0].position;
                    i1.col = p[0].col;
                    i1.uv = p[0].uv;
                    i1.normal = norm;
                    i1.dist = float3(dist.x, 0, 0);

                    i2.position = p[1].position;
                    i2.col = p[1].col;
                    i2.uv = p[1].uv;
                    i2.normal = norm;
                    i2.dist = float3(0, dist.y, 0);

                    i3.position = p[2].position;
                    i3.col = p[2].col;
                    i3.uv = p[2].uv;
                    i3.normal = norm;
                    i3.dist = float3(0, 0, dist.z);

                    triStream.Append(i1);
                    triStream.Append(i2);
                    triStream.Append(i3);
            }

            fixed4 frag (g2f input, fixed facing : VFACE) : COLOR
            {
                float alpha = UCLAGL_GetWireframeAlpha(input.dist, .25, 100, 1);
                clip(alpha - 0.9);
                
                float4 col = input.col;
                float2 uv = TRANSFORM_TEX (input.uv, _MainTex);
                col = tex2D(_MainTex, uv) * float4(input.normal * facing, 1);
                
                return col;
            }
            ENDCG
        }
    }
}
