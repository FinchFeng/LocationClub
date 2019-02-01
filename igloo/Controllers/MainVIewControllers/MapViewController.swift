//
//  MapViewController.swift
//  igloo
//
//  Created by 冯奕琦 on 2018/12/21.
//  Copyright © 2018 冯奕琦. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //隐藏TopBar
        self.navigationController!.setNavigationBarHidden(true, animated: false)
        if let tabVC =  self.tabBarController as? MainTabBarController{
            if tabVC.justBackFromLoginInMenu == true{
                tabVC.justBackFromLoginInMenu = false
                //返回MyLocationVC
                tabVC.selectedIndex = 0
                return
            }
        }
        //尝试登陆
        if LoginModel.login == false {
            let rootVC  = self.tabBarController! as! MainTabBarController
            rootVC.login()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //显示tapBar
        self.navigationController!.setNavigationBarHidden(false, animated: false)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
