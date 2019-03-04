//
//  ImageManager.swift
//  igloo
//
//  Created by 冯奕琦 on 2019/3/2.
//  Copyright © 2019 冯奕琦. All rights reserved.
//

import Foundation
import UIKit

class ImageManager {
    
    static func changeUIImageToData(image:UIImage)->Data?{
        if let data = image.jpegData(compressionQuality: 1){
            return data
        }else if let data = image.pngData() {
            return data
        }else{
            return nil
        }
    }
    
    static func send(dataArray:[(String,UIImage)]){
        //递归方法
        var index = 0
        func sendImage(noYetSend:[(String,UIImage)]){
            if let firstImage = noYetSend.first {
                var newImageArray = noYetSend
                newImageArray.remove(at: 0)
                //更改为Data
                let data = changeUIImageToData(image: firstImage.1)
                SendDataToImageBed.send(data, filename: firstImage.0 ){
                    print("ImageManager")
                    print("文件名称")
                    print(firstImage.0)
                    print(index)
                    index += 1
                    print("发送成功")
                    sendImage(noYetSend: newImageArray)
                }
            }else{
                print("结束")
                return
            }
        }
        sendImage(noYetSend: dataArray)
    }
}
