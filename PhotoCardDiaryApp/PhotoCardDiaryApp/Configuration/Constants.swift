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
    private init() { }
}

public struct Icon {
    static let xMark = "xmark"
    static let glass = "magnifyingglass"
    static let write = "highlighter"
    static let calendar = "calendar"
    static let sunMin = "sun.min"
    static let sunMax = "sum.max"
    static let bolt = "cloud.bolt"
    static let fog = "cloud.fog"
    static let snow = "cloud.snow"
    static let rain = "cloud.rain"
    static let drizzle = "cloud.drizzle"
    
    static let add = "imgAdd"
    static let noData = "noData"
    static let noResult = "noResult"
}

public struct CellName {
    static let photoCardCell = "PhotoCardCell"
    static let collectCell = "CollectCell"
    static let resultCell = "ResultCell"
}
