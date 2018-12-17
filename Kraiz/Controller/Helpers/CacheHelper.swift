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

    func getVibesByIndex(index: String) -> Results<VibeDataEntity>? {
        do {
            let realm = try Realm()
            print(Realm.Configuration.defaultConfiguration.fileURL ?? "No File Url")
            let results = realm.objects(VibeDataEntity.self).filter("gsiPK == '\(index)'").sorted(byKeyPath: "updatedTime", ascending: false)
            return results
        } catch {
            print("error in realm: \(error)")
        }
        return nil
    }

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
