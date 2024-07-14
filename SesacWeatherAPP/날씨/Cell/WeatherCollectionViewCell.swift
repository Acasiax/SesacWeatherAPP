//
//  WeatherCollectionViewCell.swift
//  SesacWeatherAPP
//
//  Created by 이윤지 on 7/14/24.
//

import UIKit

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
