//
//  ForecastResponse.swift
//  WeatherApp
//
//  Created by Abdulloh Bahromjonov on 04/06/25.
//

import Foundation

struct ForecastResponse: Codable {
    let cod: String
    let list: [List]
    let city: City
}
