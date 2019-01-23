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
    //使用一个方法让用户直接创建LocationInfoLocal
    init(locationID:String,locationName:String,iconKindString:String,locationDescription:String,
         locationLatitudeKey:Double,locationLongitudeKey:Double,isPublic:Bool,locationLikedAmount:Int,
         locationInfoWord:String,locationInfoImageURL:String,VisitedNoteID:[VisitedNote],noteIDs:[String]) {
        self.locationID = locationID
        self.locationName = locationName
        self.iconKindString = iconKindString
        self.locationDescription = locationDescription
        self.locationLatitudeKey = locationLatitudeKey
        self.locationLongitudeKey = locationLongitudeKey
        self.isPublic = isPublic
        self.locationLikedAmount = locationLikedAmount
        self.locationInfoWord = locationInfoWord
        self.locationInfoImageURL = locationInfoImageURL
        self.VisitedNoteID = VisitedNoteID
        self.noteIDs = noteIDs
    }
    //使用LocationInfo1和[VisitedNoted]来进行创建(后端数据获取)
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
        self.noteIDs = rank1Data.VisitedNoteID
        //visitedNote
        self.VisitedNoteID = visitedNoteArray
    }
    //用户本地创建 坐标加创建时间注意时间不能重复
    var locationID:String
    var noteIDs:[String]
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


