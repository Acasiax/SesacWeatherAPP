//
//  DailyForecastTableViewCell.swift
//  SesacWeatherAPP
//
//  Created by 이윤지 on 7/14/24.
//

import UIKit

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
        setupViews()
        setupCollectionView()
    }
    
    private func setupViews() {
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
            make.height.equalTo(200)
        }
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with days: [String], minTemps: [String], maxTemps: [String]) {
        var uniqueDays = [String]()
        var uniqueMinTemps = [String]()
        var uniqueMaxTemps = [String]()
        
        var seenDays = Set<String>()
        
        for index in 0..<days.count {
            let day = days[index]
            let minTemp = minTemps[index]
            let maxTemp = maxTemps[index]
            
            let dayOfWeek = getDayOfWeek(day) ?? day
            
            if !seenDays.contains(dayOfWeek) {
                seenDays.insert(dayOfWeek)
                uniqueDays.append(dayOfWeek)
                uniqueMinTemps.append(minTemp)
                uniqueMaxTemps.append(maxTemp)
            }
        }
        
        self.days = uniqueDays
        self.minTemps = uniqueMinTemps
        self.maxTemps = uniqueMaxTemps
        
        collectionView.reloadData()
    }
    
    func getDayOfWeek(_ dateString: String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = formatter.date(from: dateString) else { return nil }
        
        formatter.dateFormat = "EEEE"
        formatter.locale = Locale(identifier: "ko_KR") 
        return formatter.string(from: date)
    }
}

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
