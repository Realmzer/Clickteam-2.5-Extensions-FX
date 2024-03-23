
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
};

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};


float4 ps_main(in PS_INPUT In) : SV_TARGET
{
	int curheight =  In.texCoord.y/fPixelHeight;
	float time_counter = time_counter_var;
	In.texCoord.y =  In.texCoord.y - time_counter*fPixelHeight;

	float4 color = 0;
	if( curheight >= time_counter  )
		color = Tex0.Sample(TexSampler0, In.texCoord) * In.Tint;

	return color;
}
