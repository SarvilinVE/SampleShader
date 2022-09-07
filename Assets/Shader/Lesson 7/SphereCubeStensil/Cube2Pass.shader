Shader "Custom/Cube2Pass"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _RingTex("Texture Ring", 2D) = "white" {}
        _Height("Height", Range(0,20)) = 0.5
        _Radius("Radius", Range(0,20)) = 0.5
        _Opacity("Opacity", Range(0,1)) = 0.5
        _Color("Color", Color) = (1,1,1,1)
    }
        SubShader
        {
            Tags { "RenderType" = "Opaque" }
            LOD 100

            Cull off
            Blend SrcAlpha OneMinusSrcAlpha

            Pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag

                #include "UnityCG.cginc"



                struct v2f
                {
                    float2 uv : TEXCOORD0;
                    float4 vertex : SV_POSITION;
                };

                sampler2D _MainTex;
                float4 _MainTex_ST;
                float _Height;
                half _Opacity;
                v2f vert(appdata_full v)
                {
                    v2f o;

                    o.vertex = UnityObjectToClipPos(v.vertex);
                    o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                    return o;
                }

                fixed4 frag(v2f i) : SV_Target
                {
                    // sample the texture
                    fixed4 col = tex2D(_MainTex, i.uv);
                col.a = _Opacity;
                    return col;
                }
            ENDCG
            }

            Pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag

                #include "UnityCG.cginc"



                struct v2f
                {
                    float2 uv : TEXCOORD0;
                    float4 vertex : SV_POSITION;
                    //float3 color : COLOR0;
                };

                sampler2D _RingTex;
                float4 _RingTex_ST;
                float _Height;
                float _Radius;
                half _Opacity;
                fixed4 _Color;

                v2f vert(appdata_full v)
                {
                    v2f o;
                    v.vertex.y = 0.0;

                    v.vertex.xz += v.normal * (_Height);
                    
                    //v.vertex.z += v.vertex.x;
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    o.uv = TRANSFORM_TEX(v.texcoord, _RingTex);
                    return o;
                }

                fixed4 frag(v2f i) : COLOR
                {
                    fixed4 result = tex2D(_RingTex, i.uv) * _Color;
                if (result.r < 0.1)
                {
                    result.a = _Opacity;
                }
                    return result;
                }
            ENDCG
            }
        }
}