//
//  MapTableViewCell.swift
//  SesacWeatherAPP
//
//  Created by 이윤지 on 7/14/24.
//

//import UIKit
//import MapKit
//
//class MapTableViewCell: UITableViewCell {
//    static let identifier = "MapTableViewCell"
//
//    let mapView: MKMapView = {
//        let mapView = MKMapView()
//        return mapView
//    }()
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        contentView.addSubview(mapView)
//        mapView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
