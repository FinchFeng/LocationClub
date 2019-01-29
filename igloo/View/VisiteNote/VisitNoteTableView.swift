//
//  VisitNoteTableView.swift
//  igloo
//
//  Created by 冯奕琦 on 2019/1/26.
//  Copyright © 2019 冯奕琦. All rights reserved.
//

import UIKit

class VisitNoteTableView: UITableView,UITableViewDelegate,UITableViewDataSource {
    
    var visitNoteArray:[VisitedNote]!
    
    func setDataIn(data:[VisitedNote])  {
        //配置全部
        self.delegate = self
        self.dataSource = self
        self.separatorColor = UIColor.white
        visitNoteArray = data
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visitNoteArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if row == 0 {
            let staticCell = tableView.dequeueReusableCell(withIdentifier: "addVisitNoteCell") as! AddVisitNoteCell
            //配置点击添加记录的delegate
            return staticCell
        }else{
            let visitNoteCell = tableView.dequeueReusableCell(withIdentifier: "VisitNoteCell") as! VisitNoteCell
             print("正在生成第\(row-1)层的Cell")
            visitNoteCell.setData(data: visitNoteArray[row-1])
            return visitNoteCell
        }
    }


}
