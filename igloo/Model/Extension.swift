//
//  Extension.swift
//  igloo
//
//  Created by 冯奕琦 on 2018/12/29.
//  Copyright © 2018 冯奕琦. All rights reserved.
//
import MapKit
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
    
    static func currentDateString()->String{
        return changeDateToString(date: Date())
    }
    
}

extension MKCoordinateRegion{
    //生成使用经纬度描述的区域
    func getLatitudeLongitudeSpan()->(latitudeMax:Double,latitudeMin:Double,longtitudeMax:Double,longtitudeMin:Double){
        let latitudeMax = self.center.latitude + self.span.latitudeDelta/2
        let latitudeMin = self.center.latitude - self.span.latitudeDelta/2
        let longtitudeMax = self.center.longitude + self.span.longitudeDelta/2
        let longtitudeMin = self.center.longitude - self.span.longitudeDelta/2
        return (latitudeMax,latitudeMin,longtitudeMax,longtitudeMin)
    }
}

extension Data{
    func getSizeWithMB()->Float {
        let rawByteCount = Float(self.count)
        return rawByteCount/(1024*1024)
    }
}

extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}

extension String{
    /// 判断是不是Emoji
    ///
    /// - Returns: true false
    func containsEmoji()->Bool{
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
            0x1F300...0x1F5FF, // Misc Symbols and Pictographs
            0x1F680...0x1F6FF, // Transport and Map
            0x1F1E6...0x1F1FF, // Regional country flags
            0x2600...0x26FF, // Misc symbols
            0x2700...0x27BF, // Dingbats
            0xE0020...0xE007F, // Tags
            0xFE00...0xFE0F, // Variation Selectors
            0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
            127000...127600, // Various asian characters
            65024...65039, // Variation selector
            9100...9300, // Misc items
            8400...8447: // Combining Diacritical Marks for Symbols
                return true
            default:
                continue
            }
        }
        return false
    }
}
