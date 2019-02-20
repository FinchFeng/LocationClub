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
    }
    
//    var currentDateString:String = ""{
//        didSet{
//            let date = Date.changeStringToDate(string: currentDateString)
//            dateButton.setTitle("\(date.year!) \(date.month!).\(date.day!)", for: .normal)
//        }
//    }
//    @IBAction func changeDateAction() {
//        //调用选择器 默认今天
//        let dateChooserAlert = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
//        let datePicker = UIDatePicker()
//        datePicker.datePickerMode = .date
//        dateChooserAlert.view.addSubview(datePicker)
//        dateChooserAlert.addAction(UIAlertAction(title: "完成", style: .cancel, handler: { action in
//            self.currentDateString = Date.changeDateToString(date: datePicker.date)
//        }))
//        let height: NSLayoutConstraint = NSLayoutConstraint(item: dateChooserAlert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.1, constant: 300)
//        dateChooserAlert.view.addConstraint(height)
//        self.present(dateChooserAlert, animated: true, completion: nil)
//    }
    
    var newVisitNoteData:(VisitedNote,[UIImage])? = nil
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        //字数检查
        if storyTextView.text != ""{
            if storyTextView.text.count <= 200{
                //使用segue返回上一级添加VisitNote数据
                let dateString = Date.changeDateToString(date: Date())
                let visiteNoteData =  VisitedNote(visitNoteWord:storyTextView.text,imageURLArray:[],createdTime:dateString)
                self.newVisitNoteData = (visiteNoteData,imageArray)
                //segueBack
                performSegue(withIdentifier: "unwindBackToGreatVC", sender: nil)
            }else{
                //字数不能大于200警告
                let alertController = UIAlertController(title: "字数不能大于200", message: nil, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "好的", style: .default, handler: nil))
                present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let upVC = segue.destination as? GreatLocationInfoViewController{
            if let data = newVisitNoteData {//返回segue
                upVC.newVisitNoteData = data
            }
        }
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
            let frame = makeAFrame(0)
            let button = UIButton(frame: frame)
            let imageView = UIImageView(frame: frame)
            imageView.image = #imageLiteral(resourceName: "visitNoteAddImages")
//            button.setImage(#imageLiteral(resourceName: "visitNoteAddImages"), for: .normal)
            button.addTarget(self, action: #selector(showGallery), for: .touchUpInside)
            containerHeight.constant = size + gap*2
            //展示button
            imageContainerView.addSubview(imageView)
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
            textView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
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
        let array = images.map({ (data) -> UIImage in
            let rawImage = self.getImageFrom(asset: data.asset)
            //压缩image
            return ImageChecker.review(image: rawImage)
        })
        
        //赋值
        self.imageArray = array
        controller.dismiss(animated: true, completion: nil)
        return
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        return
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        print(images)
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
