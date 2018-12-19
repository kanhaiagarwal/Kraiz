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
    ///     - object: Profile Object
    func writeProfileToCache(_ object: ProfileEntity) {
        do {
            let realm = try Realm()
            let result = realm.object(ofType: ProfileEntity.self, forPrimaryKey: object.getId()!)
            try realm.write {
                if result == nil {
                    realm.add(object)
                } else {
                    realm.add(object, update: true)
                }
            }
        } catch {
            print("Could not write profile to the cache: \(error)")
        }
    }

    /// Writes the Vibe to Cache.
    /// - Parameters:
    ///     - object: VibeData object
    func writeVibeToCache(_ object: VibeDataEntity) {
        do {
            let realm = try Realm()
            let result = realm.object(ofType: VibeDataEntity.self, forPrimaryKey: object.getId()!)
            try realm.write {
                if result == nil {
                    realm.add(object)
                } else {
                    realm.add(object, update: true)
                }
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
            let result = realm.object(ofType: HailsEntity.self, forPrimaryKey: object.getId())
            try realm.write {
                if result == nil {
                    realm.add(object)
                } else {
                    realm.add(object, update: true)
                }
            }
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
}
