//
//  AddNewVisitNoteViewController.swift
//  igloo
//
//  Created by 冯奕琦 on 2019/1/31.
//  Copyright © 2019 冯奕琦. All rights reserved.
//

import UIKit

class AddNewVisitNoteViewController: UIViewController,UITextViewDelegate{

    
    //MARK: IBOutlet
    var navigationTitle:String!//segue到这VC的时候进行设置
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var storyTextView: UITextView!
    @IBOutlet weak var imaegContainerView: UIView!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    //图片从系统中获取🔧
    var isPlaceHolder = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.items?.first?.title = navigationTitle
        storyTextView.delegate = self
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
    
    
    //MARK: UITextViewDelegate
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if isPlaceHolder {
            isPlaceHolder = false
            textView.text = ""
        }
        return true
    }
    

}
