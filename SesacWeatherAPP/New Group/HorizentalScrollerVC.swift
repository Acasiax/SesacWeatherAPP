//
//  SecondViewController.swift
//  SesacWeatherAPP
//
//  Created by 이윤지 on 7/13/24.
//
import UIKit
import Alamofire
import SnapKit

class WeatherViewController: BaseViewController, UITableViewDataSource {

    let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    // 날씨 예보 데이터를 저장할 배열
    var forecastData: [DailyForecast] = []
    let weatherService = WeatherService()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureConstraints()
        configureView()
    }
    
    
    override func configureHierarchy() {
        view.addSubview(tableView)
    }
    
   
    override func configureConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

   
    override func configureView() {
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "WeatherCell")
        
        weatherService.fetchWeatherData { [weak self] forecasts in
            guard let self = self else { return }
            if let forecasts = forecasts {
                self.forecastData = forecasts
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastData.count
    }

   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
        let forecast = forecastData[indexPath.row]
        cell.textLabel?.text = "\(forecast.date): \(forecast.temp)°C, \(forecast.description)"
        return cell
    }
}


class WeatherService {
    let apiKey = APIKey.weatherAPIKey
    let cityId = "1835847" // 서울

    func fetchWeatherData(completion: @escaping ([DailyForecast]?) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?id=\(cityId)&appid=\(apiKey)&units=metric&lang=kr"
        
        AF.request(urlString).responseDecodable(of: WeatherResponse.self) { response in
            switch response.result {
            case .success(let weatherResponse):
                let weeklyForecasts = self.processWeatherData(weatherResponse)
                completion(weeklyForecasts)
            case .failure(let error):
                print("날씨 데이터를 fetch하는데 오류: \(error)")
                completion(nil)
            }
        }
    }

    // 날씨 데이터를 처리하여 일별 예보 데이터로 변환하기
    private func processWeatherData(_ weatherResponse: WeatherResponse) -> [DailyForecast] {
        var dailyForecasts = [String: [Forecast]]()

        // 날짜별로 예보 데이터를 그룹화
        for forecast in weatherResponse.list {
            let date = forecast.dt_txt.split(separator: " ")[0]
            let dateString = String(date)
            if dailyForecasts[dateString] == nil {
                dailyForecasts[dateString] = []
            }
            dailyForecasts[dateString]?.append(forecast)
        }

        // 일별 평균 기온과 날씨 설명을 계산하여 결과 배열에 추가하는 거
        var weeklyForecasts = [DailyForecast]()
        for (date, forecasts) in dailyForecasts {
            let averageTemp = forecasts.map { $0.main.temp }.reduce(0, +) / Double(forecasts.count)
            let weatherDescription = forecasts.first?.weather.first?.description ?? ""
            weeklyForecasts.append(DailyForecast(date: date, temp: averageTemp, description: weatherDescription))
        }

        return weeklyForecasts
    }
}
