//
//  SnowScreen.metal
//  WeatherAPPUI
//
//  Created by Lurich on 2024/3/7.
//

#define pi 3.1415926

#include <metal_stdlib>
using namespace metal;


// iq's hash function from https://www.shadertoy.com/view/MslGD8
float2 hash( float2 p ) { p=float2(dot(p,float2(127.1, 311.7)),dot(p,float2(269.5,183.3))); return fract(sin(p)*18.5453); }

float simplegridnoise(float2 v, float T)
{
    float2 fl = floor(v), fr = fract(v);
    float mindist = 1e9;
    for(int y = -1; y <= 1; y++)
        for(int x = -1; x <= 1;x++)
        {
            float2 offset = float2(x,y);
            float2 pos = .5 + .5 * cos(2.* pi * (T*.1 + hash(fl+offset)) + float2(0,1.6));
            mindist = min(mindist, length(pos+offset -fr));
        }
    return mindist;
}
float blobnoise(float2 v,  float s, float T)
{
    return pow(.5 + .5 * cos(pi * clamp(simplegridnoise(v, T)*2., 0.,  1.)), s);
}
float fractalblobnoise(float2 v,  float s, float T)
{
    float val = 0.;
    const float n = 4.;
    for(float i = 0.; i< n; i++)
        //val += 1.0 / (i +1.0)* blobnoise((i + 1.0) * v + vec2(0.0, iTime * 1.0), s);
        val += pow(0.5,  i+1.) * blobnoise(exp2(i)*v + float2(0, T), s, T);
    return val;
}
sampler textureSampler2;

[[ stitchable ]] half4 snowScreen(float2 pos,float4 boundingRect,  float iTime,texture2d<half> image) {
    float T = iTime;
    float2 r = float2(1.0, boundingRect[3]/ boundingRect[2]);
    float2 uv = pos;
    float2 UV = pos/float2(boundingRect[2], boundingRect[3]);
    
    uv.x =(pos.x - 0.5 *boundingRect[2]) / boundingRect[3];
    uv.y = (pos.y - 0.5 *boundingRect[3]) / boundingRect[3];
    
    uv.y = -uv.y;
    
    float val = fractalblobnoise(r * uv * 20.0, 5.0, T);
    
    half4 tex = image.sample(textureSampler2, UV, 1);
    half3 col = mix(tex,half4(1.0), half4(val)).rgb;
    
    return half4(col.r, col.g, col.b, 1);

}
