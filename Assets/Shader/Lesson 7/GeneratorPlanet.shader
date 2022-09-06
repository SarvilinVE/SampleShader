Shader "Custom/GeneratorPlanet"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Emission("Emission", Color) = (1,1,1,1)
        _Height("Height", Range(-1,1)) = 0.0
        _Seed("Seed", Range(0,10000)) = 10
        _SizeSeed("SizeSeed", Range(0,1)) = 0.5
        _HeightOcean("Height Ocean", Range(0,1)) = 0.45
        _HeightLand("Height Land", Range(0,1)) = 0.75
        _ColorOcean("Color Ocean", Color) = (1,1,1,1)
        _ColorLand("Color Land", Color) = (1,1,1,1)
        _ColorMountin("Color Mountin", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue" = "Geometry-1"}
        LOD 200


        /*Stencil
        {
            Ref 10
            Comp NotEqual
        }*/

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Lambert noforwardadd noshadow vertex:vert

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float4 color : COLOR;
        };

        fixed4 _Color;
        float4 _Emission;
        float _Height;
        float _Seed;
        float _SizeSeed;
        float _HeightOcean;
        float _HeightLand;
        fixed4 _ColorOcean;
        fixed4 _ColorLand;
        fixed4 _ColorMountin;

        float hash(float2 st)
        {
            return frac(sin(dot(st.xy, float2(12.9898, 78.233))) * 43758.5453123);
        }

        float noise(float2 p, float size)
        {
            float result = 0;
            p *= size;
            float2 i = floor(p + _Seed);
            float2 f = frac(p + _Seed / 739);
            float2 e = float2(0, 1);
            float z0 = hash((i + e.xx) % size);
            float z1 = hash((i + e.yx) % size);
            float z2 = hash((i + e.xy) % size);
            float z3 = hash((i + e.yy) % size);
            float2 u = smoothstep(0, 1, f);
            result = lerp(z0, z1, u.x) + (z2 - z0) * u.y * (1.0 - u.x) + (z3 - z1) * u.x *
                u.y;
            return result;
        }

        void vert(inout appdata_full v)
        {
            float height = noise(v.texcoord, 5 * _SizeSeed) * 0.75 + noise(v.texcoord, 30 * _SizeSeed) * 0.125 +
                noise(v.texcoord, 50 * _SizeSeed) * 0.125;
            v.color.r = height + _Height;
        }

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 color = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            float height = IN.color.r;
            if (height < _HeightOcean)
            {
                //color.x = 0.10;
                //color.y = 0.30;
                //color.z = 0.50;
                color = _ColorOcean;
            }
            else if (height < _HeightLand)
            {
                //color.x = 0.10;
                //color.y = 0.60;
                //color.z = 0.30;
                color = _ColorLand;
            }
            else
            {
                //color.x = 0.60;
                //color.y = 0.30;
                //color.z = 0.30;
                color = _ColorMountin;
            }
            o.Albedo = color.rgb;
            o.Emission = _Emission.xyz;
            o.Alpha = color.a;

        }
        ENDCG
    }
    FallBack "Diffuse"
}
