//
//  Extension.swift
//  igloo
//
//  Created by 冯奕琦 on 2018/12/29.
//  Copyright © 2018 冯奕琦. All rights reserved.
//

import Foundation

extension Date {
    
    static let componentsSet:Set = [Calendar.Component.year,Calendar.Component.month,Calendar.Component.day,
                                    Calendar.Component.hour,Calendar.Component.minute,Calendar.Component.second]
    
    
    static func changeStringToDate(string:String)->DateComponents{
        //String->Date
        let timeString = string
        //格式设置
        let dateFormer = DateFormatter()
        dateFormer.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = dateFormer.date(from: timeString)!
        let components = Calendar.current.dateComponents(componentsSet, from: date)
        return components
    }
    
    static func changeDateToString(date:Date)->String{
        //Date -> String
        //格式设置
        let dateFormer = DateFormatter()
        dateFormer.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let string = dateFormer.string(from: date)
        return string
    }
    
    static func getCurrentDateComponents()->DateComponents{
        //获取现在的Date
        let currentDate = Date()
        let currentComponents = Calendar.current.dateComponents(componentsSet, from: currentDate)
        return currentComponents
    }
    
    
}
