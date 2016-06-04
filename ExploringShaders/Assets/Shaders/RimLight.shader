Shader "CustomShaders/SimpleShaders/RimLight"
{
	Properties
	{
		_Color("Color", Color) = (1.0,1.0,1.0,1.0)
		_SpecColor("Specular Color", Color) = (1.0,1.0,1.0,1.0)
		_Shininess("Shininess", float) = 10
		_RimColor("Rim Color", Color) = (1.0,1.0,1.0,1.0)
		_RimPower("Rim Power", Range(1.0, 10.0)) = 3.0
	}

	SubShader
	{
		Pass
		{
			Tags{"LightMode" = "ForwardBase"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			//user defined variables
			float4 _Color;
			float4 _SpecColor;
			float4 _RimColor;
			float _Shininess;
			float _RimPower;

			//Unity defined variables
			float4 _LightColor0;

			//structs
			struct vertexInput
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};
			struct vertexOutput
			{
				float4 pos : SV_POSITION;
				float4 posWorld : TEXTCOORD0;
				float3 normalDir : TEXTCOORD1;
			};

			//functions
			vertexOutput vert(vertexInput v)
			{
				vertexOutput o;

				o.normalDir = mul(_World2Object, v.normal);
				o.posWorld = mul(_Object2World, v.vertex);

				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				return o;
			}

			float4 frag (vertexOutput i) : COLOR
			{
				//Vectors
				float3 normalDirection = normalize(i.normalDir);
				float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
				float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
				float atten = 1.0;

				//lightNormalDot
				float lightNormalDot = saturate(dot(lightDirection, normalDirection));

				//reflections
				float3 diffuseReflection = atten * _LightColor0.xyz * lightNormalDot;
				float3 specularReflection = atten * _SpecColor.xyz * lightNormalDot * pow(max(0.0, saturate(dot(reflect(-lightDirection, normalDirection), viewDirection))), _Shininess);
				//rim
				float rim = 1 - saturate(dot(viewDirection, normalDirection));
				float3 rimLighting = atten * _RimColor.xyz * lightNormalDot * pow(rim, _RimPower);

				float3 lightFinal = diffuseReflection + specularReflection + rimLighting + UNITY_LIGHTMODEL_AMBIENT;
				return float4(lightFinal * _Color.rgb, 1.0); 
			}
			ENDCG
		}
	}
}