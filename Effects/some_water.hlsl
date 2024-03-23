
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
};

Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);

Texture2D<float4> bkd : register(t1);
sampler bkdSampler : register(s1);

Texture2D<float4> normalmap : register(t2);
sampler normalmapSampler : register(s2);

cbuffer PS_VARIABLES : register(b0)
{
	float4 watercolor;
	float time_x;
	float time_y;
	int  normalwidth;
	int  normalheight;
	int reflect;
	int refract;
	float angle;
	float waveamplitude;
	int wavefreq;
	int needtopborderline;
	float4 topborderlinecolor;
};

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};


float4 ps_main(in PS_INPUT In) : SV_TARGET
{
	float top = 0.5 + (cos(angle +  In.texCoord.x*wavefreq))*waveamplitude+  sin(angle+1 + In.texCoord.x*(wavefreq*1.8))*(waveamplitude*0.8);

	float4 color;
	if (In.texCoord.y > top)
	{
		float3  my_normalmap = normalmap.Sample(normalmapSampler, float2( (In.texCoord.x/fPixelWidth)/normalwidth + time_x,  (In.texCoord.y/fPixelHeight)/normalheight + time_y) ).rgb;
		float2 refr_offset = ( my_normalmap.xy*2 - 1)*0.05;
		float4 refraction = 0;

		if(refract ==1)
		{
			refraction = bkd.Sample(bkdSampler, float2(clamp(In.texCoord.x+refr_offset.x,0.001,0.999),clamp(In.texCoord.y+refr_offset.y,top,0.999)) );
		}

		float4 reflection = 0;
		if(reflect == 1)
		{
			reflection = bkd.Sample(bkdSampler, float2(clamp(In.texCoord.x+refr_offset.x,0.001,0.999),clamp (top-(In.texCoord.y+refr_offset.y-top),0.001,top) ));
			reflection.a =length(top);
		}
		
		if(refract ==1 && reflect ==1)
		{
			color = (watercolor * lerp( refraction , reflection , reflection.a)).rgba;
		}
		else
		{
			if(refract==1)
			{
				color = watercolor*refraction;
			}
			else
			{
				if(reflect == 1)
				{
					color = watercolor*reflection;
				}
				else
				{
					color = watercolor;
				}
			}
		}
		//

		color.a = 1;
	}
	else 
	{
		if((needtopborderline==1) && (In.texCoord.y<=top)&& (In.texCoord.y>=top-0.02))  
		{
			color = topborderlinecolor;
			color.a=0.17;
		}
		else
		{
			color=0;
		}
	}

	return color;
}

float4 ps_main_pm(in PS_INPUT In) : SV_TARGET
{
	float top = 0.5 + (cos(angle +  In.texCoord.x*wavefreq))*waveamplitude+  sin(angle+1 + In.texCoord.x*(wavefreq*1.8))*(waveamplitude*0.8);

	float4 color;
	if (In.texCoord.y > top)
	{
		float3  my_normalmap = normalmap.Sample(normalmapSampler, float2( (In.texCoord.x/fPixelWidth)/normalwidth + time_x,  (In.texCoord.y/fPixelHeight)/normalheight + time_y) ).rgb;
		float2 refr_offset = ( my_normalmap.xy*2 - 1)*0.05;
		float4 refraction = 0;

		if(refract ==1)
		{
			refraction = bkd.Sample(bkdSampler, float2(clamp(In.texCoord.x+refr_offset.x,0.001,0.999),clamp(In.texCoord.y+refr_offset.y,top,0.999)) );
			if ( refraction.a != 0 )
				refraction.rgb /= refraction.a;
		}

		float4 reflection = 0;
		if(reflect == 1)
		{
			reflection = bkd.Sample(bkdSampler, float2(clamp(In.texCoord.x+refr_offset.x,0.001,0.999),clamp (top-(In.texCoord.y+refr_offset.y-top),0.001,top) ));
			if ( reflection.a != 0 )
				reflection.rgb /= reflection.a;
			reflection.a =length(top);
		}
		
		if(refract ==1 && reflect ==1)
		{
			color = (watercolor * lerp( refraction , reflection , reflection.a)).rgba;
		}
		else
		{
			if(refract==1)
			{
				color = watercolor*refraction;
			}
			else
			{
				if(reflect == 1)
				{
					color = watercolor*reflection;
				}
				else
				{
					color = watercolor;
				}
			}
		}
		//

		color.a = 1;
	}
	else 
	{
		if((needtopborderline==1) && (In.texCoord.y<=top)&& (In.texCoord.y>=top-0.02))  
		{
			color = topborderlinecolor;
			color.a=0.17;
			color.rgb *= color.a;
		}
		else
		{
			color=0;
		}
	}

	return color;
}
