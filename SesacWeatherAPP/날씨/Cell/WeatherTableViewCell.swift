//
//  WeatherTableViewCell.swift
//  SesacWeatherAPP
//
//  Created by 이윤지 on 7/14/24.
//

import UIKit
import SnapKit

class WeatherTableViewCell: UITableViewCell {
    static let identifier = "WeatherTableViewCell"
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
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
            let currentDateTime = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            // 현재 시간 이후의 데이터만 필터링
            //지금 새벽 12시라서 3시간 간격의 데이터 중 다음 시간이 03시
            let filteredTimes = times.filter { formatter.date(from: $0)! >= currentDateTime }
            
            self.times = filteredTimes.map { formatTime($0) }
            self.temperatures = temperatures
            collectionView.reloadData()
        }
    
    private func formatTime(_ dateTime: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // 서버에서 반환하는 날짜 형식에 맞춤
        if let date = formatter.date(from: dateTime) {
            formatter.dateFormat = "HH시"
            return formatter.string(from: date)
        }
        return dateTime
    }
}

extension WeatherTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return times.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.identifier, for: indexPath) as! WeatherCollectionViewCell
        cell.configure(time: times[indexPath.row], temperature: temperatures[indexPath.row])
        return cell
    }
    
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 여기서는 임의로 60x100 크기를 설정했지만 필요에 따라 동적으로 계산할 수 있음
        return CGSize(width: 60, height: 100)
    }
}
