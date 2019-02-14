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
    
    //MARK:State or properties
    var model = AirModel()
    var isShowingMarsView:Bool = false
    
    //MARK:LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            marsViewMove(up: !isShowingMarsView)
            isShowingMarsView = !isShowingMarsView
        }
    }
    
    @IBAction func resetRegionAction(_ sender: Any) {
        print("research Region")
        let dataArray:[(LocationInfoRank2,LocationInfoRank3)] =  [(LocationInfoRank2(locationName: "cocoCoffee" ,locationInfoWord: "nearby upc" ,locationLikedAmount: 0 ,locationInfoImageURL: "nil" ),LocationInfoRank3(locationLatitudeKey:3,locationLongitudeKey:6,iconKindString:"Cafe")),
                       (LocationInfoRank2(locationName: "koiCoffee" ,locationInfoWord: "nearby upc" ,locationLikedAmount: 0 ,locationInfoImageURL: "nil" ),LocationInfoRank3(locationLatitudeKey:4,locationLongitudeKey:5,iconKindString:"Bar")),
                       (LocationInfoRank2(locationName: "cocoCoffee" ,locationInfoWord: "nearby upc" ,locationLikedAmount: 0 ,locationInfoImageURL: "nil" ),LocationInfoRank3(locationLatitudeKey:6,locationLongitudeKey:6,iconKindString:"Cafe")),
                       (LocationInfoRank2(locationName: "cocoCoffee" ,locationInfoWord: "nearby upc" ,locationLikedAmount: 0 ,locationInfoImageURL: "nil" ),LocationInfoRank3(locationLatitudeKey:7,locationLongitudeKey:6,iconKindString:"Cafe"))]
        marsView.setDataIn(locationDataArray:dataArray)
        
    }
    
    //MARK: 动画效果
    
    func marsViewMove(up:Bool) {
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
    
}

protocol MapViewDelegate {
    func selectAnnotion(id:String)
    func getIdOf(index:Int)->String
}
