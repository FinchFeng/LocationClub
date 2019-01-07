//
//  SignUpModel.swift
//  igloo
//
//  Created by 冯奕琦 on 2018/12/19.《
//  Copyright © 2018 冯奕琦. All rights reserved.
//

import Foundation
import UIKit

//LocationInfo

struct LocationInfoLocal:Codable{//此类储存在本地,可以直接喂给ViewController吃
    //🔧 使用一个方法让用户直接创建LocationInfoLocal
    
    //使用LocationInfo1和[VisitedNoted]来进行创建(后端数据进行获取)
    init(locationID:String,rank1Data:LocationInfoRank1,rank2Data:LocationInfoRank2,visitedNoteArray:[VisitedNote]) {
        self.locationID = locationID
        //Rank2
        self.locationInfoWord = rank2Data.locationInfoWord
        self.locationInfoImageURL = rank2Data.locationInfoImageURL
        //rank1
        self.locationName = rank1Data.locationName
        self.iconKindString = rank1Data.iconKindString
        self.locationDescription = rank1Data.locationDescription
        self.locationLatitudeKey = rank1Data.locationLatitudeKey
        self.locationLongitudeKey = rank1Data.locationLongitudeKey
        self.isPublic = rank1Data.isPublic
        self.locationLikedAmount = rank1Data.locationLikedAmount
        //visitedNote
        self.VisitedNoteID = visitedNoteArray
    }
    //用户本地创建 坐标加创建时间注意时间不能重复
    var locationID:String
    //数据可更改
    var locationName:String
    var iconKindString:String
    var locationDescription:String
    var locationLatitudeKey:Double
    var locationLongitudeKey:Double
    var isPublic:Bool
    var locationLikedAmount:Int
    //Info2
    var locationInfoWord:String
    var locationInfoImageURL:String
    //使用类来储存
    var VisitedNoteID:[VisitedNote]
    //使用这个方法来转化为RankingData使用RankingData来展示页面。
    func changeDataTo(rank:Int) -> Codable {
        switch rank {
        case 2:return LocationInfoRank2(locationName: locationName, locationInfoWord: locationInfoWord, locationLikedAmount: locationLikedAmount, locationInfoImageURL: locationInfoImageURL)
        case 3:return LocationInfoRank3(locationLatitudeKey: locationLatitudeKey, locationLongitudeKey: locationLongitudeKey, iconKindString: iconKindString)
        case 4:return LocationInfoRank4(locationLikedAmount: locationLikedAmount)
        default: return LocationInfoRank4(locationLikedAmount: -1)
        }
    }
    
}

//不可以直接呈现
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
    //visited ID 使用属于的地点的ID+系统时间 直接把VisitedNote作为LocationInfo的也一个子类

    //其他数据
    var visitNoteWord :String
    var imageURLArray:[String]//使用这个URL作为储存的path
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
        let data = Shower.changeCodable(object: rawData)
        try! data.write(to: document.appendingPathComponent(fileName))
        return true
    }
    static func getData()->LocationInfoRank4?{//FileName不变
        let url = document.appendingPathComponent(fileName)
        let data = try! Data(contentsOf: url)
        let codableData = Shower.decoderJson(jsonData: data, type: LocationInfoRank4.self)
        return codableData
    }
}
