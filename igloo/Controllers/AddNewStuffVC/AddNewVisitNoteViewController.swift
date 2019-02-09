//
//  AddNewVisitNoteViewController.swift
//  igloo
//
//  Created by 冯奕琦 on 2019/1/31.
//  Copyright © 2019 冯奕琦. All rights reserved.
//

import UIKit
import Photos
import Gallery

class AddNewVisitNoteViewController: UIViewController,UITextViewDelegate,GalleryControllerDelegate{

    
    //MARK: IBOutlet
    var navigationTitle:String!//segue到这VC的时候进行设置
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var storyTextView: UITextView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    //图片从系统中获取🔧
    var isPlaceHolder = true
    var imageArray:[UIImage] = []{
        didSet{
            updateImageToViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.items?.first?.title = navigationTitle
        storyTextView.delegate = self
        updateImageToViews()
        setUpGallery()
        //把日期设置为今天
    }
    

    @IBAction func changeDateAction() {
        //调用选择器 默认今天
    }
    
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        //字数检查
    }
    
    
    @IBAction func tapIt(_ sender: UITapGestureRecognizer) {
        storyTextView.resignFirstResponder()
    }
    
    func updateImageToViews(){
        //删除所有之前的View
        imageContainerView.subviews.forEach({$0.removeFromSuperview()})
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
        //没有image的话
        if imageArray.isEmpty {
            //创建button
            let button = UIButton(frame: makeAFrame(0))
            button.setImage(#imageLiteral(resourceName: "visitNoteAddImages"), for: .normal)
            button.addTarget(self, action: #selector(showGallery), for: .touchUpInside)
            containerHeight.constant = size + gap*2
            //展示button
            imageContainerView.addSubview(button)
            return
        }
        //cell进行构建
        var maxImageY:CGFloat = 0
        //创建imageViews
        for (index,image) in self.imageArray.enumerated(){
            let frame = makeAFrame(index)
            //与最大的Y进行比较
            maxImageY = frame.maxY > maxImageY ? frame.maxY : maxImageY
            let imageView = UIImageView(frame:frame)
            //初始化index
            imageView.image = image
            imageView.backgroundColor = UIColor.lightGray
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageContainerView.addSubview(imageView)
            //添加TapGesture
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showGallery))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tapGesture)
        }
        //设定Cell的高度
        let height = maxImageY
        containerHeight.constant = height
    }
    
    @objc func showGallery()  {
        present(gallery, animated: true, completion: nil)
    }
    
    //MARK: UITextViewDelegate
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if isPlaceHolder {
            isPlaceHolder = false
            textView.text = ""
        }
        return true
    }
    
    //MARK:Gallery
    var gallery = GalleryController()
    
    func setUpGallery() {
        gallery.delegate = self
        Gallery.Config.tabsToShow = [.imageTab]
        Gallery.Config.Grid.FrameView.borderColor = #colorLiteral(red: 0.02745098039, green: 0.462745098, blue: 0.4705882353, alpha: 1)
        Gallery.Config.Grid.CloseButton.tintColor = #colorLiteral(red: 0.02745098039, green: 0.462745098, blue: 0.4705882353, alpha: 1)
    }
    
    //delegate
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        //转换为UIImageArray
        let array = images.map({ self.getImageFrom(asset: $0.asset)})
        //赋值
        self.imageArray = array
        controller.dismiss(animated: true, completion: nil)
        return
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        return
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        return
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
        return
    }
    
    
    
    func getImageFrom(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    
}
