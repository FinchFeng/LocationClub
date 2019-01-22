//
//  MyLocationsViewController.swift
//  igloo
//
//  Created by 冯奕琦 on 2018/12/21.
//  Copyright © 2018 冯奕琦. All rights reserved.
//

import UIKit

class MyLocationsViewController: UIViewController {

    //MARK:Model
    let dataArray:[(LocationInfoRank2,LocationInfoRank3)] = []
    let data = (LocationInfoRank2(locationName:"环岛路栈桥",locationInfoWord:"厦门 亚洲海湾",
                                  locationLikedAmount:12,locationInfoImageURL:"imageTest"),
                LocationInfoRank3(locationLatitudeKey: 37.334922,locationLongitudeKey:-122.009033,iconKindString:"Views"))
    
    //MARK:Outlet
    @IBOutlet weak var locationTableView: MarsTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //储存Image到本地图片池
        let image = #imageLiteral(resourceName: "locationTestImage")
//        LocalImagePool.set(image: image, url: "imageTest")
        //配置tableView
        locationTableView.setDataIn(locationDataArray: dataArray)
//        locationTableView.addCell(data: data)
    }
    
    @IBAction func buttonTaped() {
          locationTableView.addCell(data: data)
//        locationTableView.deleteCell(index:0)
//        locationTableView.setDataIn(locationDataArray: [data])
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}
