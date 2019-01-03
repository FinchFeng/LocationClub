//
//  NetworkManager.swift
//  igloo
//
//  Created by 冯奕琦 on 2018/12/14.
//  Copyright © 2018 冯奕琦. All rights reserved.
//

import Foundation
import Alamofire
import WebKit

class Network {
    
    //MARK:登陆接口
    
    //登陆接口igloo
    static func login(withGoogle:Bool,GoogleId:String? = nil,GoogleName:String? = nil,number:String? = nil,password:String? = nil,action: @escaping ([String:Any])->Void ){
        //配置参数
        var parameters :Parameters = [:]
        if withGoogle {
            parameters = [Constants.thirdPartyID:GoogleId!,Constants.userName:GoogleName!,Constants.loginWithGoogle:"True"]
        }else{
            parameters = [Constants.phoneNumber:number!,Constants.password:password!,Constants.loginWithGoogle:"False"]
        }
        //配置地址
        let url = Constants.backendURL + "iglooLogin/"
        //发送方法
        sendRuquest(url: url, method: .post, parameters: parameters, action: action)
        
    }
    
    
    
    //获取验证码
    static func gettingCode(phoneNumber:String,action: @escaping ([String:Any])->Void){//调用前检查手机号格式
        
        //配置参数
        let parameters = [Constants.phoneNumber:phoneNumber]
        //配置Url
        let url = Constants.backendURL + "gettingCode/"
        //发送方法
        sendRuquest(url: url, method: .post, parameters: parameters, action: action)
        
    }
    
    //注册
    static func signUp(phoneNumber:String,code:String,password:String,action: @escaping ([String:Any])->Void){
        let parameters = [Constants.phoneNumber:phoneNumber,Constants.code:code,Constants.password:password]
        let url = Constants.backendURL + "signIn/"
        sendRuquest(url: url, method: .post, parameters: parameters, action: action)
    }
    
    //MARK: LocationInfo
    
    //登陆之后才能使用
    static func createNewLocationToServer(locaitonID:String,data:LocationInfoLocal,action:@escaping ([String:Any])->Void){
        //locationInfoLocal转化为parameters参数
        var parameters = Shower.changeLocationInfoToParameters(data: data)
        //获取LocaitonID iglooID
        parameters[Constants.iglooID] = LoginModel.iglooID
        parameters[Constants.locationID] = locaitonID
        //url
        let url = Constants.backendURL + "addLocation/"
        sendRuquest(url: url, method: .get, parameters: parameters, action: action)
    }
    
    
    
    //获取地点信息 注意顶级信息在这里代表全部信息
    static func getLocationInfo(locationID:String,rank:Int,landingAction: @escaping (Any)->Void){//
        
        let locationUrl = Constants.backendURL + "getLocation/"
        
        //内部方法—————使用这个方法来获取2到4rank的数据
        func getRankData(_ rank:Int){
            let paramenters = [Constants.locationID:locationID,Constants.rankOfLocationInfo:String(rank)]
            Alamofire.request(locationUrl, method: .get, parameters: paramenters, encoding: URLEncoding(destination: .methodDependent)).responseJSON(completionHandler: { (response) in
                if let data = response.data {
                    //直接Decode Json
                    var dataForUse:Codable?
                    print(rank)
                    switch rank{
                    case 2: dataForUse = Shower.decoderJson(jsonData: data, type: LocationInfoRank2.self)
                    case 3: dataForUse = Shower.decoderJson(jsonData: data, type: LocationInfoRank3.self)
                    case 4: dataForUse = Shower.decoderJson(jsonData: data, type: LocationInfoRank4.self)
                    default : return
                    }
                    //执行LandingAction
                    if let data = dataForUse{
                        landingAction(data)
                    }else{
                        print("无数据")
                    }
                }
            })
        }
        
        let paramenters1 = [Constants.locationID:locationID,Constants.rankOfLocationInfo:"1"]
        let paramenters2 = [Constants.locationID:locationID,Constants.rankOfLocationInfo:"2"]
        switch rank {
        case 1://获取全部地址信息
            //数据储存器
            var rank1Data:Data?
            var rank2Data:Data?
            var visitedNoteIDArray:[String] = []
            //手写链式调用Request
            Alamofire.request(locationUrl, method: .get, parameters: paramenters1,encoding: URLEncoding(destination: .methodDependent))
                .responseJSON { (response) in//第一次返回一个Rank1数据
                    //使用Shower来更改为Swift类型
                    if let data = response.data {
                        rank1Data = data
                        //获取VisitedNoteID数组
                        if let rank1class = Shower.decoderJson(jsonData: data, type: LocationInfoRank1.self){
                            visitedNoteIDArray = rank1class.VisitedNoteID
//                            print(visitedNoteIDArray)
                        }else{
                            print("出错鸟")
                            return
                        }
                    }
                    //进行rank2data的请求
                    Alamofire.request(locationUrl, method: .get, parameters: paramenters2, encoding: URLEncoding(destination: .methodDependent)).responseJSON(completionHandler: { (response) in
                        if let data = response.data {
                            rank2Data = data
                            //进行递归的数组信息获取 并且在最后一个Block执行Block
                            getVisitNotes(locationID:locationID,IDs: visitedNoteIDArray, dataArray: [],
                                          rankData: [rank1Data!,rank2Data!], finalBlock: landingAction)
                        }
                    })
                    
                }
        default:
            if 2 <= rank , rank <= 4{
                getRankData(rank)//其他级别使用这个方法
            }else{
                print("超出范围")
            }
        }
        
        
        
    }
    
