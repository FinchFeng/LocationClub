//
//  MyLocationsViewController.swift
//  igloo
//
//  Created by 冯奕琦 on 2018/12/21.
//  Copyright © 2018 冯奕琦. All rights reserved.
//

import UIKit

class MyLocationsViewController: UIViewController,SegueTpGreatInfoDelegate {

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
    //MARK: NavigationBar
    
    lazy var leftBarItem:UIBarButtonItem = {
        let button = UIBarButtonItem(title: "编辑", style: UIBarButtonItem.Style.plain, target: self, action: #selector(editTableView))
        //设置颜色
        button.tintColor = #colorLiteral(red: 0.02745098039, green: 0.462745098, blue: 0.4705882353, alpha: 1)
        return button
    }()
    
    lazy var rightBarItem:UIBarButtonItem = {
        let button = UIBarButtonItem(title: "new", style: UIBarButtonItem.Style.plain, target: self, action: #selector(newLocationData))
        //设置颜色
        button.tintColor = #colorLiteral(red: 0.02745098039, green: 0.462745098, blue: 0.4705882353, alpha: 1)
        return button
    }()
    
    @objc func editTableView() {
        print("开始更改tableView")
    }
    
    @objc func newLocationData(){
        
    }
    
    //MARK:Outlet
    @IBOutlet weak var locationTableView: MarsTableView!
    
    func reloadTableViewData() {
        //配置tableView M->C->V
        locationTableView.setDataIn(locationDataArray:dataArrayForTableView)
    }
    
    var needToReloadTableViewData:Bool = false
    
    //MARK: Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //初始化TableVIew
        reloadTableViewData()
        locationTableView.segueTpGreatInfoDelegate = self
        //给tabBarController设置顶栏
        let tabBarVC = self.tabBarController!
        tabBarVC.title = "我的地点"
        tabBarVC.navigationItem.leftBarButtonItem = leftBarItem
        tabBarVC.navigationItem.rightBarButtonItem = rightBarItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if needToReloadTableViewData {//检查是否需要重新填装tableView
            needToReloadTableViewData = false
            reloadTableViewData()
        }
    }
    
    //MARK:Functions
    
    
    func hadLogin()  {
        model.loginHander()
        //标记下一次展现这个页面需要重新刷新TableView
        needToReloadTableViewData = true
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
    
    //MARK:Segue
    
    var dataSendToGreatInfo:LocationInfoLocal?
    
    func didSelectCell(index:Int){
        //获取LocationInfolocal数据
        self.dataSendToGreatInfo = model.locationDataArray[index]
        //segue到下一个ViewController
        performSegue(withIdentifier: "SegueToGreatLocationInfo", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //判断segue
        if let id = segue.identifier,id == "SegueToGreatLocationInfo"{//显示GreatInfo
            if let data = self.dataSendToGreatInfo{
                if let nextVC = segue.destination as? GreatLocationInfoViewController{
                    //读入数据
                    nextVC.setDataIn(data: data)
                }
            }
        }
    }
    
    //MARK:测试区
    
    @IBAction func buttonTaped() {
//                let rank1 = LocationInfoRank1(locationName: "Beef Noodle" ,iconKindString: "Restaurant" ,locationDescription: "A lots of beef" ,locationLatitudeKey: 37.334922 ,locationLongitudeKey: -122.009033 ,isPublic: true ,locationLikedAmount: 10 ,VisitedNoteID: [])//重复性在这里要注意⚠️
//                let rank2Data = LocationInfoRank2(locationName: "Beef Noodle" ,locationInfoWord: "nearby my home" ,locationLikedAmount: 10 ,locationInfoImageURL: "nil" )
//                let locationData = LocationInfoLocal(locationID: "4", rank1Data: rank1, rank2Data: rank2Data, visitedNoteArray: [])
//                addLocation(data: locationData)
        
//        deleteLocation(index: 0)
//        changeLocationData(newData: locationData, key: Constants.locationName, value: "BNoodles")//两个都要更改
        
        //写入图片
        
        model.addNewVisitNoteTo(locationID: "4", visitNoteID: "2-3", data: VisitedNote(visitNoteWord:"循环强引",imageURLArray:[],createdTime:Date.currentDateString()), imageArray: [#imageLiteral(resourceName: "beatlesAndAli")])//自动
//        model.deleteVisitNoteFrom(locationID: "4", visitNoteID: "2-4")
        
//        LocalImagePool.set(image:  #imageLiteral(resourceName: "ali"), url: "uploads/2-1-0_389_400.jpg")
//        print(ImageChecker.getImage(url: "uploads/2-1-0_389_400.jpg"))
        print(LoginModel.login)
        print(LoginModel.owenLocationIDArray)
        print(model.locationDataArray)
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
