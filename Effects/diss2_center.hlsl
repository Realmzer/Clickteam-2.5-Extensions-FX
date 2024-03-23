
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
	float2 newinput;
	float2 Center=float2(0.5,0.5);
	float dist = distance(Center,In.texCoord);
	float time_counter = time_counter_var;

	newinput.x = (In.texCoord.x-0.5) * (dist+time_counter*0.01)/dist + 0.5;
	newinput.y = (In.texCoord.y-0.5) * (dist+time_counter*0.01)/dist + 0.5;

	float4 color = 0;
	if (newinput.x<=1 && newinput.x>=0 && newinput.y<=1 && newinput.y>=0)
		color = Tex0.Sample(TexSampler0, newinput) * In.Tint;

	return color;
}

