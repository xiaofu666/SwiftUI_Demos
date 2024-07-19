//
//  Leather.metal
//  MetalWallpaper
//
//  Created by Lurich on 2024/7/19.
//

#include <metal_stdlib>
using namespace metal;

// MARK: - Base grain

float2 hash(float2 p) {
    p = float2(dot(p, float2(127.1,311.7)), dot(p,float2(269.5,183.3)));
    return fract(p);
}

float3 voronoi(float2 x) {
    float2 n = floor(x);
    float2 f = fract(x);

    float2 mg, mr;

    float3 m = float3( 8.0 );
    for(int j=-1; j<=1; j++) {
        for(int i=-1; i<=1; i++) {
            float2  g = float2(float(i), float(j));
            float2  o = hash( n + g );

            float2  r = g - f + o;
            float d = dot(r, r);

            if( d<m.x ){
                mr = r;
                mg = g;
                m = float3( d, o.x,o.y);
            }
        }
    }

    float md = 8.0 ;
    for( int j=-2; j<=2; j++ ){
        for( int i=-2; i<=2; i++ ){
            float2 g = mg + float2(float(i),float(j));
            float2 o = hash( n + g );
            float2 r =  g - f + o;

            if(dot(mr - r, mr - r) > 0.00001) {
                md = min(md, dot( 0.5 * (mr + r), normalize(r - mr)));
            }
        }
    }
    return float3( sqrt(m.x), m.y*m.z, md );
}

// MARK: - Lighting & shadows

struct Vibe { float3 a0, a1, b1, a2, b2; };

float2 doubleAngleIdentities(float2 n){
    return float2(n.x * n.x - n.y*n.y, 2.0 * n.x * n.y);
}

Vibe fourierAdd(float3 delta, float3 color, Vibe vibe){
    float3 direction = normalize(delta);
    float distRatio = min(1.0, 0.1/length(delta.xy));
    float distFactor = sqrt(1.0 - distRatio * distRatio);

    const float c0 = 0.318309886184;
    vibe.a0 += mix(c0, 1.0, direction.z) * color;

    float c1 = 0.3183 + 0.1817 * distFactor;
    float2 g1 = -c1 * direction.xy;
    vibe.a1 += g1. x *color;
    vibe.b1 += g1.y * color;

    float c2 = 0.2122 * distFactor;
    float2 g2 = c2 * doubleAngleIdentities(-direction.xy);
    vibe.a2 += g2.x * color;
    vibe.b2 += g2.y * color;
    return vibe;
}

float3 fourierApply(float3 n, Vibe vibe){
    float2 g1 = n.xy;
    float2 g2 = doubleAngleIdentities(g1);
    return vibe.a0 + vibe.a1 * g1.xxx + vibe.b1 * g1.yyy + vibe.a2 * g2.xxx + vibe.b2 * g2.yyy;
}

float2 transformGradient(float2 basis, float h){
    float2 m1 = dfdx(basis), m2 = dfdy(basis);
    float2x2 adjoint = float2x2(m2.y, -m2.x, -m1.y, m1.x);

    float eps = 1e-7;
    float det = m2.x * m1.y - m1.x * m2.y + eps;
    return float2(dfdx(h), dfdy(h))*adjoint/det;
}

// MARK: - Normals

float3 bumpMap(float2 uv, float height, half4 col){
    float value = height * col.r;
    float2 gradient = transformGradient(uv, value);
    return float3(gradient, 1.0 - dot(gradient, gradient));
}

// MARK: - Shader

[[ stitchable ]]
half4 leather(float2 position, float4 bounds, half4 color, float time) {
    float2 p = position / max(bounds.z, bounds.w);
    float2 coords = position / bounds.zw;

    // create the base grain

    float3 c = voronoi(30.0 * p);
    float3 d = voronoi(20.0 * p);

    float2 hashing = hash(float2(0.0, c.y)) * 30.0;
    c.y *= hashing.x * hashing.y;
    c.y = fract(c.y);

    hashing = hash(float2(0.0, d.y)) * 30.0;
    d.y *= hashing.x * hashing.y;
    d.y = fract(d.y);

    half4 col = half4(1);

    float strength = 20.0;

    float x = (p.x + 4.0 ) * (coords.y + 4.0 ) * 10.0;
    half4 grain = half4(fmod((fmod(x, 13.0) + 1.0) * (fmod(x, 123.0) + 1.0), 0.01)-0.005) * strength;
    col += min(col, grain);

    half4 edge = half4(half3(smoothstep( 0.04, 0.17, c.z)), 1.0) * 0.6;
    half4 secondaryEdge = half4(half3(smoothstep( 0.04, 0.17, d.z)), 1.0) + 0.6;
    edge *= secondaryEdge;
    col = col * edge;

    // create some ambient color

    float3 ambient = float3(0.01, 0.01, 0.01);
    Vibe vibe;
    vibe.a0 = ambient;
    vibe.a1 = float3(0.0);
    vibe.b1 = float3(0.0);
    vibe.a2 = float3(0.0);
    vibe.b2 = float3(0.0);

    float3 dir = float3(1.0, 1.0, 0.0);
    vibe = fourierAdd(dir, float3(0.2, 0.2, 0.2), vibe);

    // add an animated light source

    float2 light = float2(sin(time * 0.6), 0.1);
    float2 delta = coords - light;
    float3 lightInt = float3(delta, 0.2);
    float3 lightColor = float3(color.xyz) * 0.4 * max(0.0, 0.7 - length(delta) / 2.75);
    vibe = fourierAdd(lightInt, lightColor, vibe);

    // calculate the normals
    float3 n = bumpMap(coords, 0.014, col * 0.15);

    // apply the magic
    
    col.xyz = half3(fourierApply(n, vibe));

    return col;
}

