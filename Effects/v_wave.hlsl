
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
	float amplitude;
	float wavefreq;
	float angle;
};

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};

float4 ps_main(in PS_INPUT In) : SV_TARGET
{
	In.texCoord.x+=amplitude*cos(angle +  In.texCoord.y*wavefreq);

	float4 color = 0;
	if(In.texCoord.x>=0&&In.texCoord.x<=1)
		color = Tex0.Sample(TexSampler0, In.texCoord) * In.Tint;

	return color;
}
