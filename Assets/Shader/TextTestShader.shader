Shader "Unlit/TextTestShader"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_MainTex_ST("MainTex_ST", Vector) = (1, 1, 0, 0)

		_FontTex("Texture", 2D) = "white" {}
		_FontTex_ST("FontTex_ST", Vector) = (0, 0, 0, 0)
		_FontTex_RG("FontTex_RG", Vector) = (0, 0, 0, 0)
		_FontColor("FontColor", Color) = (1,1,1,1)
		_Flag ("Flag",INT) = 0

	}
		SubShader
		{
			Tags { "RenderType" = "Opaque" }
			LOD 100

			Pass
			{
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				#include "UnityCG.cginc"


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

				sampler2D _MainTex;
				float4 _MainTex_ST;
				sampler2D _FontTex;
				float4 _FontTex_ST;
				float4 _FontTex_RG;
				float4 _FontColor;
				int _Flag;

				fixed4 ChangeFontColor(fixed4 finalColor, float2 uv)
				{
					float2 nUV = uv;
					nUV = (nUV - float2(0.5, 0.5)) * _FontTex_ST.xy + float2(0.5, 0.5);
					nUV = (nUV + _FontTex_ST.zw);
					if (nUV.x < 0 || nUV.y < 0 || nUV.x>1 || nUV.y>1)
					{
					}
					else
					{
						if (_Flag == 0)
						{
							float x = nUV.x * (_FontTex_RG.z - _FontTex_RG.x) + _FontTex_RG.x; 
							float y = nUV.y * (_FontTex_RG.w - _FontTex_RG.y) + _FontTex_RG.y;
							float2 newUV = float2(x, y);
							fixed4 fontColor = tex2D(_FontTex, newUV);
							finalColor = finalColor * (1 - fontColor.a) + _FontColor * fontColor.a;
						}
						else
						{
							float x = nUV.y * (_FontTex_RG.z - _FontTex_RG.x) + _FontTex_RG.x;
							float y = nUV.x * (_FontTex_RG.y - _FontTex_RG.w) + _FontTex_RG.w;
							float2 newUV = float2(x, y);
							fixed4 fontColor = tex2D(_FontTex, newUV);
							finalColor = finalColor * (1 - fontColor.a) + _FontColor * fontColor.a;
						}
					}
					return finalColor;
				}
				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = TRANSFORM_TEX(v.uv, _MainTex);
					return o;
				}

				fixed4 frag(v2f i) : SV_Target
				{
					fixed4 col = tex2D(_MainTex, i.uv);
					col = ChangeFontColor(col, i.uv);
				return col;
			}
			ENDCG
		}
	}
}
