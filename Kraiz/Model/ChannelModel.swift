//
//  ChannelModel.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 21/10/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import Foundation

class ChannelModel {
    var id: String?
    var accessHash: String?
    var createdAt: String?
    var isAnonymousAllowed: Bool
    var userStates: [String:String]?
    
    init() {
        id = nil
        accessHash = nil
        createdAt = nil
        isAnonymousAllowed = false
        userStates = nil
    }
}
