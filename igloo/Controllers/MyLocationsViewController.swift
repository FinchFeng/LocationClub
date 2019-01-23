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
    
    //转换为tableView可以读入读形式
    var dataArrayForTableView:[(LocationInfoRank2,LocationInfoRank3)] {
        var resultArray :[(LocationInfoRank2,LocationInfoRank3)] = []
        for data in model.locationDataArray{
            let rank2 = data.changeDataTo(rank: 2) as! LocationInfoRank2
            let rank3 = data.changeDataTo(rank: 3) as! LocationInfoRank3
            resultArray.append((rank2,rank3))
        }
        return resultArray
    }
    
    //MARK:Outlet
    @IBOutlet weak var locationTableView: MarsTableView!
    
    func reloadTableViewData() {
        //配置tableView M->C->V
        locationTableView.setDataIn(locationDataArray:dataArrayForTableView)
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadTableViewData()
    }
    
    //MARK:functions
    
    
    func hadLogin()  {
        model.loginHander()
        //标记下一次展现这个页面需要重新刷新TableView
    }
    
    func addLocation(data:LocationInfoLocal) {
        //更改Model
        model.addLocationInfo(data: data)
        reloadTableViewData()
    }
    
    func deleteLocation(index:Int)  {
        let id = model.locationDataArray[index].locationID
        model.deleteLocaitonInfo(id: id)
        reloadTableViewData()
    }
    
    func changeLocationData(newData: LocationInfoLocal, key: String, value: String) {
        model.editLocationInfo(newData: newData, key: key, value: value)
        reloadTableViewData()
    }
    
    //MARK:测试区
    
    @IBAction func buttonTaped() {
                let rank1 = LocationInfoRank1(locationName: "BNoodles" ,iconKindString: "Restaurant" ,locationDescription: "A lots of beef" ,locationLatitudeKey: 37.334922 ,locationLongitudeKey: -122.009033 ,isPublic: true ,locationLikedAmount: 10 ,VisitedNoteID: [])
                let rank2Data = LocationInfoRank2(locationName: "Beef Noodle" ,locationInfoWord: "nearby my home" ,locationLikedAmount: 10 ,locationInfoImageURL: "nil" )
                let locationData = LocationInfoLocal(locationID: "4", rank1Data: rank1, rank2Data: rank2Data, visitedNoteArray: [])
//                addLocation(data: locationData)
        print(LoginModel.login)
        print(LoginModel.owenLocationIDArray)
        print(model.locationDataArray)
//        deleteLocation(index: 0)
        changeLocationData(newData: locationData, key: Constants.locationName, value: "BNoodles")//两个都要更改
    }
    
    
    
    //location的更改
    
    
    
    
//    func testAddNewLocationData() {
//        let rank1 = LocationInfoRank1(locationName: "Beef Noodle" ,iconKindString: "Restaurant" ,locationDescription: "A lots of beef" ,locationLatitudeKey: 37.334922 ,locationLongitudeKey: -122.009033 ,isPublic: true ,locationLikedAmount: 10 ,VisitedNoteID: [])
//        let rank2Data = LocationInfoRank2(locationName: "Beef Noodle" ,locationInfoWord: "nearby my home" ,locationLikedAmount: 10 ,locationInfoImageURL: "nil" )
//        let locationData = LocationInfoLocal(locationID: "4", rank1Data: rank1, rank2Data: rank2Data, visitedNoteArray: [])
//        model.addLocationInfo(data: locationData)
//    }
//
//    func editLocationData() {
//        let rank1 = LocationInfoRank1(locationName: "Noodles" ,iconKindString: "Restaurant" ,locationDescription: "A lots of beef" ,locationLatitudeKey: 37.334922 ,locationLongitudeKey: -122.009033 ,isPublic: true ,locationLikedAmount: 10 ,VisitedNoteID: [])
//        let rank2Data = LocationInfoRank2(locationName: "Beef Noodle" ,locationInfoWord: "nearby my home" ,locationLikedAmount: 10 ,locationInfoImageURL: "nil" )
//        let newData = LocationInfoLocal(locationID: "3", rank1Data: rank1, rank2Data: rank2Data, visitedNoteArray: [])
//        model.editLocationInfo(newData: newData, key: Constants.isPublic, value: "false")
//    }
//
//    func deleteLocation() {
//        model.deleteLocaitonInfo(id: "3")
//
//    }
//
//
//    override func viewWillDisappear(_ animated: Bool) {
//        //注意要滑动TableView到顶端
//        super.viewWillDisappear(animated)
//    }

}
//    let dataArray:[(LocationInfoRank2,LocationInfoRank3)] = []
//    let data = (LocationInfoRank2(locationName:"环岛路栈桥",locationInfoWord:"厦门 亚洲海湾",
//                                  locationLikedAmount:12,locationInfoImageURL:"imageTest"),
//                LocationInfoRank3(locationLatitudeKey: 37.334922,locationLongitudeKey:-122.009033,iconKindString:"Views"))

//测试成功
//        deleteLocation()
//        testAddNewLocationData()
//        deleteLocation()
//        print(LoginModel.owenLocationIDArray)
//        print(model.localLocationDataArray)
//        print(model.localLocationDataArray)
//          locationTableView.addCell(data: data)
//        locationTableView.deleteCell(index:0)
//        locationTableView.setDataIn(locationDataArray: [data])
//        editLocationData()
//储存Image到本地图片池
//        let image = #imageLiteral(resourceName: "locationTestImage")
//        LocalImagePool.set(image: image, url: "imageTest")
