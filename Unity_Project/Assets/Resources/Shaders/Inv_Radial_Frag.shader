Shader "Custom/Inv_Radial_Frag"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _C1 ("C1 value", Float) = 0
        _C2 ("C2 value", Float) = 0
    }
    SubShader
    {
        Cull Off ZWrite On ZTest Always
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            uniform sampler2D _MainTex;
            uniform float _C1;
            uniform float _C2;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }
            
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

            fixed4 frag (v2f i) : SV_Target
            {
                /*LaValle states that the forward radial transform f is used to approximate the effects of lens distortion. Pixel based methods calculate the radius r_1 of a given pixel p_1 and then sample pixel p_2
                from elsewhere in the image at radius r_2, effectively moving p_2 to the location of p_1. Therefore, for pre-correction using the inverse transform r_1 = f^-1 (r2). To get r_2 from r_1 is then given by r_2 = f(r_1).
                */
                float2 pos = (2.0 * i.uv) - 1.0;

                float r_c = length(pos);
                float r_d = pow(pos.x, 2) + pow(pos.y, 2);
                float theta = atan2(pos.y, pos.x);

                float r_corr = distortion(r_c);
                float2 corr = float2(r_corr * cos(theta), r_corr * sin(theta));

                float4 tex = tex2D(_MainTex, 0.5 * (corr + 1.0)); 
                return tex;
            }
            ENDCG
        }
    }
}