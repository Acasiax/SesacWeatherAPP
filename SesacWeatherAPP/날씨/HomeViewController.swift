//
//  HomeViewController.swift
//  SesacWeatherAPP
//
//  Created by 이윤지 on 7/10/24.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController, UITextFieldDelegate {
    
    private let cityNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "도시 이름 입력"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let cityNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 64)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()
    
    private let windSpeedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private let pressureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private let humidityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private let viewModel = WeatherViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addview()
        setupUI()
        bindViewModel()
        
        cityNameTextField.delegate = self
    }
    
    func addview() {
        view.addSubview(cityNameTextField)
        view.addSubview(cityNameLabel)
        view.addSubview(temperatureLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(windSpeedLabel)
        view.addSubview(pressureLabel)
        view.addSubview(humidityLabel)
    }
    
    private func setupUI() {
        cityNameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
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
        }
    }
    
    private func bindViewModel() {
        viewModel.weather.bind { weather in
            if let weather = weather {
                self.updateUI(with: weather)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let cityName = textField.text, !cityName.isEmpty {
            viewModel.cityName.value = cityName
        } else {
            showAlert(message: "도시 이름을 입력하세요")
        }
        return true
    }
    
    private func updateUI(with weather: WeatherModel) {
        cityNameLabel.text = weather.name
        temperatureLabel.text = "\(weather.main.temp)°C"
        descriptionLabel.text = weather.weather.first?.description
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
