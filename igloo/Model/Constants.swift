//
//  Constants.swift
//  igloo
//
//  Created by 冯奕琦 on 2018/12/14.
//  Copyright © 2018 冯奕琦. All rights reserved.
//

import Foundation

class Constants {
    //MARK: 后端的Keys
    static let backendURL =  "http://127.0.0.1:8000/location/"
    
    //JsonKeys
    static let locationLongitudeKey = "locationLongitudeKey"
    static let locationLatitudeKey = "locationLatitudeKey"
    static let usersOwenPlacesDefaultJsonKey = "ownPlaceId"
    static let usersLikePlacesDefaultJsonKey = "likedPlaceId"
    static let locationVisitnoteDefaultJsonKey = "VisitedNoteID"
    static let visitNoteImagesDefaultJsonKey = "imageURL"
    //JsonKey for Login
    static let thirdPartyID = "thirdPartyID"
    static let userImageURL = "userImageURL"
    static let userName = "userName"
    // For return
    static let iglooID = "iglooID"
    
    //JSONKey for AddIn LocationInfo
    static let locationName = "locationName"
    static let createrID = "createrID"
    static let locationID = "locationID"
    //经纬度在上面
    static let locationLikedAmount = "locationLikedAmount"
    static let iconKindString = "iconKindString"
    static let isPublic = "isPublic"
    static let locationCreatedTime = "locationCreatedTime"
    static let locationDescription = "locationDescription"
    
    //JSON For Getting LocationInfo
    static let rankOfLocationInfo = "rankOfLocationInfo"
    static let allVisitNoteId = "allVisitNoteId"
    static let locationInfoWord = "locationInfoWord"
    static let lastVisitNoteId = "lastVisitNoteId"
    static let locationInfoImageURL = "locationInfoImageURL"
    
    //JSON For VisitNote
    static let VisitedNoteID = "VisitedNoteID"
    static let visitNoteWord = "visitNoteWord"
    static let imageURL = "imageURL"
    static let createdTime = "createdTime"
    static let imageURLArray = "imageURLArray"
    
    //Json For getLocatinID
    static let spanX = "spanX"
    static let spanY = "spanY"
    static let spanWidth = "spanWidth"
    static let spanHeigh = "spanHeigh"
    
    //Login shit
    static let phoneNumber = "phoneNumber"
    static let code = "code"
    static let password = "password"
    static let loginWithGoogle = "loginWithGoogle"
    
    //Contact Us
    static let content = "content"
    static let success = "success"
    
    //MARK:储存的keys
    static let isLogin = "isLogin"
}
