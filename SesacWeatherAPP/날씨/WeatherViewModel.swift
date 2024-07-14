//
//  WeatherViewModel.swift
//  SesacWeatherAPP
//
//  Created by 이윤지 on 7/10/24.
//

import Foundation
import Alamofire

class WeatherViewModel {
    var weather: Observable<WeatherModel?> = Observable(nil)
    var forecasts: Observable<[Forecast]> = Observable([])
    var cityName: Observable<String> = Observable("")
    private let apiKey = APIKey.weatherAPIKey
    
    init() {
        cityName.bind { [weak self] cityName in
            self?.fetchWeather { weather in
                DispatchQueue.main.async {
                    self?.weather.value = weather
                }
            }
            self?.fetchForecast { forecasts in
                DispatchQueue.main.async {
                    self?.forecasts.value = forecasts
                }
            }
        }
    }
    
    private func fetchWeather(completion: @escaping (WeatherModel?) -> Void) {
        let city = cityName.value.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric&lang=kr"
        
        AF.request(urlString).responseDecodable(of: WeatherModel.self) { response in
            switch response.result {
            case .success(let weather):
                completion(weather)
            case .failure:
                completion(nil)
            }
        }
    }
    
    private func fetchForecast(completion: @escaping ([Forecast]) -> Void) {
        let city = cityName.value.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(city)&appid=\(apiKey)&units=metric&lang=kr"
        
        AF.request(urlString).responseDecodable(of: WeatherResponse.self) { response in
            switch response.result {
            case .success(let forecastResponse):
                completion(forecastResponse.list)
            case .failure:
                completion([])
            }
        }
    }
}
