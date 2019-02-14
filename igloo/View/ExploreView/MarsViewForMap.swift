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
    
    override func setDataIn(locationDataArray: [(rank2: LocationInfoRank2, rank3: LocationInfoRank3)]) {
        super.setDataIn(locationDataArray: locationDataArray)
        //配置decelerate的速度
        decelerationRate = UIScrollView.DecelerationRate(rawValue: 0)
        //select第一个Cell
        if !locationDataArray.isEmpty {
            let cell = cellForRow(at: IndexPath(row: 0, section: 0 )) as! LocationCell
            cell.showIndecater()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if locationDataArray.isEmpty {
            return 1
        }else{
            return locationDataArray.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if locationDataArray.isEmpty{
            let cell = dequeueReusableCell(withIdentifier: "noResultCell")!
            return cell
        }else{
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //进行全部信息的获取
    }
    
    //MARK:滑动控制
    
    //惯性停止
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
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
        if locationDataArray.isEmpty { return }//没有Cell的话不用处理
        let offset = self.contentOffset.y
        let cell = getCellFrom(offset: offset)!
        scrollTo(cell: cell)
    }
    
    //移动到某一Cell上
    func scrollTo(cell:LocationCell) {
        let minY = cell.frame.minY
        self.setContentOffset(CGPoint(x: 0, y: minY), animated: true)
        //显示指示条
        for index in 0..<self.locationDataArray.count {
            if let cell = self.cellForRow(at: IndexPath(row: index, section: 0)) as? LocationCell{
                cell.hideIndecater()
            }
        }
        cell.showIndecater()
    }
    
    func scrollTo(index:Int) {
        let cell = self.cellForRow(at: IndexPath(row: index, section: 0)) as! LocationCell
        scrollTo(cell: cell)
    }
    
    
    //找到这个Offset属于哪个Cell
    func getCellFrom(offset:CGFloat)->LocationCell?  {
//        let lastIndex = self.locationDataArray.count-1
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
        return nil
    }
    
}

