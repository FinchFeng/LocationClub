//
//  TextViewWithoutEmoji.swift
//  igloo
//
//  Created by 冯奕琦 on 2019/3/12.
//  Copyright © 2019 冯奕琦. All rights reserved.
//

import Foundation
import UIKit

class TextViewWithoutEmoji: UITextView,UITextViewDelegate {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setUpDelegate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpDelegate()
    }
    
    func setUpDelegate() {
        self.delegate = self
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let hasEmoji = text.containsEmoji()
        if hasEmoji {
            //提醒用户
            Network.showCanInputEmoji()
            return false
        }else{
            return true
        }
    }
    
}

class TextFieldWithoutEmoji: UITextField,UITextFieldDelegate {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpDelegate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpDelegate()
    }
    
    func setUpDelegate() {
        self.delegate = self
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let hasEmoji = text.containsEmoji()
        if hasEmoji {
            //提醒用户
            Network.showCanInputEmoji()
            return false
        }else{
            return true
        }
    }
    
}
