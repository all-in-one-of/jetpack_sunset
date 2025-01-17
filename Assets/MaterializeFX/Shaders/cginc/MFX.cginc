#ifndef MFX_INCLUDED
#define MFX_INCLUDED

//EMISSION 2
uniform float3 _EmissionColor2;
uniform float _EmissionSize2;
sampler2D _EmissionMap2;
uniform float4 _EmissionMap2_ST;
uniform float2 _EmissionMap2_Scroll;

//ALBEDO 2
uniform float4 _Color2;
sampler2D _MainTex2;
uniform float4 _MainTex2_ST;

//NORMAL
sampler2D _BumpMap2;
uniform float4 _BumpMap2_ST;

//MASK
uniform float _MaskType;
uniform float _CutoffAxis;
uniform float _MaskOffset;
uniform float4 _MaskWorldPosition;

//EDGE
uniform float3 _EdgeColor;
uniform sampler2D _EdgeRampMap1;
uniform float4 _EdgeRampMap1_ST;
uniform float2 _EdgeRampMap1_Scroll;
uniform float _EdgeSize;
uniform float _EdgeStrength;

//DISSOLVE
uniform float3 _DissolveEdgeColor;
uniform float _DissolveEdgeSize;
uniform float _DissolveSize;
sampler2D _DissolveMap1;
uniform float4 _DissolveMap1_ST;
uniform float2 _DissolveMap1_Scroll;

//FRINGE
uniform float _FringeSize;
uniform float _FringeAmount;
uniform sampler2D _FringeRampMap;
uniform float4 _FringeRampMap_ST;

//INVERT
uniform float _Invert;

#define MFX_TRANSFORM_TEX(texUV,texName) (texUV.xy * texName##_ST.xy + texName##_ST.zw + texName##_Scroll * _Time.y)

inline float Remap(float s, float a1, float a2, float b1, float b2)
{
    return b1 + (s - a1) * (b2 - b1) / (a2 - a1);
}

inline void MfxClip(float alpha)
{
    clip(alpha - _Cutoff);
}

inline void PassMfxVertex2Fragment(float2 mainUv, inout float4 mfxUv) //xy - edge, zw - dissolve
{
    mfxUv.xy = MFX_TRANSFORM_TEX(mainUv, _EdgeRampMap1);
    mfxUv.zw = MFX_TRANSFORM_TEX(mainUv, _DissolveMap1);
}

//--------------
// POSITION

inline float GetMfxLocalPosition(float3 vertexPos)
{
    float pos = mul(unity_WorldToObject, float4(vertexPos, 1))[(int)_CutoffAxis];
    return pos;
} 

inline float GetMfxGlobalPosition(float3 vertexPos)
{
    float pos = (vertexPos)[(int) _CutoffAxis];
    return pos;
}

inline float GetMfxLengthGlobalPosition(float3 vertexPos)
{
    return length(_MaskWorldPosition - vertexPos);
}

inline float GetMfxSinglePosition(float3 vertexPos)
{
    float invert_option = lerp(1, -1, _Invert);

#if defined(_MASKTYPE_AXIS_LOCAL)
    return GetMfxLocalPosition(vertexPos) * invert_option;
#elif defined (_MASKTYPE_AXIS_GLOBAL)
    return GetMfxGlobalPosition(vertexPos) * invert_option;
#elif defined (_MASKTYPE_GLOBAL)
    return GetMfxLengthGlobalPosition(vertexPos) * invert_option;
#endif
    return 1;
}

inline float GetMfxMaskOffset()
{
#if defined(_MASKTYPE_AXIS_LOCAL) || defined (_MASKTYPE_AXIS_GLOBAL) || defined(_MASKTYPE_NONE)
    return _MaskOffset;
#elif defined (_MASKTYPE_GLOBAL)
    float invert_option = lerp(1, -1, _Invert);
    return _MaskOffset * invert_option;
#endif
    return 0;
}

inline float GetAlpha(float2 mfxDissolveUv, float3 vertexPos)
{
   float pos = GetMfxSinglePosition(vertexPos);
   float mask_pos = (pos - GetMfxMaskOffset());
   float alpha = (_DissolveSize + (mask_pos - (GetMfxMaskOffset() - tex2D(_DissolveMap1, mfxDissolveUv).r)));
   return alpha;
}

// DISSOLVE
inline float GetMfxDissolve(float4 mfxUv, float3 vertexPos)
{
    float alpha = GetAlpha(mfxUv.zw, vertexPos);
    return alpha;
}

