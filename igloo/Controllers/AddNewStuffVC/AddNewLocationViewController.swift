//
//  AddNewLocationViewController.swift
//  igloo
//
//  Created by 冯奕琦 on 2019/1/31.
//  Copyright © 2019 冯奕琦. All rights reserved.
//

import UIKit

class AddNewLocationViewController: UIViewController,UITextFieldDelegate {

    //MARK:IBOutlet
    @IBOutlet weak var locationNameTextFeild: UITextField!
    @IBOutlet weak var locationDescribeTextFeild: UITextField!
    @IBOutlet weak var iconKindStringTextField: UITextField!
    
    //icons
    @IBOutlet weak var iconImageButton1:UIButton!
    @IBOutlet weak var iconImageButton2:UIButton!
    @IBOutlet weak var iconImageButton3:UIButton!
    @IBOutlet weak var iconImageButton4:UIButton!
    @IBOutlet weak var iconImageButton5:UIButton!
    @IBOutlet weak var iconImageButton6:UIButton!
    @IBOutlet weak var iconImageButton7:UIButton!
    @IBOutlet weak var iconImageButton8:UIButton!
    @IBOutlet weak var iconImageButton9:UIButton!
    @IBOutlet weak var iconImageButton10:UIButton!
    @IBOutlet weak var iconImageButton11:UIButton!
    @IBOutlet weak var iconImageButton12:UIButton!
    @IBOutlet weak var iconImageButton13:UIButton!
    @IBOutlet weak var iconImageButton14:UIButton!
    var iconImageButtonArray:[UIButton]{
        return [iconImageButton1,iconImageButton2,iconImageButton3,iconImageButton4,iconImageButton5,iconImageButton6,iconImageButton7,iconImageButton8,iconImageButton9,iconImageButton10,iconImageButton11,iconImageButton12,iconImageButton13,iconImageButton14]
    }
    //其他
    @IBOutlet weak var mapLocationImageLocationInfoStringLabel: UITextField!
    @IBOutlet weak var mapLocationImageVIew: UIImageView!
    @IBOutlet weak var mapLocationImageButton: UIButton!
    @IBOutlet weak var isPublicSwitch: UISwitch!
    @IBOutlet weak var iconLocationImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationNameTextFeild.delegate = self
        locationDescribeTextFeild.delegate = self
        // Do any additional setup after loading the view.
    }
    
    //MARK: Properties
    
    var currentIconString:String = "Defualt"
    
    @IBAction func selectIcon(sender:UIButton){
        for button in iconImageButtonArray {
            button.isSelected = false
        }
        //选择这个sender
        sender.isSelected = true
        //更改与它关联的UI控件
        let image = sender.currentImage!
        let iconData = Constants.getIconStruct(image:image)!
        currentIconString = iconData.kind
        iconKindStringTextField.text = iconData.kindInChinese
    }
    
    @IBAction func segueToChoseLocationVC() {
        performSegue(withIdentifier: "segueToChoseLocationImage", sender: nil)
    }
    
    @IBAction func unwind(segue:UIStoryboardSegue){
        //装入地理位置
        
    }
    
    //完成之后生成一个LocationInfoLocal并且上传
    func done()  {
        
    }

    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
