//
//  LocalCache.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 21/10/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//
import RealmSwift

class LocalCache {
    static let shared = LocalCache()
    
    private init(){
    }
    
    func playWithRealm() {
        let realm = try! Realm()
        print(Realm.Configuration.defaultConfiguration.fileURL)
    }
}
