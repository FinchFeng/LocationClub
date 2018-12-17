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
        Alamofire.request(url, method: .post, parameters: parameters ,encoding: URLEncoding(destination: .methodDependent))
            .responseJSON{ response in
                //检查数据是否传输到位
                if response.result.isSuccess, let JSONDict = response.value! as? [String:Any]{
                    print(JSONDict[Constants.usersOwenPlacesDefaultJsonKey] as! [String])
                    //执行传入的Block
                    action(JSONDict)
                }else{
                    print("错误")
                }
        }
        
    }
    
}

