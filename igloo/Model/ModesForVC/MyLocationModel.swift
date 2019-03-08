//
//  myLocationModel.swift
//  igloo
//
//  Created by 冯奕琦 on 2018/12/27.
//  Copyright © 2018 冯奕琦. All rights reserved.
//

import Foundation
import UIKit

class MyLocationModel {
    
    //初始化的时候就从本地读入数据
    init() {
        //从LoginModel中读入
        let savedLocationID = LoginModel.owenLocationIDArray
        locationDataArray = getLocationArrayFromFile(locationIDs: savedLocationID)
    }
    
    //MARK: Login
    
    //情况处理
    func loginHander() {
        //递归创建visit note
        func createSomeVisitNote(dataArray:[VisitedNote],id:[String],locationID:String){
            if let data = dataArray.first {
                var newID = id;newID.remove(at: 0)
                var newDataArray = dataArray;newDataArray.remove(at: 0)
                var imageArray:[UIImage] = []
                for imageURL in data.imageURLArray{
                    imageArray.append(ImageSaver.getImage(filename: imageURL)!)
                }
                Network.createVisitedNote(locationID:locationID,visitNoteID:id.first!, data: data, imageArray: imageArray){
                    createSomeVisitNote(dataArray: newDataArray, id: newID, locationID: locationID)
                }
            }else{
//                print("全部创建完成")
                return
            }
        }
        //对id进行处理 本地的检查是否isPublic是的话上传 云端的检查进行下载
//        print("loginHander  ",LoginModel.owenLocationIDArray)
        for locationId in LoginModel.owenLocationIDArray {
            //检查这个id是不是本地的 和云端是否有重复
            if let locationData = CodableSaver.getData(fileName: locationId){
                //本地的检查是否public
                if locationData.isPublic {
                    //上传云端 包括照片
                    Network.createNewLocationToServer(locaitonID: locationId, data: locationData) { (JSON) in
                        //上传封面照片如果有的话
                        if locationData.locationInfoImageURL != "nil"{
                            let image = ImageSaver.getImage(filename: locationData.locationInfoImageURL)!
                            Network.changeLocationInfoImage(locationID: locationId, image: image)
                        }
                       createSomeVisitNote(dataArray: locationData.VisitedNoteID, id: locationData.noteIDs, locationID: locationId)
                    }
                }
            }else{
                //非本地的下载到本地 图片本地化🔧
                Network.getLocationInfo(locationID: locationId, rank: 1) { (data) in
                    let data = data as! LocationInfoLocal
                    //进行本地添加 Cell图片？
                    self.locationDataArray.insert(data, at: 0)
                }
            }
        }
        
    }
    
    //MARK:数据持久化
    
    var locationDataArray:[LocationInfoLocal]!{
        didSet{
            print("MyLocationModel")
            print("localLocationDataArray我被写入了")
            //restore all data
            storeAll(datas: locationDataArray)
            print(LoginModel.owenLocationIDArray)
            print(locationDataArray)
        }
    }
    
    func storeAll(datas:[LocationInfoLocal]){
        //刷新LoginModel中的LocationIDs
        let newLocationIDs = datas.map { (data) -> String in
            return data.locationID
        }
        LoginModel.owenLocationIDArray = newLocationIDs
        //重新储存所有的数据
        for data in datas{
            CodableSaver.save(rawData: data, fileName: data.locationID)
        }
        
    }
    
    //通过id数组获取locationInfoData数组
    func getLocationArrayFromFile(locationIDs:[String])->[LocationInfoLocal] {
        var resultArray:[LocationInfoLocal] = []
        for id in locationIDs{
            if let data = CodableSaver.getData(fileName: id){
                resultArray.append(data)
            }
        }
        return resultArray
    }
    
    func updateAllLocationInfoLikeAmount(landingAction:@escaping([LocationInfoLocal])->Void){
        let oldDataArray = self.locationDataArray!
        //递归更新
        func updateLikeAmount(oldArray:[LocationInfoLocal],newArray:[LocationInfoLocal]){
            if let data = oldArray.first {
                var removedOldArray = oldArray
                removedOldArray.remove(at: 0)
                Network.getLocationInfo(locationID: data.locationID, rank: 4) { (likeAmoutData) in
                    let newLikeAmout = (likeAmoutData as! LocationInfoRank4).locationLikedAmount
                    //添加到总Like中去
                    print("MylocationModel")
                    print("递归更新Like情况")
                    LoginModel.totalLikeAmout += newLikeAmout
                    var newData = data
                    newData.locationLikedAmount = newLikeAmout
                    var addedNewArray = newArray
                    addedNewArray.append(newData)
                    updateLikeAmount(oldArray: removedOldArray, newArray: addedNewArray)
                }
            }else{
                self.locationDataArray = newArray
                landingAction(newArray)
                return
            }
        }
        updateLikeAmount(oldArray: oldDataArray, newArray: [])
    }
    
    
    //MARK: 增加 保存 更改 删除LocationInfo
    
