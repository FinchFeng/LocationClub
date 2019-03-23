//
//  MapViewController.swift
//  igloo
//
//  Created by 冯奕琦 on 2018/12/21.
//  Copyright © 2018 冯奕琦. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController,MapViewDelegate,LikeDelegate {
    //MARK:IBOutlet
    @IBOutlet weak var map: MapViewForExplore!
    @IBOutlet weak var distanceMarsViewShowing: NSLayoutConstraint!
    @IBOutlet weak var marsView: MarsTableViewForMap!
    @IBOutlet weak var resetRegion: UIButton!
    @IBOutlet weak var indecator: UIActivityIndicatorView!
    @IBOutlet weak var searchLocationButton: UIButton!
    @IBOutlet weak var addNewLocationButton: UIButton!
    
    var selectedPin:MKPlacemark? = nil
    var resultSearchController:UISearchController? = nil
    
    lazy var halfMapView: HitThoughView = {//使用这个View来进行map移动到准确位置
        let view = HitThoughView(frame: CGRect(x: 0, y:marsView.frame.height/2, width: self.view.frame.width, height:  self.map.frame.height-marsView.frame.height))
        view.isUserInteractionEnabled = false
        self.view.addSubview(view)
        return view
    }()
    
    //MARK:State or properties
    var model = AirModel()
    var isShowingMarsView:Bool = true
    
    //MARK:LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        map.mapviewDelegate = self
        marsView.mapViewDelegate = self
        resetRegion.layer.cornerRadius = 6
        resetRegion.layer.masksToBounds = true
        //进行handleMapVC的配置
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        locationSearchTable.handleMapSearchDelegate = self
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        locationSearchTable.mapView = map
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //隐藏TopBar
        self.navigationController!.setNavigationBarHidden(true, animated: false)
        if let tabVC =  self.tabBarController as? MainTabBarController{
            if tabVC.justBackFromLoginInMenu == true{
                tabVC.justBackFromLoginInMenu = false
                //返回MyLocationVC
                tabVC.selectedIndex = 0
                return
            }
        }
        //尝试登陆⚠️
