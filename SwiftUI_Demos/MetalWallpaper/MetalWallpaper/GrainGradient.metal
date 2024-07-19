//
//  GrainGradient.metal
//  MetalWallpaper
//
//  Created by Lurich on 2024/7/19.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI.h>

using namespace metal;

float h00(float x) { return 2.0 * x * x * x - 3.0 * x * x + 1.0; }
float h10(float x) { return x * x * x - 2.0 * x * x + x; }
float h01(float x) { return 3.0 * x * x - 2.0 * x * x * x; }
float h11(float x) { return x * x * x - x * x; }

float hermite(float p0, float p1, float m0, float m1, float x) {
    return p0 * h00(x) + m0 * h10(x) + p1 * h01(x) + m1 * h11(x);
}

int getIndex(int x, int y, int2 gridSize, int lastIndex) {
    return clamp(y * gridSize.x + x, 0, lastIndex);
}

int4 getIndices(float2 gridCoords, int2 gridSize, int lastIndex) {
    int2 idStart = int2(gridCoords);
    int2 idEnd = int2(ceil(gridCoords));

    int4 id = int4(getIndex(idStart.x, idStart.y, gridSize, lastIndex),
                   getIndex(idEnd.x,   idStart.y, gridSize, lastIndex),
                   getIndex(idStart.x, idEnd.y, gridSize, lastIndex),
                   getIndex(idEnd.x,   idEnd.y, gridSize, lastIndex));
    return id;
}

half4 gridInterpolation(float2 coords, device const half4 *colors, float4 gridRange, int2 gridSize, int lastIndex, float time) {

    float a = sin(time * 1.0) * 0.5 + 0.5;
    float b = sin(time * 1.5) * 0.5 + 0.5;
    float c = sin(time * 2.0) * 0.5 + 0.5;
    float d = sin(time * 2.5) * 0.5 + 0.5;

    float y0 = mix(a, b, coords.x);
    float y1 = mix(c, d, coords.x);
    float x0 = mix(a, c, coords.y);
    float x1 = mix(b, d, coords.y);

    coords.x = hermite(0.0, 1.0, 2.0 * x0, 2.0 * x1, coords.x);
    coords.y = hermite(0.0, 1.0, 2.0 * y0, 2.0 * y1, coords.y);

    float2 gridCoords = coords * gridRange.zw;
    int4 id = getIndices(gridCoords, gridSize, lastIndex);

    float2 factors = smoothstep(float2(0.0), float2(1.0), fract(gridCoords));

    half4 result[2];
    result[0] = mix(colors[id.x], colors[id.y], factors.x);
    result[1] = mix(colors[id.z], colors[id.w], factors.x);

    return half4(mix(result[0], result[1], factors.y));
}

[[ stitchable ]]
half4 grainGradient(float2 position, float4 bounds, float size, float time, device const half4 *colors, int count) {

    const int2 gridSize = int2(size);
    const int4 gridRange = int4(0, 0, gridSize.x - 1, gridSize.y - 1);
    const int gridLastIndex = count - 1;

    float2 coords = position / bounds.zw;
    half4 result = gridInterpolation(coords, colors, float4(gridRange), gridSize, gridLastIndex, time * 0.20);

    float strength = 16.0;

    float x = (coords.x + 4.0 ) * (coords.y + 4.0 ) * 10.0;
    float4 grain = float4(fmod((fmod(x, 13.0) + 1.0) * (fmod(x, 123.0) + 1.0), 0.01)-0.005) * strength;

    result = result + half4(grain);

    return result;
}
