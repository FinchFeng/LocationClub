//
//  choseLocationViewController.swift
//  igloo
//
//  Created by 冯奕琦 on 2019/2/2.
//  Copyright © 2019 冯奕琦. All rights reserved.
//

import UIKit
import MapKit

class ChoseLocationViewController: UIViewController {
    
    var selectedPin:MKPlacemark? = nil
    let locationManager = CLLocationManager()
    var resultSearchController:UISearchController? = nil
    @IBOutlet weak var mapView: MKMapView!
    //MARK: LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("mapVC出现")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //请求地点代理 申请权限
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        //进行handleMapVC的配置
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        locationSearchTable.handleMapSearchDelegate = self
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        locationSearchTable.mapView = mapView
        //配置navgationBar
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.setValue("取消", forKey:"_cancelButtonText")
        searchBar.tintColor = #colorLiteral(red: 0.02745098039, green: 0.462745098, blue: 0.4705882353, alpha: 1)
        searchBar.placeholder = "搜索位置"
        searchBar.setImage(UIImage(), for: .clear, state: .normal)//隐藏删除buttun
        showDoneButton()
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false//控制bar不隐藏
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        
    }
    
    
    func setMapViewToUserLocation() {
        let location = mapView.userLocation.coordinate
        let delta = Constants.lengthOfBigMap
        let span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    //MARK:DoneAction
    
    var stringToUnwind:String  = ""
    @objc func doneAction(){
        //获取字符串
        let coordinate = mapView.centerCoordinate
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if error == nil {
                if let firstLocation = placemarks?.first{
                    self.stringToUnwind = firstLocation.changeToString()
                    //unwind
                    self.performSegue(withIdentifier: "unwind", sender: nil)
                }
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier,id == "unwind" {
            if let upVC = segue.destination as? AddNewLocationViewController{
                upVC.currenLocatinInfoString = stringToUnwind
                upVC.currenLocation2D = mapView.centerCoordinate
            }
        }
    }
    
    @IBAction func deviceLocation(){
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.requestLocation()
        setMapViewToUserLocation()
    }
    
    func showDoneButton() {
        let barButton = UIBarButtonItem(title: "完成", style: UIBarButtonItem.Style.plain, target: self, action: #selector(doneAction))
        barButton.tintColor = #colorLiteral(red: 0.02745098039, green: 0.462745098, blue: 0.4705882353, alpha: 1)
        navigationItem.rightBarButtonItem = barButton
    }
    
    func hideDoneButton() {
         navigationItem.rightBarButtonItem = nil
    }
    
}

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
    func showDoneButton()
    func hideDoneButton()
}

extension ChoseLocationViewController : MKMapViewDelegate {
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse {//权限被修改了之后重新获取
//            locationManager.requestLocation()
////            setMapViewToUserLocation()
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
////        if let location = manager.location {//使用了requestLocation之后调用这个方法
////            let delta = Constants.lengthOfBigMap
////            let span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
////            let region = MKCoordinateRegion(center: location.coordinate, span: span)
////            mapView.setRegion(region, animated: true)
////        }
//        setMapViewToUserLocation()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("error:: \(error)")
//    }
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {//mapView更新userLocation的时候
        let location = userLocation.coordinate
        let delta = Constants.lengthOfBigMap
        let span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }

}

extension ChoseLocationViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){//mapView移动到当前位置
        // cache the pin
        selectedPin = placemark
//        let delta = Constants.lengthOfBigMap
//        let span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: mapView.region.span)
        mapView.setRegion(region, animated: true)
    }
}

extension LocationSearchTable {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){//点击这个row
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        dismiss(animated: true, completion: nil)
    }
}

extension CLPlacemark{
    func changeToString() -> String {
        var result:String = ""
        if let locality = self.locality {
            result += locality + " "
        }
//        if let subLocality = self.subLocality{
//            result += subLocality + " "
//        }
        if let thoroughfare = self.thoroughfare{
            result += thoroughfare + " "
        }
        if let subThoroughfare = self.subThoroughfare{
            result += subThoroughfare
        }
        return result
    }
}
