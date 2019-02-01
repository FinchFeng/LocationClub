//
//  AddNewVisitNoteViewController.swift
//  igloo
//
//  Created by 冯奕琦 on 2019/1/31.
//  Copyright © 2019 冯奕琦. All rights reserved.
//

import UIKit

class AddNewVisitNoteViewController: UIViewController {

    
    //MARK: IBOutlet
    
    @IBOutlet weak var storyTextView: UITextView!
    @IBOutlet weak var imaegContainerView: UIView!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    //图片从系统中获取🔧
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func changeDateAction() {
        //调用选择器 默认今天
    }
    

}
