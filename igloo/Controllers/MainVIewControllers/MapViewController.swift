//
//  MapViewController.swift
//  igloo
//
//  Created by 冯奕琦 on 2018/12/21.
//  Copyright © 2018 冯奕琦. All rights reserved.
//

import UIKit

class MapViewController: UIViewController,MapViewDelegate {
    //MARK:IBOutlet
    @IBOutlet weak var map: MapViewForExplore!
    @IBOutlet weak var distanceMarsViewShowing: NSLayoutConstraint!
    @IBOutlet weak var marsView: MarsTableViewForMap!
    @IBOutlet weak var resetRegion: UIButton!
    @IBOutlet weak var indecator: UIActivityIndicatorView!
    
    lazy var halfMapView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y:marsView.frame.height/2, width: self.view.frame.width, height:  self.map.frame.height-marsView.frame.height))
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
        //尝试登陆
        if LoginModel.login == false {
            let rootVC  = self.tabBarController! as! MainTabBarController
            rootVC.login()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //显示tapBar
        self.navigationController!.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK:Actions
    @IBAction func tapView(_ sender: UITapGestureRecognizer) {//暂时不需要使用
//        if sender.state == .ended {
//            marsViewMove(up: true)//要是没有选中就自动选择第一个
//        }
    }
    
    @IBAction func resetRegionAction() {
       print("research Region")
       
        //展现全新的LocationData 自动选择第一个cell
        let currentRegion = map.region
        model.getAnnotionsAndShow(span: currentRegion) { (dataArray) in
            let dataArrayForMap = dataArray.map({ (data) -> (String,LocationInfoRank3) in
                return (data.id,data.data3)
            })
            self.map.setAnnotion(array: dataArrayForMap)
            let dataArrayForMarsView = dataArray.map({ (data) -> (LocationInfoRank2,LocationInfoRank3) in
                return (data.data2,data.data3)
            })
            self.marsView.setDataIn(locationDataArray: dataArrayForMarsView)
            //展现第一个Cell如果有数据的话
            self.marsViewMove(up: true)
            if !dataArray.isEmpty {
                self.marsView.scrollTo(index: 0)
            }else{
                //滑动到提醒的地方
                self.marsView.scrollToRow(at: IndexPath(item: 0, section: 0), at: UITableView.ScrollPosition.top, animated: false)
            }
        }
    }
    
    //MARK: 动画效果
    
    func marsViewMove(up:Bool) {
        //先更改状态
        if isShowingMarsView == up {return}
        isShowingMarsView = !isShowingMarsView
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
    
    //MARK: MapViewDelegate
    
    func selectAnnotionInCell(id: String,show:Bool) {//展现MarsView
        marsViewMove(up: true)
        print("selectAnnotionInCell(id: String,show:\(show)")
        if show == false {return}
        for (index,data) in model.currentAnnationLocationDataArray.enumerated() {
            if data.id == id {//滑动到这个Cell
                marsView.scrollTo(index:index)
                return
            }
        }
    }
    
    func getIdOf(index:Int)->String {
        return model.currentAnnationLocationDataArray[index].id
    }
    
    func showNextGroupLocation(){
        print("showNextGroupLocation")
        //展现MarsView 获取新数据
        //进行loading显示
        marsView.isGettingData = true
        indecator.startAnimating()
        indecator.isHidden = false
        model.showNextGroupOfLocationData { (newDatas) in
            let lastCellIndex = self.marsView.locationDataArray.count-1
            let dataArray = newDatas.map({ (data) -> (LocationInfoRank2,LocationInfoRank3) in
                return (data.data2,data.data3)
            })
            self.marsView.addDataIn(locationDataArray: dataArray)
            //关闭loading
            self.indecator.stopAnimating()
            self.marsView.isGettingData = false
            //select到上次最后一个Cell
//            self.marsView.scrollTo(index: lastCellIndex)
            print("lastCellIndex")
            print(lastCellIndex)
            print(self.marsView.locationDataArray.count-1)
        }
        //展现更多的Annotions
        let newAnnotionArray = Array(model.currentAnnationLocationDataArray[0..<model.currentShowingIndexMax])
        map.setAnnotion(array: newAnnotionArray)
    }
    
    func getHalfMapView()->UIView{
        return halfMapView
    }
    
    func selectAnnotionFromCell(id:String)  {
        //不进行展现
        map.dontNeedToShowMarsView = true
        map.selectLocation(id: id)
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
}