    func addLocationInfo(data:LocationInfoLocal,UIActionBlock:@escaping ()->Void){
        //本地添加
        //查看是否公开
        if data.isPublic && LoginModel.login{
            //登陆之后->后端添加
            Network.createNewLocationToServer(locaitonID: data.locationID, data: data) { (JSON) in
                print("MyLocationModel")
                print("成功添加LocationInfo")
                //本地添加
                self.locationDataArray.insert(data, at: 0)
                UIActionBlock()
            }
        }else{
        //未登陆只进行本地添加
        locationDataArray.insert(data, at: 0)
        UIActionBlock()
        }
        
    }
    
    func editLocationInfo(newData:LocationInfoLocal,key:String,value:String,landing:@escaping () -> Void) {//key data 用于更新后端 使用这两个参数更新后端
        //查看是否公开
        if LoginModel.login && (newData.isPublic || (newData.isPublic == false && key == Constants.isPublic)){//对后端进行更改
            //查看是不是isPublic改变了
            if key == Constants.isPublic {
                //查看是改变为公开还是不公开
                if newData.isPublic && LoginModel.login{
                    //后端添加这个newData
                    Network.createNewLocationToServer(locaitonID: newData.locationID, data: newData) { (JSON) in
                        print("MyLocationModel")
                        print("后端成功添加")
                    }
                }else{
                    //后端删除这个location
                    Network.deleteLocation(locationID: newData.locationID, landingAction: {})
                }
            }else{
                //后端修改data
                Network.changeLocationData(key: key, data: value, locationID: newData.locationID, landing: landing)
            }
        }
        //只进行本地修改
        for (index,data) in locationDataArray.enumerated(){
             print("MyLocationModel")
             print("本地修改中 ", data.locationID , " " ,  newData.locationID)
            if data.locationID == newData.locationID{
               
                //进行更改
                locationDataArray[index] = newData
                break
            }
        }
        
        
    }
    
    func deleteLocaitonInfo(id:String,UIActionBlock:@escaping ()->Void)  {
        //本地删除 后端删除
        for (index,data) in locationDataArray.enumerated(){
            if data.locationID == id {
                let localDeleteBlock = {
                    //删除缓存的图片
                    let locationsData = self.locationDataArray[index]
                    for visitNote in locationsData.VisitedNoteID {
                        for imageUrl in visitNote.imageURLArray{
                            ImageSaver.deleteImage(fileName: imageUrl)
                        }
                    }
                    //本地删除
                    self.locationDataArray.remove(at: index)
                    print("MyLocationModel")
                    print("删除location")
                    print(index)
                    print(self.locationDataArray)
                    UIActionBlock()
                }
                //对data进行操作
                if data.isPublic && LoginModel.login {
                    //后端删除
                    Network.deleteLocation(locationID: id, landingAction: {
                        localDeleteBlock()
                    })
                }else{
                    localDeleteBlock()
                }
                break
            }
        }
    }
    
    //MARK: 添加删除某一个Location下的VisitNoted
    
    func addNewVisitNoteTo(locationID:String,visitNoteID:String,data:VisitedNote,imageArray:[UIImage],landingAction:(()->Void)?){
        print("MylocationModel")
        print("addNewVisitNoteTo")
        //添加ImageURL到VisitedNote数据中
        var finalData = data
        for (index,image) in imageArray.enumerated() {
            let radioString = String(Int(image.size.width))+"\(Constants.imageNameIdentChar)"+String(Int(image.size.height))//比例大小字符串
            let name = visitNoteID + "O\(index)" + "\(Constants.imageNameIdentChar)" + radioString
            //缓存到本地
            let url = "uploads/" + name + ".jpg"
            LocalImagePool.set(image: image, url: url)
            //添加到data里
            finalData.imageURLArray.append(url)
        }
        
        //找到这个location
        for (index,value) in locationDataArray.enumerated(){
            if value.locationID == locationID {
                let localAddIt = {
                    print("执行异步闭包————————————————————————")
                    //添加Cell图片
                    //自动配上图片
                    if let image = imageArray.first{
                        print("MylocationModel")
                        print("添加新的visitedNote")
                        self.setNewImageTo(locationID: locationID, image: image)
                    }
                    print("MyLocationModel")
                    print("本地添加这个visitedNote")
                    //本地添加这个visitedNote
                    var locationData = self.locationDataArray[index] //这个value为添加之前的数据
                    locationData.VisitedNoteID.insert(finalData, at: 0)//添加两个记录到数组最前面
                    locationData.noteIDs.insert(visitNoteID, at: 0)
                    //把这个更改的Location移到最前面
                    self.locationDataArray.remove(at: index)
                    self.locationDataArray.insert(locationData, at: 0)
                    if let action = landingAction{
                        action()
                    }
                    print("执行异步闭包————————————————————————End")
                }
                 //查看是否需要后端创建
                if value.isPublic && LoginModel.login{
                    Network.createVisitedNote(locationID: locationID, visitNoteID: visitNoteID, data: finalData, imageArray: imageArray ,landingAction: {
                        //本地添加
                        localAddIt()
                    })
                }else{
                    localAddIt()
                }
                break
            }
        }
        
    }
    
