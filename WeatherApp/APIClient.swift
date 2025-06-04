//
//  APIClient.swift
//  WeatherApp
//
//  Created by Abdulloh Bahromjonov on 04/06/25.
//

import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
    case serverError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL provided"
        case .networkError(let error):
            return "Network error occurred: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response received from server"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .serverError(let message):
            return message
        }
    }
}

class APIClient {
    static let shared = APIClient()
    private let session: URLSession
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        self.session = URLSession(configuration: config)
    }
    
    func get<T: Decodable>(
        url: String,
        headers: [String: String] = [:],
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let decoder = JSONDecoder()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                if (200...299).contains(httpResponse.statusCode) {
                    let decodedResponse = try decoder.decode(T.self, from: data)
                    completion(.success(decodedResponse))
                } else {
                    let decodedError = try decoder.decode(ErrorResponse.self, from: data)
                    completion(.failure(.serverError(decodedError.message)))
                }
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        
        task.resume()
    }
}


