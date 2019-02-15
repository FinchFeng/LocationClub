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
        let dataArray:[(LocationInfoRank2,LocationInfoRank3)] =  [(LocationInfoRank2(locationName: "cocoCoffee" ,locationInfoWord: "nearby upc" ,locationLikedAmount: 0 ,locationInfoImageURL: "nil" ),LocationInfoRank3(locationLatitudeKey:3,locationLongitudeKey:6,iconKindString:"Cafe")),
                                                                  (LocationInfoRank2(locationName: "koiCoffee" ,locationInfoWord: "nearby upc" ,locationLikedAmount: 0 ,locationInfoImageURL: "nil" ),LocationInfoRank3(locationLatitudeKey:4,locationLongitudeKey:5,iconKindString:"Bar")),
                                                                  (LocationInfoRank2(locationName: "cocoCoffee" ,locationInfoWord: "nearby upc" ,locationLikedAmount: 0 ,locationInfoImageURL: "nil" ),LocationInfoRank3(locationLatitudeKey:6,locationLongitudeKey:6,iconKindString:"Cafe")),
                                                                  (LocationInfoRank2(locationName: "cocoCoffee" ,locationInfoWord: "nearby upc" ,locationLikedAmount: 0 ,locationInfoImageURL: "nil" ),LocationInfoRank3(locationLatitudeKey:7,locationLongitudeKey:6,iconKindString:"Cafe"))]
        
        marsView.setDataIn(locationDataArray:dataArray)
        map.setAnnotion(array: [
            ("1",LocationInfoRank3(locationLatitudeKey: 22.294681,locationLongitudeKey:114.168177,iconKindString:"Cafe"))
            ,("1",LocationInfoRank3(locationLatitudeKey: 22.384681,locationLongitudeKey:114.158177,iconKindString:"Bar"))
            ,("1",LocationInfoRank3(locationLatitudeKey: 22.244681,locationLongitudeKey:114.148177,iconKindString:"Alien"))
            ,("1",LocationInfoRank3(locationLatitudeKey: 22.254681,locationLongitudeKey:114.168177,iconKindString:"Hotel"))])
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
    @IBAction func tapView(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if map.selectedAnnotations.count == 0 {
                marsViewMove(up: true)//要是没有选中就自动选择第一个
            }else{
                
            }
        }
    }
    
    @IBAction func resetRegionAction(_ sender: Any) {
       print("research Region")
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
    
    func selectAnnotion(id: String) {//展现MarsView
        
    }
    
    func getIdOf(index:Int)->String {
        return model.currentAnnationLocationDataArray[index].id
    }
    
    func showNextGroupLocation(){
        //展现MarsView 获取新数据
        model.showNextGroupOfLocationData { (newDatas) in
            let dataArray = newDatas.map({ (data) -> (LocationInfoRank2,LocationInfoRank3) in
                return (data.data2,data.data3)
            })
            self.marsView.addDataIn(locationDataArray: dataArray)
        }
        //展现Annotions
        let newAnnotionArray = Array(model.currentAnnationLocationDataArray[model.currentShowingIndexMax..<model.currentShowingIndexMax+model.groupAmount])
        map.setAnnotion(array: newAnnotionArray)
    }
    
    func getHalfMapView()->UIView{
        return halfMapView
    }
}

protocol MapViewDelegate {
    func selectAnnotion(id:String)
    func getIdOf(index:Int)->String
    func showNextGroupLocation()
    func getHalfMapView()->UIView
}
