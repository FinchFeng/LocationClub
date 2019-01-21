//
//  LocationCell.swift
//  igloo
//
//  Created by 冯奕琦 on 2019/1/21.
//  Copyright © 2019 冯奕琦. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {

    //MARK:IBOutlet
    
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var locaitonInfoWord: UILabel!
    @IBOutlet weak var likeAmount: UILabel!
    @IBOutlet weak var locationInfoImage: UIImageView!
    
    
    
    //MARK:图片已经在上一级生成装入数据
    func set(data:LocationInfoRank2,image:UIImage){//UIImage长宽比固定
        self.locationName.text = data.locationName
        self.locaitonInfoWord.text = data.locationInfoWord
        self.likeAmount.text = String(data.locationLikedAmount)
        self.locationInfoImage.image = image
        //添加效果
        labelBlur(label: locationName)
        labelBlur(label: locaitonInfoWord)
        labelBlur(label: likeAmount)
    }
    
    func labelBlur(label:UILabel) {
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 4.0
        label.layer.shadowOpacity = 0.5
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.masksToBounds = false
    }
    
    //暂时不需要
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
