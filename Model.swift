//
//  Model.swift
//  SesacWeatherAPP
//
//  Created by 이윤지 on 7/11/24.
//

import Foundation

struct APIKey {
    static let weatherAPIKey = "98452eee52fc2e5b3aa9be02efc8a3fb"
}

// 현재 날씨 데이터 모델
struct WeatherModel: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let wind: Wind
    var iconURL: URL?
}

struct Main: Codable {
    let temp: Double
    let pressure: Double
    let humidity: Double
    let temp_min: Double
    let temp_max: Double
}

struct Weather: Codable {
    let description: String
    let icon: String
}

struct Wind: Codable {
    let speed: Double
}

// 일주일 날씨 데이터 모델
struct DailyWeather: Codable {
    let dt: Int
    let temp: Temperature
    let weather: [Weather]
}

struct Temperature: Codable {
    let day: Double
}

struct WeeklyWeather: Codable {
    let daily: [DailyWeather]
}


struct WeatherResponse: Codable {
    let list: [Forecast]
}

struct Forecast: Codable {
    let dt: Int
    let main: Main
    let weather: [Weather]
    let dt_txt: String
    var iconURL: URL?
}



struct DailyForecast {
    let date: String
    let temp: Double
    let description: String
}

