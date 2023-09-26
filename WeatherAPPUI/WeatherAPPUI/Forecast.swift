//
//  Forecast.swift
//  WeatherAPPUI
//
//  Created by Lurich on 2021/6/18.
//

import SwiftUI

// sample model and ten days data

struct DayForecast: Identifiable {
    
    var id = UUID().uuidString
    var day: String
    var farenheit: CGFloat
    var image: String
}

var forecast = [
    
    DayForecast(day: "Today", farenheit: 94, image: "sun.min"),
    DayForecast(day: "Wed", farenheit: 94, image: "cloud.sun"),
    DayForecast(day: "Tue", farenheit: 94, image: "cloud.sun.bolt"),
    DayForecast(day: "Thu", farenheit: 94, image: "sun.max"),
    DayForecast(day: "Fri", farenheit: 94, image: "cloud.sun"),
    DayForecast(day: "Sat", farenheit: 94, image: "sun.min"),
    DayForecast(day: "Sun", farenheit: 94, image: "sun.max"),
    DayForecast(day: "Mon", farenheit: 94, image: "sun.min"),
    DayForecast(day: "Wed", farenheit: 94, image: "cloud.sun"),
    DayForecast(day: "Tue", farenheit: 94, image: "cloud.sun.bolt"),
    DayForecast(day: "Thu", farenheit: 94, image: "sun.max"),
    DayForecast(day: "Fri", farenheit: 94, image: "cloud.sun"),
    DayForecast(day: "Sat", farenheit: 94, image: "sun.min"),
    DayForecast(day: "Sun", farenheit: 94, image: "sun.max"),
    
]
