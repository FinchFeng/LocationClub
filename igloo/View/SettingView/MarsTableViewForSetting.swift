//
//  MarsTableViewForSetting.swift
//  igloo
//
//  Created by 冯奕琦 on 2019/2/18.
//  Copyright © 2019 冯奕琦. All rights reserved.
//

import Foundation
import UIKit

class MarsTableViewForSetting: MarsTableView {
    var settingDelegate:SettingDelegate!
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        settingDelegate.getFullLocationDataAndShow(index: indexPath.row)
    }
}
