Shader "Custom/Radial_Vert"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _C1 ("C1 value", Float) = 0
        _C2 ("C2 value", Float) = 0
    }

    SubShader
    {
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            fixed4 _MainTex_ST;
            uniform float _C1;
            uniform float _C2;

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

            float distortion(float r_c)
            {
                float r_d = r_c + (_C1 * pow(r_c, 3)) + (_C2 * pow(r_c, 5));
                return r_d;
            }

            float inv_distortion(float r_d)
            {
                float r_corr_n = (_C1 * pow(r_d, 2)) + (_C2 * pow(r_d, 4)) + (pow(_C1, 2) * pow(r_d, 4)) + (pow(_C2, 2) * pow(r_d, 8)) + (2 * _C1 * _C2 * pow(r_d, 6));
                float r_corr_d = 1 + (4 * _C1 * pow(r_d, 2)) + (6 * _C2 * pow(r_d, 4));
                float r_corr = r_corr_n / r_corr_d;

                return r_corr;
            }

            v2f vert (appdata v)
            {
                float4 world_cord = UnityObjectToClipPos(v.vertex);
                float2 pos = world_cord.xy / world_cord.w;

                float r_c = length(pos);
                float theta = atan2(pos.y, pos.x);

                float r_corr = distortion(r_c);
                float2 corr = float2(r_corr * cos(theta), r_corr * sin(theta));
                if (pos.x == 0 && pos.y == 0)
                {
                    corr = pos;
                }

                world_cord.xy = corr * world_cord.w;

                v2f o;
                o.vertex = world_cord;
                
                o.uv = v.uv;
                return o;
            }
            
            sampler2D _MainTex;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}