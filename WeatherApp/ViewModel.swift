//
//  ViewModel.swift
//  WeatherApp
//
//  Created by Abdulloh Bahromjonov on 04/06/25.
//

import Foundation
import Combine
import CoreLocation

// MARK: - ViewModel
class WeatherViewModel: ObservableObject {
    private let baseUrl = "https://api.openweathermap.org/data/2.5/"
    private let apiKey = "3f01ac15545ea5842ab115df67e5f402"
    private var cancellables = Set<AnyCancellable>()
    
    @Published var fiveDayForecast: ForecastResponse?
    @Published var state: ViewModelState = .neutral
    
    func getWeather(for city: String) async {
        state = .loading
        
        let urlString = "\(baseUrl)forecast?q=\(city)&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            state = .error
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let httpResponse = response as? HTTPURLResponse
                print("ERROR: \(String(describing: httpResponse))")
                return
            }
            
            fiveDayForecast = try JSONDecoder().decode(ForecastResponse.self, from: data)
        } catch {
            print("ERROR: \(error)")
        }
        
    }
    
    func reset() {
        fiveDayForecast = nil
        state = .neutral
    }
}

// MARK: - ViewModel State Enum
enum ViewModelState {
    case neutral, loading, success, error
}
