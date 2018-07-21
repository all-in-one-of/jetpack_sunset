// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "QFX/MFX/ASE/Uber/Standard Specular"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.1
		[HDR]_Color("Albedo Color", Color) = (1,1,1,1)
		_MainTex("Albedo", 2D) = "white" {}
		_BumpMap("Normal Map", 2D) = "bump" {}
		_Glossiness("Smoothness", Range( 0 , 1)) = 0
		_SpecGlossMap("Specular", 2D) = "white" {}
		_SpecColor("SpecColor", Color) = (1,1,1,1)
		_OcclusionMap("Occlusion", 2D) = "white" {}
		_OcclusionStrength("Occlusion", Range( 0 , 1)) = 0
		[HDR]_EmissionColor("Emission Color", Color) = (1,1,1,1)
		_EmissionMap("Emission Texture", 2D) = "white" {}
		[HDR]_Color2("Albedo Color 2", Color) = (1,1,1,1)
		_MainTex2("Albedo 2", 2D) = "white" {}
		_BumpMap2("Normal Map 2", 2D) = "bump" {}
		[HDR]_EmissionColor2("Emission Color 2", Color) = (1,1,1,1)
		_EmissionMap2("Emission Texture 2", 2D) = "white" {}
		_EmissionMap2_Scroll("Emission Texture 2 Scroll", Vector) = (0,0,0,0)
		_EmissionSize2("Emission Size 2", Range( 0 , 1)) = 1
		[HDR]_EdgeColor("Edge Color", Color) = (1,1,1,1)
		_EdgeRampMap1("Edge Ramp Map", 2D) = "white" {}
		_EdgeMap_Scroll("Edge Map Scroll", Vector) = (0,0,0,0)
		_EdgeSize("Edge Size", Range( 0 , 1)) = 0
		_EdgeStrength("Edge Strength", Range( 0 , 1)) = 0.1
		_DissolveMap1("Dissolve Map", 2D) = "white" {}
		_DissolveMap1_Scroll("Dissolve Map Scroll", Vector) = (0,0,0,0)
		_DissolveSize("Dissolve Size", Range( 0 , 3)) = 0
		[HDR]_DissolveEdgeColor("Dissolve Edge Color", Color) = (0,0,0,0)
		_DissolveEdgeSize("Dissolve Edge Size", Range( 0 , 1)) = 0.1
		_FringeRampMap("Fringe Ramp Map", 2D) = "white" {}
		_FringeSize("Fringe Size", Float) = 0.596873
		_FringeAmount("Fringe Amount", Float) = 0.596873
		_MaskOffset("Mask Offset", Float) = 0.1458042
		[KeywordEnum(None,AxisLocal,AxisGlobal,Global)] _MaskType("Mask Type", Float) = 0
		[Toggle]_Invert("Invert", Float) = 0
		[KeywordEnum(X,Y,Z)] _CutoffAxis("Cutoff Axis", Float) = 0
		_MaskWorldPosition("Mask World Position", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature _CUTOFFAXIS_X _CUTOFFAXIS_Y _CUTOFFAXIS_Z
		#pragma shader_feature _MASKTYPE_NONE _MASKTYPE_AXISLOCAL _MASKTYPE_AXISGLOBAL _MASKTYPE_GLOBAL
		#pragma surface surf StandardSpecular keepalpha addshadow fullforwardshadows noshadow vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float2 uv2_texcoord2;
			float2 uv_texcoord;
		};

		uniform float _EdgeSize;
		uniform float3 _MaskWorldPosition;
		uniform float _Invert;
		uniform float _MaskOffset;
		uniform sampler2D _EdgeRampMap1;
		uniform float2 _EdgeMap_Scroll;
		uniform float4 _EdgeRampMap1_ST;
		uniform float _FringeAmount;
		uniform float _FringeSize;
		uniform sampler2D _FringeRampMap;
		uniform float4 _FringeRampMap_ST;
		uniform sampler2D _BumpMap;
		uniform float4 _BumpMap_ST;
		uniform sampler2D _BumpMap2;
		uniform float4 _BumpMap2_ST;
		uniform float4 _Color;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float4 _Color2;
		uniform sampler2D _MainTex2;
		uniform float4 _MainTex2_ST;
		uniform float _DissolveSize;
		uniform sampler2D _DissolveMap1;
		uniform float2 _DissolveMap1_Scroll;
		uniform float4 _DissolveMap1_ST;
		uniform float _DissolveEdgeSize;
		uniform float4 _DissolveEdgeColor;
		uniform float4 _EmissionColor;
		uniform sampler2D _EmissionMap;
		uniform float4 _EmissionMap_ST;
		uniform float4 _EmissionColor2;
		uniform sampler2D _EmissionMap2;
		uniform float2 _EmissionMap2_Scroll;
		uniform float4 _EmissionMap2_ST;
		uniform float _EmissionSize2;
		uniform float _EdgeStrength;
		uniform float4 _EdgeColor;
		uniform sampler2D _SpecGlossMap;
		uniform float4 _SpecGlossMap_ST;
		uniform float _Glossiness;
		uniform sampler2D _OcclusionMap;
		uniform float4 _OcclusionMap_ST;
		uniform float _OcclusionStrength;
		uniform float _Cutoff = 0.1;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 temp_cast_0 = (1.0).xxx;
			float3 temp_cast_1 = (1.0).xxx;
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 temp_cast_2 = (length( ( ase_worldPos - _MaskWorldPosition ) )).xxx;
			#if defined(_MASKTYPE_NONE)
				float3 staticSwitch396 = temp_cast_0;
			#elif defined(_MASKTYPE_AXISLOCAL)
				float3 staticSwitch396 = ase_vertex3Pos;
			#elif defined(_MASKTYPE_AXISGLOBAL)
				float3 staticSwitch396 = ase_worldPos;
			#elif defined(_MASKTYPE_GLOBAL)
				float3 staticSwitch396 = temp_cast_2;
			#else
				float3 staticSwitch396 = temp_cast_0;
			#endif
			float3 break397 = staticSwitch396;
			#if defined(_CUTOFFAXIS_X)
				float staticSwitch398 = break397.x;
			#elif defined(_CUTOFFAXIS_Y)
				float staticSwitch398 = break397.y;
			#elif defined(_CUTOFFAXIS_Z)
				float staticSwitch398 = break397.z;
			#else
				float staticSwitch398 = break397.x;
			#endif
			float pos399 = staticSwitch398;
			float invert_option351 = lerp(1.0,-1.0,_Invert);
			float temp_output_361_0 = ( invert_option351 * _MaskOffset );
			float mask_pos206 = ( ( pos399 * invert_option351 ) - temp_output_361_0 );
			float2 uv_EdgeRampMap1 = v.texcoord.xy * _EdgeRampMap1_ST.xy + _EdgeRampMap1_ST.zw;
			float2 panner112 = ( 1.0 * _Time.y * _EdgeMap_Scroll + uv_EdgeRampMap1);
			float2 uv_TexCoord111 = v.texcoord.xy + panner112;
			float edge_pos109 = ( mask_pos206 - ( temp_output_361_0 - tex2Dlod( _EdgeRampMap1, float4( uv_TexCoord111, 0, 0.0) ).r ) );
			float temp_output_22_0 = ( (50.0 + (_EdgeSize - 0.0) * (0.0 - 50.0) / (1.0 - 0.0)) * edge_pos109 );
			float clampResult38 = clamp( temp_output_22_0 , 0.0 , 1.0 );
			float clampResult34 = clamp( ( 1.0 - abs( temp_output_22_0 ) ) , 0.0 , 1.0 );
			float edge_threshold42 = ( ( 1.0 - clampResult38 ) - clampResult34 );
			float3 ase_vertexNormal = v.normal.xyz;
			float mask_offset362 = temp_output_361_0;
			float2 uv_FringeRampMap = v.texcoord * _FringeRampMap_ST.xy + _FringeRampMap_ST.zw;
			float4 temp_output_364_0 = ( saturate( ( ( mask_pos206 - mask_offset362 ) + ( _FringeSize + 1.0 ) ) ) * tex2Dlod( _FringeRampMap, float4( uv_FringeRampMap, 0, 0.0) ) );
			float4 local_vert_offset310 = ( float4( ( edge_threshold42 * ase_vertexNormal * _FringeAmount ) , 0.0 ) * temp_output_364_0 );
			v.vertex.xyz += local_vert_offset310.rgb;
		}

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv2_BumpMap = i.uv2_texcoord2 * _BumpMap_ST.xy + _BumpMap_ST.zw;
			float2 uv2_BumpMap2 = i.uv2_texcoord2 * _BumpMap2_ST.xy + _BumpMap2_ST.zw;
			float3 temp_cast_0 = (1.0).xxx;
			float3 temp_cast_1 = (1.0).xxx;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float3 ase_worldPos = i.worldPos;
			float3 temp_cast_2 = (length( ( ase_worldPos - _MaskWorldPosition ) )).xxx;
			#if defined(_MASKTYPE_NONE)
				float3 staticSwitch396 = temp_cast_0;
			#elif defined(_MASKTYPE_AXISLOCAL)
				float3 staticSwitch396 = ase_vertex3Pos;
			#elif defined(_MASKTYPE_AXISGLOBAL)
				float3 staticSwitch396 = ase_worldPos;
			#elif defined(_MASKTYPE_GLOBAL)
				float3 staticSwitch396 = temp_cast_2;
			#else
				float3 staticSwitch396 = temp_cast_0;
			#endif
			float3 break397 = staticSwitch396;
			#if defined(_CUTOFFAXIS_X)
				float staticSwitch398 = break397.x;
			#elif defined(_CUTOFFAXIS_Y)
				float staticSwitch398 = break397.y;
			#elif defined(_CUTOFFAXIS_Z)
				float staticSwitch398 = break397.z;
			#else
				float staticSwitch398 = break397.x;
			#endif
			float pos399 = staticSwitch398;
			float invert_option351 = lerp(1.0,-1.0,_Invert);
			float temp_output_361_0 = ( invert_option351 * _MaskOffset );
			float mask_pos206 = ( ( pos399 * invert_option351 ) - temp_output_361_0 );
			float2 uv_EdgeRampMap1 = i.uv_texcoord * _EdgeRampMap1_ST.xy + _EdgeRampMap1_ST.zw;
			float2 panner112 = ( 1.0 * _Time.y * _EdgeMap_Scroll + uv_EdgeRampMap1);
			float2 uv_TexCoord111 = i.uv_texcoord + panner112;
			float edge_pos109 = ( mask_pos206 - ( temp_output_361_0 - tex2D( _EdgeRampMap1, uv_TexCoord111 ).r ) );
			float temp_output_22_0 = ( (50.0 + (_EdgeSize - 0.0) * (0.0 - 50.0) / (1.0 - 0.0)) * edge_pos109 );
			float clampResult38 = clamp( temp_output_22_0 , 0.0 , 1.0 );
			float clampResult34 = clamp( ( 1.0 - abs( temp_output_22_0 ) ) , 0.0 , 1.0 );
			float edge_threshold42 = ( ( 1.0 - clampResult38 ) - clampResult34 );
			float3 lerpResult134 = lerp( UnpackNormal( tex2D( _BumpMap, uv2_BumpMap ) ) , UnpackNormal( tex2D( _BumpMap2, uv2_BumpMap2 ) ) , edge_threshold42);
			float3 normal136 = lerpResult134;
			o.Normal = normal136;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 uv_MainTex2 = i.uv_texcoord * _MainTex2_ST.xy + _MainTex2_ST.zw;
			float4 lerpResult33 = lerp( ( _Color * tex2D( _MainTex, uv_MainTex ) ) , ( _Color2 * tex2D( _MainTex2, uv_MainTex2 ) ) , edge_threshold42);
			float4 albedo51 = lerpResult33;
			o.Albedo = albedo51.rgb;
			float2 uv_DissolveMap1 = i.uv_texcoord * _DissolveMap1_ST.xy + _DissolveMap1_ST.zw;
			float2 panner91 = ( 1.0 * _Time.y * _DissolveMap1_Scroll + uv_DissolveMap1);
			float2 uv_TexCoord90 = i.uv_texcoord + panner91;
			float alpha48 = ( _DissolveSize + ( mask_pos206 - ( temp_output_361_0 - tex2D( _DissolveMap1, uv_TexCoord90 ).r ) ) );
			float2 uv_EmissionMap = i.uv_texcoord * _EmissionMap_ST.xy + _EmissionMap_ST.zw;
			float4 base_emission147 = ( _EmissionColor * tex2D( _EmissionMap, uv_EmissionMap ) );
			float2 uv_EmissionMap2 = i.uv_texcoord * _EmissionMap2_ST.xy + _EmissionMap2_ST.zw;
			float2 panner198 = ( 1.0 * _Time.y * _EmissionMap2_Scroll + uv_EmissionMap2);
			float2 uv_TexCoord199 = i.uv_texcoord + panner198;
			float clampResult74 = clamp( ( ( ( 1.0 - tex2D( _EmissionMap2, uv_TexCoord199 ).r ) - 0.5 ) * 3.0 ) , 0.0 , 1.0 );
			float mask_offset362 = temp_output_361_0;
			float4 Emission2142 = ( _EmissionColor2 * ( pow( clampResult74 , 3.0 ) * saturate( ( ( mask_pos206 - mask_offset362 ) + (0.0 + (_EmissionSize2 - 0.0) * (3.0 - 0.0) / (1.0 - 0.0)) ) ) ) );
			float4 lerpResult62 = lerp( base_emission147 , Emission2142 , edge_threshold42);
			float4 emission64 = lerpResult62;
			float smoothstepResult281 = smoothstep( ( 1.0 - _EdgeSize ) , 1.0 , clampResult34);
			float edge72 = smoothstepResult281;
			float4 final_emission67 = (( alpha48 <= _DissolveEdgeSize ) ? _DissolveEdgeColor :  ( emission64 + (( (1.0 + (_EdgeStrength - 0.0) * (0.1 - 1.0) / (1.0 - 0.0)) <= edge72 ) ? _EdgeColor :  ( _EdgeColor * edge72 ) ) ) );
			o.Emission = final_emission67.rgb;
			float2 uv_SpecGlossMap = i.uv_texcoord * _SpecGlossMap_ST.xy + _SpecGlossMap_ST.zw;
			float4 tex2DNode117 = tex2D( _SpecGlossMap, uv_SpecGlossMap );
			float4 Specular122 = ( tex2DNode117.r * _SpecColor );
			o.Specular = Specular122.rgb;
			float Smothness121 = ( tex2DNode117.a * _Glossiness );
			o.Smoothness = Smothness121;
			float2 uv_OcclusionMap = i.uv_texcoord * _OcclusionMap_ST.xy + _OcclusionMap_ST.zw;
			float lerpResult128 = lerp( 1.0 , tex2D( _OcclusionMap, uv_OcclusionMap ).r , _OcclusionStrength);
			float occlusion129 = lerpResult128;
			o.Occlusion = occlusion129;
			o.Alpha = 1;
			clip( alpha48 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15401
7;29;1906;1004;600.5963;-1153.118;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;183;-423.7378,2827.129;Float;False;1603.808;768.7366;;10;390;391;392;393;394;395;396;397;398;399;Pos;1,0,0.7241378,1;0;0
Node;AmplifyShaderEditor.Vector3Node;390;-302.6573,3367.081;Float;False;Property;_MaskWorldPosition;Mask World Position;35;0;Create;False;0;0;False;0;0,0,0;-1.95,0.77,-0.83;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;391;-265.66,3209.297;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;392;-31.49085,3311.47;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LengthOpNode;395;115.0106,3312.181;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;394;-223.9068,2921.773;Float;False;Constant;_1;1;36;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;393;-269.0677,3038.673;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;396;-30.19703,3022.47;Float;False;Property;_MaskType;Mask Type;32;0;Create;True;0;0;False;0;0;0;0;True;;KeywordEnum;4;None;AxisLocal;AxisGlobal;Global;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;349;1237.486,2850.081;Float;False;499.6643;210.5081;;2;351;350;Invert;1,0,0.7241378,1;0;0
Node;AmplifyShaderEditor.BreakToComponentsNode;397;221.9416,3025.309;Float;True;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.CommentaryNode;141;-428.8928,1487.719;Float;False;2117.487;1266.031;;27;109;107;207;106;206;48;46;8;10;7;5;90;91;96;92;204;104;182;111;6;112;113;114;356;357;361;362;Dissolve & Edge Ramp;0,0.5034485,1,1;0;0
Node;AmplifyShaderEditor.StaticSwitch;398;532.0347,3020.253;Float;False;Property;_CutoffAxis;Cutoff Axis;34;0;Create;True;0;0;False;0;0;0;0;True;;KeywordEnum;3;X;Y;Z;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;350;1281.419,2921.709;Float;False;Property;_Invert;Invert;33;0;Create;True;0;0;False;0;0;2;0;FLOAT;1;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;145;-819.9175,-869.4588;Float;False;2385.28;1256.44;;21;142;60;252;56;301;78;74;297;283;77;304;79;239;305;76;75;57;199;198;197;196;Emission 2;0,0.6275864,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;114;-374.6469,2578.943;Float;False;Property;_EdgeMap_Scroll;Edge Map Scroll;20;0;Create;False;0;0;False;0;0,0;0,-0.05;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;113;-366.2211,2451.937;Float;False;0;104;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;351;1509.082,2919.521;Float;False;invert_option;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;197;-792.2313,-666.3396;Float;False;0;57;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;356;-103.2874,1838.35;Float;False;351;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-67.50871,1921.176;Float;False;Property;_MaskOffset;Mask Offset;31;0;Create;True;0;0;False;0;0.1458042;0.35;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;399;799.7318,3019.766;Float;False;pos;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;182;-343.8723,1555.52;Float;True;399;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;196;-781.2313,-503.3396;Float;False;Property;_EmissionMap2_Scroll;Emission Texture 2 Scroll;16;0;Create;False;0;0;False;0;0,0;0,0.3;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;112;-121.993,2512.987;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;361;168.7613,1906.332;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;357;122.529,1561.77;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;198;-477.2309,-567.3396;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;111;137.9767,2416.424;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;104;422.2266,2341.004;Float;True;Property;_EdgeRampMap1;Edge Ramp Map;19;0;Create;False;0;0;False;0;None;2db968192363cee4da5d06d841ed8987;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;204;350.7755,1561.169;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;199;-301.1589,-591.2114;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;57;-519.988,-801.387;Float;True;Property;_EmissionMap2;Emission Texture 2;15;0;Create;False;0;0;False;0;None;8c4a7fca2884fab419769ccc0355c0c1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;140;-437.5188,515.5353;Float;False;1921.035;901.1141;;14;72;41;34;71;24;38;23;22;110;25;19;42;281;282;Edge;0,0.6275864,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;207;765.0082,2110.022;Float;False;206;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;106;759.2487,2255.553;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;206;579.0191,1556.455;Float;False;mask_pos;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-379.9276,765.2415;Float;False;Property;_EdgeSize;Edge Size;21;0;Create;True;0;0;False;0;0;0.66;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;75;-229.6376,-773.9956;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;107;994.4472,2197.942;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;76;-74.77987,-773.9417;Float;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;110;-105.1539,967.375;Float;True;109;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;362;410.4926,1848.741;Float;False;mask_offset;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;25;-81.74005,769.9133;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;50;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;305;-329.0804,-174.9579;Float;True;362;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;109;1270.668,2193.064;Float;True;edge_pos;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;239;-329.0804,-382.9579;Float;True;206;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;79;-327.8381,57.66326;Float;True;Property;_EmissionSize2;Emission Size 2;17;0;Create;True;0;0;False;0;1;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;138.5464,828.3665;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;283;20.76446,59.81854;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;304;-105.0803,-254.9579;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;80.30888,-773.9771;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;74;240.1217,-774.5722;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;92;-388.6284,2244.166;Float;False;Property;_DissolveMap1_Scroll;Dissolve Map Scroll;24;0;Create;False;0;0;False;0;0,0;0,0.2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;96;-401.3016,2110.514;Float;False;0;5;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.AbsOpNode;23;386.1413,827.3668;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;297;278.9195,33.04211;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;24;572.4553,826.874;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;78;483.9659,-776.0984;Float;True;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;38;478.4857,581.9752;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;91;-109.6854,2178.051;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;144;-2367.079,2454.067;Float;False;1215.546;888.8182;;9;64;62;143;147;63;148;59;55;58;Emission;0,0,0,1;0;0
Node;AmplifyShaderEditor.SaturateNode;301;540.5244,37.80836;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;58;-2330.748,2694.311;Float;True;Property;_EmissionMap;Emission Texture;10;0;Create;False;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;34;776.375,827.1055;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;252;832.1389,-434.0156;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;306;1794.311,1529.413;Float;False;2004.03;968.3962;;16;310;314;309;313;339;364;365;368;363;382;383;385;387;370;386;388;Fringe (Vertex Offset);0,0.6275864,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;55;-2243.104,2510.947;Float;False;Property;_EmissionColor;Emission Color;9;1;[HDR];Create;False;0;0;False;0;1,1,1,1;0,0,0,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;56;772.2062,-748.5606;Float;False;Property;_EmissionColor2;Emission Color 2;14;1;[HDR];Create;False;0;0;False;0;1,1,1,1;0.6487889,1.16442,1.764706,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;90;75.08936,2126.214;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;71;746.7791,583.2764;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;282;585.6412,1159.689;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;1046.529,-634.8297;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;383;1848.915,1817.169;Float;True;362;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;382;1848.915,1609.169;Float;True;206;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;370;1849.035,2049.022;Float;False;Property;_FringeSize;Fringe Size;29;0;Create;True;0;0;False;0;0.596873;0.44;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;138;-2921.519,1727.413;Float;False;1892.359;679.8414;;13;270;267;66;268;65;67;261;266;191;263;21;73;20;Edge Emission;0,0,0,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;41;1076.77,681.533;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;421.9146,2041.334;Float;True;Property;_DissolveMap1;Dissolve Map;23;0;Create;False;0;0;False;0;None;2db968192363cee4da5d06d841ed8987;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-2027.555,2638.392;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;281;1004.857,1142.609;Float;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;7;752.5357,1989.934;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;148;-2220.577,2927.869;Float;False;147;0;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;20;-2450.645,2106.615;Float;False;Property;_EdgeColor;Edge Color;18;1;[HDR];Create;True;0;0;False;0;1,1,1,1;3,0.7279412,0.7279412,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;142;1255.987,-637.7138;Float;True;Emission2;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;42;1239.524,677.5984;Float;True;edge_threshold;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;143;-2190.527,3001.836;Float;False;142;0;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;385;2072.915,1737.169;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;73;-2854.303,2161.33;Float;True;72;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;268;-2759.505,1976.508;Float;False;Property;_EdgeStrength;Edge Strength;22;0;Create;True;0;0;False;0;0.1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;147;-1847.064,2632.806;Float;False;base_emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;388;2067.432,2112.98;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;63;-2190.285,3077.846;Float;True;42;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;72;1267.192,1138.567;Float;True;edge;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;824.5463,1668.213;Float;False;Property;_DissolveSize;Dissolve Size;25;0;Create;True;0;0;False;0;0;1.67;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;139;-2363.308,924.239;Float;False;1157.36;791.994;;9;54;51;33;32;29;27;28;30;31;Diffuse;0,0,0,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;386;2280.114,1861.587;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;8;932.5671,1795.862;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;270;-2427.79,1872.82;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-2175.788,2229.598;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;62;-1942.219,2933.19;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;115;-2360.427,-817.0568;Float;False;870.6512;681.29;;7;389;121;122;120;119;118;117;Specular & Smoothness;0,0,0,1;0;0
Node;AmplifyShaderEditor.SamplerNode;31;-2198.205,1507.454;Float;True;Property;_MainTex2;Albedo 2;12;0;Create;False;0;0;False;0;None;ea2908c2cd40fc54f8c2bd813439d4dd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;339;2509.266,1585.35;Float;True;42;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;313;2551.544,1789.295;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;131;-2366.09,401.7381;Float;False;752.2058;441.1062;;5;136;135;134;133;132;Normal;0,0,0,1;0;0
Node;AmplifyShaderEditor.SamplerNode;363;2542.827,2275.057;Float;True;Property;_FringeRampMap;Fringe Ramp Map;28;0;Create;True;0;0;False;0;None;11f03d9db1a617e40b7ece71f0a84f6f;True;0;True;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;387;2542.104,2091.858;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;65;-2894.496,1769.581;Float;True;64;0;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;27;-2233.972,965.9473;Float;False;Property;_Color;Albedo Color;1;1;[HDR];Create;False;0;0;False;0;1,1,1,1;1,1,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;125;-2364.525,-100.9189;Float;False;775.5983;398.703;;4;129;128;127;126;Ambient Occlusion;0,0,0,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;309;2547.361,1936.725;Float;False;Property;_FringeAmount;Fringe Amount;30;0;Create;True;0;0;False;0;0.596873;0.36;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;46;1163.299,1672.349;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0.15;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCCompareLowerEqual;267;-1999.937,1868.927;Float;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;28;-2315.616,1132.712;Float;True;Property;_MainTex;Albedo;2;0;Create;False;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;30;-2110.562,1326.09;Float;False;Property;_Color2;Albedo Color 2;11;1;[HDR];Create;False;0;0;False;0;1,1,1,1;0,0,0,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;64;-1732.511,2929.326;Float;True;emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-2018.423,1093.392;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;118;-2325.993,-330.1342;Float;False;Property;_Glossiness;Smoothness;4;0;Create;False;0;0;False;0;0;0.693;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;364;2938.533,2163.628;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;66;-1830.751,1784.17;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;263;-1884.084,2050.768;Float;False;48;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-1895.012,1451.535;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;133;-2341.837,643.4477;Float;True;Property;_BumpMap2;Normal Map 2;13;0;Create;False;0;0;False;0;None;None;True;1;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;135;-2041.038,725.6877;Float;False;42;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;314;2920.066,1684.449;Float;True;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;266;-1833.756,2228.011;Float;False;Property;_DissolveEdgeColor;Dissolve Edge Color;26;1;[HDR];Create;True;0;0;False;0;0,0,0,0;2.095741,1.286765,3.5,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;126;-2325.607,-48.821;Float;True;Property;_OcclusionMap;Occlusion;7;0;Create;False;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;48;1404.641,1544.734;Float;True;alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;117;-2335.049,-772.0155;Float;True;Property;_SpecGlossMap;Specular;5;0;Create;False;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;127;-2325.607,159.1787;Float;False;Property;_OcclusionStrength;Occlusion;8;0;Create;False;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;389;-2252.293,-576.6719;Float;False;Property;_SpecColor;SpecColor;6;0;Fetch;False;0;0;False;0;1,1,1,1;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;132;-2337.39,455.3405;Float;True;Property;_BumpMap;Normal Map;3;0;Create;False;0;0;False;0;None;None;True;1;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;54;-1731.499,1485.125;Float;False;42;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;191;-1976.316,2150.18;Float;False;Property;_DissolveEdgeSize;Dissolve Edge Size;27;0;Create;True;0;0;False;0;0.1;0.169;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;119;-1983.549,-492.8848;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;128;-1986.477,27.58154;Float;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;33;-1731.833,1284.201;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;-1973.865,-686.7137;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;365;3357.417,2013.058;Float;True;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCCompareLowerEqual;261;-1577.201,1999.727;Float;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;134;-1992.136,572.4476;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;52;1899.848,599.4089;Float;False;51;0;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;124;1886.73,952.4059;Float;False;121;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;49;1907.092,1116.615;Float;False;48;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;129;-1802.378,24.15844;Float;False;occlusion;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;368;3122.762,2011.136;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;122;-1809.127,-691.9866;Float;False;Specular;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;311;1850.755,1207.514;Float;False;310;0;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;123;1896.866,864.106;Float;False;122;0;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;67;-1301.85,1996.763;Float;False;final_emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;130;1901.373,1032.003;Float;False;129;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;137;1901.581,688.5706;Float;False;136;0;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;121;-1805.582,-497.9386;Float;False;Smothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;68;1861.774,779.3271;Float;False;67;0;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;51;-1439.285,1225.089;Float;False;albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;136;-1822.036,567.6877;Float;False;normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;310;3580.855,2007.526;Float;False;local_vert_offset;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2216.772,737.6642;Float;False;True;2;Float;ASEMaterialInspector;0;0;StandardSpecular;QFX/MFX/ASE/Uber/Standard Specular;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.1;True;True;0;True;TransparentCutout;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;392;0;391;0
WireConnection;392;1;390;0
WireConnection;395;0;392;0
WireConnection;396;1;394;0
WireConnection;396;0;393;0
WireConnection;396;2;391;0
WireConnection;396;3;395;0
WireConnection;397;0;396;0
WireConnection;398;1;397;0
WireConnection;398;0;397;1
WireConnection;398;2;397;2
WireConnection;351;0;350;0
WireConnection;399;0;398;0
WireConnection;112;0;113;0
WireConnection;112;2;114;0
WireConnection;361;0;356;0
WireConnection;361;1;6;0
WireConnection;357;0;182;0
WireConnection;357;1;356;0
WireConnection;198;0;197;0
WireConnection;198;2;196;0
WireConnection;111;1;112;0
WireConnection;104;1;111;0
WireConnection;204;0;357;0
WireConnection;204;1;361;0
WireConnection;199;1;198;0
WireConnection;57;1;199;0
WireConnection;106;0;361;0
WireConnection;106;1;104;1
WireConnection;206;0;204;0
WireConnection;75;0;57;1
WireConnection;107;0;207;0
WireConnection;107;1;106;0
WireConnection;76;0;75;0
WireConnection;362;0;361;0
WireConnection;25;0;19;0
WireConnection;109;0;107;0
WireConnection;22;0;25;0
WireConnection;22;1;110;0
WireConnection;283;0;79;0
WireConnection;304;0;239;0
WireConnection;304;1;305;0
WireConnection;77;0;76;0
WireConnection;74;0;77;0
WireConnection;23;0;22;0
WireConnection;297;0;304;0
WireConnection;297;1;283;0
WireConnection;24;0;23;0
WireConnection;78;0;74;0
WireConnection;38;0;22;0
WireConnection;91;0;96;0
WireConnection;91;2;92;0
WireConnection;301;0;297;0
WireConnection;34;0;24;0
WireConnection;252;0;78;0
WireConnection;252;1;301;0
WireConnection;90;1;91;0
WireConnection;71;0;38;0
WireConnection;282;0;19;0
WireConnection;60;0;56;0
WireConnection;60;1;252;0
WireConnection;41;0;71;0
WireConnection;41;1;34;0
WireConnection;5;1;90;0
WireConnection;59;0;55;0
WireConnection;59;1;58;0
WireConnection;281;0;34;0
WireConnection;281;1;282;0
WireConnection;7;0;361;0
WireConnection;7;1;5;1
WireConnection;142;0;60;0
WireConnection;42;0;41;0
WireConnection;385;0;382;0
WireConnection;385;1;383;0
WireConnection;147;0;59;0
WireConnection;388;0;370;0
WireConnection;72;0;281;0
WireConnection;386;0;385;0
WireConnection;386;1;388;0
WireConnection;8;0;206;0
WireConnection;8;1;7;0
WireConnection;270;0;268;0
WireConnection;21;0;20;0
WireConnection;21;1;73;0
WireConnection;62;0;148;0
WireConnection;62;1;143;0
WireConnection;62;2;63;0
WireConnection;387;0;386;0
WireConnection;46;0;10;0
WireConnection;46;1;8;0
WireConnection;267;0;270;0
WireConnection;267;1;73;0
WireConnection;267;2;20;0
WireConnection;267;3;21;0
WireConnection;64;0;62;0
WireConnection;29;0;27;0
WireConnection;29;1;28;0
WireConnection;364;0;387;0
WireConnection;364;1;363;0
WireConnection;66;0;65;0
WireConnection;66;1;267;0
WireConnection;32;0;30;0
WireConnection;32;1;31;0
WireConnection;314;0;339;0
WireConnection;314;1;313;0
WireConnection;314;2;309;0
WireConnection;48;0;46;0
WireConnection;119;0;117;4
WireConnection;119;1;118;0
WireConnection;128;1;126;1
WireConnection;128;2;127;0
WireConnection;33;0;29;0
WireConnection;33;1;32;0
WireConnection;33;2;54;0
WireConnection;120;0;117;1
WireConnection;120;1;389;0
WireConnection;365;0;314;0
WireConnection;365;1;364;0
WireConnection;261;0;263;0
WireConnection;261;1;191;0
WireConnection;261;2;266;0
WireConnection;261;3;66;0
WireConnection;134;0;132;0
WireConnection;134;1;133;0
WireConnection;134;2;135;0
WireConnection;129;0;128;0
WireConnection;368;0;364;0
WireConnection;122;0;120;0
WireConnection;67;0;261;0
WireConnection;121;0;119;0
WireConnection;51;0;33;0
WireConnection;136;0;134;0
WireConnection;310;0;365;0
WireConnection;0;0;52;0
WireConnection;0;1;137;0
WireConnection;0;2;68;0
WireConnection;0;3;123;0
WireConnection;0;4;124;0
WireConnection;0;5;130;0
WireConnection;0;10;49;0
WireConnection;0;11;311;0
ASEEND*/
//CHKSM=1EE7468EBB78DAD74337714F2253B8CA777FB8D6