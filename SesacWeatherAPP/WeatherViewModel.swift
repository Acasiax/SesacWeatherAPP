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
        
        AF.request(urlString).responseDecodable(of: WeatherModel.self) { [weak self] response in
            guard let self = self else { return }
            
            switch response.result {
            case .success(var weather):
    
                if let iconCode = weather.weather.first?.icon {
                    weather.iconURL = self.iconURL(for: iconCode)
                }
                
                DispatchQueue.main.async {
                    self.weather.value = weather
                }
                
                completion(weather)
            case .failure:
                completion(nil)
            }
        }
    }

    
    private func fetchForecast(completion: @escaping ([Forecast]) -> Void) {
        let city = cityName.value.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(city)&appid=\(apiKey)&units=metric&lang=kr"
        
        AF.request(urlString).responseDecodable(of: WeatherResponse.self) { [weak self] response in
            guard let self = self else { return }
            
            switch response.result {
            case .success(let forecastResponse):
                // Fetch icon URLs for each forecast
                let forecasts = forecastResponse.list.map { forecast -> Forecast in
                    var updatedForecast = forecast
                    if let iconCode = forecast.weather.first?.icon {
                        updatedForecast.iconURL = self.iconURL(for: iconCode)
                    }
                    return updatedForecast
                }
                
                completion(forecasts)
            case .failure:
                completion([])
            }
        }
    }
    
    private func iconURL(for iconCode: String) -> URL? {
        return URL(string: "https://openweathermap.org/img/wn/\(iconCode)@2x.png")
    }
}
