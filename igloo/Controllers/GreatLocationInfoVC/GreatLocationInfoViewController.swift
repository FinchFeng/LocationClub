//
//  GreatLocationInfoViewController.swift
//  igloo
//
//  Created by 冯奕琦 on 2019/1/24.
//  Copyright © 2019 冯奕琦. All rights reserved.
//

import UIKit
import MapKit

class GreatLocationInfoViewController: UIViewController {
    
    //Map
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var mapImage: UIImageView!
    
    @IBOutlet weak var moreActionButton: UIButton!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationDescrptionLabel: UILabel!
    @IBOutlet weak var LikeAmountLabel: UILabel!
    @IBOutlet weak var visitNoteTableView: VisitNoteTableView!
    @IBOutlet var mapViewCell: UIView!
    
    var locationData:LocationInfoLocal!
    var delegate:MyLocationDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moreActionButton.imageView!.contentMode = .scaleAspectFit
        //隐藏TopBar 返回的时候要再把它显示出来
        self.navigationController!.setNavigationBarHidden(true, animated: false)
        showDataToView()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        visitNoteTableView.sendSubviewToBack(mapViewCell)
//    }
    
    //被Segue之前进行配置
    func setDataIn(data:LocationInfoLocal) {
        self.locationData = data
    }
    
    func update(data:LocationInfoLocal){
        setDataIn(data: data)
        showDataToView()
    }
    
    func showDataToView(){
        //map截图
        iconImageView.image = Constants.getIconStruct(name: locationData.iconKindString)!.highlightImage
        MapSnapShotter.getMapImageForCell(latitude: locationData.locationLatitudeKey, longitude: locationData.locationLongitudeKey) { (image) in
            self.mapImage.image = image
        }
        //配置Label数据
        setAllLabel()
        //配置tableView
        visitNoteTableView.setDataIn(data: locationData.VisitedNoteID, ids: locationData.noteIDs)
        visitNoteTableView.deleteVisitNoteDelegate = self
    }
    
    //Segue到下一个
    @IBAction func segueToBigMap(_ sender: Any) {
        performSegue(withIdentifier: "segueToBigMap", sender: nil)
    }
    
    @IBAction func segueToAddVisitNote(){
        performSegue(withIdentifier: "segueToAddVisiteNote", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier , id == "segueToBigMap"{
            if let nextVC = segue.destination as? BigMapViewController{
                nextVC.setDataIn(data: self.locationData)
            }
        }else if let id = segue.identifier , id == "segueToAddVisiteNote" {
            if let nextVC = segue.destination as? AddNewVisitNoteViewController {
                nextVC.navigationTitle = locationNameLabel.text!//传递地点的名称
            }
        }else if let id = segue.identifier , id == "segueToEditLocationData"{
            if let nextVC = segue.destination as? AddNewLocationViewController {
                nextVC.setDataInForEdit(data: self.locationData) //传递地点的数据
            }
        }
    }
    
    func setAllLabel() {
        //blur all the label
        LocationCell.labelBlur(label: locationNameLabel)
        LocationCell.labelBlur(label: locationDescrptionLabel)
        LocationCell.labelBlur(label: LikeAmountLabel)
        //数据填入
        locationNameLabel.text = locationData.locationName
        locationDescrptionLabel.text = locationData.locationDescription
        LikeAmountLabel.text = String(locationData.locationLikedAmount)
    }

    @IBAction func likeAction() {
        //进行点赞
    }
    
    
    @IBAction func moreAction() {
        //展示sheet
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "在Apple地图中查看", style: .default, handler: { (_) in
            let latitude = self.locationData.locationLatitudeKey
            let longtitude = self.locationData.locationLongitudeKey
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: coordinate),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: MKCoordinateSpan(latitudeDelta: Constants.lengthOfBigMap, longitudeDelta: Constants.lengthOfBigMap))
            ]
            let placemark = MKPlacemark(coordinate:coordinate, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = self.locationData.locationName
            mapItem.openInMaps(launchOptions: options)
        }))
        actionSheet.addAction(UIAlertAction(title: "编辑地点信息", style: .default, handler: { (_) in
            //segueToEditLocationData
            self.performSegue(withIdentifier: "segueToEditLocationData", sender: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "删除此地点", style: .destructive, handler: { (_) in
            self.delegate.deleteLocation(id:self.locationData.locationID)
            self.backToMyLocation()//segue 回去
        }))
        actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func backToMyLocation() {
        performSegue(withIdentifier: "unwindFromOther", sender: nil)
        //显示TopBar
        self.navigationController!.setNavigationBarHidden(false, animated: false)
    }
    
    var newVisitNoteData:(VisitedNote,[UIImage])? = nil
    @IBAction func unwind(_ segue:UIStoryboardSegue){
        if let data = newVisitNoteData{//在这VC进行添加
            let newVisitNoteID = locationData.locationID+Date.changeDateToString(date: Date())//生成新的visiteNoteID
            delegate.addNewVisitNoteAndUpdateView(GreatVC: self, locationID: locationData.locationID, visitNoteID: newVisitNoteID, data: data.0, imageArray: data.1)
            newVisitNoteData = nil//清除
        }
        //更改的数据
    }
    
    
}

extension GreatLocationInfoViewController :DeleteVisiteNoteDelegate{
    func deleteVisiteNote(id: String) {
        delegate.deleteVisiteNote(locationID: self.locationData.locationID, visitNoteID: id)
    }
}

protocol DeleteVisiteNoteDelegate {
    func deleteVisiteNote(id:String)
}
