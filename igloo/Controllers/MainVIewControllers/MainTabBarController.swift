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
    
    var justBackFromLoginInMenu:Bool = false
    
    func login() {
        if LoginModel.login == false {
            performSegue(withIdentifier: "loginMenuSegue", sender: nil)
        }
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
        justBackFromLoginInMenu = true
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
    
    var newLocationData:LocationInfoLocal?
    @IBAction func unwindFromOther(_ unwindSegue:UIStoryboardSegue){
        //添加Location的处理
        if unwindSegue.source is AddNewLocationViewController{
            if let data = newLocationData {//有数据传回来
                let myLocationVC = self.viewControllers![0] as! MyLocationsViewController
                myLocationVC.addLocation(data: data)
                self.newLocationData = nil//清除数据
            }
        }
    }

}
