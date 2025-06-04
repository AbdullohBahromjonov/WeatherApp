//
//  ErrorResponse.swift
//  WeatherApp
//
//  Created by Abdulloh Bahromjonov on 05/06/25.
//

import Foundation

struct ErrorResponse: Decodable {
    let cod: String
    let message: String
}
