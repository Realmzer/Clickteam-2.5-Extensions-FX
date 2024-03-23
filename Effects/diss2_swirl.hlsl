
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
	int radius_var;
	float angle;	//  = 0.8;
	float scale;
};

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};


float4 ps_main(in PS_INPUT In) : SV_TARGET
{
	float image_w = 1/fPixelWidth;
	float image_h = 1/fPixelHeight;
	float2 center = float2( image_w/2,  image_h/2);

	float2 textureSize = float2(image_w,image_h);
	float2 current_coord = In.texCoord * textureSize;

	current_coord -= center;

	float distance = length(current_coord);

	float radius = radius_var;
	if (distance < radius) 
	{
		float percent = (radius - distance) / radius;
		float temp_angle = percent * percent * angle * 8.0;
		float s = sin(temp_angle);
		float c = cos(temp_angle);
		current_coord = float2(dot(current_coord, float2(c, -s)), dot(current_coord, float2(s, c)));
	}

	//  сurrent_coord *= scale;
	current_coord = current_coord/scale;
	current_coord += center;
	current_coord/=textureSize;

	float4 color = 0;
	if(current_coord.x>=0 && current_coord.x<=1 && current_coord.y>=0 && current_coord.y<=1)
		color = Tex0.Sample(TexSampler0, current_coord) * In.Tint;

	return color;

}
