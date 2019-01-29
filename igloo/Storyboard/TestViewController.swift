//
//  TestViewController.swift
//  igloo
//
//  Created by 冯奕琦 on 2018/12/17.
//  Copyright © 2018 冯奕琦. All rights reserved.
//

import MapKit
import UIKit
import SwiftPhotoGallery


class TestViewController: UIViewController, SwiftPhotoGalleryDataSource, SwiftPhotoGalleryDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
//        let image = #imageLiteral(resourceName: "beatlesAndAli")
//        //crop it !
//        let radio:CGFloat = 376/153
//        let newImage = crop(image: image, radio: radio)
//        print(newImage.size)
//
//        imageView.image = newImage
//        print(self.view.frame.size)
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
        
//        Getlocaiton方法测试
//        Network.getLocationInfo(locationID: "2", rank: 1, landingAction: { result in
//            let location = result as! LocationInfoLocal
//            print(location)
//        })
        
        //创建一个地点
//        let rank1 = LocationInfoRank1(locationName: "cocoCoffee" ,iconKindString: "Coffee" ,locationDescription: "hhhh" ,locationLatitudeKey: 3 ,locationLongitudeKey: 6 ,isPublic: true ,locationLikedAmount: 0 ,VisitedNoteID: [])
//        let rank2Data = LocationInfoRank2(locationName: "cocoCoffee" ,locationInfoWord: "nearby upc" ,locationLikedAmount: 0 ,locationInfoImageURL: "aaa" )
//        let locationData = LocationInfoLocal(locationID: "3", rank1Data: rank1, rank2Data: rank2Data, visitedNoteArray: [])
//
//        Network.createNewLocationToServer(locaitonID: "3", data: locationData) { (JSON) in
//            print("函数已经返回")
//        }
        
        //changLocation测试 登陆之后使用
//        Network.changeLocationData(key: Constants.locationName, data: "Starbucka", locationID: "1")
        
        //点赞之交测试
//        Network.likedOrNot(cancel: true, location: "1") { (result) in
//            print(result)
//        }
        
        //联系我们测试
//        Network.contactUs(string: "谢谢")
        
        //查找一个区域中的地点测试
//        let locationRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 2, longitude: 5),span:MKCoordinateSpan(latitudeDelta: 4, longitudeDelta: 4))
//        Network.getLocationsIn(span: locationRegion) { (dataArray) in
//            for data in dataArray{
//                print(data)
//                Network.getLocationInfo(locationID: data.0, rank: 2, landingAction: { data in
//                    print(data as! LocationInfoRank2)
//                })
//            }
//        }
        //VisitedNote创建与删除
//        let dateString = Date.changeDateToString(date: Date())
//        Network.createVisitedNote(locationID: "2",visitNoteID:"test",
//                                  data: VisitedNote(visitNoteWord:"aaddd",imageURLArray:[],createdTime:dateString),
//                                  imageArray:[imageView.image!,imageView.image!])

//            Network.deleteVisitedNote(id: "2112")
        //获取图片
//        Network.getImage(at: "uploads/4A8E6687-E905-4053-94B8-2786F4461319-3876-000005BE98C0017A_tmp.JPG") { image in
//            self.imageView.image = image
//        }
        //发送图片
//        let image = imageView.image!
//        Network.send(filename:"21-1", image: image, visitNoteID: "21") { (result) in
//            print(result)
//        }
        //更改LocationInfoImage
//        Network.changeLocationInfoImage(locationID: "2", image: imageView.image!)
//        配置mapView
//        let coordinates = CLLocationCoordinate2DMake(locationData.locationLatitudeKey, locationData.locationLongitudeKey)
//        var mapRegion = MKCoordinateRegion()
//        let mapRegionSpan = Constants.lengthOfGreatInfoMap
//        mapRegion.center = coordinates
//        mapRegion.span.latitudeDelta = mapRegionSpan
//        mapRegion.span.longitudeDelta = mapRegionSpan
//        map.setRegion(mapRegion, animated: false)
//        map.addNewLocation(data: locationData.changeDataTo(rank: 3) as! LocationInfoRank3)
        
        didPressShowMeButton()
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
    
    let imageArray = [#imageLiteral(resourceName: "beatlesAndAli"),#imageLiteral(resourceName: "ali"),#imageLiteral(resourceName: "defualtMapImage")]
    var index: Int = 1
    
    @IBAction func didPressShowMeButton() {
        let gallery = SwiftPhotoGallery(delegate: self, dataSource: self)
        
        gallery.firstShowImageIndex = 2
        gallery.backgroundColor = UIColor.black
        gallery.pageIndicatorTintColor = UIColor.gray.withAlphaComponent(0.5)
        gallery.currentPageIndicatorTintColor = UIColor.white
        gallery.hidePageControl = false
        
        present(gallery, animated: true, completion:  { () -> Void in
        })
        
       
         /// Or load on a specific page like this:
         
//         present(gallery, animated: true, completion: { () -> Void in
//         gallery.currentPage = self.index
//         })
 
        
    }
    
    // MARK: SwiftPhotoGalleryDataSource Methods
    
    func numberOfImagesInGallery(gallery: SwiftPhotoGallery) -> Int {
        return imageArray.count
    }
    
    func imageInGallery(gallery: SwiftPhotoGallery, forIndex: Int) -> UIImage? {
        return imageArray[forIndex]
    }
    
    // MARK: SwiftPhotoGalleryDelegate Methods
    
    func galleryDidTapToClose(gallery: SwiftPhotoGallery) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