    func deleteVisitNoteFrom(locationID:String,visitNoteID:String,UIActionBlock:@escaping ()->Void){
        //找到这个location
        for (index,value) in locationDataArray.enumerated(){
            if value.locationID == locationID {
                let deleteLocalVisitNote = {
                    //删除本地visitNote
                    for (number,notes) in self.locationDataArray[index].noteIDs.enumerated(){
                        if notes == visitNoteID{
                            //删除本地图片
                            for imageURl in self.locationDataArray[index].VisitedNoteID[number].imageURLArray{
                                ImageSaver.deleteImage(fileName: imageURl)
                            }
                            //删除两个记录
                            self.locationDataArray[index].noteIDs.remove(at: number)
                            self.locationDataArray[index].VisitedNoteID.remove(at: number)
                            //检查删除的是不是首个VisitNote
                            if number == 0 {
                                print("MyLocationModel")
                                print("deleteVisitNoteFrom -> setNewImageTo")
                                //添加下一个VisitedNote为Cell图片
                                if let nextImageUrl = self.locationDataArray[index].VisitedNoteID.first?.imageURLArray.first{
                                    let nextImage = LocalImagePool.getImage(url: nextImageUrl)!
                                    self.setNewImageTo(locationID: locationID, image:nextImage)
                                }else{
                                    //没有VisiteNote或者没有图片
                                    self.setNewImageTo(locationID: locationID, image: nil)
                                }
                            }
                        }
                    }
                }
                //查看后端是否需要删除
                if value.isPublic && LoginModel.login{
                    Network.deleteVisitedNote(id: visitNoteID, landingAction: {
                        deleteLocalVisitNote()
                        UIActionBlock()
                    })
                }else{
                    deleteLocalVisitNote()
                    UIActionBlock()
                }
                
                
            }
        }
    }
    
    //MARK:更新imageInfoImage （显示在Cell上面的Image）
    func setNewImageTo(locationID:String,image:UIImage?) {
        print("MylocationModel")
        print("setNewImageTo被调用了")
        //找到这个location
        for (index,location) in locationDataArray.enumerated(){
            if location.locationID == locationID{
                if let image = image {//添加image
                    //crop the image
                    let radio = UIScreen.main.bounds.width/CGFloat(162)
                    let croppedImage = ImageCropper.crop(image: image, radio: radio)
                    //检查是否需要后端添加Image
                    if location.isPublic && LoginModel.login{
                        Network.changeLocationInfoImage(locationID: locationID, image: croppedImage)
                    }
                    //进行本地修改
                    let url = Network.getLocationInfoImageUrl(locationID: locationID)
                    LocalImagePool.set(image: croppedImage, url: url)//更新LocalImaagePool中的infoImage
                    locationDataArray[index].locationInfoImageURL = url
                    print("MyLocationModel")
                    print("更新LocalImaagePool中的infoImage")
                }else{//删除Image
                    //检查是否需要后端添加Nil
                    if location.isPublic && LoginModel.login{
                        Network.changeLocationData(key: Constants.locationInfoImageURL, data: "nil", locationID: locationID, landing: {})
                    }
                    //进行本地修改Nil
                    locationDataArray[index].locationInfoImageURL = "nil"
                }
                return
            }
        }
    }
    
    
}




//基于这个方法来进行数据储存的设计

class CodableSaver {//使用Json转换为Data类型
    static let document = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    @discardableResult static func save(rawData: LocationInfoLocal,fileName:String)-> Bool {
        let data = Shower.changeCodable(object: rawData)
        try! data.write(to: document.appendingPathComponent(fileName))
        return true
    }
    static func getData(fileName:String)->LocationInfoLocal?{//FileName不变
        let url = document.appendingPathComponent(fileName)
        let data = try? Data(contentsOf: url)
        if let actualData = data {
            let codableData = Shower.decoderJson(jsonData: actualData, type: LocationInfoLocal.self)
            return codableData
        }else{
            return nil
        }
    }
}

class ImageCropper {
    static func crop(image:UIImage,radio:CGFloat) -> UIImage {
        //确定新照片的rect
        let oldHeight = CGFloat(image.cgImage!.height)
        let width = CGFloat(image.cgImage!.width)
        let centerY = oldHeight/2
        let height = width/radio
        let newImageRect = CGRect(x: 0, y: centerY-height/2, width: width, height: height)
        //调用方法进行裁剪
        let newCGImage = image.cgImage!.cropping(to: newImageRect)!
        let newImage:UIImage = UIImage(cgImage: newCGImage,scale:image.scale,
                                       orientation:image.imageOrientation)
        return newImage
    }
}


