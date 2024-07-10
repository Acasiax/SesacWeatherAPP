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
    var cityName: Observable<String> = Observable("")
    private let apiKey = APIKey.weatherAPIKey
    
    init() {
        cityName.bind { cityName in
            self.fetchWeather(completion: { weather in
                DispatchQueue.main.async {
                    self.weather.value = weather
                }
            })
        }
    }
    
    func fetchWeather(completion: @escaping (WeatherModel?) -> Void) {
        let city = cityName.value.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        
        AF.request(urlString).responseDecodable(of: WeatherModel.self) { response in
            switch response.result {
            case .success(let weather):
                completion(weather)
            case .failure:
                completion(nil)
            }
        }
    }
}


