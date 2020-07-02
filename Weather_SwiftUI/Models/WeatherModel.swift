//
//  Weather.swift
//  Weather_SwiftUI
//
//  Created by 村尾慶伸 on 2020/07/02.
//  Copyright © 2020 村尾慶伸. All rights reserved.
//

import Foundation
import Combine

final class WeatherModel {
    let apiKey = "0e4203375ffd67b9320a9e4c2bdb8d7c"

    var components: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/weather"
        components.queryItems = [URLQueryItem(name: "q", value: "London"), URLQueryItem(name: "appid", value: apiKey)]
        return components
    }

    func fetchWeather() -> AnyPublisher<WeatherDataContainer, Error> {
        return URLSession.shared.dataTaskPublisher(for: components.url!)
            .map { $0.data }
            .decode(type: WeatherDataContainer.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()

    }

}

struct WeatherDataContainer: Decodable, Hashable {
    let name: String
    let weather: [Weather]
}

struct Weather: Decodable, Hashable {
    let main: String
}
