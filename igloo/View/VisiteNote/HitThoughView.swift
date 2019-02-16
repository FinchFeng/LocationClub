//
//  HitThoughView.swift
//  igloo
//
//  Created by 冯奕琦 on 2019/2/11.
//  Copyright © 2019 冯奕琦. All rights reserved.
//

import UIKit

class HitThoughView: UIView {

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return true
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view is HitThoughView {
//            print("穿过底层")
            return nil
        }//穿过底层
//        print("点击到其他View")
        return view
    }

}
