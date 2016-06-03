Shader "CustomShaders/SimpleShaders/FlatColor"
{
	Properties
	{
		_Color("Color", Color) = (1.0,1.0,1.0,1.0)
	}
	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			//user defined variables
			uniform float4 _Color;

			//Base input structs
			struct vertexInput
			{
				float4 vertex : POSITION;
			};
			struct vertexOutput
			{
				float4 pos : SV_POSITION; //SV_ directX syntax
			};

			//Vertex functions
			vertexOutput vert(vertexInput v)
			{
				vertexOutput o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex); //register in the GPU
				return o;
			}

			//Fragment function
			float4 frag(vertexOutput i) : COLOR
			{
				return _Color;
			}

			ENDCG
		}
	}
}