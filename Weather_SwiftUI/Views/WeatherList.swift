//
//  ContentView.swift
//  Weather_SwiftUI
//
//  Created by 村尾慶伸 on 2020/07/02.
//  Copyright © 2020 村尾慶伸. All rights reserved.
//

import SwiftUI
import Combine

struct WeatherList: View {
    @ObservedObject private var viewModel = WeatherListViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Text(viewModel.name)
                Text(viewModel.main)
            }
            .onAppear {
                self.viewModel.fetchWeatherData()
            }
            .navigationBarTitle("Weather")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherList()
    }
}

class WeatherListViewModel: ObservableObject {

    var name: String = ""
    var main: String = ""

    private let weatherModel = WeatherModel()

    var cancellable: AnyCancellable?

    func fetchWeatherData() {

        cancellable = weatherModel.fetchWeather()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error \(error.localizedDescription)")
                }
            }, receiveValue: { weatherDataContainer in
                self.name = weatherDataContainer.name
                self.main = weatherDataContainer.weather.first!.main
            })
    }

}
