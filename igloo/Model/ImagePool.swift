//
//  ImagePool.swift
//  igloo
//
//  Created by 冯奕琦 on 2019/1/17.
//  Copyright © 2019 冯奕琦. All rights reserved.
//

import Foundation
import UIKit

class ImageChecker {
    
    //缓存策略为退出前都有保存
    static var pool:[String:UIImage] = [:]
    
    class func getImage(url:String)->UIImage?{
        return pool[url]
    }
    
    class func set(image:UIImage,url:String){
        pool[url] = image
    }
    
    //进行图片大小格式检查
    static func review(image:UIImage)->UIImage{
        //转换为Data检查大小
        let data = image.jpegData(compressionQuality: 1)!
        let size = data.getSizeWithMB()
        //进行压缩
        var resultData:Data!
        if size > 5 {
            resultData = image.jpegData(compressionQuality: 0.5)!
        }else if size > 1{
            resultData = image.jpegData(compressionQuality: 0.8)!
        }
        //返回UIImage
        return UIImage(data: resultData)!
    }
    
}

class LocalImagePool:ImageChecker {
    //加入local图片池的图片全部都保存在本机
//    override class func set(image:UIImage,url:String){
//
//    }
//    override class func getImage(url:String)->UIImage?{
//        return pool[url]
//    }
}



