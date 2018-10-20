//
//  DeviceConstants.swift
//  StoryFi
//
//  Created by Kumar Agarwal, Kanhai on 11/06/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import Foundation
import UIKit

public class DeviceConstants {
    static public let IPHONE5S_HEIGHT : CGFloat = 568.0
    static public let IPHONE7_HEIGHT : CGFloat = 667.0
    static public let IPHONE7PLUS_HEIGHT : CGFloat = 736.0
    static public let IPHONEX_HEIGHT : CGFloat = 812.0
    static public let IPHONEXR_HEIGHT : CGFloat = 896.0
    
    // Common Errors
    static public let NO_INTERNET_ERROR = NSError(domain: "NoInternetConnection", code: 503, userInfo: ["__type": "NoInternetConnectionException"])
    
    // User Defaults Keys
    static public let DOB : String = "dob"
    static public let GENDER : String = "gender"
    static public let ID_TOKEN : String = "tokenString"
    static public let IS_PROFILE_PRESENT : String = "isProfilePresent"
    static public let MOBILE_NUMBER : String = "mobileNumber"
    static public let NAME : String = "name"
    static public let PROFILE_PICTURE : String = "profilePicture"
    static public let USER_ID : String = "userId"
    static public let USER_NAME : String = "username"
    
    // Segues
    static public let CREATE_STORY_SEGUE = "gotoCreateStory"
    
    // Tab Bar Index
    static public let DEFAULT_SELECTED_INDEX = 0
    
    // Colors
    static public let DEFAULT_SEPERATOR_COLOR = UIColor(displayP3Red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
}

