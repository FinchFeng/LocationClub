//
//  MarsTableView.swift
//  igloo
//
//  Created by 冯奕琦 on 2019/1/21.
//  Copyright © 2019 冯奕琦. All rights reserved.
//

import UIKit

class MarsTableView: UITableView,UITableViewDelegate,UITableViewDataSource {
    
    
    //MARK:使用[(Rank2,Rank3)]作为数据源,进行init
    
    var locationDataArray:[(rank2:LocationInfoRank2,rank3:LocationInfoRank3)]!
    
    func setDataIn(locationDataArray:[(rank2:LocationInfoRank2,rank3:LocationInfoRank3)]){
        //进行数据的装入
        self.locationDataArray = locationDataArray
        //delegate的装入
        self.delegate = self
        self.dataSource = self
    }
    
    //MARK:添加Cell或者删除Cell 使用之前TableView需要处于最顶部
    func addCell(data:(rank2:LocationInfoRank2,rank3:LocationInfoRank3)) {
        locationDataArray.insert(data, at: 0)
        //执行动画
        let firstCellIndex = IndexPath(row: 0, section: 0)
        self.insertRows(at: [firstCellIndex], with: UITableView.RowAnimation.fade)
    }
    
    func deleteCell(index:Int)  {
        locationDataArray.remove(at: index)
        self.deleteRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }
    
    //MARK:高度问题,与屏幕宽度成比例
    
    var locationCellHeight:CGFloat {
        let weight = self.frame.width
        return weight/MarsTableView.locationCellRadio
    }
    
    
    //MARK: TableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationDataArray.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //注意一下获取Height的时候View的Width有没有加载⚠️
        return locationCellHeight
    }
    
    //MARK: DataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationCell
        let data = locationDataArray[indexPath.row]
        //获取image
        let image:UIImage!
        let imageURL = data.rank2.locationInfoImageURL
        if imageURL == "nil"{
            //获取地图截图🔧
            image = UIImage()
        }else{
            //从本地获取
            image = LocalImagePool.getImage(url:imageURL)
        }
        //loadtheData
        cell.set(data: data.rank2, image: image)
        return cell
    }
    
}

extension MarsTableView{
    //不变的参数
    static var locationCellRadio:CGFloat = 2.31
}
