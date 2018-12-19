//
//  ViewController.swift
//  igloo
//
//  Created by 冯奕琦 on 2018/12/7.
//  Copyright © 2018 冯奕琦. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func login(_ sender: UIButton) {
        performSegue(withIdentifier: "loginMenuSegue", sender: nil)
    }
    
    
    @IBAction func unwind(_ unwindSegue: UIStoryboardSegue) {
       //登陆后的信息处理
    }
    
    @IBAction func unwindFromIglooLogin(_ unwindSegue:UIStoryboardSegue){
        //登陆后的信息处理
    }
    
}

