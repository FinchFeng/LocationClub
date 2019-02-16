//
//  AirModel.swift
//  igloo
//
//  Created by 冯奕琦 on 2019/2/11.
//  Copyright © 2019 冯奕琦. All rights reserved.
//

import Foundation
import MapKit

class AirModel {
    
    //MARK:数据
    //图标数据类型数据
    var currentAnnationLocationDataArray:[(id:String,data:LocationInfoRank3)] = []
    var currentShowingIndexMax = 0
    let groupAmount = 20
    //MARK:Functions
    
    //获取某个区域的数据并且展示第一Group的数据
    func getAnnotionsAndShow(span:MKCoordinateRegion,landingBlock:@escaping (([(id:String,data2:LocationInfoRank2,data3:LocationInfoRank3)]))->Void) {
        currentAnnationLocationDataArray = [] //清空数据
        currentShowingIndexMax = 0
        Network.getLocationsIn(span: span) { (data) in
            //获取array
            self.currentAnnationLocationDataArray = data
            self.showNextGroupOfLocationData(landingBlock: landingBlock)
        }
    }
    
    //使用这个方法来进行数据获取LocationRank2Data 取到没有的时候就为空
    func showNextGroupOfLocationData(landingBlock:@escaping (([(id:String,data2:LocationInfoRank2,data3:LocationInfoRank3)]))->Void){
        //取出要获取的数据
        let lastIndex = currentShowingIndexMax+groupAmount > currentAnnationLocationDataArray.count ? currentAnnationLocationDataArray.count : currentShowingIndexMax+groupAmount//防止最后一Group不够20
        let resultDataArray = currentAnnationLocationDataArray[currentShowingIndexMax..<lastIndex]
        currentShowingIndexMax = lastIndex
        //递归获取这些数据
        func getData(resultArray:[(id:String,data2:LocationInfoRank2,data3:LocationInfoRank3)],inputArray:[(id:String,data:LocationInfoRank3)]){
            if let firstData = inputArray.first{
                //更新输入数据
                var newInputArray = inputArray
                newInputArray.remove(at: 0)
                //获取rank2data
                var newResultArray = resultArray
                Network.getLocationInfo(locationID: firstData.id, rank: 2) { (rank2Data) in
                    let data = rank2Data as! LocationInfoRank2
                    //更新新的LocationData
                    newResultArray.append((id:firstData.id , data2: data, data3: firstData.data))
                    getData(resultArray: newResultArray, inputArray: newInputArray)
                }
            }else{
                //执行landingAction
                landingBlock(resultArray)
            }
        }
        getData(resultArray: [], inputArray:Array(resultDataArray))
    }
    
    //获取全部数据
    
    func getFullData(id:String,landing:@escaping (LocationInfoLocal)->Void) {
        Network.getLocationInfo(locationID: id, rank: 1) { (data) in
            landing(data as! LocationInfoLocal)
        }
    }
    
    
}

class dataPool{//
    
}
