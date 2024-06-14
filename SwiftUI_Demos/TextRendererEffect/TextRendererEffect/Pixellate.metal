//
//  Pixellate.metal
//  TextRendererEffect
//
//  Created by Lurich on 2024/6/14.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[stitchable]] float2 pixellate(float2 position, float size) {
    float2 pixellatePosition = round(position / size) * size;
    return pixellatePosition;
}


