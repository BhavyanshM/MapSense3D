Shader "Custom/DepthShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
    	Tags {"RenderType" = "Opaque"}

        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _CameraDepthTexture;

            fixed4 frag (v2f i) : SV_Target
            {
                float depth01 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2D(_CameraDepthTexture, i.uv))) / 10;
             
                //depth = Linear01Depth(depth);
            	//float scale = 0.08;
                
                //depth = depth * _ProjectionParams.z;
                //depth = depth * scale;
                //return depth;

				float lowBits = floor(depth01 * 256) / 256;
				float medBits = 256 * (depth01 - lowBits);
				medBits = floor(256 * medBits) / 256;
				//float highBits = 256 * 256 * (depth01 - lowBits - medBits / 256);
			  	//highBits = floor(256 * highBits) / 256;

				return fixed4(lowBits, medBits, 0.0, 0.0);

            }


            ENDCG
        }
    }
}
