Shader "Custom/Cube2Pass"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Height("Height", Range(0,20)) = 0.5
        _Radius("Radius", Range(0,20)) = 0.5
        _Opacity("Opacity", Range(0,1)) = 0.5
    }
        SubShader
        {
            Tags { "RenderType" = "Opaque" }
            LOD 100

            Blend SrcAlpha OneMinusSrcAlpha

                     Pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                // make fog work
                #pragma multi_compile_fog

                #include "UnityCG.cginc"



                struct v2f
                {
                    float2 uv : TEXCOORD0;
                    UNITY_FOG_COORDS(1)
                    float4 vertex : SV_POSITION;
                };

                sampler2D _MainTex;
                float4 _MainTex_ST;
                float _Height;
                v2f vert(appdata_full v)
                {
                    v2f o;

                    o.vertex = UnityObjectToClipPos(v.vertex);
                    o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                    UNITY_TRANSFER_FOG(o,o.vertex);
                    return o;
                }

                fixed4 frag(v2f i) : SV_Target
                {
                    // sample the texture
                    fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }

            Pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                // make fog work
                #pragma multi_compile_fog

                #include "UnityCG.cginc"



                struct v2f
                {
                    float2 uv : TEXCOORD0;
                    UNITY_FOG_COORDS(1)
                    float4 vertex : SV_POSITION;
                };

                sampler2D _MainTex;
                float4 _MainTex_ST;
                float _Height;
                float _Radius;
                half _Opacity;

                v2f vert(appdata_full v)
                {
                    v2f o;
                    v.vertex.y = 0.0;

                    if (abs(v.vertex.x) < _Radius) {
                        v.vertex.xz += 0.0;
                    }

                    if (abs(v.vertex.x) > _Radius) {
                        v.vertex.xz += v.normal * _Height;
                    }
                    //v.vertex.z += v.vertex.x;
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                    UNITY_TRANSFER_FOG(o,o.vertex);
                    return o;
                }

                fixed4 frag(v2f i) : SV_Target
                {
                    // sample the texture
                    fixed4 col = tex2D(_MainTex, i.uv);
                col.a = _Opacity;
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
                }
            ENDCG
            }
        }
}