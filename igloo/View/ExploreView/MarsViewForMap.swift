//
//  MarsViewForMap.swift
//  igloo
//
//  Created by 冯奕琦 on 2019/2/13.
//  Copyright © 2019 冯奕琦. All rights reserved.
//

import Foundation
import UIKit

class MarsTableViewForMap: MarsTableView {//不保存ID 使用delegate回去请求
    
    //记得赋值
    var mapViewDelegate:MapViewDelegate!
    var isGettingData:Bool = false
    
    //MARK:加入数据
    override func setDataIn(locationDataArray: [(rank2: LocationInfoRank2, rank3: LocationInfoRank3)]) {
        super.setDataIn(locationDataArray: locationDataArray)
        DispatchQueue.main.async {
            self.scrollTo(index: 0,selectAnnotion:true)
        }
        isEndOfTableView = false
        //配置decelerate的速度
        decelerationRate = UIScrollView.DecelerationRate(rawValue: 0)
    }
    //endline label
    var shouldScrollTo:Int?
    var endLineLabel:UILabel?
    var isEndOfTableView:Bool = false {
        didSet{
            if oldValue == false , isEndOfTableView == true{
                //添加“到底了”标签
                let newLabel = UILabel(frame: CGRect(x: 0, y: contentSize.height, width: UIScreen.main.bounds.width, height: Constants.locationCellSize.height*0.6))
                newLabel.text = "————— 底线 —————"
                newLabel.textAlignment = .center
                newLabel.textColor = UIColor.white
                newLabel.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
                addSubview(newLabel)
                endLineLabel = newLabel
                //更改ScrollView的大小
                let newContentY = newLabel.frame.maxY
                self.contentSize = CGSize(width: contentSize.width, height: newContentY)
            }else if isEndOfTableView == false{
                //删除此标签
                if let label = endLineLabel{
                    label.removeFromSuperview()
                }
            }
            
        }
    }
    
    func addDataIn(locationDataArray: [(rank2: LocationInfoRank2, rank3: LocationInfoRank3)]) {
        let currentIndex = self.locationDataArray.count
        self.locationDataArray += locationDataArray
        var indexArray:[IndexPath] = []
        for (index,_) in locationDataArray.enumerated() {
            indexArray.append(IndexPath(row: currentIndex+index, section: 0))
        }
        insertRows(at: indexArray, with: UITableView.RowAnimation.fade)
        //insert结束之后得到通知
        DispatchQueue.main.async {
            if let index = self.shouldScrollTo {
                self.scrollTo(index: index, selectAnnotion: true)
                self.shouldScrollTo = nil
            }
        }
    }
    
    //MARK : Override tableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if locationDataArray.isEmpty {
            return 1
        }else{
            return locationDataArray.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if locationDataArray.isEmpty {
            let cell = dequeueReusableCell(withIdentifier: "noResultCell")!
            return cell
        }else{
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //取消选中
        tableView.deselectRow(at: indexPath, animated: false)
        //进行全部信息的获取
        let locationID = mapViewDelegate.getIdOf(index: indexPath.row)
        print("MarsViewForMap")
         print("点击了\(indexPath.row)cell locationID \(locationID)")
        mapViewDelegate.showAFullLocationData(id: locationID)
    }
    
    //MARK:滑动控制
    
    //惯性开始
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.stoppedScrolling()
    }
    //停止动作
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.stoppedScrolling()
        }
    }
    //停止的处理方法
    func stoppedScrolling() {
        print("MarsViewForMap")
        print("stoppedScrolling")
        if locationDataArray.isEmpty {
//            print("locationDataArray.isEmpty")
            return
        }//没有Cell的话不用处理
        let offset = self.contentOffset.y
        let cell = getCellFrom(offset: offset)!
        scrollTo(cell: cell,selectAnnotion:true)
    }
    
    //移动到某一Cell上
    func scrollTo(cell:LocationCell,selectAnnotion:Bool) {
        if isGettingData {return}
        let minY = cell.frame.minY
        self.setContentOffset(CGPoint(x: 0, y: minY), animated: true)
        //显示指示条
        for index in 0..<self.locationDataArray.count {
            if let cell = self.cellForRow(at: IndexPath(row: index, section: 0)) as? LocationCell{
                cell.hideIndecater()
            }
        }
        cell.showIndecater()
        print("MarsViewForMap")
        print(cell.index!," Cell 被选中")
        //要是是最后一个地点数据，进行新一轮的数据获取
        if cell.index == self.locationDataArray.count-1 , isEndOfTableView == false{
            mapViewDelegate.showNextGroupLocation()
        }
        //展现对应的Annotion
        if selectAnnotion {
            let id = mapViewDelegate.getIdOf(index: cell.index)
            mapViewDelegate.selectAnnotionFromCell(id: id)
        }
        
    }
    func scrollTo(index:Int,selectAnnotion:Bool) {//只有选择Map之后才会调用这个方法
        if let cell = self.cellForRow(at: IndexPath(row: index, section: 0)) as? LocationCell {
            print("MarsViewForMap")
            print("scrollTo(index:\(index) selectAnnotion \(selectAnnotion)")
            scrollTo(cell: cell,selectAnnotion:selectAnnotion)
        }else{
            //Cell还未生成直接滑动到顶部
            print("MarsViewForMap")
            print("第\(index)个 Cell还未生成")
            self.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        }
    }
    
    
    //找到这个Offset属于哪个Cell
    func getCellFrom(offset:CGFloat)->LocationCell?  {
        for index in 0..<self.locationDataArray.count {
            if let cell = self.cellForRow(at: IndexPath(row: index, section: 0)) {
                //判断是否在这个区域内
                let midY = cell.frame.minY
                let cellHeight = Constants.locationCellSize.height
                if midY-cellHeight/2 < offset && offset <= midY+cellHeight/2 {
                    return cell as? LocationCell
                }
            }
        }
        if offset < 0 {
            return cellForRow(at: IndexPath(row: 0, section: 0)) as? LocationCell
        }else{
            return cellForRow(at: IndexPath(row: self.locationDataArray.count-1, section: 0)) as? LocationCell
        }
    }
    
}

