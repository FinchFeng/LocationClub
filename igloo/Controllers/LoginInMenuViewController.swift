//
//  LoginInMenuViewController.swift
//  igloo
//
//  Created by 冯奕琦 on 2018/12/13.
//  Copyright © 2018 冯奕琦. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginInMenuViewController: UIViewController,GIDSignInUIDelegate{

    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var iglooSignIn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        //GIDSignIn.sharedInstance()!.signInSilently()
        //展现圆角
        iglooSignIn.layer.cornerRadius = 8
        iglooSignIn.layer.masksToBounds = true
    }
    
    //MARK:igloo SignIn
    
    @IBAction func goToNextVC() {
        performSegue(withIdentifier: "segueToSignIn", sender: nil)
    }
    
    
    //MARK: Google Sign In
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error?) {
        print("结束SignIn")
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //GoogleSignOut
    
    @IBAction func signOut(sender:UIButton){
        GIDSignIn.sharedInstance()?.signOut()
    }
    
    //UnWind
    @IBAction func unwind(_ unwindSegue: UIStoryboardSegue) {
        //do nothing...
    }

}
