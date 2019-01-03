//
//  TestViewController.swift
//  igloo
//
//  Created by 冯奕琦 on 2018/12/17.
//  Copyright © 2018 冯奕琦. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        let image = #imageLiteral(resourceName: "beatlesAndAli")
//        //crop it !
//        let radio:CGFloat = 376/153
//        let newImage = crop(image: image, radio: radio)
//        print(newImage.size)
//
//        imageView.image = newImage
        
    }
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func hitButton() {
//        Network.login(withGoogle:false,number: "17864266604", password: "12345") { JSON in
//            print(JSON)
//        }
//        Network.login(withGoogle:true,GoogleId: "Gogle2",GoogleName:"Fucker") { _ in }
//        Network.gettingCode(phoneNumber: "17864266604", action: {_ in
//            print("GettingCode")
//        })
//        Network.signUp(phoneNumber: "17864266604", code: "9080", password: "12345", action: {_ in
//            print("signUp")
//        })
//        print(LoginModel.login)
//        print(LoginModel.owenLikedLocationIDArray)
//        print(LoginModel.iglooID)
        //图片储存
//        print(ImageSaver.saveImage(image: #imageLiteral(resourceName: "ali")))
//        let image = ImageSaver.getImage(name: "ali.jpeg")
//        print(image)
        //CodableSaver
//        let data = LocationInfoRank4(locationLikedAmount:3)
//        print(CodableSaver.save(rawData: data))
//        let codableData = CodableSaver.getData()
//        print(codableData!.locationLikedAmount)
        
        //Getlocaiton方法测试
//        Network.getLocationInfo(locationID: "1", rank: 4, landingAction: { result in
//            let location = result as! LocationInfoRank4
//            print(location)
//        })
        
        //changLocation测试
        Network.changeLocationData(key: Constants.locationName, data: "Starbucka", locationID: "1")
    }
    
    
    
    func crop(image:UIImage,radio:CGFloat) -> UIImage {
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
