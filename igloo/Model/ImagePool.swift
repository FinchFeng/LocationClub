//
//  ImagePool.swift
//  igloo
//
//  Created by 冯奕琦 on 2019/1/17.
//  Copyright © 2019 冯奕琦. All rights reserved.
//

import Foundation
import UIKit

class ImageChecker {//网络方法链接的Pool
    
    //缓存策略为退出前都有保存
    static var pool:[String:UIImage] = [:]
    
    class func getImage(url:String)->UIImage?{
        if let networkCacheImage = pool[url] {
            return networkCacheImage
        }else{//也可以获取Local的资源
            return LocalImagePool.getImage(url:url)
        }
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

class LocalImagePool {//是ImageChecker的子集
    //加入local图片池的图片全部都保存在本机 注意父类的Pool
    static var pool:[String:UIImage] = [:]{
        didSet{
            print(pool)
        }
    }
    class func set(image:UIImage,url:String){
        //进行图片储存
        ImageSaver.save(image: image,fileName:url)
        //加入pool
        pool[url] = image
    }
    
    class func getImage(url:String)->UIImage?{
        if let imageInPool = pool[url]{
            return imageInPool
        }else{
            //去文档系统中获取
            if let image = ImageSaver.getImage(filename: url){
                //储存到Pool
                pool[url] = image
                return image
            }else{
                return nil
            }
        }
    }
}
class ImageSaver {
    static let document = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    @discardableResult static func save(image: UIImage,fileName:String) -> Bool {
        do {
            guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
                return false
            }
            try data.write(to: document.appendingPathComponent(fileName))
        }catch{
            print(error)
            return false
        }
        return true
    }
    static func getImage(filename:String)->UIImage?{//FileName不变
        let url = document.appendingPathComponent(filename)
        let data = try? Data(contentsOf: url)
        if let actualData = data{
            let image = UIImage(data: actualData)
            return image
        }else{
            return nil
        }
    }
}


