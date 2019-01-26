//
//  VisitNoteCell.swift
//  igloo
//
//  Created by 冯奕琦 on 2019/1/26.
//  Copyright © 2019 冯奕琦. All rights reserved.
//

import UIKit

class VisitNoteCell: UITableViewCell {

    var data:VisitedNote!
    
    //MARK: IBOutlet
    @IBOutlet weak var visitNoteWordLabel: UILabel!
    @IBOutlet weak var imageVIewContainer: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageContainerHeightConstraint: NSLayoutConstraint!
    
    func setData(data:VisitedNote)  {
        self.data = data
        //进行赋值
        visitNoteWordLabel.text = data.visitNoteWord
        //时间字符串需要加工
        let dateCompont = Date.changeStringToDate(string: data.createdTime)
        dateLabel.text = "\(dateCompont.year!) \(dateCompont.month!).\(dateCompont.day!)"
        //重点图片的展现
        switch data.imageURLArray.count {
        case 0: //不展现图片
            imageContainerHeightConstraint.constant = 0
        case 1://展现一个图片
            let imageName = data.imageURLArray.first!
            //获取分辨率
            let result = getRadio(string: imageName)
            print(Constants.displayScale)
            var width = result.0 //除于屏幕显示倍数
            var height = result.1
            //创建一个ImageView占位
            if width > Constants.visitNotePictureMaxWidth{
                //减小图片的大小
                height = Constants.visitNotePictureMaxWidth*height/width
                width = Constants.visitNotePictureMaxWidth
            }
            print("Image Size is ")
            print(width)
            print(height)
            //cell进行构建
            imageContainerHeightConstraint.constant = height
            //构建ImageView
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
            imageView.backgroundColor = UIColor.gray
            imageVIewContainer.addSubview(imageView)
            //对image进行获取
            Network.getImage(at: imageName) { (image) in
                imageView.image = image
            }
            return
        default: return //展现多个图片
        }
    }
    
    func getRadio(string:String) -> (CGFloat,CGFloat) {
        let firstIndex = string.index(after:string.firstIndex(of: "_")!)
        var secondIndex = string.lastIndex(of: "_")!
        let widthString = string[firstIndex..<secondIndex]
        secondIndex = string.index(after:string.lastIndex(of: "_")!)
        let heightString = string[secondIndex..<string.lastIndex(of: ".")!]
        let width = Int(widthString)!
        let height = Int(heightString)!
        print(width)
        print(height)
        return(CGFloat(width),CGFloat(height))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
