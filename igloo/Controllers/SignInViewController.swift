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
    //上一个VC传递来的Block
    var loginBlock:((String,String, @escaping (Bool)->Void)->Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func SignUpAction(_ sender: UIButton) {
        //进行信息检查
        let number = phoneNumber.text!
        let password = self.password.text!
        //给后台发送登陆请求
        loginBlock(number,password,{(result) in
            if result == true{
                print("登陆成功")
                self.performSegue(withIdentifier: "unwindToMain", sender: nil)
            }else{
                print("登陆失败")
                //展示这个信息
                let alert = UIAlertController(title: "用户名或者密码输入错误", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "好的", style: .destructive, handler: nil))
                //清空密码
                self.present(alert, animated: true, completion: { () in
                    self.password.text = ""
                })
            }
        })
        
    }
    
    
    //UnWind
    @IBAction func unwind(_ unwindSegue: UIStoryboardSegue) {
        //do nothing...
    }

}
