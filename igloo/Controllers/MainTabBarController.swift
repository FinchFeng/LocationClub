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
    
    func hadLogin(){
        //Mylocation进行更改
        if let mylocationVC = self.viewControllers![0] as? MyLocationsViewController{
            mylocationVC.hadLogin()
        }else{
            print("tabbarController出现错误")
        }
    }
    
    @IBAction func unwind(_ unwindSegue: UIStoryboardSegue) {//fromLoginMe
        print("segueFromLogin")
        //登陆后的信息处理
        if LoginModel.login {
            hadLogin()
        }
    }
    
    @IBAction func unwindFromIglooLogin(_ unwindSegue:UIStoryboardSegue){
        //登陆后的信息处理
        if LoginModel.login{
            hadLogin()
        }
    }

}
