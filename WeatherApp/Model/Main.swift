//
//  Main.swift
//  WeatherApp
//
//  Created by Abdulloh Bahromjonov on 04/06/25.
//

import Foundation

struct Main: Codable {
    let temp: Double
    let tempMin: Double
    let tempMax: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}
