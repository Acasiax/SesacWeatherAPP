//
//  HomeViewController.swift
//  SesacWeatherAPP
//
//  Created by 이윤지 on 7/10/24.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    // UI Components
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.identifier)
        tableView.register(DailyForecastTableViewCell.self, forCellReuseIdentifier: DailyForecastTableViewCell.identifier)
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
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 64)
        label.text = "0°C"
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.text = "Description"
        return label
    }()
    
    private let windSpeedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "풍속: 0 m/s"
        return label
    }()
    
    private let pressureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "기압: 0 hPa"
        return label
    }()
    
    private let humidityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "습도: 0 %"
        return label
    }()
    
    private let viewModel = WeatherViewModel()
    
    // View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupDelegates()
        bindViewModel()
    }
    
    // UI Setup Methods
    private func setupUI() {
        view.backgroundColor = .white
        addSubviews()
    }
    
    private func addSubviews() {
        view.addSubview(cityNameTextField)
        view.addSubview(cityNameLabel)
        view.addSubview(temperatureLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(windSpeedLabel)
        view.addSubview(pressureLabel)
        view.addSubview(humidityLabel)
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
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
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(humidityLabel.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupDelegates() {
        cityNameTextField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // ViewModel Binding
    private func bindViewModel() {
        viewModel.weather.bind { [weak self] weather in
            guard let self = self else { return }
            if let weather = weather {
                self.updateUI(with: weather)
            }
        }
    }
    
    // UI Update Method
    private func updateUI(with weather: WeatherModel) {
        cityNameLabel.text = weather.name
        temperatureLabel.text = "\(weather.main.temp)°C"
        descriptionLabel.text = weather.weather.first?.description ?? "No description"
        windSpeedLabel.text = "풍속: \(weather.wind.speed) m/s"
        pressureLabel.text = "기압: \(weather.main.pressure) hPa"
        humidityLabel.text = "습도: \(weather.main.humidity) %"
        tableView.reloadData()
    }
    
    // Alert Method
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

// UITextFieldDelegate Methods
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

// UITableViewDelegate and UITableViewDataSource Methods
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // 두 개의 섹션: 시간별 예보와 일간 예보
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // 각 섹션당 하나의 행
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
            cell.configure(with: ["12시", "15시", "18시", "21시", "00시"], temperatures: ["7°", "8°", "4°", "2°", "0°"])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: DailyForecastTableViewCell.identifier, for: indexPath) as! DailyForecastTableViewCell
            cell.configure(with: ["오늘", "목", "금"], minTemps: ["-2°", "-4°", "-3°"], maxTemps: ["9°", "7°", "15°"])
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
}

// WeatherTableViewCell Class
class WeatherTableViewCell: UITableViewCell {
    static let identifier = "WeatherTableViewCell"
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal // 가로 스크롤 설정
        layout.itemSize = CGSize(width: 60, height: 100)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: WeatherCollectionViewCell.identifier)
        return collectionView
    }()
    
    private var times = [String]()
    private var temperatures = [String]()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with times: [String], temperatures: [String]) {
        self.times = times
        self.temperatures = temperatures
        collectionView.reloadData()
    }
}

// WeatherTableViewCell Extensions for Collection View Delegation
extension WeatherTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return times.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.identifier, for: indexPath) as! WeatherCollectionViewCell
        cell.configure(time: times[indexPath.row], temperature: temperatures[indexPath.row])
        return cell
    }
}

// WeatherCollectionViewCell Class
class WeatherCollectionViewCell: UICollectionViewCell {
    static let identifier = "WeatherCollectionViewCell"
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(timeLabel)
        contentView.addSubview(temperatureLabel)
        
        timeLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(time: String, temperature: String) {
        timeLabel.text = time
        temperatureLabel.text = temperature
    }
}

// DailyForecastTableViewCell Class
class DailyForecastTableViewCell: UITableViewCell {
    static let identifier = "DailyForecastTableViewCell"
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 40)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(DailyForecastCollectionViewCell.self, forCellWithReuseIdentifier: DailyForecastCollectionViewCell.identifier)
        return collectionView
    }()
    
    private var days = [String]()
    private var minTemps = [String]()
    private var maxTemps = [String]()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
            make.height.equalTo(200) // 적절한 높이로 설정
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with days: [String], minTemps: [String], maxTemps: [String]) {
        self.days = days
        self.minTemps = minTemps
        self.maxTemps = maxTemps
        collectionView.reloadData()
    }
}

// DailyForecastTableViewCell Extensions for Collection View Delegation
extension DailyForecastTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DailyForecastCollectionViewCell.identifier, for: indexPath) as! DailyForecastCollectionViewCell
        cell.configure(day: days[indexPath.row], minTemp: minTemps[indexPath.row], maxTemp: maxTemps[indexPath.row])
        return cell
    }
}

// DailyForecastCollectionViewCell Class
class DailyForecastCollectionViewCell: UICollectionViewCell {
    static let identifier = "DailyForecastCollectionViewCell"
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(dayLabel)
        dayLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(day: String, minTemp: String, maxTemp: String) {
        dayLabel.text = "\(day): 최저 \(minTemp), 최고 \(maxTemp)"
    }
}
