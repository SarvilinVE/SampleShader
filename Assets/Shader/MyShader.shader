Shader "Custom/UnlitTextureMix"
{
	//свойства шейдера
	Properties
	{
	_Tex1("Texture1", 2D) = "white" {} // текстура1
	_Tex2("Texture2", 2D) = "white" {} // текстура2
	_MixValue("Mix Value", Range(0,1)) = 0.5 // параметр смешивания текстур
	_Color("Main Color", COLOR) = (1,1,1,1) // цвет окрашивания
		_Power1("Power1", Range(-20,20)) = 0.5 // сила изгиба
		_Power2("Power2", Range(-20,20)) = 0.5 // высота
		_Height("Height", Range(-20,20)) = 0.5 // высота
		
	}
		//сабшейдер
		SubShader
	{
		Tags { "RenderType" = "Opaque" } // тег, означающий, что шейдер непрозрачный
		LOD 100 // минимальный уровень детализации
		Pass
		{

			CGPROGRAM
			#pragma vertex vert // директива для обработки вершин
			#pragma fragment frag // директива для обработки фрагментов
			#include "UnityCG.cginc" // библиотека с полезными функциями

			

			sampler2D _Tex1; // текстура1
			float4 _Tex1_ST;
			sampler2D _Tex2; // текстура2
			float4 _Tex2_ST;
			float _MixValue; // параметр смешивания
			float4 _Color; // цвет, которым будет окрашиваться изображение
			float _Power1; // сила изгиба
			float _Power2; // высота
			float _Height; // высота
			
			struct appdata 
			{
				float4 vertex: SV_POSITION;
				float4 uv: TEXCOORD0;
			};
			// структура, которая помогает преобразовать данные вершины в данные
				//фрагмента
			struct v2f
			{
				float2 uv : TEXCOORD0; // UV-координаты вершины
				float4 vertex : SV_POSITION; // координаты вершины
			};
			//здесь происходит обработка вершин
			v2f vert(appdata_full v)
			{
				v2f result;
				v.vertex.xyz += v.normal * _Power1 * v.texcoord.x * v.texcoord.x - v.normal * _Power2 * v.texcoord.x + v.normal * _Height;
				//v.vertex.xyz += _Height * sin(v.normal * _Power * v.texcoord.x) + v.normal * _Height1 * v.texcoord.x;
				result.vertex = UnityObjectToClipPos(v.vertex);
				result.uv = TRANSFORM_TEX(v.texcoord, _Tex1);
				
				return result;
			}
			//здесь происходит обработка пикселей, цвет пикселей умножается на цвет
				//материала
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

