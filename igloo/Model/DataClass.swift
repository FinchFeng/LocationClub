//
//  SignUpModel.swift
//  igloo
//
//  Created by 冯奕琦 on 2018/12/19.
//  Copyright © 2018 冯奕琦. All rights reserved.
//

import Foundation


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
