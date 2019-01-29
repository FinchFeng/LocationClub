//
//  VisitNoteCell.swift
//  igloo
//
//  Created by 冯奕琦 on 2019/1/26.
//  Copyright © 2019 冯奕琦. All rights reserved.
//

import UIKit
import SwiftPhotoGallery

class VisitNoteCell: UITableViewCell, SwiftPhotoGalleryDataSource, SwiftPhotoGalleryDelegate {

    var data:VisitedNote!
    lazy var viewController:UIViewController =  self.findViewController()!
    var imageArray:[UIImage] = []
    
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
        //进行图片更新删除旧的图片
        for views in imageVIewContainer.subviews {
            views.removeFromSuperview()
        }
        switch data.imageURLArray.count {
        case 0: //不展现图片
            imageContainerHeightConstraint.constant = 0
        case 1://展现一个图片
            let imageName = data.imageURLArray.first!
            //获取分辨率
            let result = getRadio(string: imageName)
            print(Constants.displayScale)
            var width = result.0 
            var height = result.1
            //创建一个ImageView占位
            //控制大小
            if width > Constants.visitNotePictureMaxWidth{
                //减小图片的大小
                height = Constants.visitNotePictureMaxWidth*height/width
                width = Constants.visitNotePictureMaxWidth
            }
            if height > Constants.visitNotePictureMaxWidth{
                //减小图片的大小
                width = Constants.visitNotePictureMaxWidth*width/height
                height = Constants.visitNotePictureMaxWidth
            }
            //cell进行构建
            imageContainerHeightConstraint.constant = height
            //构建ImageView
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
            imageView.backgroundColor = UIColor.lightGray
            imageVIewContainer.addSubview(imageView)
            //准备更新ImgeArray
            self.imageArray = []
            //对image进行获取
            Network.getImage(at: imageName) {(image) in//内存泄露？？
                imageView.image = image
                //更新到ImageArray
                self.imageArray.append(image)
                //添加TapGesture
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapSingleImageView(sender:)))
                imageView.isUserInteractionEnabled = true
                imageView.addGestureRecognizer(tapGesture)
            }
            return
        default:
            //最多9张图片
            let gap:CGFloat = 6
            let size:CGFloat = UIScreen.main.bounds.width*0.22
            
            let makeAFrame = { (index:Int)->CGRect  in
                let row = CGFloat((index) % 3)
                let line = CGFloat((index) / 3)
                let point = CGPoint(x: row*(size+gap), y: line*(size+gap))
                let newframe = CGRect(origin: point, size: CGSize(width: size, height: size))
                return newframe
            }
            //cell进行构建
            var maxImageY:CGFloat = 0
            //准备更新ImgeArray
            self.imageArray = []
            //创建imageViews
            for (index,imageUrL) in data.imageURLArray.enumerated(){
                let frame = makeAFrame(index)
                //与最大的Y进行比较
                maxImageY = frame.maxY > maxImageY ? frame.maxY : maxImageY
                let imageView = MutipleImageView(frame:frame)
                imageView.index = index //初始化index
                imageView.backgroundColor = UIColor.lightGray
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                imageVIewContainer.addSubview(imageView)
                //对image进行获取 需要递归？⚠️
                Network.getImage(at: imageUrL) { (image) in//内存泄露？？
                    imageView.image = image
                    //添加到ImageArray
                    self.imageArray.append(image)
                    //添加TapGesture
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapMutiplerImageView(sender:)))
                    imageView.isUserInteractionEnabled = true
                    imageView.addGestureRecognizer(tapGesture)
                }
            }
            //设定Cell的高度
            let height = maxImageY
            imageContainerHeightConstraint.constant = height
            return //展现多个图片
        }
        
    }
    
    @objc func tapSingleImageView(sender:UITapGestureRecognizer){
        if sender.state == .ended {
            //展现单个的BigImageView
            let gallery = createABigImageView()
            viewController.present(gallery, animated: true, completion:  nil)
        }
    }
    
    @objc func tapMutiplerImageView(sender:UITapGestureRecognizer) {
        let senderView = sender.view! as! MutipleImageView
        let index = senderView.index
        let gallery = createABigImageView(firstImageIndex: index)
        viewController.present(gallery, animated: true, completion:  nil)
    }
    
    func createABigImageView(firstImageIndex:Int?=nil)->SwiftPhotoGallery {
        let gallery = SwiftPhotoGallery(delegate: self, dataSource: self)
        if let index = firstImageIndex {
            gallery.firstShowImageIndex = index
        }
        gallery.backgroundColor = UIColor.black
        gallery.pageIndicatorTintColor = UIColor.gray.withAlphaComponent(0.5)
        gallery.currentPageIndicatorTintColor = UIColor.white
        gallery.hidePageControl = self.imageArray.count == 1 ? true : false
        return gallery
    }
    
    //辅助方法
    func getRadio(string:String) -> (CGFloat,CGFloat) {
        let firstIndex = string.index(after:string.firstIndex(of: "_")!)
        var secondIndex = string.lastIndex(of: "_")!
        let widthString = string[firstIndex..<secondIndex]
        secondIndex = string.index(after:string.lastIndex(of: "_")!)
        let heightString = string[secondIndex..<string.lastIndex(of: ".")!]
        let width = Int(widthString)!
        let height = Int(heightString)!
        return(CGFloat(width),CGFloat(height))
    }
    
    // MARK: SwiftPhotoGalleryDataSource Methods
    
    func numberOfImagesInGallery(gallery: SwiftPhotoGallery) -> Int {
        return imageArray.count
    }
    
    func imageInGallery(gallery: SwiftPhotoGallery, forIndex: Int) -> UIImage? {
        return imageArray[forIndex]
    }
    
    // MARK: SwiftPhotoGalleryDelegate Methods
    
    func galleryDidTapToClose(gallery: SwiftPhotoGallery) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        //长按删除
//        // Configure the view for the selected state
//    }

}
