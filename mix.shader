Shader "Unlit/mix"
{
    Properties
    {
        _MainTex ("MainTexture", 2D) = "white" {}
        _SubTex("SubTExture", 2D) = "white" {}
        _Mix ("Mix", Range(0.0, 1.0)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

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

            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _SubTex;
            float4 _SubTex_ST;
            float _Mix;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 mask = step(_Mix, i.uv.x);

                fixed4 col1 = tex2D(_MainTex, i.uv) *(1.0 - mask) ;
                fixed4 col2 = tex2D(_SubTex, i.uv) * mask;

                fixed4 colMix = fixed4(0.0, 0.0, 0.0, 0.0);

                colMix = col1 + col2;
                return colMix;
            }
            ENDCG
        }
    }
}
