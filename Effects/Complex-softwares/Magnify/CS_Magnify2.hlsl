// Global variables
//sampler2D Tex0;
Texture2D<float4> bkd : register(t1);
sampler bkdSampler : register(s1);

cbuffer PS_VARIABLES : register(b0)
{
	float fZoom;
	float fX;
	float fY;
};

// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

float4 ps_main( in PS_INPUT In ) : SV_TARGET
{
	float2 newCoord;
	newCoord.x = ((In.texCoord.x-0.5)/fZoom)+fX;
	newCoord.y = ((In.texCoord.y-0.5)/fZoom)+fY; 
	
	float4 newColor = bkd.Sample( bkdSampler, newCoord ); 
	
    return newColor;
}
