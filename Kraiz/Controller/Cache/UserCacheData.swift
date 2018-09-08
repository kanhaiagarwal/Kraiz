//
//  UserCacheData.swift
//  Kraiz
//
//  Created by Kumar Agarwal, Kanhai on 08/09/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import Foundation
import RealmSwift

class UserCacheData: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var username: String = ""
    @objc dynamic var mobileNumber: String = ""
    @objc dynamic var isFirstSignIn: Bool = true
}
