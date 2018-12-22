//
//  VibeComponentEntity.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 22/12/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import Foundation
import RealmSwift

class VibeComponentEntity: Object {
    @objc dynamic var id: String?
    @objc dynamic var vibeName: String?
    @objc dynamic var from: String?
    @objc dynamic var to: String?
    @objc dynamic var receiverUsername: String?
    @objc dynamic var receiverProfilePic: String?
    @objc dynamic var category: Int = 0
    @objc dynamic var type: Int = 0
    @objc dynamic var isBackgroundMusicEnabled: Bool = false
    @objc dynamic var isSenderAnonymous: Bool = false
    @objc dynamic var isPhotosPresent: Bool = false
    @objc dynamic var isLetterPresent: Bool = false
    @objc dynamic var letter: CacheLetterEntity?
    var images: List<CachePhotoEntity>? = List<CachePhotoEntity>()
    @objc dynamic var backgroundMusicIndex: Int = 0
    @objc dynamic var imageBackdrop: Int = 0

    /// MARK: - Getters Start.

    public func getId() -> String? {
        return self.id
    }

    public func getVibeName() -> String? {
        return self.vibeName
    }

    public func getSender() -> String? {
        return self.from
    }

    public func getReceiverMobileNumber() -> String? {
        return self.to
    }

    public func getReceiverUsername() -> String? {
        return self.receiverUsername
    }

    public func getReceiverProfilePic() -> String? {
        return self.receiverProfilePic
    }

    public func getCategory() -> Int? {
        return self.category
    }

    public func getType() -> Int? {
        return self.type
    }

    public func getIsBackgroundMusicEnabled() -> Bool? {
        return self.isBackgroundMusicEnabled
    }

    public func getIsSenderAnonymous() -> Bool? {
        return self.isSenderAnonymous
    }

    public func getIsPhotosPresent() -> Bool? {
        return self.isPhotosPresent
    }

    public func getIsLetterPresent() -> Bool? {
        return self.isLetterPresent
    }

    public func getLetter() -> CacheLetterEntity? {
        return self.letter
    }

    public func getImages() -> List<CachePhotoEntity>? {
        return self.images
    }

    public func getBackgroundMusicIndex() -> Int? {
        return self.backgroundMusicIndex
    }

    public func getImageBackdrop() -> Int? {
        return self.imageBackdrop
    }

    /// MARK: - Getters End.

    /// MARK: - Setters Start.

    public func setId(_ id: String?) {
        self.id = id
    }

    public func setVibeName(_ name: String?) {
        self.vibeName = name
    }

    public func setSender(_ sender: String?) {
        self.from = sender
    }

    public func setReceiverMobileNumber(_ number: String?) {
        self.to = number
    }

    public func setReceiverUsername(_ username: String?) {
        self.receiverUsername = username
    }

    public func setReceiverProfilePic(_ profilePic: String?) {
        self.receiverProfilePic = profilePic
    }

    public func setCategory(_ category: Int) {
        self.category = category
    }

    public func setType(_ type: Int) {
        self.type = type
    }

    public func setIsBackgroundMusicEnabled(_ backgroundMusicEnabled: Bool) {
        self.isBackgroundMusicEnabled = backgroundMusicEnabled
    }

    public func setIsSenderAnonymous(_ anonymous: Bool) {
        self.isSenderAnonymous = anonymous
    }

    public func setIsPhotosPresent(_ photosPresent: Bool) {
        self.isPhotosPresent = photosPresent
    }

    public func setIsLetterPresent(_ letterPresent: Bool) {
        self.isLetterPresent = letterPresent
    }

    public func setLetter(_ letter: CacheLetterEntity?) {
        self.letter = letter
    }

    public func setImages(_ photos: List<CachePhotoEntity>?) {
        self.images = photos
    }

    public func setBackgroundMusicIndex(_ index: Int) {
        self.backgroundMusicIndex = index
    }

    public func setImageBackdrop(_ backdrop: Int) {
        self.imageBackdrop = backdrop
    }

    /// MARK: - Setters End.

    override static func primaryKey() -> String? {
        return "id"
    }

    public func addImageToImages(image: CachePhotoEntity) {
        if images == nil {
            images = List<CachePhotoEntity>()
        }
        images?.append(image)
    }

    public func removeImageAtIndex(index: Int) {
        if images == nil {
            return
        }
        images?.remove(at: index)
    }
}
