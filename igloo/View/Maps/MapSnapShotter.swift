//
//  MapSnapShotter.swift
//  igloo
//
//  Created by 冯奕琦 on 2019/1/22.
//  Copyright © 2019 冯奕琦. All rights reserved.
//

import Foundation
import MapKit

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
            options.scale = UIScreen.main.scale
            options.size = Constants.mapSnapSize//⚠️size是固定的
            let mapSnapShot = MKMapSnapshotter(options:options)
            mapSnapShot.start{ (snapshot, error) in//分配到主队列
                //保证正确
                guard let snapshot = snapshot, error == nil else {
                    print(error!)
                    return
                }
                //添加到Pool里
                LocalImagePool.set(image: snapshot.image, url: locationString)
                DispatchQueue.main.async {
                    //执行UI的改变
                    completeAction(snapshot.image)
                }
            }
        }
    }
    
    //给MomentVC使用 还有一个Image
    
}


