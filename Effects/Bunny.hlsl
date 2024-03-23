
// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color   : SV_TARGET;
};

// Global variables
Texture2D<float4> Tex0 : register(t0);
sampler Tex0Sampler : register(s0);

Texture2D<float4> lookup : register(t1);
sampler lookupSampler : register(s1);

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
	
	Out.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x,In.texCoord.y));
	
	float4 search;
	float pos;
	int i = 0;
	
	for (i = 0;i < 8; i++ )
	{
		pos = i * 1/8.0 + 0.0625;
		search = lookup.Sample(lookupSampler, float2(0, pos));
	
		if (Out.Color.r == search.r && Out.Color.g == search.g && Out.Color.b == search.b)
		{
			Out.Color.rgb = lookup.Sample(lookupSampler, float2(0.75, pos)).rgb;
		}
	}
	Out.Color *= In.Tint;
	
    return Out;
}

PS_OUTPUT ps_main_pm( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
	
	Out.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x,In.texCoord.y));
	if ( Out.Color.a != 0 )
		Out.Color.rgb /= Out.Color.a;
	
	float4 search;
	float pos;
	int i = 0;
	
	for (i = 0;i < 8; i++ )
	{
		pos = i * 1/8.0 + 0.0625;
		search = lookup.Sample(lookupSampler, float2(0, pos));
		if ( search.a != 0 )
			search.rgb /= search.a;

		if (Out.Color.r == search.r && Out.Color.g == search.g && Out.Color.b == search.b)
		{
			float4 lk = lookup.Sample(lookupSampler, float2(0.75, pos));
			if ( lk.a != 0 )
				lk.rgb /= lk.a;
			Out.Color.rgb = lk.rgb;
		}
	}
	Out.Color.rgb *= Out.Color.a;
	Out.Color *= In.Tint;
	
    return Out;
}
