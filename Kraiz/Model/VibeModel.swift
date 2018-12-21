//
//  VibeModel.swift
//  Kraiz
//
//  Created by Kumar Agarwal, Kanhai on 20/08/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import Foundation

public class VibeModel {
    var id: String
    var vibeName: String
    var from: String
    var to: String
    var category: Int
    var type: Int
    var isBackgroundMusicEnabled: Bool
    var isSenderAnonymous: Bool
    var isPhotosPresent: Bool
    var isLetterPresent: Bool
    var letter: LetterEntity
    var images: [PhotoEntity]
    var backgroundMusicIndex: Int
    var imageBackdrop: Int
    
    init() {
        id = ""
        vibeName = ""
        from = ""
        to = ""
        category = 0
        type = 0
        isBackgroundMusicEnabled = false
        isSenderAnonymous = false
        isPhotosPresent = false
        isLetterPresent = false
        letter = LetterEntity()
        images = [PhotoEntity]()
        backgroundMusicIndex = 0
        imageBackdrop = 0
    }
    
    init(vibeName: String, from: String, to: String, isBackgroundMusicEnabled: Bool, isSenderAnonymous: Bool) {
        self.id = ""
        self.vibeName = vibeName
        self.from = from
        self.to = to
        self.category = 0
        self.type = 0
        self.isBackgroundMusicEnabled = isBackgroundMusicEnabled
        self.isSenderAnonymous = isSenderAnonymous
        self.isLetterPresent = false
        self.isPhotosPresent = false
        self.letter = LetterEntity()
        self.images = [PhotoEntity]()
        self.backgroundMusicIndex = 0
        self.imageBackdrop = 0
    }
    
    public func getLetter() -> LetterEntity {
        return letter
    }
    
    public func setLetter(letterString: String, background: Int) {
        letter.text = letterString
        letter.background = background
    }
    
    public func setImages(photos: [PhotoEntity]) {
        images = photos
    }
    
    public func getImages() -> [PhotoEntity] {
        return images
    }

    public func setId(id: String) {
        self.id = id
    }
    public func setLetterText(letterString: String) {
        letter.text = letterString
    }
    
    public func setLetterBackground(background: Int) {
        letter.background = background
    }
    
    public func setVibeName(name: String) {
        vibeName = name
    }
    
    public func setSender(sender: String) {
        from = sender
    }
    
    public func setReceiver(receiver: String) {
        to = receiver
    }
    
    public func setLetterPresent(isLetterPresent: Bool) {
        self.isLetterPresent = isLetterPresent
    }
    
    public func setPhotosPresent(isPhotosPresent: Bool) {
        self.isPhotosPresent = isPhotosPresent
    }
    
    public func setBackgroundMusicEnabled(isBackgroundMusicEnabled: Bool) {
        self.isBackgroundMusicEnabled = isBackgroundMusicEnabled
    }
    
    public func setBackgroundMusic(index: Int) {
        self.backgroundMusicIndex = index
    }
    
    public func setAnonymous(isSenderAnonymous: Bool) {
         self.isSenderAnonymous = isSenderAnonymous
    }
    
    public func setCategory(category: Int) {
        self.category = category
    }
    
    public func setVibeType(type: Int) {
        self.type = type
    }
    
    public func setImageBackdrop(backdrop: Int) {
        self.imageBackdrop = backdrop
    }
}
