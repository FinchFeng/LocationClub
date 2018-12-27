//
//  myLocationModel.swift
//  igloo
//
//  Created by 冯奕琦 on 2018/12/27.
//  Copyright © 2018 冯奕琦. All rights reserved.
//

import Foundation

class MyLocationModel {
    
    //MARK: Login S
    //注意UserDefualt的数据 没有登陆怎么处理 两种情况一种没有本地数据进行登陆 第二种有本地数据进行登陆在
    //退出登陆之后删除本地数据
    
    
    //情况处理
    func loginHander() {
        //处理两种情况
        
    }
    
    //MARK: LocationInfo
    
    //增加 保存 更改 删除LocationInfo
    
    func addLocationInfo(data:LocationInfoLocal){
        //查看是否公开
        //本地添加 登陆之后->后端添加
    }
    
    func editLocationInfo(newData:LocationInfoLocal) {
        //查看是否公开
        //本地保存 后端传输
    }
    
    func deleteLocaitonInfo(id:String)  {
        //本地删除 后端删除
    }
}

