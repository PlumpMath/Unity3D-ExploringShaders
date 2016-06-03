Shader "CustomShaders/SimpleShaders/Specular"
{
	Properties
	{
		_Color("Color", Color) = (1.0,1.0,1.0,1.0)
		_SpecColor("Specular Color", Color) = (1.0,1.0,1.0,1.0)
		_Shininess("Shininess", float) = 10
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
			float _Shininess;

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
				float4 col : COLOR;
			};

			//functions
			vertexOutput vert(vertexInput v)
			{
				vertexOutput o;

				//Calculate vectors
				float3 normalDirection = normalize(mul(float4(v.normal, 0.0), _World2Object).xyz);
				float3 viewDirection = normalize(float3(_WorldSpaceCameraPos - v.vertex));
				float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
				float atten = 1.0;

				//Calculate dot light*normal dot
				float lightNormalDot = max(0.0, dot(lightDirection, normalDirection));

				//Calculate light reflections {diffuse, specular, finalLight}
				float3 diffuseReflection = atten * _LightColor0.xyz * lightNormalDot;
				float3 specularReflection = atten * _SpecColor.rgb * lightNormalDot * pow(max(0.0, dot(reflect(-lightDirection, normalDirection), viewDirection)), _Shininess);
				float3 finalLight = diffuseReflection + specularReflection + UNITY_LIGHTMODEL_AMBIENT;

				o.col = float4(finalLight * _Color.rgb, 1.0);
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				return o;
			}

			float4 frag(vertexOutput i) : COLOR
			{
				return i.col;
			}
			ENDCG
		}
	}
}