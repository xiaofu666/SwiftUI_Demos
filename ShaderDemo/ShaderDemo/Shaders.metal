//
//  Shaders.metal
//  SwiftUI_iOS17_Demo
//
//  Created by Lurich on 2023/6/26.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]] float2 pixellate(float2 position, float size) {
    float2 pixellatedPosition = round(position / size) * size;
    return pixellatedPosition;
}

[[ stitchable ]] float2 wave(float2 position, float time, float speed, float frequency, float amplitude) {
    float positionY = position.y + sin((time * speed) + (position.x / frequency)) * amplitude;
    return float2(position.x, positionY);
}

[[ stitchable ]] half4 grayscale(float2 position, SwiftUI::Layer layer) {
    half4 originalColor = layer.sample(position);
    float grayscaleValue = (originalColor.r + originalColor.g + originalColor.b) / 3.0;
    return half4(grayscaleValue, grayscaleValue, grayscaleValue, originalColor.a);
}
