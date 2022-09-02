Shader "Custom/UnlitTextureMix"
{
	//�������� �������
	Properties
	{
	_Tex1("Texture1", 2D) = "white" {} // ��������1
	_Tex2("Texture2", 2D) = "white" {} // ��������2
	_MixValue("Mix Value", Range(0,1)) = 0.5 // �������� ���������� �������
	_Color("Main Color", COLOR) = (1,1,1,1) // ���� �����������
		_Power("Power", Range(-20,20)) = 0.5 // ���� ������
		_Height("Height", Range(-20,20)) = 0.5 // ������
		_Height1("Height1", Range(-20,20)) = 0.5 // ������
	}
		//���������
		SubShader
	{
		Tags { "RenderType" = "Opaque" } // ���, ����������, ��� ������ ������������
		LOD 100 // ����������� ������� �����������
		Pass
		{

			CGPROGRAM
			#pragma vertex vert // ��������� ��� ��������� ������
			#pragma fragment frag // ��������� ��� ��������� ����������
			#include "UnityCG.cginc" // ���������� � ��������� ���������

			

			sampler2D _Tex1; // ��������1
			float4 _Tex1_ST;
			sampler2D _Tex2; // ��������2
			float4 _Tex2_ST;
			float _MixValue; // �������� ����������
			float4 _Color; // ����, ������� ����� ������������ �����������
			float _Power; // ���� ������
			float _Height; // ������
			float _Height1; // ������
			struct appdata 
			{
				float4 vertex: SV_POSITION;
				float4 uv: TEXCOORD0;
			};
			// ���������, ������� �������� ������������� ������ ������� � ������
				//���������
			struct v2f
			{
				float2 uv : TEXCOORD0; // UV-���������� �������
				float4 vertex : SV_POSITION; // ���������� �������
			};
			//����� ���������� ��������� ������
			v2f vert(appdata_full v)
			{
				v2f result;
				//v.vertex.xyz += v.normal * _Power * v.texcoord.x * v.texcoord.x - v.normal * _Height1 * v.texcoord.x + v.normal * _Height;
				v.vertex.xyz += _Height * sin(v.normal * _Power * v.texcoord.x) + v.normal * _Height1 * v.texcoord.x;
				result.vertex = UnityObjectToClipPos(v.vertex);
				result.uv = TRANSFORM_TEX(v.texcoord, _Tex1);
				
				return result;
			}
			//����� ���������� ��������� ��������, ���� �������� ���������� �� ����
				//���������
			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 color;
				color = tex2D(_Tex1, i.uv) * _MixValue;
				color = tex2D(_Tex2, i.uv) * (1 - _MixValue);
				color = color * _Color;
				return color;
				//fixed4 col = tex2D(_Tex1, i.uv) * half4(1, 0, 0, 0);
			//return col;

			}

			ENDCG
		}
	}
}