    //更改Location信息 登陆之后才能使用⚠️
    static func changeLocationData(key:String,data:String,locationID:String){
        //从UserDefault中获取iglooID
        let iglooID = LoginModel.iglooID
        //配置Url
        let url = Constants.backendURL + "changeLocationInfo/"
        //配置参数
        let parameters = ["key":key,"data":data,Constants.iglooID:iglooID,Constants.locationID:locationID]
        //发送参数
        sendRuquest(url: url, method: .get, parameters: parameters) { (JSON) in
            if let result = JSON["success"] as? Bool{
                print("更改Location信息 " + String(result))
            }else{
                //错误信息
            }
        }
    }
    
    //删除Locaition
    static func deleteLocation(locationID:String){
        //从UserDefault中获取iglooID
        let iglooID = LoginModel.iglooID
        //配置Url
        let url = Constants.backendURL + "changeLocationInfo/"
        //配置参数
        let parameters = ["key":"delete",Constants.iglooID:iglooID,Constants.locationID:locationID]
        //发送参数
        sendRuquest(url: url, method: .get, parameters: parameters) { (JSON) in
            if let result = JSON["success"] as? String{
                print("删除Location信息 " + result)
            }
        }
    }
    
    //MARK:辅助方法
    
    //使用这个方法运行没有Codable类的功能
    static func sendRuquest(url:String,method:HTTPMethod,parameters:Parameters,action: @escaping ([String:Any])->Void){
        //发送方法
        Alamofire.request(url, method: method, parameters: parameters ,encoding: URLEncoding(destination: .methodDependent))
            .responseJSON{ response in
                //检查数据是否传输到位
                if response.result.isSuccess, let JSONDict = response.value! as? [String:Any]{
                    //执行传入的Block
                    DispatchQueue.main.async {
                        action(JSONDict)
                    }
                }else{
                    print("错误")
                }
        }
    }
    
    //递归获取方法 等待加入图片获取
    static func getVisitNotes(locationID:String,IDs: [String],dataArray: [Data],rankData:[Data],finalBlock: @escaping (Any)->Void){//当IDs空的时候就停止递归
        let url = Constants.backendURL + "getVisitedNoteInfo/"
        //检查是否结束了
        if IDs.isEmpty {//结束那么所有数据到手
            //组装LocationInfo
            if let locationInfo = Shower.assemble(locationID:locationID, rank1Data: rankData[0], rank2Data: rankData[1], VisitedNotedArray: dataArray){
                //执行最后的操作
                finalBlock(locationInfo)
            }
            return
        }else{
            Alamofire.request(url, method: .get, parameters: [Constants.VisitedNoteID:IDs.first!], encoding: URLEncoding(destination: .methodDependent))
                .responseJSON { (JSONRespond) in
                    if let data = JSONRespond.data {
                        //存入数组
                        var nextDataArray = dataArray
                        nextDataArray.append(data)
                        //删除被获取的id
                        var nextIDs = IDs
                        nextIDs.remove(at:0)
                        //继续递归
                        getVisitNotes(locationID:locationID,IDs: nextIDs, dataArray: nextDataArray, rankData: rankData,finalBlock: finalBlock)
                    }
            }
        }
    }
    
    
    
    
    
}

