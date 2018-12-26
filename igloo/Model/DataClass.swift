//
//  SignUpModel.swift
//  igloo
//
//  Created by 冯奕琦 on 2018/12/19.
//  Copyright © 2018 冯奕琦. All rights reserved.
//

import Foundation
import UIKit

//LocationInfo

struct LocationInfoRank1:Codable {
    var locationName:String
    var iconKindString:String
    var locationDescription:String
    var locationLatitudeKey:Double
    var locationLongitudeKey:Double
    var isPublic:Bool
    var locationLikedAmount:Int
    var VisitedNoteID:[String]
}

struct LocationInfoRank2:Codable {
    
    var locationName:String
    var locationInfoWord:String
    var locationLikedAmount:Int
    var locationInfoImageURL:String
    
}

struct LocationInfoRank3:Codable{
    
    var locationLatitudeKey:Double
    var locationLongitudeKey:Double
    var iconKindString:String
}

struct LocationInfoRank4:Codable{
    
    var locationLikedAmount : Int
    
}

//VisitedNote

struct VisitedNote:Codable{
    var visitNoteWord :String
    var imageURLArray:[String]
    var createdTime:String
}

//基于这两个方法来进行数据储存的设计
class ImageSaver {
    static let fileName = "ali.jpg"
    static let document = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static func saveImage(image: UIImage) -> Bool {
        do {
            guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
                    return false
            }
            try data.write(to: document.appendingPathComponent(fileName))
        }catch{
            print(error)
            return false
        }
        return true
    }
    static func getImage()->UIImage?{//FileName不变
        let url = document.appendingPathComponent(fileName)
        let data = try? Data(contentsOf: url)
        let image = UIImage(data: data!)
        return image
    }
}

class CodableSaver {
    static let fileName = "codable"
    static let document = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let path = document.appendingPathComponent(fileName).path
    static func save(rawData: LocationInfoRank4)-> Bool {
        let data = Network.changeCodable(object: rawData)
        try! data.write(to: document.appendingPathComponent(fileName))
        return true
    }
    static func getData()->LocationInfoRank4?{//FileName不变
        let url = document.appendingPathComponent(fileName)
        let data = try! Data(contentsOf: url)
        let codableData = Network.decoderJson(jsonData: data, type: LocationInfoRank4.self)
        return codableData
    }
}
