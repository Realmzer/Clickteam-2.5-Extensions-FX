
// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
};

// Global variables
Texture2D<float4> Tex0 : register(t0);
sampler TexSampler0 : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
	int time_counter_var;
	float random_clickteam;
};

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};


float nrand(float2 uv)
{
    return frac(sin(dot(uv, float2(12.9898, 78.233))) * 43758.5453);
}

float4 ps_main(in PS_INPUT In) : SV_TARGET
{
	float4 maintexture = Tex0.Sample(TexSampler0, In.texCoord) * In.Tint;
	float time_counter = time_counter_var;
	maintexture.a =clamp(maintexture.a  - random_clickteam - nrand(In.texCoord)*time_counter/5-time_counter/140,0,1);
	return maintexture;
}

float4 ps_main_pm(in PS_INPUT In) : SV_TARGET
{
	float4 maintexture = Tex0.Sample(TexSampler0, In.texCoord) * In.Tint;
	if ( maintexture.a != 0 )
		maintexture.rgb /= maintexture.a;
	float time_counter = time_counter_var;
	maintexture.a =clamp(maintexture.a  - random_clickteam - nrand(In.texCoord)*time_counter/5-time_counter/140,0,1);
	maintexture.rgb *= maintexture.a;
	return maintexture;
}
