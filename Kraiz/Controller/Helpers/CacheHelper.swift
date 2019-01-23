//
//  CacheHelper.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 16/12/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import Foundation
import RealmSwift

public class CacheHelper {
    static let shared = CacheHelper()

    private init(){}

    /// Writes the profile to cache.
    /// - Parameters:
    ///     - object: Profile Object.
    func writeProfileToCache(_ object: ProfileEntity) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(object, update: true)
            try realm.commitWrite()
        } catch {
            print("Could not write profile to the cache: \(error)")
        }
    }

    /// Writes the Vibe to Cache.
    /// - Parameters:
    ///     - object: VibeData object
    ///     - checkVersion: True only if object needs to be added or updated if the cache version is less than the object version.
    func writeVibeToCache(_ object: VibeDataEntity, checkVersion: Bool) {
        do {
            let realm = try Realm()
            let result = realm.object(ofType: VibeDataEntity.self, forPrimaryKey: object.getId()!)
            if result == nil || (result!.getVersion() < object.getVersion()) {
                realm.beginWrite()
                realm.add(object, update: true)
                try realm.commitWrite()
            }
        } catch {
            print("Could not write vibe to the cache: \(error)")
        }
    }

    /// Writes Hail to Cache.
    /// - Parameters:
    ///     - object: Hail object.
    func writeHailToCache(_ object: HailsEntity) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(object, update: true)
            try realm.commitWrite()
        } catch {
            print("Could not write hail to the cache: \(error)")
        }
    }

    /// Gets all the hails corresponding to the Vibe.
    /// - Parameters:
    ///     - vibeId: Vibe ID for which the Hails are to be fetched.
    func getHailsOfVibe(vibeId: String) -> Results<HailsEntity>? {
        do {
            let realm = try Realm()
            return realm.objects(HailsEntity.self).filter("vibeId == '\(vibeId)'").sorted(byKeyPath: "createdAt", ascending: false)
        } catch {
            print("error in fetching the hails for the vibe: \(error)")
        }
        return nil
    }

    /// Adds the hail to the vibe.
    /// - Parameters:
    ///     - hail: Hail.
    ///     - vibeId: Vibe ID.
    func addHailToVibe(hail: HailsEntity, vibeId: String) {
        do {
            let realm = try Realm()
            let result = realm.object(ofType: VibeDataEntity.self, forPrimaryKey: vibeId)
            if result != nil {
                realm.beginWrite()
                result?.addHailToVibe(hail: hail)
                try realm.commitWrite()
            }
        } catch {
            print("Error in realm: \(error)")
        }
    }

    func getDemoVibe() -> VibeDataEntity? {
        do {
            let realm = try Realm()
            let result = realm.object(ofType: VibeDataEntity.self, forPrimaryKey: DeviceConstants.DEMO_VIBE_ID)
            return result
        } catch {
            print("error in realm: \(error)")
        }
        return nil
    }

    /// Get all the Vibes of a particular index.
    /// - Parameters:
    ///     - index: Vibe Index.
    ///     - value: Index Value
    func getVibesByIndex(index: String, value: String) -> Results<VibeDataEntity>? {
        do {
            let realm = try Realm()
            print(Realm.Configuration.defaultConfiguration.fileURL ?? "No File Url")
            let results = realm.objects(VibeDataEntity.self).filter("\(index) == '\(value)'").sorted(byKeyPath: "updatedTime", ascending: false)
            return results
        } catch {
            print("error in realm: \(error)")
        }
        return nil
    }
    
    func getVibesByIndexWithoutDemoVibe(index: String, value: String) -> Results<VibeDataEntity>? {
        do {
            let realm = try Realm()
            let results = realm.objects(VibeDataEntity.self).filter("\(index) == '\(value)'").filter("id != '\(DeviceConstants.DEMO_VIBE_ID)'").sorted(byKeyPath: "updatedTime", ascending: false)
            return results
        } catch {
            print("error in realm: \(error)")
        }
        return nil
    }
    
    /// Returns all the unseen vibes of a particular index.
    /// - Parameters:
    ///     - index: Vibe Index.
    ///     - value: Index Value.
    func getUnseenVibesByIndex(index: String, value: String) -> Results<VibeDataEntity>? {
        do {
            let realm = try Realm()
            let results = realm.objects(VibeDataEntity.self).filter("\(index) == '\(value)' AND isSeen == false AND isSender == false   ")
            return results
        } catch {
            print("error in realm: \(error)")
        }
        return nil
    }

    /// Returns the Seen status of the Vibe. Query by VibeEnitity
    /// - Parameters:
    ///     - vibe: Vibe Entity.
    /// - Returns: Seen Status of the Vibe.
    func getSeenStatusOfVibe(vibe: VibeDataEntity) -> Bool {
        do {
            let realm = try Realm()
            let result = realm.object(ofType: VibeDataEntity.self, forPrimaryKey: vibe)
            return result?.getIsSeen() ?? false
        } catch {
            print("error in realm: \(error)")
        }
        return false
    }

    /// Returns the Seen status of the Vibe. Query by Vibe ID.
    /// - Parameters:
    ///     - vibeId: Vibe ID.
    /// - Returns: Seen Status of the vibe.
    func getSeenStatusOfVibe(vibeId: String) -> Bool {
        print("vibeId inside getSeenStatus: \(vibeId)")
        do {
            let realm = try Realm()
            let result = realm.object(ofType: VibeDataEntity.self, forPrimaryKey: vibeId)
            print("result of primary key in getSeenStatusOfVibe: \(result)")
            return result?.getIsSeen() ?? false
        } catch {
            print("error in realm: \(error)")
        }
        return false
    }

    /// Updates the seen status of the vibe in the local cache.
    /// - Parameters:
    ///     - vibeId: Vibe ID whose status is changed.
    ///     - seenStatus - Seen Status.
    func updateVibeSeenStatus(vibeId: String, seenStatus: Bool) {
        do {
            let realm = try Realm()
            let result = realm.object(ofType: VibeDataEntity.self, forPrimaryKey: vibeId)
            realm.beginWrite()
            result?.setIsSeen(seenStatus)
            try! realm.commitWrite()
        } catch {
            print("error in realm: \(error)")
        }
    }

    func updateVibeDownloadStatus(vibe: VibeDataEntity, isDownloadInProgress: Bool) {
        do {
            let realm = try! Realm()
            realm.beginWrite()
            vibe.setIsDownloadInProgress(isDownloadInProgress)
            try realm.commitWrite()
        } catch {
            print("error in realm: \(error)")
        }
    }

    /// Gets the profile by Id.
    /// - Parameters:
    ///     - id: Profile ID.
    func getProfileById(id: String) -> ProfileEntity? {
        do {
            let realm = try Realm()
            let results = realm.object(ofType: ProfileEntity.self, forPrimaryKey: id)
            return results
        } catch {
            print("error in realm: \(error)")
        }
        return nil
    }

    /// Gets the Public Vibe Time Entity.
    func getPublicVibeTimeEntity() -> PublicVibeTimeEntity? {
        do {
            let realm = try Realm()
            return realm.object(ofType: PublicVibeTimeEntity.self, forPrimaryKey: UserDefaults.standard.string(forKey: DeviceConstants.USER_ID)!)
            
        } catch {
            print("realm has error: \(error)")
        }
        return nil
    }

    func getPublicVibeLastAccessedTime() -> Int {
        do {
            let realm = try Realm()
            return (realm.object(ofType: PublicVibeTimeEntity.self, forPrimaryKey: UserDefaults.standard.string(forKey: DeviceConstants.USER_ID)!)?.getLastVibeAccessTime())!
        } catch {
            print("realm has error: \(error)")
        }
        return Int(Date().timeIntervalSinceNow)
    }

    func setPublicVibeLastAccessedime(lastVibeFetchTime: Int) {
        do {
            let realm = try Realm()
            if let result = realm.object(ofType: PublicVibeTimeEntity.self, forPrimaryKey: UserDefaults.standard.string(forKey: DeviceConstants.USER_ID)!) {
                realm.beginWrite()
                result.setLastVibeAccessTime(currentTime: lastVibeFetchTime)
                try realm.commitWrite()
            } else {
                let object = PublicVibeTimeEntity()
                object.setLastVibeAccessTime(currentTime: lastVibeFetchTime)
                object.setUserId(id: UserDefaults.standard.string(forKey: DeviceConstants.USER_ID)!)
                object.setPublicVibeSeen(publicVibeSeen: false)
                realm.beginWrite()
                realm.add(object)
                try realm.commitWrite()
            }
        } catch {
            print("realm has error: \(error)")
        }
    }

    /// Initializes the Public Vibe Time Entity. This happens if the entity is not present for the first time in the app.
    func initializePublicVibeEntity() {
        do {
            let realm = try Realm()
            let publicVibeTimeEntity = PublicVibeTimeEntity()
            publicVibeTimeEntity.setUserId(id: UserDefaults.standard.string(forKey: DeviceConstants.USER_ID)!)
            publicVibeTimeEntity.setPublicVibeSeen(publicVibeSeen: false)
            publicVibeTimeEntity.setLastVibeAccessTime(currentTime: Int(Date().timeIntervalSince1970))
            try realm.write {
                realm.add(publicVibeTimeEntity)
            }
        } catch {
            print("error in realm: \(error)")
        }
    }

    /// Sets the hasNewHails for the Vibe.
    /// - Parameters:
    ///     - hasNewHails: true if the vibe has new hails. Else false.
    func setHasNewHailsInVibe(hasNewHails: Bool, vibeId: String) {
        do {
            let realm = try Realm()
            if let result = realm.object(ofType: VibeDataEntity.self, forPrimaryKey: vibeId) {
                realm.beginWrite()
                result.setHasNewHails(hasNewHails: hasNewHails)
                try realm.commitWrite()
            }
        } catch {
            print("error in realm: \(error)")
        }
    }
    
    /// Gets the Hails Count of the Vibe.
    /// - Parameters:
    ///     - vibeId: Vibe ID.
    func getHailsCountForVibe(vibeId: String) -> Int {
        do {
            let realm = try Realm()
            let result = realm.object(ofType: VibeDataEntity.self, forPrimaryKey: vibeId)
            if result != nil {
                let hails = result!.getAllHails()
                return hails.count
            } else {
                return 0
            }
        } catch {
            print("error in realm: \(error)")
        }
        return 0
    }

    /// Deletes the draft from the cache.
    /// - Parameters:
    ///     - draftId - Draft ID.
    func deleteDraft(draftId: String) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            if let object = realm.object(ofType: DraftEntity.self, forPrimaryKey: draftId) {
                if let vibeComponentEntity = object.getVibeEntity() {
                    if let letter = vibeComponentEntity.getLetter() {
                        realm.delete(letter)
                    }
                    if let photos = vibeComponentEntity.getImages() {
                        realm.delete(photos)
                    }
                    realm.delete(vibeComponentEntity)
                }
                realm.delete(object)
            }
            try realm.commitWrite()
        } catch {
            print("error in realm: \(error)")
        }
    }
    func getDraftsFromCache() -> Results<DraftEntity>? {
        do {
            let realm = try Realm()
            let objects = realm.objects(DraftEntity.self).sorted(byKeyPath: "lastUpdatedTime", ascending: false)
            return objects
        } catch {
            print("error in realm: \(error)")
        }
        return nil
    }

    /// Stores the draft in the cache. If the draft is already present, then update it.
    /// - Parameters:
    ///     - draftId: Draft ID.
    ///     - vibeModel - Vibe Model.
    func storeDraft(draftId: String?, vibeModel: VibeModel) {
        do {
            let realm = try Realm()
            let timeNow = Int(Date().timeIntervalSince1970)
            if draftId != nil, let queryResult = realm.object(ofType: DraftEntity.self, forPrimaryKey: draftId!) {
                realm.beginWrite()
                queryResult.setLastUpdatedTime(timeNow)
                queryResult.setVibeEntity(createVibeComponentEntityFromVibeModel(vibeComponentId: draftId!, vibeModel: vibeModel, realm: realm))
                try realm.commitWrite()
            } else {
                let entity = DraftEntity()
                realm.beginWrite()
                entity.setId(String(timeNow))
                entity.setLastUpdatedTime(timeNow)
                entity.setVibeEntity(createVibeComponentEntityFromVibeModel(vibeComponentId: String(timeNow), vibeModel: vibeModel, realm: realm))
                realm.add(entity, update: true)
                try realm.commitWrite()
            }
        } catch {
            print("Error in realm: \(error)")
        }
    }

    /// Creates a VibeComponentEntity from the vibe model.
    /// - Parameters:
    ///     - draftId: Draft ID.
    ///     - vibeModel: Vibe Model.
    ///     - realm: Realm.
    func createVibeComponentEntityFromVibeModel(vibeComponentId: String, vibeModel: VibeModel, realm: Realm) -> VibeComponentEntity {
        if let vibeEntity = realm.object(ofType: VibeComponentEntity.self, forPrimaryKey: vibeComponentId) {
            vibeEntity.setType(vibeModel.type)
            vibeEntity.setSender(vibeModel.from?.getId())
            vibeEntity.setCategory(vibeModel.category)
            vibeEntity.setVibeName(vibeModel.vibeName)
            vibeEntity.setImageBackdrop(vibeModel.imageBackdrop)
            vibeEntity.setReceiverUsername(vibeModel.receiverUsername)
            vibeEntity.setIsSenderAnonymous(vibeModel.isSenderAnonymous)
            vibeEntity.setReceiverProfilePic(vibeModel.receiverProfilePic)
            vibeEntity.setBackgroundMusicIndex(vibeModel.backgroundMusicIndex)
            vibeEntity.setReceiverMobileNumber(vibeModel.to?.getMobileNumber())
            vibeEntity.setIsBackgroundMusicEnabled(vibeModel.isBackgroundMusicEnabled)
            vibeEntity.setIsPhotosPresent(vibeModel.isPhotosPresent)
            vibeEntity.setIsLetterPresent(vibeModel.isLetterPresent)
            
            if vibeModel.isLetterPresent {
                if vibeEntity.isLetterPresent && vibeEntity.getLetter() != nil {
                    vibeEntity.getLetter()?.setText(vibeModel.getLetter().text)
                    vibeEntity.getLetter()?.setBackground(vibeModel.getLetter().background!)
                } else {
                    let letter = CacheLetterEntity()
                    letter.setText(vibeModel.getLetter().text)
                    letter.setBackground(vibeModel.getLetter().background!)
                    vibeEntity.setLetter(letter)
                    vibeEntity.setIsLetterPresent(true)
                }
            } else {
                vibeEntity.setLetter(nil)
                vibeEntity.setIsLetterPresent(false)
            }
            
            if vibeModel.isPhotosPresent {
                // remove old images from the vibe entity and image data from the Cache folder.
                while vibeEntity.getImages()!.count > 0 {
                    if let urlString = vibeEntity.getImages()![0].localPath {
                        let imageUrl = URL(fileURLWithPath: NSHomeDirectory().appending(urlString))
                        do {
                            let fileManager = FileManager()
                            try fileManager.removeItem(at: imageUrl)
                        } catch {
                            print("cannot convert the image: \(error)")
                        }
                    }
                    realm.delete(vibeEntity.getImages()![0])
                }
                let imagesFromVibeModel = vibeModel.getImages()
                for i in 0 ..< imagesFromVibeModel.count {
                    let image = CachePhotoEntity()
                    image.setCaption(imagesFromVibeModel[i].caption)
                    image.setLocalPath(imagesFromVibeModel[i].image!.saveImageToLibraryDirectory())
                    vibeEntity.addImageToImages(image: image)
                }
            } else {
                vibeEntity.setImages(nil)
            }
            return vibeEntity
        } else {
            let vibeEntity = VibeComponentEntity()
            vibeEntity.setId(vibeComponentId)
            vibeEntity.setType(vibeModel.type)
            vibeEntity.setSender(vibeModel.from?.getId())
            vibeEntity.setCategory(vibeModel.category)
            vibeEntity.setVibeName(vibeModel.vibeName)
            vibeEntity.setImageBackdrop(vibeModel.imageBackdrop)
            vibeEntity.setReceiverUsername(vibeModel.receiverUsername)
            vibeEntity.setIsSenderAnonymous(vibeModel.isSenderAnonymous)
            vibeEntity.setReceiverProfilePic(vibeModel.receiverProfilePic)
            vibeEntity.setBackgroundMusicIndex(vibeModel.backgroundMusicIndex)
            vibeEntity.setReceiverMobileNumber(vibeModel.to?.getMobileNumber())
            vibeEntity.setIsBackgroundMusicEnabled(vibeModel.isBackgroundMusicEnabled)
            vibeEntity.setIsPhotosPresent(vibeModel.isPhotosPresent)
            vibeEntity.setIsLetterPresent(vibeModel.isLetterPresent)
            
            if vibeModel.isLetterPresent {
                let letter = CacheLetterEntity()
                letter.setText(vibeModel.getLetter().text)
                letter.setBackground(vibeModel.getLetter().background!)
                vibeEntity.setLetter(letter)
            } else {
                vibeEntity.setLetter(nil)
            }
            
            if vibeModel.isPhotosPresent {
                let images = List<CachePhotoEntity>()
                let imagesFromVibeModel = vibeModel.getImages()
                for i in 0 ..< imagesFromVibeModel.count {
                    let image = CachePhotoEntity()
                    image.setCaption(imagesFromVibeModel[i].caption)
                    image.setLocalPath(imagesFromVibeModel[i].image!.saveImageToLibraryDirectory())
                    images.append(image)
                }
                if images.count == 0 {
                    vibeEntity.setIsPhotosPresent(false)
                }
                vibeEntity.setImages(images)
            } else {
                vibeEntity.setImages(nil)
            }
            realm.add(vibeEntity, update: true)
            return vibeEntity
        }
    }

    /// Adds the Random Public Vibe to Cache by creating its VibeComponentEntity.
    /// - Parameters:
    ///     - vibeModel: Vibe Model.
    func addRandomPublicVibeToCache(vibeModel: VibeModel) {
        do {
            let realm = try Realm()
            if let object = realm.object(ofType: PublicVibeTimeEntity.self, forPrimaryKey: UserDefaults.standard.string(forKey: DeviceConstants.USER_ID)!) {
                realm.beginWrite()
                _ = createVibeComponentEntityFromVibeModel(vibeComponentId: vibeModel.id, vibeModel: vibeModel, realm: realm)
                object.setLastPublicVibeId(publicVibeId: vibeModel.id)
                try realm.commitWrite()
            }
        } catch {
            print("error in realm: \(error)")
        }
    }

    /// Sets the Vibe Model from the VibeComponents of the Draft.
    /// - Parameters:
    ///     - draftId: Draft ID.
    ///     - completionHandler: Action to perform after the vibe model is ready.
    func setVibeModelFromDraftEntity(draftId: String, completionHandler: (VibeModel) -> Void) {
        var vibeModel = VibeModel()
        do {
            let realm = try Realm()
            if let result = realm.object(ofType: DraftEntity.self, forPrimaryKey: draftId) {
                if let vibeComponent = result.getVibeEntity() {
                    vibeModel = setVibeModelFromVibeComponentEntity(vibeComponent: vibeComponent)
                }
            }
        } catch {
            print("error in realm: \(error)")
        }
        completionHandler(vibeModel)
    }

    func getVibeModelForRandomPublicVibe(vibeId: String, completionHandler: (VibeModel) -> Void) {
        var vibeModel = VibeModel()
        do {
            let realm = try Realm()
            if let result = realm.object(ofType: VibeComponentEntity.self, forPrimaryKey: vibeId) {
                vibeModel = setVibeModelFromVibeComponentEntity(vibeComponent: result)
            }
        } catch {
            print("error in realm: \(error)")
        }
        completionHandler(vibeModel)
    }
    
    func setVibeModelFromVibeComponentEntity(vibeComponent: VibeComponentEntity) -> VibeModel {
        let vibeModel = VibeModel()
        vibeModel.setId(id: vibeComponent.getId() != nil ? vibeComponent.getId()! : "")
        vibeModel.setVibeName(name: vibeComponent.getVibeName() != nil ? vibeComponent.getVibeName()! : "")
        vibeModel.setSenderId(sender: vibeComponent.getSender() != nil ? vibeComponent.getSender()! : "")
        vibeModel.from?.setId(id: vibeComponent.getSender() != nil ? vibeComponent.getSender()! : "")
        vibeModel.setReceiverMobileNumber(mobileNumber: vibeComponent.getReceiverMobileNumber() != nil ? vibeComponent.getReceiverMobileNumber()! : "")
        vibeModel.setReceiverUsername(username: vibeComponent.getReceiverUsername() != nil ? vibeComponent.getReceiverUsername()! : "")
        vibeModel.setReceiverProfilePic(profilePic: vibeComponent.getReceiverProfilePic() != nil ? vibeComponent.getReceiverProfilePic()! : "")
        vibeModel.setCategory(category: vibeComponent.getCategory() != nil ? vibeComponent.getCategory()! : 0)
        vibeModel.setVibeType(type: vibeComponent.getType() != nil ? vibeComponent.getType()! : 0)
        vibeModel.setBackgroundMusicEnabled(isBackgroundMusicEnabled: vibeComponent.getIsBackgroundMusicEnabled() != nil ? vibeComponent.getIsBackgroundMusicEnabled()! : false)
        vibeModel.setAnonymous(isSenderAnonymous: vibeComponent.getIsSenderAnonymous() != nil ? vibeComponent.getIsSenderAnonymous()! : false)
        vibeModel.setPhotosPresent(isPhotosPresent: vibeComponent.getIsPhotosPresent() != nil ? vibeComponent.getIsPhotosPresent()! : false)
        vibeModel.setLetterPresent(isLetterPresent: vibeComponent.getIsLetterPresent() != nil ? vibeComponent.getIsLetterPresent()! : false)
        vibeModel.setBackgroundMusic(index: vibeComponent.getBackgroundMusicIndex() != nil ? vibeComponent.getBackgroundMusicIndex()! : 0)
        vibeModel.setImageBackdrop(backdrop: vibeComponent.getImageBackdrop() != nil ? vibeComponent.getImageBackdrop()! : 0)
        vibeModel.setLetterText(letterString: (vibeComponent.getLetter() != nil && vibeComponent.getLetter()!.getText() != nil) ? vibeComponent.getLetter()!.getText()! : "")
        vibeModel.setLetterBackground(background: (vibeComponent.getLetter() != nil) ? vibeComponent.getLetter()!.getBackground() : 0)
        if vibeComponent.isPhotosPresent {
            if let images = vibeComponent.getImages() {
                var allModelPhotos = [PhotoEntity]()
                for i in 0 ..< images.count {
                    var modelPhoto = PhotoEntity()
                    if let urlString = images[i].localPath {
                        let imageUrl = URL(fileURLWithPath: NSHomeDirectory().appending(urlString))
                        do {
                            let image = try Data(contentsOf: imageUrl)
                            modelPhoto.image = UIImage(data: image)
                            modelPhoto.caption = images[i].caption
                            allModelPhotos.append(modelPhoto)
                        } catch {
                            print("cannot convert the image: \(error)")
                        }
                    }
                }
                vibeModel.setImages(photos: allModelPhotos)
                if allModelPhotos.count == 0 {
                    vibeModel.setPhotosPresent(isPhotosPresent: false)
                }
            } else {
                vibeModel.setPhotosPresent(isPhotosPresent: false)
            }
        }
        return vibeModel
    }

    func clearLastPublicVibe() {
        do {
            let realm = try Realm()
            if let userId = UserDefaults.standard.string(forKey: DeviceConstants.USER_ID) {
                if let object = realm.object(ofType: PublicVibeTimeEntity.self, forPrimaryKey: userId) {
                    realm.beginWrite()
                    if let vibe = realm.object(ofType: VibeComponentEntity.self, forPrimaryKey: object.getLastPublicVibeId()) {
                        if vibe.getSender()! != UserDefaults.standard.string(forKey: DeviceConstants.USER_ID)! {
                            if vibe.getLetter() != nil {
                                realm.delete(vibe.getLetter()!)
                            }
                            if vibe.getImages() != nil && vibe.getImages()!.count > 0 {
                                for image in vibe.getImages()! {
                                    realm.delete(image)
                                }
                            }
                            realm.delete(vibe)
                        }
                    }
                    object.setLastPublicVibeId(publicVibeId: nil)
                    try realm.commitWrite()
                }
            }
        } catch {
            print("Error in realm: \(error)")
        }
    }

    /// Clears all the data from the default Realm Cache.
    func clearCache() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("error in realm: \(error)")
        }
    }
}
