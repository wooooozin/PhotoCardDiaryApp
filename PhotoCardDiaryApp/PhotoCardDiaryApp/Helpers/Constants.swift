//
//  Constants.swift
//  PhotoCardDiaryApp
//
//  Created by 효우 on 2022/10/13.
//

import Foundation

public struct WeatherApi {
    static let requestUrl = "https://api.openweathermap.org/data/2.5/weather?appid=47228ae38ba58f5d99a291937c257ebd&units=metric"
}

public struct CVCell {
    static let spacingWitdh: CGFloat = 10
    static let cellColumns: CGFloat = 2
    private init() {}
}
