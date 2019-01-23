//
//  MyLocationsViewController.swift
//  igloo
//
//  Created by 冯奕琦 on 2018/12/21.
//  Copyright © 2018 冯奕琦. All rights reserved.
//

import UIKit

class MyLocationsViewController: UIViewController {

    //MARK:Model
    
    let model:MyLocationModel = MyLocationModel()
    
    let dataArray:[(LocationInfoRank2,LocationInfoRank3)] = []
    let data = (LocationInfoRank2(locationName:"环岛路栈桥",locationInfoWord:"厦门 亚洲海湾",
                                  locationLikedAmount:12,locationInfoImageURL:"imageTest"),
                LocationInfoRank3(locationLatitudeKey: 37.334922,locationLongitudeKey:-122.009033,iconKindString:"Views"))
    
    //MARK:Outlet
    @IBOutlet weak var locationTableView: MarsTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //储存Image到本地图片池
        let image = #imageLiteral(resourceName: "locationTestImage")
        LocalImagePool.set(image: image, url: "imageTest")
        //配置tableView
        locationTableView.setDataIn(locationDataArray: dataArray)
//        locationTableView.addCell(data: data)
        print("Login" + String(LoginModel.login))
    }
    
    @IBAction func buttonTaped() {
        //测试成功
//        deleteLocation()
//        testAddNewLocationData()
//        print(model.localLocationDataArray)
//          locationTableView.addCell(data: data)
//        locationTableView.deleteCell(index:0)
//        locationTableView.setDataIn(locationDataArray: [data])
//        editLocationData()
    }
    
    func testAddNewLocationData() {
        let rank1 = LocationInfoRank1(locationName: "Beef Noodle" ,iconKindString: "Restaurant" ,locationDescription: "A lots of beef" ,locationLatitudeKey: 37.334922 ,locationLongitudeKey: -122.009033 ,isPublic: true ,locationLikedAmount: 10 ,VisitedNoteID: [])
        let rank2Data = LocationInfoRank2(locationName: "Beef Noodle" ,locationInfoWord: "nearby my home" ,locationLikedAmount: 10 ,locationInfoImageURL: "nil" )
        let locationData = LocationInfoLocal(locationID: "3", rank1Data: rank1, rank2Data: rank2Data, visitedNoteArray: [])
        model.addLocationInfo(data: locationData)
    }
    
    func editLocationData() {
        let rank1 = LocationInfoRank1(locationName: "Noodles" ,iconKindString: "Restaurant" ,locationDescription: "A lots of beef" ,locationLatitudeKey: 37.334922 ,locationLongitudeKey: -122.009033 ,isPublic: true ,locationLikedAmount: 10 ,VisitedNoteID: [])
        let rank2Data = LocationInfoRank2(locationName: "Beef Noodle" ,locationInfoWord: "nearby my home" ,locationLikedAmount: 10 ,locationInfoImageURL: "nil" )
        let newData = LocationInfoLocal(locationID: "3", rank1Data: rank1, rank2Data: rank2Data, visitedNoteArray: [])
        model.editLocationInfo(newData: newData, key: Constants.isPublic, value: "false")
    }
    
    func deleteLocation() {
        model.deleteLocaitonInfo(id: "3")
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        //注意要滑动TableView到顶端
        super.viewWillDisappear(animated)
    }
    
}