//        if LoginModel.login == false {
//            let rootVC  = self.tabBarController! as! MainTabBarController
//            rootVC.login()
//        }
    }
    
    //这个Manager需要持久化才可以进行界面请求
    var locationManager = CLLocationManager()
    override func viewDidAppear(_ animated: Bool) {
        //进行地点权限申请
        if LoginModel.login {
            //请求地点代理 申请权限
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //显示tapBar
        self.navigationController!.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK:Actions
    @IBAction func tapView(_ sender: UITapGestureRecognizer) {//暂时不需要使用
//        print(map.annotations.count)
        if map.annotations.count == 1 {
            if map.userLocation.location != nil {
                marsViewMove(up: !isShowingMarsView)
            }else{
                
            }
            
        }
    }
    
    @objc func doneAction(){
        searchLocationButton.isHidden = false
        addNewLocationButton.isHidden = false
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func resetRegionAction() {
//       print("research Region")
        //展现全新的LocationData 自动选择第一个cell
        let currentRegion = map.region
        //调用Model进行数据获取
        model.getAnnotionsAndShow(span: currentRegion) { (dataArray) in
            //把数据填入marsView和mapview
            let dataArrayForMap = dataArray.map({ (data) -> (String,LocationInfoRank3) in
                return (data.id,data.data3)
            })
            self.map.setAnnotion(array: dataArrayForMap)
            let dataArrayForMarsView = dataArray.map({ (data) -> (LocationInfoRank2,LocationInfoRank3) in
                return (data.data2,data.data3)
            })
            self.marsView.setDataIn(locationDataArray: dataArrayForMarsView)
            self.marsViewMove(up: true)
            if dataArray.isEmpty {
                //该区域没有数据，滑动到提示的地方
                self.marsView.scrollToRow(at: IndexPath(item: 0, section: 0), at: UITableView.ScrollPosition.top, animated: false)
            }
        }
    }
    
    @IBAction func searchLocationAction() {
        let navigationItem = tabBarController!.navigationItem
        //配置navigationBar
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.setValue("取消", forKey:"_cancelButtonText")
        searchBar.tintColor = #colorLiteral(red: 0.02745098039, green: 0.462745098, blue: 0.4705882353, alpha: 1)
        searchBar.placeholder = "搜索位置"
        searchBar.setImage(UIImage(), for: .clear, state: .normal)//隐藏删除buttun
        navigationItem.rightBarButtonItem = nil
        navigationItem.titleView = resultSearchController?.searchBar
        navigationItem.leftBarButtonItem = nil
        showDoneButton()
        resultSearchController?.hidesNavigationBarDuringPresentation = false//控制bar不隐藏
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        //隐藏两个Button展现NavigationBar
        searchLocationButton.isHidden = true
        addNewLocationButton.isHidden = true
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    //MARK: 动画效果
    
    func marsViewMove(up:Bool) {
        //先更改状态
        if isShowingMarsView == up {return}
        isShowingMarsView = !isShowingMarsView
        //动画效果
        UIView.animate(withDuration: 0.27, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            let heightOfMarsView = self.marsView.frame.height
            let moveUpDistance = up ? -heightOfMarsView : 0
            if up {
                self.marsView.frame.origin.y -= heightOfMarsView
                self.resetRegion.frame.origin.y -= heightOfMarsView
            }else{
                self.marsView.frame.origin.y += heightOfMarsView
                self.resetRegion.frame.origin.y += heightOfMarsView
            }
            self.distanceMarsViewShowing.constant = moveUpDistance
            
        }, completion: nil)
    }
    
    //MARK:Segue
    
    var dataSendToGreatInfo:LocationInfoLocal?
    var dataToSendIndex:Int!{
        for (index,data) in model.currentAnnationLocationDataArray.enumerated() {
            if data.id == dataToSendLocationID!{
                return index
            }
        }
        return nil
    }
    var dataToSendLocationID:String?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //判断segue
        if let id = segue.identifier,id == "showGreatInfo"{//显示GreatInfo
            if let data = self.dataSendToGreatInfo{
                if let nextVC = segue.destination as? GreatLocationInfoViewController{
                    //读入数据
                    nextVC.setDataIn(data: data, isMyOwnData: false)
                    nextVC.index = dataToSendIndex
                    nextVC.locationID = dataToSendLocationID!
                    nextVC.likeDelegate = self
                    for likeId in LoginModel.owenLikedLocationIDArray{
                        if likeId == dataToSendLocationID!{
                            nextVC.haveLike = true
                            break
                        }
                    }
                }
            }
        }
    }
    
    //MARK: MapViewDelegate
    
    func selectAnnotionInCell(id: String,show:Bool) {//展现MarsView
        marsViewMove(up: true)
//        print("selectAnnotionInCell(id: String,show:\(show)")
        if show == false {return}//阻止Annotion再次选择Cell
        for (index,data) in model.currentAnnationLocationDataArray.enumerated() {
            if data.id == id {//滑动到这个Cell
                marsView.scrollTo(index:index,selectAnnotion:false)//阻止Cell再次选择Annotion
                return
            }
        }
    }
    func selectAnnotionFromCell(id:String)  {
        //返回的时候不进行展现
        map.selectLocation(id: id)
    }
    
    func getIdOf(index:Int)->String {
        return model.currentAnnationLocationDataArray[index].id
    }
    
    func showNextGroupLocation(){
//        print("showNextGroupLocation")
        //展现MarsView 获取新数据
        //进行loading显示
        marsView.isGettingData = true
        indecator.startAnimating()
        indecator.isHidden = false
        let lastCurrentShowingIndexMax = model.currentShowingIndexMax
        model.showNextGroupOfLocationData { (newDatas) in
            //如果没有返回数据
            if newDatas.isEmpty {
//                print("没有返回数据")
                //关闭loading 
                self.indecator.stopAnimating()
                self.marsView.isGettingData = false
                self.marsViewMove(up: true)
                self.marsView.isEndOfTableView = true
                print("MapViewController")
                print("selectAnnotion之后")
                print(self.marsView.contentOffset)
                return
            }
            //有返回数据
            let lastCellIndex = self.marsView.locationDataArray.count-1
            let dataArray = newDatas.map({ (data) -> (LocationInfoRank2,LocationInfoRank3) in
                return (data.data2,data.data3)
            })
            //关闭loading
            self.indecator.stopAnimating()
            self.marsView.isGettingData = false
            //select到上次最后一个Cell
            self.marsView.addDataIn(locationDataArray: dataArray)
            self.marsView.shouldScrollTo = lastCellIndex
        }
        //展现更多的Annotions
        let newAnnotionArray = Array(model.currentAnnationLocationDataArray[lastCurrentShowingIndexMax..<model.currentShowingIndexMax])
        map.addData(array: newAnnotionArray)
    }
    
    func getHalfMapView()->UIView{
        return halfMapView
    }
    
    func showAFullLocationData(id:String) {
        model.getFullData(id: id) { (data) in
            self.dataSendToGreatInfo = data
            self.dataToSendLocationID = id
            self.performSegue(withIdentifier: "showGreatInfo", sender: nil)
        }
    }
    
    func clickCellLike(index:Int,cancel:Bool){
        //发送后端
        let locationID = self.dataToSendLocationID!
        Network.liked(cancel: cancel, location: locationID) { (result) in
            print("MapViewController")
            print("LikedResult")
            print(result)
            //更改Cell
            let cell = self.marsView.cellForRow(at: IndexPath(row: index, section: 0)) as! LocationCell
            let oldAmount = Int(cell.likeAmount.text!)!
            let newAmount = cancel ? String(oldAmount-1) : String(oldAmount+1)
            cell.likeAmount.text =  newAmount
            //添加或者删除likedLocation
            if cancel {
                let index = LoginModel.owenLikedLocationIDArray.index(of:locationID)!
                LoginModel.owenLikedLocationIDArray.remove(at: index)
            }else{
                LoginModel.owenLikedLocationIDArray.append(locationID)
            }
        }
    } 
    
}

protocol MapViewDelegate {
    func selectAnnotionInCell(id: String,show:Bool)
    func getIdOf(index:Int)->String
    func showNextGroupLocation()
    func getHalfMapView()->UIView
    func marsViewMove(up:Bool)
    func resetRegionAction()
    func selectAnnotionFromCell(id:String)
    func showAFullLocationData(id:String)
}

extension MapViewController: HandleMapSearch {
    
    func showDoneButton() {
        let navigationItem = tabBarController!.navigationItem
        let barButton = UIBarButtonItem(title: "完成", style: UIBarButtonItem.Style.plain, target: self, action: #selector(doneAction))
        barButton.tintColor = #colorLiteral(red: 0.02745098039, green: 0.462745098, blue: 0.4705882353, alpha: 1)
        navigationItem.rightBarButtonItem = barButton
    }
    
    func hideDoneButton() {
        let navigationItem = tabBarController!.navigationItem
        navigationItem.rightBarButtonItem = nil
    }
    
    func dropPinZoomIn(placemark:MKPlacemark){//mapView移动到当前位置
        selectedPin = placemark
        let region = MKCoordinateRegion(center: placemark.coordinate, span: map.region.span)
        map.setRegion(region, animated: true)
    }
}

protocol LikeDelegate {
    func clickCellLike(index:Int,cancel:Bool)
}
