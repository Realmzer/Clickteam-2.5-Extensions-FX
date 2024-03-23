
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
	float4 color = 0;
	if( curheight <= (1/fPixelHeight - time_counter) || (uint)curheight % 2 == 0  )
	{
		if((time_counter <= 1/fPixelHeight) || ((1/fPixelHeight-(time_counter-1/fPixelHeight)) >= curheight ) )
			color = Tex0.Sample(TexSampler0, In.texCoord) * In.Tint;
	}

	return color;
}
