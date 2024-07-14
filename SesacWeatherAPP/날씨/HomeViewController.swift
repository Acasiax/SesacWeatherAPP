//
//  HomeViewController.swift
//  SesacWeatherAPP
//
//  Created by 이윤지 on 7/14/24.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "날씨배경화면")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5) // 어두운 오버레이
        return view
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.identifier)
        tableView.register(DailyForecastTableViewCell.self, forCellReuseIdentifier: DailyForecastTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 500
        return tableView
    }()
    
    private let cityNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "도시 이름 입력"
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .search
        return textField
    }()
    
    private let cityNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.text = "City Name"
        label.textColor = .white
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 64)
        label.text = "0°C"
        label.textColor = .white
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.text = "Description"
        label.textColor = .white
        return label
    }()
    
    private let windSpeedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "풍속: 0 m/s"
        label.textColor = .white
        return label
    }()
    
    private let pressureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "기압: 0 hPa"
        label.textColor = .white
        return label
    }()
    
    private let humidityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "습도: 0 %"
        label.textColor = .white
        return label
    }()
    
    private let viewModel = WeatherViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subView()
        setupConstraints()
        setupDelegates()
        bindViewModel()
        cityNameTextField.text = "seoul"
        viewModel.cityName.value = cityNameTextField.text ?? ""
    }
    
    private func subView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(overlayView)
        contentView.addSubview(cityNameTextField)
        contentView.addSubview(cityNameLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(windSpeedLabel)
        contentView.addSubview(pressureLabel)
        contentView.addSubview(humidityLabel)
        contentView.addSubview(tableView)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.width.equalTo(scrollView)
            make.bottom.equalTo(tableView.snp.bottom)
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        cityNameTextField.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        cityNameLabel.snp.makeConstraints { make in
            make.top.equalTo(cityNameTextField.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(cityNameLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        windSpeedLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        pressureLabel.snp.makeConstraints { make in
            make.top.equalTo(windSpeedLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        humidityLabel.snp.makeConstraints { make in
            make.top.equalTo(pressureLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualTo(tableView.snp.top).offset(-20)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(humidityLabel.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    private func setupDelegates() {
        cityNameTextField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func bindViewModel() {
        viewModel.weather.bind { [weak self] weather in
            guard let self = self, let weather = weather else { return }
            self.updateUI(with: weather)
        }
        
        viewModel.forecasts.bind { _ in
            self.tableView.reloadData()
        }
    }
    
    private func updateUI(with weather: WeatherModel) {
        cityNameLabel.text = weather.name
        temperatureLabel.text = "\(weather.main.temp)°C"
        descriptionLabel.text = weather.weather.first?.description ?? "No description"
        windSpeedLabel.text = "풍속: \(weather.wind.speed) m/s"
        pressureLabel.text = "기압: \(weather.main.pressure) hPa"
        humidityLabel.text = "습도: \(weather.main.humidity) %"
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let cityName = textField.text, !cityName.isEmpty {
            viewModel.cityName.value = cityName
        } else {
            showAlert(message: "도시 이름을 입력하세요")
        }
        return true
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
            let times = viewModel.forecasts.value.map { $0.dt_txt }
            let temperatures = viewModel.forecasts.value.map { "\($0.main.temp)°" }
            cell.configure(with: times, temperatures: temperatures)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: DailyForecastTableViewCell.identifier, for: indexPath) as! DailyForecastTableViewCell
            let days = viewModel.forecasts.value.map { $0.dt_txt }
            let minTemps = viewModel.forecasts.value.map { "\($0.main.temp_min)°" }
            let maxTemps = viewModel.forecasts.value.map { "\($0.main.temp_max)°" }
            cell.configure(with: days, minTemps: minTemps, maxTemps: maxTemps)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "🗓️ 3시간 간격의 일기예보"
        } else {
            return "🗓️ 5일 간의 일기예보"
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = UILabel()
        headerLabel.font = UIFont.boldSystemFont(ofSize: 13)
        headerLabel.textColor = .white
        
        if section == 0 {
            headerLabel.text = "🗓️ 3시간 간격의 일기예보"
        } else {
            headerLabel.text = "🗓️ 5일 간의 일기예보"
        }
        
        let headerView = UIView()
        headerView.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        } else {
            return 300
        }
    }
    
    private func getDayOfWeek(from dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "EEEE"
            return formatter.string(from: date)
        }
        return dateString
    }
}

