//
//  ConnectionModel.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 20/10/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import Foundation

public class ConnectionModel {
    var username: String?
    var vibeName: String?
    var isLetterPresent: Bool?
    var isPhotosPresent: Bool?
    var isVideoPresent: Bool?
    var isAudioPresent: Bool?
    var timestamp: String?
    var isUserSender: Bool?

    init() {
        username = nil
        vibeName = nil
        isLetterPresent = false
        isPhotosPresent = false
        isVideoPresent = false
        isAudioPresent = false
        timestamp = nil
        isUserSender = false
    }

    init(username: String?, vibeName: String?, isLetterPresent: Bool?, isPhotosPresent: Bool?, isVideoPresent: Bool?, isAudioPresent: Bool?, timestamp: String?, isUserSender: Bool?) {
        self.username = username
        self.vibeName = vibeName
        self.isLetterPresent = isLetterPresent
        self.isPhotosPresent = isPhotosPresent
        self.isVideoPresent = isVideoPresent
        self.isAudioPresent = isAudioPresent
        self.timestamp = timestamp
        self.isUserSender = isUserSender
    }
}
