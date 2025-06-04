//
//  ContentView.swift
//  WeatherApp
//
//  Created by Abdulloh Bahromjonov on 04/06/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = WeatherViewModel()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            viewModel.getWeather(for: "Moscow")
            print(viewModel.fiveDayForecast)
        }
    }
}

#Preview {
    ContentView()
}
