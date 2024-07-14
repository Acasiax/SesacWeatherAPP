//
//  DailyForecastCollectionViewCell.swift
//  SesacWeatherAPP
//
//  Created by 이윤지 on 7/14/24.
//

import UIKit

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

