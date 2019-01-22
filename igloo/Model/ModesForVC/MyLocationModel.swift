//
//  myLocationModel.swift
//  igloo
//
//  Created by 冯奕琦 on 2018/12/27.
//  Copyright © 2018 冯奕琦. All rights reserved.
//

import Foundation

class MyLocationModel {
    
    //初始化的时候就从本地读入数据
    init() {
        //从LoginModel中读入
        let savedLocationID = LoginModel.owenLocationIDArray
        localLocationDataArray = getLocationArrayFromFile(locationIDs: savedLocationID)
    }
    
    //MARK: Login
    
    //情况处理
    func loginHander() {
        //处理两种情况
        
    }
    
    //MARK:数据持久化
    
    var localLocationDataArray:[LocationInfoLocal]!{
        didSet{
            print("localLocationDataArray我被写入了")
            //restore all data
            storeAll(datas: localLocationDataArray)
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
    
    //通过id数组获取locationInfoData数组q
    func getLocationArrayFromFile(locationIDs:[String])->[LocationInfoLocal] {
        var resultArray:[LocationInfoLocal] = []
        for id in locationIDs{
            if let data = CodableSaver.getData(fileName: id){
                resultArray.append(data)
            }
        }
        return resultArray
    }
    
    
    //MARK: LocationInfo
    
    //增加 保存 更改 删除LocationInfo
    
    func addLocationInfo(data:LocationInfoLocal){
        //本地添加
        //查看是否公开
        if data.isPublic && LoginModel.login{
            //登陆之后->后端添加
            Network.createNewLocationToServer(locaitonID: data.locationID, data: data) { (JSON) in
                print("成功添加")
            }
        }
        //未登陆只进行本地添加
        localLocationDataArray.insert(data, at: 0)
        
    }
    
    func editLocationInfo(newData:LocationInfoLocal,key:String,value:String) {//key data 用于更新后端 使用这两个参数更新后端
        //查看是否公开
        if newData.isPublic && LoginModel.login && (newData.isPublic == false && key == Constants.isPublic){//对后端进行更改
            //查看是不是isPublic改变了
            if key == Constants.isPublic {
                //查看是改变为公开还是不公开
                if newData.isPublic{
                    //后端添加这个newData
                    Network.createNewLocationToServer(locaitonID: newData.locationID, data: newData) { (JSON) in
                        print("成功添加")
                    }
                }else{
                    //后端删除这个location
                    Network.deleteVisitedNote(id: newData.locationID)
                }
            }else{
                //后端修改data
                Network.changeLocationData(key: key, data: value, locationID: newData.locationID)
            }
        }
        //只进行本地修改
        for (index,data) in localLocationDataArray.enumerated(){
            if data.locationID == newData.locationID{
                //进行更改
                localLocationDataArray[index] = newData
                break
            }
        }
        
        
    }
    
    func deleteLocaitonInfo(id:String)  {
        //本地删除 后端删除
        for (index,data) in localLocationDataArray.enumerated(){
            if data.locationID == id {
                //对data进行操作
                if data.isPublic {
                    //后端删除
                    Network.deleteLocation(locationID: id)
                }
                //本地删除
                localLocationDataArray.remove(at: index)
                break
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
        let data = try! Data(contentsOf: url)
        let codableData = Shower.decoderJson(jsonData: data, type: LocationInfoLocal.self)
        return codableData
    }
}


