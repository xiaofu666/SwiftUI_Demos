//
//  BackgroundMaterial.swift
//  MetalWallpaper
//
//  Created by Lurich on 2024/7/19.
//

import SwiftUI


// more metal effect from https://www.shadertoy.com/view/MslGD8

// MARK: - Grainy gradient
extension ShapeStyle where Self == AnyShapeStyle {
    static func grainGradient(time: TimeInterval, gridSize: Int = 3) -> Self {
        // MARK: - Gradient colors
        let tl = Color("top_left")
        let tc = Color("top_center")
        let tr = Color("top_right")

        let ml = Color("middle_left")
        let mc = Color("middle_center")
        let mr = Color("middle_right")

        let bl = Color("bottom_left")
        let bc = Color("bottom_center")
        let br = Color("bottom_right")
        return AnyShapeStyle(ShaderLibrary.default.grainGradient(
            .boundingRect,
            .float(3),
            .float(time),
            .colorArray([tl, tc, tr,
                         ml, mc, mr,
                         bl, bc, br])
        ))
    }
}

// MARK: - Leather
extension ShapeStyle where Self == AnyShapeStyle {
    static func leather(lightColor: Color, time: TimeInterval) -> Self {
        return AnyShapeStyle(ShaderLibrary.default.leather(
            .boundingRect,
            .color(lightColor),
            .float(time)
        ))
    }
}

// MARK: - Rain
extension ShapeStyle where Self == AnyShapeStyle {
    static func rain(image: Image, time: TimeInterval) -> Self {
        return AnyShapeStyle(ShaderLibrary.default.heartfelt(
            .boundingRect,
            .float(time),
            .image(image)
        ))
    }
}

// MARK: - Snow
extension ShapeStyle where Self == AnyShapeStyle {
    static func snow(image: Image, time: TimeInterval) -> Self {
        return AnyShapeStyle(ShaderLibrary.default.snowScreen(
            .boundingRect,
            .float(time),
            .image(image)
        ))
    }
}
