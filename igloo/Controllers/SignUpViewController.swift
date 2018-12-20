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
    //MARK:自动计数按钮
    var timer:Timer!
    var canGetCodeNow:Bool = true
    
    @IBOutlet weak var timingLabel: UILabel!
    
    var gettingCodeClock:Int? {
        didSet{
            if let time = gettingCodeClock{
                //检查是否到0
                if time == 0 {//到了
                    timer.invalidate()
                    //buttonTitle可以获取
                    getCodeButton.setTitle("获取验证码", for: .normal)
                    gettingCodeClock = nil
                    timingLabel.isHidden = true
                    canGetCodeNow = true
                }else{
                    //更新到Button Title
                    timingLabel.text = "("+String(time)+"s)"
                }
            }
        }
    }
    
    func startClocking(time:Int) {
        gettingCodeClock = time
        //配置定时器
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
            if self.gettingCodeClock != nil{
                self.gettingCodeClock! -= 1
                //                print(self.gettingCodeClock!)
            }
        })
        //设置按钮不可点
        canGetCodeNow = false
        getCodeButton.setTitle("重新获取", for: .normal)
        timingLabel.isHidden = false
        //启动计时器
        timer.fire()
    }
    //MARK: 网络方法
    @IBAction func getVerifyCode() {
        if canGetCodeNow == false { return }
        //验证手机号
        if let number = phoneNumber.text, number.count == 11 {
            Network.gettingCode(phoneNumber: phoneNumber.text!) { (result) in
                //获取成功的UI展示
                //过一段时间才能再次获取
                self.startClocking(time: 5)
            }
        }else{
            //展示提醒
            let alert = UIAlertController(title: "手机号格式不正确", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "好的", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func signUp() {
        //验证密码
        if let text = password.text,let textForVertify = password.text,text == textForVertify{
            Network.signUp(phoneNumber: phoneNumber.text!, code: verifyCode.text!, password: password.text!) { (result) in
                //是否注册成功
                let success = result[Constants.success] as! Bool
                //更改界面
                if success == true {
                    //展示成功消息
                    self.performSegue(withIdentifier: "signUpSuccess", sender: nil)
                }else{
                    //展示提醒
                    let alert = UIAlertController(title: "验证码不正确", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "好的", style: .destructive, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }else{
            //密码不匹配
            let alert = UIAlertController(title: "确认密码不匹配", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "好的", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    
}
