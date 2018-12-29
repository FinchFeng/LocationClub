//
//  Shower.swift
//  igloo
//
//  Created by 冯奕琦 on 2018/12/27.
//  Copyright © 2018 冯奕琦. All rights reserved.
//

import Foundation

class Shower {
    
    //使用这个方法把LocationInfo1和VisitedNoted的Json转化为本地的LocationInfoLocal
    static func assemble(locationID: String,rank1Data:Data,
                         rank2Data:Data,VisitedNotedArray:[Data])->LocationInfoLocal?{
        //获取两个主要的数据
        if let rank1 = Shower.decoderJson(jsonData: rank1Data, type: LocationInfoRank1.self),let rank2 =  Shower.decoderJson(jsonData: rank2Data, type: LocationInfoRank2.self){
            //获取visitedNoted数组
            var visitedNotes:[VisitedNote] = []
            for visitedNote in VisitedNotedArray {
                if let actuclVisitedNote = Shower.decoderJson(jsonData: visitedNote, type: VisitedNote.self){
                    visitedNotes.append(actuclVisitedNote)
                }
            }
            //assemble组装为一个大类
            return LocationInfoLocal(locationID: locationID, rank1Data: rank1,
                                     rank2Data: rank2, visitedNoteArray: visitedNotes)
        }else{
            return nil
        }
    }
    
    //这个方法把LocationInfoLocal转化为参数准备发送给后端 locationID iglooID从客户端获取
    static func changeLocationInfoToParameters(data:LocationInfoLocal)-> [String:String] {
        var result:[String:String] = [:]
        result[Constants.locationName] = data.locationName
        //坐标转换为String
        result[Constants.locationLongitudeKey] = String(data.locationLongitudeKey)
        result[Constants.locationLatitudeKey] = String(data.locationLatitudeKey)
        //时间问题 从手机系统时间获取
        result[Constants.locationCreatedTime] = Date.changeDateToString(date: Date())
        //简单的文字转换
        result[Constants.locationInfoWord] = data.locationInfoWord
        result[Constants.locationDescription] = data.locationDescription
        result[Constants.locationLikedAmount] = String(data.locationLikedAmount)
        result[Constants.iconKindString] = data.iconKindString
        result[Constants.isPublic] = data.isPublic ? "True" : "False"//注意这个地方的设计是False的话，后端无数据
        return result
    }
    
    //使用泛型(带有Protocal) 把JSON直接转化为Codable Class
    static func decoderJson<T:Codable>(jsonData:Data,type:T.Type) -> T? {
        if let newData = try? JSONDecoder().decode(type, from: jsonData){
            return newData
        }else{
            return nil
        }
    }
    
    //把Codable转化为JSON
    static func changeCodable<T:Codable>(object:T)->Data{
        let jsonData:Data = try! JSONEncoder().encode(object)
        return jsonData
    }
    
    
    
}

