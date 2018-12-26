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
    
    //使用泛型(带有Protocal) 把JSON直接转化为Codable Class
    static func decoderJson<T:Codable>(jsonData:Data,type:T.Type) -> T? {
        if let newData = try? JSONDecoder().decode(type, from: jsonData){
            return newData
        }else{
            return nil
        }
    }
    
    //把Codable转化为JSON
    static func changeCodable<T:Codable>(object:T)->Data{
        let jsonData:Data = try! JSONEncoder().encode(object)
        return jsonData
    }
    
}

