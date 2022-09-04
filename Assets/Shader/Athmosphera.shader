Shader "Custom/Unlit/Atmosphere"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}
        _TextureShift("Texture shift", Range(0, 1)) = 0
        [PowerSlider(4)] _Fading("Fading texture", Range(0.1, 5)) = 1.0
        [PowerSlider(4)] _AtmoWidth("Atmosphere density", Range(0.1, 5)) = 1.0
       
        [Header(Culling)]
        [Enum(UnityEngine.Rendering.CullMode)] _Cull("Cull", Float) = 2 //"Back"
        [Enum(Off,0,On,1)]_ZWrite ("ZWrite", Float) = 1.0

        [Header(Stencil)]
                _Stencil ("Stencil ID [0;255]", Float) = 0
                _ReadMask ("ReadMask [0;255]", Int) = 255
                _WriteMask ("WriteMask [0;255]", Int) = 255
                [Enum(UnityEngine.Rendering.CompareFunction)] _StencilComp ("Stencil Comparison", Int) = 3
                [Enum(UnityEngine.Rendering.StencilOp)] _StencilOp ("Stencil Operation", Int) = 0
                [Enum(UnityEngine.Rendering.StencilOp)] _StencilFail ("Stencil Fail", Int) = 0
                [Enum(UnityEngine.Rendering.StencilOp)] _StencilZFail ("Stencil ZFail", Int) = 0

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        Blend SrcAlpha OneMinusSrcAlpha
        Cull [_Cull]
        ZWrite [_ZWrite]
                Stencil
                {
                        Ref [_Stencil]
                        ReadMask [_ReadMask]
                        WriteMask [_WriteMask]
                        Comp [_StencilComp]
                        Pass [_StencilOp]
                        Fail [_StencilFail]
                        ZFail [_StencilZFail]
                }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
                float3 viewD : TEXCOORD2;
            };

            fixed4 _Color;
            sampler2D _MainTex;
            float _TextureShift;
            float _Fading;
            float _AtmoWidth;

            v2f vert (appdata_full v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);                
                o.viewD = normalize(WorldSpaceViewDir(v.vertex));
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed a = dot(_WorldSpaceLightPos0, -i.normal);
                fixed a2 = a * step(a, 1);
                a2 = pow(a2, _Fading);
                fixed a3 = dot(-i.normal, i.viewD);
                float2 uv = float2(a2, _TextureShift);
                fixed4 c = tex2D (_MainTex, uv) * _Color * _LightColor0;
                c.a = pow(1 - clamp(abs(a3), 0, 1), 5.0 - _AtmoWidth) * c.a;
                return c;
            }
            ENDCG
        }
    }
}