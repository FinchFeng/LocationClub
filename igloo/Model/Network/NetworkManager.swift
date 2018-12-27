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
    
    //登陆
    
    //MARK:辅助方法
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
    
    
    
}

