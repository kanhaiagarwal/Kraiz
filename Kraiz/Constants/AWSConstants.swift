//
//  AWSConstants.swift
//  Kraiz
//
//  Created by Kumar Agarwal, Kanhai on 15/08/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import Foundation
import AWSCore

public class AWSConstants {
    /// Testing credentials.
//    static public let AWS_REGION : AWSRegionType = AWSRegionType.USWest2
//    static public let APP_SYNC_ENDPOINT : URL = URL(string: "https://hmi5ytmqybc5zjyg7qjvp7mxxq.appsync-api.us-west-2.amazonaws.com/graphql")!
//    static public let COGNITO_APP_CLIENT_ID : String = "1vkf7m8h3eqao1abk0alv4h6m9"
//    static public let COGNITO_APP_CLIENT_SECRET : String = "kvhricpgiqhka4u9si4crman72o9o7nekit9lm4u3aut62rjv9j"
//    static public let COGNITO_IDENTITY_POOL_ID : String = "us-west-2:803ed36a-9107-4a4a-98ce-b4b52bd5b68a"
//    static public let COGNITO_USER_POOL_ID : String = "us-west-2_oPLIFxSIr"
//    static public let COGNITO_USER_POOL_NAME : String = "Kraiz-2"
//    static public let DATABASE_NAME = "appsync-local-db"

    /// Alpha credentials.
    static public let AWS_REGION : AWSRegionType = AWSRegionType.APSouth1
    static public let APP_SYNC_ENDPOINT : URL = URL(string: "https://3zncuvfpl5bc7c4rofcvrwj2va.appsync-api.ap-south-1.amazonaws.com/graphql")!
    static public let COGNITO_APP_CLIENT_ID : String = "6ujh6f3kkeq2ucvqian492t9jg"
    static public let COGNITO_APP_CLIENT_SECRET : String = "aua1do3k5kphnac4ri4sohv81nq6nipr4i6l7ibvhv84rmimng4"
    //    static public let COGNITO_IDENTITY_POOL_ID : String = "us-west-2:803ed36a-9107-4a4a-98ce-b4b52bd5b68a"
    static public let COGNITO_USER_POOL_ID : String = "ap-south-1_tb1laAVw7"
    static public let COGNITO_USER_POOL_NAME : String = "Kraiz"
    static public let DATABASE_NAME = "appsync-local-db"
}
