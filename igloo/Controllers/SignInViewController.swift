//
//  SignInViewController.swift
//  igloo
//
//  Created by 冯奕琦 on 2018/12/13.
//  Copyright © 2018 冯奕琦. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func SignUpAction(_ sender: UIButton) {
        //给后台发送登陆请求
        
    }
    
    
    //UnWind
    @IBAction func unwind(_ unwindSegue: UIStoryboardSegue) {
        //do nothing...
    }

}
