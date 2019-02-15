//
//  MapViewForExplore.swift
//  igloo
//
//  Created by 冯奕琦 on 2019/2/13.
//  Copyright © 2019 冯奕琦. All rights reserved.
//

import Foundation
import MapKit

class MapViewForExplore: MapViewForGreatLocation,SelectedAnnotionDelegate{
    
    var mapviewDelegate:MapViewDelegate!
    
    func setAnnotion(array:[(String,LocationInfoRank3)]){
        //删除之前所有的Annotion 除了userLocation
        self.annotations.forEach { (data) in
            print(data.title!!)
        }
        self.removeAnnotations(self.annotations)
        array.forEach { (data) in
            //添加Annotion
            let locationData = AnnotionData(rank3Data: data.1)
            locationData.subtitle = data.0
            self.addAnnotation(locationData)
        }
    }
    
    //MARK: MKMapViewDelegate
    
    override func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        //对titile的分类创建AnnotionView 进行reuse的注册🔧
        let data = annotation
        let title = annotation.title!!//两次解包？
        let view = AnnotionView(annotation: data, reuseIdentifier: nil)
        view.selectedDelegate = self
        view.image = Constants.getIconStruct(name: title)!.image
        return view
    }
    //自动定位
    var firstTimeUpdateUserLocation = true
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {//mapView更新userLocation的时候
        if firstTimeUpdateUserLocation {
            firstTimeUpdateUserLocation = false
            let location = userLocation.coordinate
            print(location)
            let delta = Constants.lengthOfBigMap
            let span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: false)
            //移动地图到真正的中点
            setUserLocationInHalfView(animated: false)
        }
    }
    
    func setUserLocationInHalfView(animated:Bool) {
        let halfMapView = mapviewDelegate.getHalfMapView()
        let realCenter = convert(halfMapView.center, toCoordinateFrom: halfMapView)
        self.setCenter(realCenter, animated: animated)
    }
    
    func setCenterInHalfView(center:CLLocationCoordinate2D){
        let halfMapView = mapviewDelegate.getHalfMapView()
        let realCenter = convert(halfMapView.center, toCoordinateFrom: halfMapView)
        let latitudeDistance:CLLocationDegrees =  realCenter.latitude - self.centerCoordinate.latitude //国内为正⚠️
//        print(realCenter)
//        print(self.centerCoordinate)
//        print(latitudeDistance)
        let newCenter = CLLocationCoordinate2D(latitude: center.latitude+latitudeDistance, longitude: center.longitude)
        self.setCenter(newCenter, animated: true)
    }
    
    
    func selectLocation(id:String)  {//代码选择location
        for data in self.annotations{
            if data.subtitle! == id {
                self.selectAnnotation(data, animated: true)
                break
            }
        }
    }
    
    //MARK: SelectedAnnotionDelegate
    func setLocationCenter(data:CLLocationCoordinate2D){
        setCenterInHalfView(center: data)
//        self.setRegion(MKCoordinateRegion(center: data, span: self.region.span), animated: false)
//        setUserLocationInHalfView(animated: false)
    }
    
    func annotionBeingSelected(id: String) {
        mapviewDelegate.selectAnnotion(id:id)
    }
    
    func getCurrentMapView()->MapViewForExplore{
        return self
    }
}

class AnnotionView:StaticAnnotionView{//可以选中
    
    var selectedDelegate:SelectedAnnotionDelegate!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        let annotion = self.annotation! as! AnnotionData
        //更换Selected图片
        if selected {
            let annotionHighLightImage = Constants.getIconStruct(name: annotion.title!)!.highlightImage
            self.image = annotionHighLightImage
            //执行delegate
            let locationID = annotion.subtitle!
//            print(locationID)
            selectedDelegate.annotionBeingSelected(id: locationID)
            //delegate去移动MapView
            selectedDelegate.setLocationCenter(data: annotion.coordinate)
        }else{
            let annotionImage = Constants.getIconStruct(name: self.annotation!.title!!)!.image
            self.image = annotionImage
            
        }
        print(selected)
        print(selectedDelegate.getCurrentMapView().selectedAnnotations.count)
    }
    
    
}

protocol SelectedAnnotionDelegate {
    func setLocationCenter(data:CLLocationCoordinate2D)
    func annotionBeingSelected(id:String)
    func getCurrentMapView()->MapViewForExplore
}
