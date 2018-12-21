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
        print("inside writeProfileToCache with id: \(object.getId()!)")
        do {
            let realm = try Realm()
            let result = realm.object(ofType: ProfileEntity.self, forPrimaryKey: object.getId()!)
            realm.beginWrite()
            realm.add(object, update: true)
//                if result == nil {
//                    realm.add(object)
//                } else {
//                    if result!.getId() != object.getId() {
//                        result!.setId(object.getId()!)
//                    }
//                    if result!.getDob() != object.getDob() {
//                        result!.setDob(object.getDob())
//                    }
//                    if result!.getName() != object.getName() {
//                        result!.setName(object.getName())
//                    }
//                    if result!.getGender() != object.getGender() {
//                        result!.setGender(object.getGender())
//                    }
//                    if result!.getUsername() != object.getUsername() {
//                        result!.setUsername(object.getUsername())
//                    }
//                    if result!.getMobileNumber() != object.getMobileNumber() {
//                        result!.setMobileNumber(object.getMobileNumber())
//                    }
//                    if result!.getProfilePicId() != object.getProfilePicId() {
//                        result!.setProfilePicId(object.getProfilePicId())
//                    }
//                }
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
        print("inside writeVibeToCache for vibeId: \(object.getId()!)")
        do {
            let realm = try Realm()
            let result = realm.object(ofType: VibeDataEntity.self, forPrimaryKey: object.getId()!)
            if result == nil || (result!.getVersion() < object.getVersion()) {
                realm.beginWrite()
                realm.add(object, update: true)
                try realm.commitWrite()
            }
//            if result != nil {
//                let cacheVersion = result!.getVersion()
//                if !checkVersion || (object.getVersion() > cacheVersion) {
//                    realm.beginWrite()
//                    if result!.getId() != object.getId() {
//                        result?.setVibeId(object.getId())
//                    }
//                    if result!.getHasNewHails() != object.getHasNewHails() {
//                        result?.setHasNewHails(hasNewHails: object.getHasNewHails())
//                    }
//                    if result!.getReach() != object.getReach() {
//                        result?.setReach(object.getReach())
//                    }
//                    if result!.getIsSeen() != object.getIsSeen() {
//                        result?.setIsSeen(object.getIsSeen())
//                    }
//                    result!.setVersion(object.getVersion())
//                    if result!.getIsSender() != object.getIsSender() {
//                        result!.setIsSender(object.getIsSender())
//                    }
//                    if result!.getVibeName() != object.getVibeName() {
//                        result?.setVibeName(object.getVibeName())
//                    }
//                    if result?.getCreatedAt() != object.getCreatedAt() {
//                        result?.setCreatedAt(object.getCreatedAt())
//                    }
//                    if result?.getProfileId() != object.getProfileId() {
//                        result?.setProfileId(object.getProfileId())
//                    }
//                    if result?.getIsAnonymous() != object.getIsAnonymous() {
//                        result?.setIsAnonymous(object.getIsAnonymous())
//                    }
//                    if result?.getUpdatedTime() != object.getUpdatedTime() {
//                        result?.setUpdatedTime(object.getUpdatedTime())
//                    }
//                    if result?.getVibeTypeGsiPK() != object.getVibeTypeGsiPK() {
//                        result?.setVibeTypeGsiPK(object.getVibeTypeGsiPK())
//                    }
//                    if result?.getVibeTypeTagGsiPK() != object.getVibeTypeTagGsiPK() {
//                        result?.setVibeTypeTagGsiPK(object.getVibeTypeTagGsiPK())
//                    }
//                    try realm.commitWrite()
//                }
//            } else {
//                realm.beginWrite()
//                if result == nil {
//                    realm.add(object)
//                } else {
//                    realm.add(object, update: true)
//                }
//                try realm.commitWrite()
//            }
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
//            if let result = realm.object(ofType: HailsEntity.self, forPrimaryKey: object.getId()) {
//                try realm.write {
//                    if result.getCreatedAt() != object.getCreatedAt() {
//                        result.setCreatedAt(createdAt: object.getCreatedAt())
//                    }
//                    if result.getId() != object.getId() {
//                        result.setId(id: object.getId())
//                    }
//                    if result.getAuthor() != object.getAuthor() {
//                        result.setAuthor(author: object.getAuthor())
//                    }
//                    if result.getVibeId() != object.getVibeId() {
//                        result.setVibeId(vibeId: object.getVibeId())
//                    }
//                    if result.getComment() != object.getComment() {
//                        result.setComment(comment: object.getComment())
//                    }
//                }
//            } else {
//                try realm.write {
//                    realm.add(object)
//                }
//            }
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

    /// Get all the Vibes of a particular index.
    /// - Parameters:
    ///     - index: Vibe Index.
    ///     - value: Index Value
    func getVibesByIndex(index: String, value: String) -> Results<VibeDataEntity>? {
        do {
            let realm = try Realm()
            print(Realm.Configuration.defaultConfiguration.fileURL ?? "No File Url")
            let results = realm.objects(VibeDataEntity.self).filter("\(index) == '\(value)'").sorted(byKeyPath: "createdAt", ascending: false)
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

    /// Returns the Seen status of the Vibe.
    /// - Parameters:
    ///     -vibe: Vibe Entity.
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
        print("vibeId inside getHailsCountForVibe: \(vibeId)")
        do {
            let realm = try Realm()
            let result = realm.object(ofType: VibeDataEntity.self, forPrimaryKey: vibeId)
            if result != nil {
                let hails = result!.getAllHails()
                print("hails inside getHailsCountForVibe for vibeId \(vibeId): \(hails)")
                return hails.count
            } else {
                return 0
            }
        } catch {
            print("error in realm: \(error)")
        }
        return 0
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
