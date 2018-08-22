//
//  VibeModel.swift
//  Kraiz
//
//  Created by Kumar Agarwal, Kanhai on 20/08/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import Foundation

public class VibeModel {
    var vibeName: String
    var from: String
    var to: String
    var isReceiverUsername: Bool
    var isBackgroundMusicEnabled: Bool
    var isSenderAnonymous: Bool
    var isPhotosPresent: Bool?
    var isLetterPresent: Bool?
    var isVideoPresent: Bool?
    var isAudioPresent: Bool?
    var isAppreciationEnabled: Bool?
    
    init() {
        vibeName = ""
        from = ""
        to = ""
        isReceiverUsername = false
        isBackgroundMusicEnabled = false
        isSenderAnonymous = false
        isPhotosPresent = false
        isLetterPresent = false
        isVideoPresent = false
        isAudioPresent = false
        isAppreciationEnabled = false
    }
    
    init(vibeName: String, from: String, to: String, isReceiverUsername: Bool, isBackgroundMusicEnabled: Bool, isSenderAnonymous: Bool) {
        self.vibeName = vibeName
        self.from = from
        self.to = to
        self.isReceiverUsername = isReceiverUsername
        self.isBackgroundMusicEnabled = isBackgroundMusicEnabled
        self.isSenderAnonymous = isSenderAnonymous
    }
}
