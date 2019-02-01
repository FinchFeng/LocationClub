//
//  ConstantsForMap.swift
//  igloo
//
//  Created by 冯奕琦 on 2019/1/25.
//  Copyright © 2019 冯奕琦. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension Constants{
    
    static let lengthOfMapSnap = 0.015//MarsView的地图截图
    static let lengthOfGreatInfoMap = 0.015
    static let lengthOfBigMap = 0.02
    static func getIconStruct(name:String)->Icon!{//中文或者英文都可以
        for icon in Icon.iconsArray{
            if icon.kind == name || icon.kindInChinese == name {
                return icon
            }
        }
        return nil
    }
    static func getIconStruct(image:UIImage)->Icon!{
        for icon in Icon.iconsArray{
            if icon.image == image || icon.highlightImage == image {
                return icon
            }
        }
        return nil
    }
    static let mapSnapSize:CGSize = CGSize(width: UIScreen.main.bounds.width, height: 350)
}

struct Icon {
    let kind:String
    let kindInChinese:String
    let image:UIImage
    let highlightImage:UIImage
    
    static var iconsArray:[Icon] = [Icon(kind: "Alien", kindInChinese: "有外星人", image:#imageLiteral(resourceName: "Alien"), highlightImage: #imageLiteral(resourceName: "AlienHighlight-2")),
                                    Icon(kind: "Bar", kindInChinese: "酒吧", image: #imageLiteral(resourceName: "Bar"), highlightImage: #imageLiteral(resourceName: "BarHighlight-9")),
                                    Icon(kind: "Cafe", kindInChinese: "咖啡厅", image: #imageLiteral(resourceName: "Cafe"), highlightImage: #imageLiteral(resourceName: "CafeHighlight")),
                                    Icon(kind: "Chatting", kindInChinese: "闲聊地", image: #imageLiteral(resourceName: "Chatting"), highlightImage: #imageLiteral(resourceName: "ChattingHighlight-5")),
                                    Icon(kind: "Culture", kindInChinese: "人文景观", image: #imageLiteral(resourceName: "Culture"), highlightImage: #imageLiteral(resourceName: "CultureHighlight-7")),
                                    Icon(kind: "DeadFood", kindInChinese: "难吃到死", image: #imageLiteral(resourceName: "DeadFood"), highlightImage: #imageLiteral(resourceName: "DeadFoodHighlight-3")),
                                    Icon(kind: "Default", kindInChinese: "默认", image: #imageLiteral(resourceName: "Default-1"), highlightImage: #imageLiteral(resourceName: "iglooIcon")),
                                    Icon(kind: "Hotel", kindInChinese: "酒店", image: #imageLiteral(resourceName: "Hotel"), highlightImage: #imageLiteral(resourceName: "HotelHighlight-10")),
                                    Icon(kind: "LovePlace", kindInChinese: "约会圣地", image: #imageLiteral(resourceName: "LovePlace"), highlightImage: #imageLiteral(resourceName: "LovePlaceHighlight")),
                                    Icon(kind: "Restaurant", kindInChinese: "餐厅", image: #imageLiteral(resourceName: "Restaurant"), highlightImage: #imageLiteral(resourceName: "RestaurantHighlight-8")),
                                    Icon(kind: "Smoking", kindInChinese: "聚众吸烟处", image: #imageLiteral(resourceName: "Smoking"), highlightImage: #imageLiteral(resourceName: "SmokingHighlight-6")),
                                    Icon(kind: "Sport", kindInChinese: "运动", image: #imageLiteral(resourceName: "Sport"), highlightImage: #imageLiteral(resourceName: "SportHighlight-4")),
                                    Icon(kind: "Views", kindInChinese: "自然风景", image: #imageLiteral(resourceName: "Views"), highlightImage: #imageLiteral(resourceName: "ViewsHighlight-1")),
                                    Icon(kind: "Mall", kindInChinese: "购物中心", image: #imageLiteral(resourceName: "Mall"), highlightImage: #imageLiteral(resourceName: "MallHighlight")),
                                    ]
    
}