//DIFFUSE
half3 GetMfxAlbedo(float2 mainUv, float4 mfxUv, float3 vertexPos, half3 baseAlbedo)
{
    float pos = GetMfxSinglePosition(vertexPos);
    float mask_pos = (pos - GetMfxMaskOffset());
    float edge_pos = (mask_pos - (GetMfxMaskOffset() - tex2D(_EdgeRampMap1, mfxUv.xy).r));
	float scaled_edge = ( (50.0 + (_EdgeSize - 0.0) * (0.0 - 50.0) / (1.0 - 0.0)) * edge_pos );
	float clamp_scaled_edge = clamp( scaled_edge , 0.0 , 1.0 );
	float edge = clamp( ( 1.0 - abs( scaled_edge ) ) , 0.0 , 1.0 );
	float edge_threshold = ( ( 1.0 - clamp_scaled_edge ) - edge );
    half3 final_albedo = lerp(baseAlbedo , ( _Color2 * tex2D( _MainTex2, mainUv ) ) , edge_threshold);
    return final_albedo;
}

//NORMAL
half3 GetMfxNormal(float2 mainUv, float4 mfxUv, float3 vertexPos, half3 baseNormal)
{
    float pos = GetMfxSinglePosition(vertexPos);
    float mask_pos = (pos - GetMfxMaskOffset());
    float edge_pos = (mask_pos - (GetMfxMaskOffset() - tex2D(_EdgeRampMap1, mfxUv.xy).r));
	float scaled_edge = ( (50.0 + (_EdgeSize - 0.0) * (0.0 - 50.0) / (1.0 - 0.0)) * edge_pos );
	float clamp_scaled_edge = clamp( scaled_edge , 0.0 , 1.0 );
	float edge = clamp( ( 1.0 - abs( scaled_edge ) ) , 0.0 , 1.0 );
	float edge_threshold = ( ( 1.0 - clamp_scaled_edge ) - edge );
    half3 final_normal = lerp(baseNormal , UnpackNormal( tex2D( _BumpMap2, mainUv ) ) , edge_threshold);
    return final_normal;
}

//EMISSION
half3 GetMfxEmission(float4 mfxUv, float3 vertexPos, half3 baseEmission, float alpha)
{
    float pos = GetMfxSinglePosition(vertexPos);
    float mask_pos = (pos - GetMfxMaskOffset());
    float edge_pos = (mask_pos - (GetMfxMaskOffset() - tex2D(_EdgeRampMap1, mfxUv.xy).r));
	float scaled_edge = ( (50.0 + (_EdgeSize - 0.0) * (0.0 - 50.0) / (1.0 - 0.0)) * edge_pos );
	float clamp_scaled_edge = clamp( scaled_edge , 0.0 , 1.0 );
	float edge = clamp( ( 1.0 - abs( scaled_edge ) ) , 0.0 , 1.0 );
	float edge_threshold = ( ( 1.0 - clamp_scaled_edge ) - edge );

    float emissionMap = clamp((((1.0 - tex2D(_EmissionMap2, mfxUv.xy).r) - 0.5) * 3.0), 0.0, 1.0);
    float3 emission2 = (_EmissionColor2 * (pow(emissionMap, 3.0) * saturate(((mask_pos - GetMfxMaskOffset()) + (0.0 + (_EmissionSize2 - 0.0) * (3.0 - 0.0) / (1.0 - 0.0))))));
    float3 emission2_base = lerp(baseEmission, emission2, edge_threshold);
    float alpha_original = alpha + _Cutoff;

    float edge_emission = smoothstep((1.0 - _EdgeSize), 1.0, edge);

    float3 final_emission = ((alpha <= _DissolveEdgeSize) ? _DissolveEdgeColor : (emission2_base + (((1.0 + (_EdgeStrength - 0.0) * (0.1 - 1.0) / (1.0 - 0.0)) <= edge_emission) ? _EdgeColor : (_EdgeColor * edge_emission))));
    return final_emission;
}

//Vertex Offset
half3 GetMfxVertexOffset(float2 mfxUv, float3 vertexPos, float3 normal)
{
    float pos = GetMfxSinglePosition(vertexPos);
    float mask_pos = (pos - GetMfxMaskOffset());
    float edge_ramp = tex2Dlod(_EdgeRampMap1, float4(mfxUv.xy, 0, 0)).r;
    float edge_pos = (mask_pos - (GetMfxMaskOffset() - edge_ramp));
	float scaled_edge = ( (50.0 + (_EdgeSize - 0.0) * (0.0 - 50.0) / (1.0 - 0.0)) * edge_pos );
	float clamp_scaled_edge = clamp( scaled_edge , 0.0 , 1.0 );
	float edge = clamp( ( 1.0 - abs( scaled_edge ) ) , 0.0 , 1.0 );
	float edge_threshold = ( ( 1.0 - clamp_scaled_edge ) - edge );

    half3 temp_output = (saturate(((mask_pos - GetMfxMaskOffset()) + (_FringeSize + 0.5))) * tex2Dlod(_FringeRampMap, float4(mfxUv, 0, 0.0)));
    half3 local_vert_offset = (float4((edge_threshold * normal * _FringeAmount), 0.0) * temp_output);
    return local_vert_offset;
}

//--------------

#endif // MFX_INCLUDED
