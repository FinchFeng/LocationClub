//
//  SignUpViewController.swift
//  igloo
//
//  Created by 冯奕琦 on 2018/12/13.
//  Copyright © 2018 冯奕琦. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var verifyCode: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordForVerify: UITextField!
    
    @IBOutlet weak var getCodeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func getVerifyCode() {
        //验证手机号？
        Network.gettingCode(phoneNumber: phoneNumber.text!) { (result) in
            //获取成功的UI展示
        }
    }
    
    
    @IBAction func signUp() {
        //验证密码
        if let text = password.text,let textForVertify = password.text,text == textForVertify{
            Network.signUp(phoneNumber: phoneNumber.text!, code: verifyCode.text!, password: password.text!) { (result) in
                //更改界面
            }
        }
    }
    
    
}
