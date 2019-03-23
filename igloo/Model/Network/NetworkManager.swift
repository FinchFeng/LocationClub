//
//  NetworkManager.swift
//  igloo
//
//  Created by 冯奕琦 on 2018/12/14.
//  Copyright © 2018 冯奕琦. All rights reserved.
//

import Foundation
import Alamofire
import WebKit
import MapKit
import UIKit

class Network {
    
    static var shouldConneted:Bool = true
    
    //MARK:通知有关方法
    
    static func showAlertNetworkDied(){
        showAlert(message: "无网络连接,请检查是否连接网络")
    }
    
    static func showCanInputEmoji(){
        showAlert(message: "暂时不支持使用Emoji")
    }
    
    static func showAlert(message:String){
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
        //获取最上面的VC
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            //展示它
            topController.present(alertController, animated: true, completion: nil)
        }
    }
    
    //MARK:登陆接口
    //取消登陆功能
    static func justGetAIglooID(landingAction:@escaping (String)->Void){
        let url = Constants.backendURL + "getABrandNewIglooForUser/"
        sendRuquest(url: url, method: .get, parameters: [:]) { (data) in
            let iglooID = data[Constants.iglooID] as! String
            landingAction(iglooID)
        }
    }
    //登陆接口igloo
    static func login(withGoogle:Bool,GoogleId:String? = nil,GoogleName:String? = nil,number:String? = nil,password:String? = nil,action: @escaping ([String:Any])->Void ){
        //配置参数
        var parameters :Parameters = [:]
        if withGoogle {
            parameters = [Constants.thirdPartyID:GoogleId!,Constants.userName:GoogleName!,Constants.loginWithGoogle:"True"]
        }else{
            parameters = [Constants.phoneNumber:number!,Constants.password:password!,Constants.loginWithGoogle:"False"]
        }
        //配置地址
        let url = Constants.backendURL + "iglooLogin/"
        //发送方法
        sendRuquest(url: url, method: .post, parameters: parameters, action: action)
        
    }
    
    //登出
    static func logOut(iglooID:String,landingAction:@escaping ()->Void){
        //发送登出方法
        //配置参数
        let parameters = [Constants.iglooID:iglooID]
        //配置Url
        let url = Constants.backendURL + "logout/"
        //发送它
        sendRuquest(url: url, method: .get, parameters: parameters, action: {(data) in
            landingAction()
        })
    }
    
    //获取验证码
    static func gettingCode(phoneNumber:String,action: @escaping ([String:Any])->Void){//调用前检查手机号格式
        //配置参数
        let parameters = [Constants.phoneNumber:phoneNumber]
        //配置Url
        let url = Constants.backendURL + "gettingCode/"
        //发送方法
        sendRuquest(url: url, method: .post, parameters: parameters, action: action)
    }
    
    //注册
    static func signUp(phoneNumber:String,code:String,password:String,action: @escaping ([String:Any])->Void){
        let parameters = [Constants.phoneNumber:phoneNumber,Constants.code:code,Constants.password:password]
        let url = Constants.backendURL + "signIn/"
        sendRuquest(url: url, method: .post, parameters: parameters, action: action)
    }

    //MARK: 地点操作
    
    static func checkIsLocation(iglooID:String,id:String,landingBlock:@escaping (Bool)->Void){
        //配置参数
        let parameters = [Constants.iglooID:iglooID,Constants.locationID:id]
        //配置Url
        let url = Constants.backendURL + "checkLocation/"
        //发送它
        sendRuquest(url: url, method: .get, parameters: parameters, action: {(data) in
            if let result = data["success"] as? Bool {
                landingBlock(result)
            }
        })
    }
    
    //创建地点 登陆之后才能使用 注意登陆之后上传Location的同时也要上传CellImage
    static func createNewLocationToServer(locaitonID:String,data:LocationInfoLocal,action:@escaping ([String:Any])->Void){
        //locationInfoLocal转化为parameters参数 VisitedNote需要等待这个方法返回之后进行添加
        var parameters = Shower.changeLocationInfoToParameters(data: data)
        //获取LocaitonID iglooID ⚠️测试的时候使用静态iglooID
        parameters[Constants.iglooID] = LoginModel.iglooID
        parameters[Constants.locationID] = locaitonID
        //url
        let url = Constants.backendURL + "addLocation/"
        sendRuquest(url: url, method: .get, parameters: parameters, action: action)
    }
    
    
    
    //获取地点信息 注意顶级信息在这里代表全部信息
    static func getLocationInfo(locationID:String,rank:Int,landingAction: @escaping (Any)->Void){//
        if checkNetworkConnection() == false {return}//检查是否有网络连接
        let locationUrl = Constants.backendURL + "getLocation/"
        //内部方法—————使用这个方法来获取2到4rank的数据
        func getRankData(_ rank:Int){
            let paramenters = [Constants.locationID:locationID,Constants.rankOfLocationInfo:String(rank)]
            Alamofire.request(locationUrl, method: .get, parameters: paramenters, encoding: URLEncoding(destination: .methodDependent)).responseJSON(completionHandler: { (response) in
                if let data = response.data {
                    //直接Decode Json
                    var dataForUse:Codable?
                    switch rank{
                    case 2: dataForUse = Shower.decoderJson(jsonData: data, type: LocationInfoRank2.self)
                    case 3: dataForUse = Shower.decoderJson(jsonData: data, type: LocationInfoRank3.self)
                    case 4: dataForUse = Shower.decoderJson(jsonData: data, type: LocationInfoRank4.self)
                    default : return
                    }
                    //执行LandingAction
                    if let data = dataForUse{
                        landingAction(data)
                    }else{
//                        print("无数据")
                    }
                }
            })
        }
        
        let paramenters1 = [Constants.locationID:locationID,Constants.rankOfLocationInfo:"1"]
        let paramenters2 = [Constants.locationID:locationID,Constants.rankOfLocationInfo:"2"]
        switch rank {
        case 1://获取全部地址信息
            //数据储存器
            var rank1Data:Data?
            var rank2Data:Data?
            var visitedNoteIDArray:[String] = []
            //手写链式调用Request
            Alamofire.request(locationUrl, method: .get, parameters: paramenters1,encoding: URLEncoding(destination: .methodDependent))
                .responseJSON { (response) in//第一次返回一个Rank1数据
                    //使用Shower来更改为Swift类型
                    if let data = response.data {
                        rank1Data = data
                        //获取VisitedNoteID数组
                        if let rank1class = Shower.decoderJson(jsonData: data, type: LocationInfoRank1.self){
                            visitedNoteIDArray = rank1class.VisitedNoteID
//                            print(visitedNoteIDArray)
                        }else{
                            print("NetworkManager")
                            print("getLocationInfo出错鸟")
                            return
                        }
                    }
                    //进行rank2data的请求
                    Alamofire.request(locationUrl, method: .get, parameters: paramenters2, encoding: URLEncoding(destination: .methodDependent)).responseJSON(completionHandler: { (response) in
                        if let data = response.data {
                            rank2Data = data
                            //进行递归的数组信息获取 并且在最后一个Block执行Block
                            getVisitNotes(locationID:locationID,IDs: visitedNoteIDArray, dataArray: [],
                                          rankData: [rank1Data!,rank2Data!], finalBlock: landingAction)
                        }
                    })
                    
                }
        default:
            if 2 <= rank , rank <= 4{
                getRankData(rank)//其他级别使用这个方法
            }else{
                print("NetworkManager")
                print("getLocationInfo超出范围")
            }
        }
        
        
    }
    
    //更改Location信息 登陆之后才能使用⚠️
    static func changeLocationData(key:String,data:String,locationID:String,landing: @escaping()->Void){
        //从UserDefault中获取iglooID
        let iglooID = LoginModel.iglooID
        //配置Url
        let url = Constants.backendURL + "changeLocationInfo/"
        //配置参数
        let parameters = ["key":key,"data":data,Constants.iglooID:iglooID,Constants.locationID:locationID]
        //发送参数
        sendRuquest(url: url, method: .get, parameters: parameters) { (JSON) in
            if let result = JSON["success"] as? Bool{
                print("NetworkManager")
                print("更改Location信息 " + String(result))
            }else{
                //错误信息
                print("NetworkManager")
                print("更改Location信息 错误")
            }
            landing()
        }
    }
    
    //删除Locaition 要拥有闭包
    static func deleteLocation(locationID:String,landingAction:@escaping ()->Void){
        //从UserDefault中获取iglooID
        let iglooID = LoginModel.iglooID
        //配置Url
        let url = Constants.backendURL + "changeLocationInfo/"
        //配置参数
        let parameters = ["key":"delete",Constants.iglooID:iglooID,Constants.locationID:locationID]
        //发送参数
        sendRuquest(url: url, method: .get, parameters: parameters) { (JSON) in
                print("NetworkManager")
                print("删除Location信息")
                landingAction()
        }
    }
    //MARK: 访问记录创建与删除
    //data(visitNote)中的imageArray一定要为空，直接在后面传入 [UIImage]
    static func createVisitedNote(locationID:String,visitNoteID:String,data:VisitedNote,imageArray:[UIImage],landingAction:(()->Void)? = nil){
        //直接创建新的JsonString
        var JsonString = "{\"imageURL\":["
        if data.imageURLArray.isEmpty {
            JsonString += "]}"
        }
        for (index,imageURL) in data.imageURLArray.enumerated() {
            JsonString += "\"" + imageURL + "\""
            if index == data.imageURLArray.endIndex-1{
                JsonString += "]}"
            }else{
                JsonString += ","
            }
        }
        //参数配置
        let parameters : [String : Any] = [Constants.VisitedNoteID:visitNoteID,Constants.visitNoteWord:data.visitNoteWord,
                          Constants.locationID:locationID,Constants.createdTime:data.createdTime,
                          Constants.imageURLArray:JsonString]
        //Send it!
        sendRuquest(url: Constants.backendURL+"newVisitNote/", method: .get, parameters: parameters) { (JSON) in
            if JSON["success"] as! Bool == true {
                print("NetworkManager")
                print("创建VisitedNoted成功")
                //发送图片
                let imageURlArray = data.imageURLArray
                var imageAndUrlArray:[(String,UIImage)] = []
                for (index,image) in imageArray.enumerated(){
                    imageAndUrlArray.append((imageURlArray[index],image))
                }
                ImageManager.send(dataArray: imageAndUrlArray)
                //执行闭包
                if let action = landingAction {
                    action()
                }
            }else{
                 print("NetworkManager")
                print("创建VisitedNoted不成功")
                //不在本地进行添加
            }
        }
        
        
    }
    
    static func deleteVisitedNote(id:String,landingAction:@escaping ()->Void){
        //配置参数
        let parameters = [Constants.iglooID:LoginModel.iglooID,Constants.VisitedNoteID:id]
        //Send it!
        sendRuquest(url: Constants.backendURL+"deleteVisitedNote/", method: .get, parameters: parameters) { (JSON) in
            print("NetworkManager")
            print("删除VisitedNoted成功")
            landingAction()
        }
    }
    
    //MARK: 查找区域内地点 使用Map的区域类型？
    static func getLocationsIn(span:MKCoordinateRegion,landingAction:@escaping ( [(String,LocationInfoRank3)] )->Void){
        //配置参数
        let url = Constants.backendURL + "searchSpan/"
        let spanForUse = span.getLatitudeLongitudeSpan()
//        print(spanForUse)
        let parameters = [Constants.spanX:spanForUse.latitudeMin,Constants.spanY:spanForUse.longtitudeMin,
            Constants.spanHeigh:span.span.longitudeDelta,Constants.spanWidth:span.span.latitudeDelta]
//        print(parameters)
        //发送请求
        sendRuquest(url: url, method: .get, parameters: parameters) { (JSON) in
            //数据处理
            let rawDataArray = JSON["data"] as! [[String:Any]]
            var resultArray:[(String,LocationInfoRank3)] = []
            for locations in rawDataArray{
                //对每个location数据进行处理
                let locationID = locations[Constants.locationID] as! String
                let latitude = locations[Constants.locationLatitudeKey] as! Double
                let longitude = locations[Constants.locationLongitudeKey] as! Double
                let iconKind = locations[Constants.iconKindString] as! String
                //加入结果数组
                resultArray.append((locationID,
                                    LocationInfoRank3(locationLatitudeKey:latitude, locationLongitudeKey:longitude,
                                                      iconKindString:iconKind)))
            }
            //执行处理闭包
            landingAction(resultArray)
        }
    }
    
    //MARK: 赞👍 与赞的取消 使用同一个方法
    //需要登陆过才能使用
    static func liked(cancel:Bool,location:String,landingAction:@escaping (Bool)->Void){
        //唯一的不同就是URL
        let url = Constants.backendURL + (cancel ? "unliked/" :"liked/")
        //⚠️使用静态igloo测试 LoginModel.iglooID
        let parameters = [Constants.iglooID:LoginModel.iglooID,Constants.locationID:location]
        sendRuquest(url: url, method: .get, parameters: parameters) { (JSONs) in
            if let success = JSONs["success"] as? Bool {
                //执行成功代码
                landingAction(success)
            }
        }
    }

    
    //MARK: 图片上传下载
    //对于外部来说直接传入URL就可以获取图片
    static func getImage(at url:String,savePhotos:Bool?,landingAction:@escaping (UIImage)->Void){
        if checkNetworkConnection() == false {return}//检查是否有网络连接
        //检查缓存
        if let image = ImageChecker.getImage(url: url){
            print("NetworkManager")
            print("缓存中有此图片")
            landingAction(image)
        }else{
            //进行后端图片的获取  图床的ImageURl
            print("NetworkManager获取以下地址的图片")
            print(Constants.imagebedURL+url)
            Alamofire.request(Constants.imagebedURL+url,method: .get,
                              parameters: [:],encoding: URLEncoding(destination: .methodDependent))
                .responseData { (response) in
                    let data = response.result.value!
                    //转换成为UIImage
                    if let image = UIImage(data: data) {
                        //查看是否需要储存到本机
                        if let needSavePhoto = savePhotos,needSavePhoto == true{
                            LocalImagePool.set(image: image, url: url)
                            print("NetworkManager")
                            print("保存到本地")
                        }else{
                            //加入缓存
                            ImageChecker.set(image: image, url: url)
                        }
                        //执行Action
                        landingAction(image)
                    }else{
                        print("NetworkManager")
                        print("图片Data不存在")
                    }
            }
        }
        
    }
    //使用这个方法更改代表Locationd的那个Image
    
    static func getLocationInfoImageUrl(locationID:String)->String{
        let name = String(locationID)+"InfoImage"
        let url =  "uploads/" + name + ".jpg"
        return url
    }
    
    static func changeLocationInfoImage(locationID:String,image:UIImage) {//
        let url = getLocationInfoImageUrl(locationID: locationID)
        //更改后台url
        let backendURL = Constants.backendURL + "changeLocationInfoImageURL/"
        let paramters = [Constants.locationID:locationID,Constants.locationInfoImageURL:url]
        sendRuquest(url: backendURL, method: .get, parameters: paramters) { (data) in
            print("NetworkManager")
            print("changeLocationInfoImage完成")
            //发送图片
            ImageManager.send(dataArray: [(url,image)])
        }
        
    }
