//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Abdulloh Bahromjonov on 04/06/25.
//

import Foundation

class WeatherViewModel: ObservableObject {
    @Published var fiveDayForecast: ForecastResponse?
    @Published var state: ViewModelState = .neutral
    @Published var errorMessage = ""
    
    private let baseUrl = "https://api.openweathermap.org/data/2.5/"
    private let apiKey = "3f01ac15545ea5842ab115df67e5f402"
    
    let client = APIClient.self
    
    func getWeather(for city: String) {
        let urlString = "\(baseUrl)forecast?q=\(city)&appid=\(apiKey)"
        
        APIClient.shared.get(url: urlString) { (result: Result<ForecastResponse, APIError>) in
            switch result {
            case .success(let forecast):
                self.fiveDayForecast = forecast
                self.state = .success
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func reset() {
        fiveDayForecast = nil
        state = .neutral
    }
}

enum ViewModelState {
    case neutral, loading, success, error
}
