

// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
};

// Global variables
Texture2D<float4> Tex0 : register(t0);
sampler TexSampler0 : register(s0);

Texture2D<float4> lightmap : register(t1);
sampler lightmapSampler : register(s1);

cbuffer PS_VARIABLES : register(b0)
{
	int time_counter_var;
	int lightwidth;
	int lightheight;
	float4 bcolor;
	int is_border;
	float w_border;
};

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};

float4 ps_main(in PS_INPUT In) : SV_TARGET
{
	float4 diss_texture = lightmap.Sample(lightmapSampler, float2( (In.texCoord.x/fPixelWidth)/lightwidth,  (In.texCoord.y/fPixelHeight)/lightheight) );
	float4 color = 0;
	float time_counter = time_counter_var;
	if(diss_texture.r >= time_counter/255-w_border)
	{
		float4 maintexture = Tex0.Sample(TexSampler0, In.texCoord) * In.Tint;
		if( time_counter/255-w_border < diss_texture.r &&  diss_texture.r < time_counter/255 &&  length(maintexture)!=0 && is_border==1)
		{
			color = bcolor;
		}
		else
		{
			color = maintexture;
		}
	}

	return color;
}

float4 ps_main_pm(in PS_INPUT In) : SV_TARGET
{
	float4 diss_texture = lightmap.Sample(lightmapSampler, float2( (In.texCoord.x/fPixelWidth)/lightwidth,  (In.texCoord.y/fPixelHeight)/lightheight) );
	float4 color = 0;
	float time_counter = time_counter_var;
	if(diss_texture.r >= time_counter/255-w_border)
	{
		float4 maintexture = Tex0.Sample(TexSampler0, In.texCoord) * In.Tint;
		if( time_counter/255-w_border < diss_texture.r &&  diss_texture.r < time_counter/255 &&  length(maintexture)!=0 && is_border==1)
		{
			color = bcolor;
			color.rgb *= color.a;
		}
		else
		{
			color = maintexture;
		}
	}

	return color;
}
