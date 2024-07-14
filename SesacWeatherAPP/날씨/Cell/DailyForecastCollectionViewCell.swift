//
//  DailyForecastCollectionViewCell.swift
//  SesacWeatherAPP
//
//  Created by 이윤지 on 7/14/24.
//

import UIKit
import SnapKit


class DailyForecastCollectionViewCell: UICollectionViewCell {
    static let identifier = "DailyForecastCollectionViewCell"
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
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


//class DailyForecastCollectionViewCell: UICollectionViewCell {
//    static let identifier = "DailyForecastCollectionViewCell"
//    
//    private let dayLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .black
//        label.textAlignment = .center
//        label.font = UIFont.systemFont(ofSize: 14)
//        return label
//    }()
//    
//    private let minTempLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .black
//        label.textAlignment = .center
//        label.font = UIFont.systemFont(ofSize: 14)
//        return label
//    }()
//    
//    private let maxTempLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .black
//        label.textAlignment = .center
//        label.font = UIFont.systemFont(ofSize: 14)
//        return label
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupSubviews()
//        setupConstraints()
//    }
//    
//    private func setupSubviews() {
//        contentView.addSubview(dayLabel)
//        contentView.addSubview(minTempLabel)
//        contentView.addSubview(maxTempLabel)
//    }
//    
//    private func setupConstraints() {
//        dayLabel.snp.makeConstraints { make in
//            make.top.leading.trailing.equalToSuperview()
//        }
//        
//        minTempLabel.snp.makeConstraints { make in
//            make.top.equalTo(dayLabel.snp.bottom).offset(4)
//            make.leading.trailing.equalToSuperview()
//        }
//        
//        maxTempLabel.snp.makeConstraints { make in
//            make.top.equalTo(minTempLabel.snp.bottom).offset(4)
//            make.leading.trailing.bottom.equalToSuperview()
//        }
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func configure(day: String, minTemp: String, maxTemp: String) {
//        dayLabel.text = day
//        minTempLabel.text = minTemp
//        maxTempLabel.text = maxTemp
//    }
//}
//
