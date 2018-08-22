//
//  AuthenticationUtility.swift
//  Kraiz
//
//  Created by Kumar Agarwal, Kanhai on 15/08/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import Foundation
import AWSCore
import AWSCognitoIdentityProvider

public class AuthenticationUtility {
    
    public static func doSignUp(username: String, password: String, phoneNumber: String) -> Int {
        let phone = AWSCognitoIdentityUserAttributeType.init(name: "phone", value: phoneNumber)
        
        return 0
    }
}
