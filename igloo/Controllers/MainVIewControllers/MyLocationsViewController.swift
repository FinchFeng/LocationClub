//
//  MyLocationsViewController.swift
//  igloo
//
//  Created by 冯奕琦 on 2018/12/21.
//  Copyright © 2018 冯奕琦. All rights reserved.
//
import UIKit

class MyLocationsViewController: UIViewController,MyLocationDelegate {

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
        let button = UIBarButtonItem(title: "编辑", style: UIBarButtonItem.Style.plain, target: self, action: #selector(startEditTableView))
        //设置颜色
        button.tintColor = #colorLiteral(red: 0.02745098039, green: 0.462745098, blue: 0.4705882353, alpha: 1)
        return button
    }()
    
    lazy var rightBarItem:UIBarButtonItem = {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "addButtonIcon"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(newLocationData))
        //设置颜色
        button.tintColor = #colorLiteral(red: 0.02745098039, green: 0.462745098, blue: 0.4705882353, alpha: 1)
        return button
    }()
    
    lazy var endEditingBarItem:UIBarButtonItem = {
       let button = UIBarButtonItem(title: "完成", style: UIBarButtonItem.Style.plain, target: self, action: #selector(endEditTableView))
       return button
    }()
    
    @objc func startEditTableView() {
        setEditingTableViewNavBarStart()
        locationTableView.setEditing(true, animated: true)
    }
    
    @objc func endEditTableView() {
        setEditingTableViewNavBarEnd()
        locationTableView.setEditing(false, animated: true)
    }
    
    @objc func newLocationData(){
        performSegue(withIdentifier: "segueToAddNewLocation", sender: nil)
    }
    
    func setEditingTableViewNavBarEnd() {
        let tabBarVC = self.tabBarController!
        tabBarVC.navigationItem.titleView = nil
        tabBarVC.navigationItem.leftBarButtonItem = leftBarItem
        tabBarVC.navigationItem.rightBarButtonItem = rightBarItem
        tabBarVC.title = "我的地点"
    }
    
    func setEditingTableViewNavBarStart() {
        let tabBarVC = self.tabBarController!
        tabBarVC.navigationItem.rightBarButtonItem = endEditingBarItem
        tabBarVC.navigationItem.leftBarButtonItem = nil
    }
    
    //MARK:Outlet
    @IBOutlet weak var locationTableView: MarsTableView!
    
    func reloadTableViewData() {
        //配置tableView M->C->V
        print("MylocationVC")
        print("reloadTableViewData")
        locationTableView.savePhotos = true
        locationTableView.setDataIn(locationDataArray:dataArrayForTableView)
    }
    
    var needToReloadTableViewData:Bool = false
    
    //MARK: Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTableView.viewControllerDelegate = self
        //初始化TableVIew
        if LoginModel.login{
            model.updateAllLocationInfoLikeAmount { (dataArray) in
                //更新LikeAmount
                self.reloadTableViewData()
            }
        }else{
            reloadTableViewData()
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //给tabBarController设置顶栏
        setEditingTableViewNavBarEnd()
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
        model.addLocationInfo(data: data, UIActionBlock: {
            self.reloadTableViewData()
        })
    }
    
    func deleteLocation(index:Int,reload:Bool)  {
        let id = model.locationDataArray[index].locationID
        model.deleteLocaitonInfo(id: id, UIActionBlock: {
            if reload {
                print("MyLocationsViewController")
                print("After delete reload the data")
                self.reloadTableViewData()
            }
        })
    }
    
    func deleteLocation(id:String)  {
        for (index,data) in model.locationDataArray.enumerated(){
            if data.locationID == id {
                deleteLocation(index: index, reload: true)
                return
            }
        }
    }
    
    func changeLocationData(newData: LocationInfoLocal, key: String, value: String ,landing:@escaping () -> Void) {
        print("MyLocationsViewController")
        print("changeLocationData")
        print(newData)
        model.editLocationInfo(newData: newData, key: key, value: value, landing: landing)
        reloadTableViewData()
    }
    //MARK: VisitedNote
    func addVisiteNote(locationID: String, visitNoteID: String, data:VisitedNote, imageArray: [UIImage],landingAction:@escaping()->Void) {
        model.addNewVisitNoteTo(locationID: locationID, visitNoteID: visitNoteID, data: data, imageArray: imageArray,landingAction: {
            landingAction()
            self.reloadTableViewData()
        })
        
    }
    
    func deleteVisiteNote(locationID: String, visitNoteID: String,UIActionBlock:@escaping ()->Void) {
        model.deleteVisitNoteFrom(locationID: locationID, visitNoteID: visitNoteID, UIActionBlock: {
            self.reloadTableViewData()
        })
    }
    
    func addNewVisitNoteAndUpdateView(GreatVC: GreatLocationInfoViewController, locationID: String, visitNoteID: String, data: VisitedNote, imageArray: [UIImage]) {
        addVisiteNote(locationID: locationID, visitNoteID: visitNoteID, data: data, imageArray: imageArray, landingAction: {
            //寻找更新的data进行更新
            for data in self.model.locationDataArray {
                if data.locationID == GreatVC.locationData.locationID{
                    GreatVC.update(data:data)//更新
                    return
                }
            }
        })
       
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
                    nextVC.setDataIn(data: data, isMyOwnData: true)
                    nextVC.delegate = self
                    nextVC.saveImages = true
                }
            }
        }
    }
    
    //MARK:测试区
    
    @IBAction func buttonTaped() {
//        Network.changeOwenLike(array: ["123"], userID: "706485148")
        print("MyLocationsViewController")
        print(LoginModel.login)
        print(LoginModel.owenLocationIDArray)
        print(model.locationDataArray)
//        model.updateAllLocationInfoLikeAmount { (dataArray) in
//            print(dataArray)
//        }
        
    }
}

protocol MyLocationDelegate {
    func didSelectCell(index:Int)
    func deleteLocation(id:String)
    func deleteLocation(index:Int,reload:Bool)//用来删除数据
    func deleteVisiteNote(locationID: String, visitNoteID: String,UIActionBlock:@escaping ()->Void)
    func addNewVisitNoteAndUpdateView(GreatVC:GreatLocationInfoViewController,locationID: String, visitNoteID: String, data:VisitedNote, imageArray: [UIImage])
     func changeLocationData(newData: LocationInfoLocal, key: String, value: String ,landing:@escaping () -> Void)
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
