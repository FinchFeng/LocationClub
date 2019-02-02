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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("mapVC出现")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //请求地点权限
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
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
        showDoneButton()
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false//??
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
    }
    
    //MARK:DoneAction
    
    @objc func doneAction(){
        
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
extension ChoseLocationViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {//权限被修改了之后重新获取
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {//使用了requestLocation之后调用这个方法
            
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
}

extension ChoseLocationViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){//mapView移动到当前位置
        // cache the pin
        selectedPin = placemark
        // clear existing pins
//        mapView.removeAnnotations(mapView.annotations)
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = placemark.coordinate
//        annotation.title = placemark.name
//        if let city = placemark.locality,
//            let state = placemark.administrativeArea {
//            annotation.subtitle = "\(city) \(state)"
//        }

        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
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

