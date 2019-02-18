//
//  LikedLocationViewController.swift
//  igloo
//
//  Created by 冯奕琦 on 2019/2/18.
//  Copyright © 2019 冯奕琦. All rights reserved.
//

import UIKit

class LikedLocationViewController: UIViewController,SettingDelegate {

    var locationData:[(id:String,rank2:LocationInfoRank2,rank3:LocationInfoRank3)]!
    //展示数组
    var dataForMarsview:[(rank2: LocationInfoRank2, rank3: LocationInfoRank3)]{
        let array = locationData.map { (item) -> (rank2: LocationInfoRank2, rank3: LocationInfoRank3) in
            return (item.rank2,item.rank3)
        }
        return array
    }
    @IBOutlet weak var marsView: MarsTableViewForSetting!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "我赞过的地点"
        
        marsView.settingDelegate = self
        marsView.setDataIn(locationDataArray: dataForMarsview)
    }
    
    func setDataIn(data: [(id:String,rank2:LocationInfoRank2,rank3:LocationInfoRank3)]) {
        //装入locationData
        locationData = data
    }
    //MARK:Segue
    var dataSendToGreatInfo:LocationInfoLocal?
    var dataToSendIndex:Int!{
        for (index,data) in locationData.enumerated() {
            if data.id == dataToSendLocationID!{
                return index
            }
        }
        return nil
    }
    var dataToSendLocationID:String?
    func getFullLocationDataAndShow(index:Int){
        let locationID = locationData[index].id
        Network.getLocationInfo(locationID: locationID, rank: 1) { (data) in
            let locationData = data as! LocationInfoLocal
            //缓存 等待Segue
            self.dataSendToGreatInfo = locationData
            self.dataToSendLocationID = locationID
            self.performSegue(withIdentifier: "settingToGreatLocationInfo", sender: nil)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //判断segue
        if let id = segue.identifier,id == "settingToGreatLocationInfo"{//显示GreatInfo
            if let data = self.dataSendToGreatInfo{
                if let nextVC = segue.destination as? GreatLocationInfoViewController{
                    //读入数据
                    nextVC.setDataIn(data: data, isMyOwnData: false)
                    nextVC.index = dataToSendIndex
                    nextVC.locationID = dataToSendLocationID!
                    nextVC.likeDelegate = self
                    nextVC.thisIsALikedLocation = true
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
    @IBAction func unwindToLikeLocation(sender:UIStoryboardSegue){
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

extension LikedLocationViewController:LikeDelegate {
    func clickCellLike(index:Int,cancel:Bool){
        //删除Cell
        if cancel {
            locationData.remove(at: index)
            marsView.setDataIn(locationDataArray: dataForMarsview)
        }
        //发送后端
        let locationID = self.dataToSendLocationID!
        Network.liked(cancel: cancel, location: locationID) { (result) in
            print(result)
        }
        //添加或者删除likedLocation
        if cancel {
            let index = LoginModel.owenLikedLocationIDArray.index(of:locationID)!
            LoginModel.owenLikedLocationIDArray.remove(at: index)
        }else{
            LoginModel.owenLikedLocationIDArray.append(locationID)
        }
    }
}

protocol SettingDelegate {
    func getFullLocationDataAndShow(index:Int)
}
