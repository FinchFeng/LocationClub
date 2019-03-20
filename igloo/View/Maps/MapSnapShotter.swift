//
//  MapSnapShotter.swift
//  igloo
//
//  Created by 冯奕琦 on 2019/1/22.
//  Copyright © 2019 冯奕琦. All rights reserved.
//

import Foundation
import MapKit
import Alamofire

class MapSnapShotter{
    
    static func changeToString(latitude:Double,longitude:Double)->String{
        return "(" + String(latitude) + "," + String(longitude) + ")"
    }
    
    static func getExistMapImage(latitude:Double,longitude:Double)->UIImage?{//调用返回nil
        //检查池子里面有没有 Cell使用的Image
        let locationString = changeToString(latitude: latitude, longitude: longitude) + "formapview"
        if let oldImage = LocalImagePool.getImage(url: locationString){
            return oldImage
        }else{
            return nil
        }
    }
    
    //给Cell使用
    static func getMapImageForCell(latitude:Double,longitude:Double,completeAction:@escaping (UIImage)->Void){
        //检查池子里面有没有 Cell使用的Image
        let locationString = changeToString(latitude: latitude, longitude: longitude) + "formapview"
        if let oldImage = LocalImagePool.getImage(url: locationString){
            completeAction(oldImage)
        }else{
            //进行同步获取
            let coordinates = CLLocationCoordinate2DMake(latitude,longitude)
            // Define a region for our map view
            var mapRegion = MKCoordinateRegion()
            let mapRegionSpan = Constants.lengthOfMapSnap//更改为参数
            mapRegion.center = coordinates
            mapRegion.span.latitudeDelta = mapRegionSpan
            mapRegion.span.longitudeDelta = mapRegionSpan
            //创建截图options
            let options =  MKMapSnapshotter.Options()
            options.region = mapRegion
            options.mapType = .standard
            options.showsBuildings = true
            options.scale = UIScreen.main.scale//地图图片质量参数1.0
            options.size = Constants.mapSnapSize//⚠️size是固定的
            let mapSnapShot = MKMapSnapshotter(options:options)
            mapSnapShot.start{ (snapshot, error) in//分配到主队列
                //保证正确
                guard let snapshot = snapshot, error == nil else {
                    print("MapSnapShotter")
                    print(error!)
                    //出现错误就使用高德地图的api
                    gaoDeMapImage(latitude: latitude, longitude: longitude, completeAction: { (image) in
                        //添加到Pool里
                        LocalImagePool.set(image: image, url: locationString)
                        DispatchQueue.main.async {
                            //执行UI的改变
                            completeAction(image)
                        }
                    })
                    return
                }
                //(无错误)添加到Pool里
                LocalImagePool.set(image: snapshot.image, url: locationString)
                DispatchQueue.main.async {
                    //执行UI的改变
                    completeAction(snapshot.image)
                }
            }
        }
    }
    
    //使用高德地图的网页api🌍
    
    static func gaoDeMapImage(latitude:Double,longitude:Double,completeAction:@escaping (UIImage)->Void){
        //转换成api规定的String
        let locationString = String(longitude)+","+String(latitude)
        let sizeString = String(Int(Constants.mapSnapSize.height))+"*"+String(Int(Constants.mapSnapSize.width))
        let key = "306064409c1a7e52fd7fabd82605d946"
        let scale = 2
        let zoom = 14
        //使用parameter发送
        let url = "https://restapi.amap.com/v3/staticmap"
        let parameters:Parameters = ["location":locationString,"zoom":zoom,"size":sizeString,"scale":scale,"key":key]
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding(destination: .methodDependent), headers: nil)
            .responseData { (response) in
                //获取了Data数据
                let data = response.result.value!
                if let image = UIImage(data: data){//图片获取
                    completeAction(image)
                }else{
                    print("高德地图获取出错")
                }
        }
    }
    
}


