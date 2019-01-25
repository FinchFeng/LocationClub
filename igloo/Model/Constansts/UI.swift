//
//  ConstantsForUI.swift
//  igloo
//
//  Created by 冯奕琦 on 2019/1/25.
//  Copyright © 2019 冯奕琦. All rights reserved.
//

import Foundation
import UIKit

extension Constants {
    
    //MARK: 界面数据
    
    static let locationCellRadio:CGFloat = 2.31
    static var locationCellSize:CGSize {
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: width/locationCellRadio)
    }
    
}
