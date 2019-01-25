//
//  GreatLocationInfoViewController.swift
//  igloo
//
//  Created by 冯奕琦 on 2019/1/24.
//  Copyright © 2019 冯奕琦. All rights reserved.
//

import UIKit
import MapKit

class GreatLocationInfoViewController: UIViewController {

    
    @IBOutlet weak var map: MapViewForGreatLocation!
    
    var locationData:LocationInfoLocal!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //隐藏TopBar 返回的时候要再把它显示出来
        self.navigationController!.setNavigationBarHidden(true, animated: false)
        //配置Map
        let coordinates = CLLocationCoordinate2DMake(locationData.locationLatitudeKey, locationData.locationLongitudeKey)
        var mapRegion = MKCoordinateRegion()
        let mapRegionSpan = Constants.lengthOfGreatInfoMap
        mapRegion.center = coordinates
        mapRegion.span.latitudeDelta = mapRegionSpan
        mapRegion.span.longitudeDelta = mapRegionSpan
        map.setRegion(mapRegion, animated: false)
        map.addNewLocation(data: locationData.changeDataTo(rank: 3) as! LocationInfoRank3)
    }
    
    //Segue之前进行配置
    func setDataIn(data:LocationInfoLocal) {
        self.locationData = data
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
