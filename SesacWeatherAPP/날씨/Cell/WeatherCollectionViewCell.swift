//
//  WeatherCollectionViewCell.swift
//  SesacWeatherAPP
//
//  Created by 이윤지 on 7/14/24.
//

import UIKit
import Kingfisher

class WeatherCollectionViewCell: UICollectionViewCell {
    static let identifier = "WeatherCollectionViewCell"
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
//    private let weatherIconImageView: UIImageView = {
//           let imageView = UIImageView()
//           imageView.contentMode = .scaleAspectFit
//           return imageView
//       }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
    label.textColor = .black
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
           
//        weatherIconImageView.snp.makeConstraints { make in
//                   make.centerX.equalToSuperview()
//                   make.top.equalTo(timeLabel.snp.bottom).offset(8)
//                   make.width.height.equalTo(30) // Adjust size as needed
//
//               }
        
           temperatureLabel.snp.makeConstraints { make in
               make.top.equalTo(timeLabel.snp.bottom).offset(0)
               make.leading.trailing.bottom.equalToSuperview().inset(8)
               make.bottom.equalToSuperview().offset(1)
           }
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func configure(time: String, temperature: String) {
           timeLabel.text = time
           temperatureLabel.text = temperature
//
//           if let iconURL = iconURL {
//               weatherIconImageView.kf.setImage(with: iconURL)
//           } else {
//
//               weatherIconImageView.image = UIImage(systemName: "sun.min.fill")
//           }
       }
}
