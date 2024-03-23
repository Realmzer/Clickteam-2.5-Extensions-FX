
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
Texture2D<float4> Texture0 : register(t0);
sampler TextureSampler0 : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
	int iSaturation = 0.5;

	int iScanline;
	float iScanLineCount = 240;
	float iScanLineMin = 0.0;
	float iScanLineMax = 0.0;

	int iAberracao;

	float iCorVermelho = 2.0;
	float iCorVerde = 2.0;
	float iCorAzul = 2.0;

	float iAberracaoDistortion = 0.003;
	int iRadial;
	float iRadialDistortion = 0.05;
};

float2 TubeDistortion(float2 inUV) 
{ 
	float minSize = iRadialDistortion * 0.098;
	float maxSize = 1.0 - (minSize);

	float2 outUV = inUV;
	outUV *= (maxSize - minSize);
	outUV += minSize;

	float2 cc = outUV - 0.5;
	float dt = dot(cc, cc)*iRadialDistortion;
	return outUV + cc*(1.0 + dt)*dt;
} 

PS_OUTPUT ps_main( in PS_INPUT In )
{
	  // Output pixel
	PS_OUTPUT Out;
		float2 frontUV = In.texCoord.xy; 
		

		// Tube distortion
		if( iRadial == 1 )
			frontUV = TubeDistortion( In.texCoord.xy );

		// Chromatic Aberration
		float4 back = Texture0.Sample(TextureSampler0, frontUV);
		if( iAberracao == 1 ) {
			back.r = Texture0.Sample(TextureSampler0, frontUV + float2(iAberracaoDistortion,0.0)).r * iCorVermelho;
			back.b = Texture0.Sample(TextureSampler0, frontUV + float2(iAberracaoDistortion,0.0)).b * iCorAzul;
			back.g = back.g * iCorVerde;
		}



		// Scanline
		float scanLine = 1;
		if( iScanline == 1 ) {
			scanLine = abs(sin(frontUV.y*(iScanLineCount*2.0)));
			scanLine *= (iScanLineMax - iScanLineMin);
			scanLine += iScanLineMin;
		}

		Out.Color.rgb = back.rgb * scanLine;

		if( frontUV.x < 0.0 || frontUV.x > 1.0 || 
			frontUV.y < 0.0 || frontUV.y > 1.0 ) {
			Out.Color = float4(0.0,0.0,0.0,1.0);
		}

		float gray = Out.Color.r * 0.2126 + Out.Color.g * 0.7152 + Out.Color.b * 0.0722;
		Out.Color = lerp( Out.Color, float4( gray, gray, gray, 1.0 ), iSaturation ) * In.Tint;
	return Out;
}
