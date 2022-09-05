Shader "Custom/Chromatic_Aberration"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _C1 ("C1 value", Float) = 0
        _C2 ("C2 value", Float) = 0
        _Red_Degree("Degree of red shift", Float) = 0
        _Green_Degree("Degree of green shift", Float) = 0
        _Blue_Degree("Degree of blue shift", Float) = 0
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

            uniform sampler2D _MainTex;
            uniform float _C1;
            uniform float _C2;
            uniform float _Red_Degree;
            uniform float _Blue_Degree;
            uniform float _Green_Degree;


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
            
            float2 distortion(float r_c, float theta, float degree)
            {
                float coif_1 = _C1 * degree;
                float coif_2 = _C2 * degree;
                float r_d = r_c + (coif_1 * pow(r_c, 3)) + (coif_2 * pow(r_c, 5));
                float2 dist = float2(r_d * cos(theta), r_d * sin(theta));
                return 0.5 * (dist + 1.0);
            }

            float2 inv_distortion(float r_d, float theta, float degree)
            {
                float coif_1 = _C1 * degree;
                float coif_2 = _C2 * degree;
                float r_corr_n = (coif_1 * pow(r_d, 2)) + (coif_2 * pow(r_d, 4)) + (pow(coif_1, 2) * pow(r_d, 4)) + (pow(coif_2, 2) * pow(r_d, 8)) + (2 * coif_1 * coif_2 * pow(r_d, 6));
                float r_corr_d = 1 + (4 * coif_1 * pow(r_d, 2)) + (6 * coif_2 * pow(r_d, 4));
                float r_corr = r_corr_n / r_corr_d;
                float2 corr = float2(r_corr * cos(theta), r_corr * sin(theta));
                return 0.5 * (corr + 1.0);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                /*LaValle states that the forward radial transform f is used to approximate the effects of lens distortion. Pixel based methods calculate the radius r_1 of a given pixel p_1 and then sample pixel p_2
                from elsewhere in the image at radius r_2, effectively moving p_2 to the location of p_1. Therefore, for pre-correction using the inverse transform r_1 = f^-1 (r2). To get r_2 from r_1 is then given by r_2 = f(r_1).
                */

                float2 pos = 2.0 * i.uv - 1.0;

                float r_c = length(pos);
                float theta = atan2(pos.y, pos.x);

                fixed4 corr;
                corr.r = tex2D(_MainTex, distortion(r_c, theta, _Red_Degree)).r;
                corr.g = tex2D(_MainTex, distortion(r_c, theta, _Green_Degree)).g;
                corr.b = tex2D(_MainTex, distortion(r_c, theta, _Blue_Degree)).b;
                corr.a = tex2D(_MainTex, i.uv).a;

                return corr; 
            }
            ENDCG
        }
    }
}