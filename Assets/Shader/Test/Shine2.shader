Shader "Custom/Shine2" {
	Properties{
		_MainTex("Texture", 2D) = "white" {}
	}
		CGINCLUDE
#include "UnityCG.cginc"

		sampler2D _MainTex;

	struct VertexData {
		float4 vertex : POSITION;
		float2 uv : TEXCOORD0;
	};

	struct Interpolators {
		float4 pos : SV_POSITION;
		float2 uv : TEXCOORD0;
	};

	Interpolators VertexProgram(VertexData v) {
		Interpolators i;
		i.pos = UnityObjectToClipPos(v.vertex);
		i.uv = v.uv;
		return i;
	}
	ENDCG

		SubShader{
			Cull Off
			ZTest Always
			ZWrite Off

			Pass {
				CGPROGRAM
					#pragma vertex VertexProgram
					#pragma fragment FragmentProgram
				ENDCG
			}
	}
}