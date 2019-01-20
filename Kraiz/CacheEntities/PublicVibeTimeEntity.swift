//
//  PublicVibeTimeEntity.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 19/12/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import Foundation
import RealmSwift

class PublicVibeTimeEntity: Object {
    @objc dynamic var userId: String?
    @objc dynamic var lastVibeAccessTime: Int = 0
    @objc dynamic var publicVibeSeen : Bool = false
    @objc dynamic var lastPublicVibeId : String?

    /// MARK :- Getters Start.
    func getUserId() -> String? {
        return userId
    }

    func getLastVibeAccessTime() -> Int {
        return lastVibeAccessTime
    }

    func getPublicVibeSeen() -> Bool {
        return publicVibeSeen
    }

    func getLastPublicVibeId() -> String? {
        return lastPublicVibeId
    }

    /// MARK :- Getters End.

    /// MARK :- Setters Start.
    func setUserId(id: String) {
        self.userId = id
    }

    func setLastVibeAccessTime(currentTime: Int) {
        self.lastVibeAccessTime = currentTime
    }

    func setPublicVibeSeen(publicVibeSeen: Bool) {
        self.publicVibeSeen = publicVibeSeen
    }

    func setLastPublicVibeId(publicVibeId: String?) {
        self.lastPublicVibeId = publicVibeId
    }

    /// MARK :- Setters End.

    override static func primaryKey() -> String? {
        return "userId"
    }
}
