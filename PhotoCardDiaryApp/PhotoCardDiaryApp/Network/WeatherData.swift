//
//  WeatherData.swift
//  PhotoCardDiaryApp
//
//  Created by 효우 on 2022/10/14.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
    let description: String
}
