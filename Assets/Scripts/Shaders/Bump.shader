﻿Shader "GD3/BumpShader" {

	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_DisplacementTex ("Displacement tex", 2D) = "white" {}
		_SecondTex ("Onze 2e texture", 2D) = "white" {}
		_BumpTex ("Onze normal map", 2D) = "bump" {}
		_BumpMultiplier ("Bump Multiplier", Range(0.0001,2)) = 1
		_Lerperplier ("Lerperplier", Range(0, 1)) = 1
	}

	SubShader {

		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM

		#pragma surface surf Standard

		sampler2D _MainTex;
		sampler2D _BumpTex;
		sampler2D _SecondTex;
		sampler2D _DisplacementTex;
		half _BumpMultiplier;
		half _Lerperplier;

		struct Input {
			float2 uv_MainTex;
			float2 uv_BumpTex;
		};

		void surf (Input IN, inout SurfaceOutputStandard o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			fixed4 c2 = tex2D (_SecondTex, IN.uv_MainTex);
			fixed d = tex2D (_DisplacementTex, IN.uv_MainTex).r;

			o.Albedo = lerp(c, c2, d);

			// float3 UnpackNormal - text2D - multiplier
			float3 n = UnpackNormal(tex2D(_BumpTex, IN.uv_BumpTex));

			// We kunnen de normal nog wat verder aanstippen
			half _BumpIntensity = 1/ _BumpMultiplier;
			// hoe lager de z, des te hoger de x en y na het normaliseren. Daardoor krijgen we nog harder contrast
            n.z = n.z * _BumpIntensity;

			o.Normal = normalize(n);
		}
		ENDCG
	}
	FallBack "Diffuse"
}