//    (不能直接调用!)
     static func send(filename:String,image: UIImage,
                     locationID:String? = nil,visitNoteID:String? = nil,
                     landingAction:@escaping(Bool)->Void){
        //判断要往location添加,还是VisitedNote
        var sendToLocation:Bool = false
        var id:String!
        if let lid = locationID{ id = lid;sendToLocation = true }
        if let vid = visitNoteID{ id = vid }
        //配置parameters
        let url = Constants.backendURL + (sendToLocation ? "newLocationInfoImage/" : "newVisitNoteInfoImage/")
        //发送数据
        let imageData = image.jpegData(compressionQuality: 1)!
        //使用upload方法
        Alamofire.upload(multipartFormData: { (dataToSend) in
            //添加图片数据 带有文件名称
            dataToSend.append(imageData, withName: "image", fileName: filename+".jpg", mimeType: "image/jpeg")
            //添加locationID 或 VisitedNoteID
            let name = sendToLocation ? Constants.locationID : Constants.VisitedNoteID
            //将String转换为Data才能发送
            dataToSend.append(id!.data(using: .utf8, allowLossyConversion: false)!, withName: name)
        }, to: url,
           encodingCompletion:  { encodingResult in //报错机制
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    debugPrint(response)
                    landingAction(true)
                }
            case .failure(let encodingError):
                print(encodingError)
                landingAction(false)
            }
        })
        
        //更改名字
        
    }
    
    //MARK: 联系我们
    
    static func contactUs(string:String){
        let url = Constants.backendURL + "contact/"
        //使用静态iglooID⚠️
        let parameters = [Constants.iglooID:LoginModel.iglooID,Constants.content:string]
        //发送函数
        sendRuquest(url: url, method: .get, parameters: parameters) { (JSON) in
            //do nothing
        }
    }
    
    //MARK: 辅助方法
    
    static func checkNetworkConnection()->Bool{
        if Network.shouldConneted == false {
            Network.showAlertNetworkDied()
            return false
        }else{
            return true
        }
    }
    
    //使用这个方法运行没有Codable类的功能
    static func sendRuquest(url:String,method:HTTPMethod,parameters:Parameters,action: @escaping ([String:Any])->Void){
        if checkNetworkConnection() == false {return}//检查是否有网络连接
        //发送方法
        Alamofire.request(url, method: method, parameters: parameters ,encoding: URLEncoding(destination: .methodDependent))
            .responseJSON{ response in
                //检查数据是否传输到位
                if response.result.isSuccess, let JSONDict = response.value! as? [String:Any]{
                    //执行传入的Block
                    DispatchQueue.main.async {
                        action(JSONDict)
                    }
                }else{
                     print("NetworkManager")
                    print("错误")
                }
        }
    }
    
    //递归获取方法 等待加入图片获取
    static func getVisitNotes(locationID:String,IDs: [String],dataArray: [Data],rankData:[Data],finalBlock: @escaping (Any)->Void){//当IDs空的时候就停止递归
        let url = Constants.backendURL + "getVisitedNoteInfo/"
        //检查是否结束了
        if IDs.isEmpty {//结束那么所有数据到手
            //组装LocationInfo
            if let locationInfo = Shower.assemble(locationID:locationID, rank1Data: rankData[0], rank2Data: rankData[1], VisitedNotedArray: dataArray){
                //执行最后的操作
                finalBlock(locationInfo)
            }
            return
        }else{
            Alamofire.request(url, method: .get, parameters: [Constants.VisitedNoteID:IDs.first!], encoding: URLEncoding(destination: .methodDependent))
                .responseJSON { (JSONRespond) in
                    if let data = JSONRespond.data {
                        //存入数组
                        var nextDataArray = dataArray
                        nextDataArray.append(data)
                        //删除被获取的id
                        var nextIDs = IDs
                        nextIDs.remove(at:0)
                        //继续递归
                        getVisitNotes(locationID:locationID,IDs: nextIDs, dataArray: nextDataArray, rankData: rankData,finalBlock: finalBlock)
                    }
            }
        }
    }
    
    
    
    
    
}

