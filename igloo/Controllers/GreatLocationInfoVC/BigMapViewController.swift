//
//  BigMapViewController.swift
//  igloo
//
//  Created by 冯奕琦 on 2019/1/27.
//  Copyright © 2019 冯奕琦. All rights reserved.
//

import UIKit
import MapKit

class BigMapViewController: UIViewController {

    var locationData:LocationInfoLocal!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationDescrptionLabel: UILabel!
    @IBOutlet weak var LikeAmountLabel: UILabel!
    @IBOutlet weak var map: MapViewForGreatLocation!
    
    
    //segue之前
    func setDataIn(data:LocationInfoLocal)  {
        self.locationData = data
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //配置Data
        let coordinates = CLLocationCoordinate2DMake(locationData.locationLatitudeKey, locationData.locationLongitudeKey)
        var mapRegion = MKCoordinateRegion()
        let mapRegionSpan = Constants.lengthOfBigMap
        mapRegion.center = coordinates
        mapRegion.span.latitudeDelta = mapRegionSpan
        mapRegion.span.longitudeDelta = mapRegionSpan
        map.setRegion(mapRegion, animated: false)
        map.addNewLocation(data: locationData.changeDataTo(rank: 3) as! LocationInfoRank3)
        //配置Label数据
        setAllLabel()
    }
    
    func setAllLabel() {
        //blur all the label
        LocationCell.labelBlur(label: locationNameLabel)
        LocationCell.labelBlur(label: locationDescrptionLabel)
        LocationCell.labelBlur(label: LikeAmountLabel)
        //数据填入
        locationNameLabel.text = locationData.locationName
        locationDescrptionLabel.text = locationData.locationDescription
        LikeAmountLabel.text = String(locationData.locationLikedAmount)
    }


}
