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
    
    //MARK: Datas
    var mapviewDelegate:MapViewDelegate!
    //State 有选中的annotion
    var haveChosenAnnotion:Bool = false
    
    func setAnnotion(array:[(String,LocationInfoRank3)]){
        haveChosenAnnotion = false
        firstTimeUpdateUserLocation = true
        //删除之前所有的Annotion 除了userLocation
        self.removeAnnotations(self.annotations)
        array.forEach { (data) in
            //添加Annotion
            let locationData = AnnotionData(rank3Data: data.1)
            locationData.subtitle = data.0
            self.addAnnotation(locationData)
        }
    }
    
    func addData(array:[(String,LocationInfoRank3)]){
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
    //MARK:自动定位userLocation
    var firstTimeUpdateUserLocation = true
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {//mapView更新userLocation的时候
        if firstTimeUpdateUserLocation {
            firstTimeUpdateUserLocation = false
            let location = userLocation.coordinate
//            print(location)
            let delta = Constants.lengthOfBigMap
            let span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: false)
            //移动地图到真正的中点
//            setUserLocationInHalfView(animated: false)
            //搜索locationData
            mapviewDelegate.resetRegionAction()
        }
    }
    
    func setUserLocationInHalfView(animated:Bool) {
        let halfMapView = mapviewDelegate.getHalfMapView()
        let realCenter = convert(halfMapView.center, toCoordinateFrom: halfMapView)
        self.setCenter(realCenter, animated: animated)
    }
    
    //移动到在正确的位置
    func setCenterInHalfView(center:CLLocationCoordinate2D){
        let halfMapView = mapviewDelegate.getHalfMapView()
        let realCenter = convert(halfMapView.center, toCoordinateFrom: halfMapView)
        let latitudeDistance:CLLocationDegrees =  realCenter.latitude - self.centerCoordinate.latitude //国内为正⚠️
        let newCenter = CLLocationCoordinate2D(latitude: center.latitude+latitudeDistance, longitude: center.longitude)
        self.setCenter(newCenter, animated: true)
    }
    
    
    func selectLocation(id:String)  {//cell选择location
        print("MapViewForExplore")
        print("cell选择location")
        dontNeedToShowMarsView = true
        for data in self.annotations{
            if data.subtitle! == id {
                //查看是否已经被选择
                if let annotion = self.selectedAnnotations.first, annotion.subtitle! == id {
                    //已经被选择不需要再进行操作
                    return
                }
                self.selectAnnotation(data, animated: true)
                break
            }
        }
    }
    
    //MARK: SelectedAnnotionDelegate
    func setLocationCenter(data:CLLocationCoordinate2D){
        setCenterInHalfView(center: data)
    }
    
    func annotionBeingSelected(id: String) {
        if dontNeedToShowMarsView {
            mapviewDelegate.selectAnnotionInCell(id:id,show:false)
            dontNeedToShowMarsView = false
        }else{
            mapviewDelegate.selectAnnotionInCell(id:id,show:true)
        }
    }
    
    func getCurrentMapView()->MapViewForExplore{
        return self
    }
    
    var dontNeedToShowMarsView:Bool = false
    
    func needToShowMarsView() -> Bool {
        return self.dontNeedToShowMarsView
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
            print("MapViewForExplore")
            print(annotion.title!," 被选中了")
            //delegate去移动MapView
            selectedDelegate.setLocationCenter(data: annotion.coordinate)
            //delegate执行
            selectedDelegate.annotionBeingSelected(id: locationID)
        }else{
            let annotionImage = Constants.getIconStruct(name: self.annotation!.title!!)!.image
            self.image = annotionImage
            //hide marsView
             selectedDelegate.getCurrentMapView().mapviewDelegate.marsViewMove(up: false)
        }
        
    }
    
    
}

protocol SelectedAnnotionDelegate {
    func setLocationCenter(data:CLLocationCoordinate2D)
    func annotionBeingSelected(id:String)
    func getCurrentMapView()->MapViewForExplore
    func needToShowMarsView() -> Bool
}
