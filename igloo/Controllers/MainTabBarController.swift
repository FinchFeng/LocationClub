//
//  MainTabBarController.swift
//  igloo
//
//  Created by 冯奕琦 on 2018/12/21.
//  Copyright © 2018 冯奕琦. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    func login() {
        performSegue(withIdentifier: "loginMenuSegue", sender: nil)
    }
    
    
    @IBAction func unwind(_ unwindSegue: UIStoryboardSegue) {//fromLoginMe
        //登陆后的信息处理
    }
    
    @IBAction func unwindFromIglooLogin(_ unwindSegue:UIStoryboardSegue){
        //登陆后的信息处理
    }

}
