//
//  SettingViewController.swift
//  igloo
//
//  Created by 冯奕琦 on 2018/12/21.
//  Copyright © 2018 冯奕琦. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController!.navigationItem.title = "设置"
        self.tabBarController!.navigationItem.leftBarButtonItem = nil
        self.tabBarController!.navigationItem.rightBarButtonItem = nil
    }



}
