//
//  VibeDataEntity.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 16/12/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import Foundation
import RealmSwift

class VibeDataEntity: Object {

    @objc dynamic private var id: String?
    @objc dynamic private var version: String?
    @objc dynamic private var updatedTime: Int = 0
    @objc dynamic private var vibeTypeGsiPK: String?
    @objc dynamic private var vibeTypeTagGsiPK: String?
    @objc dynamic private var vibeName: String?
    @objc dynamic private var isSender: Bool = false
    @objc dynamic private var isAnonymous: Bool = false
    @objc dynamic private var isSeen: Bool = false
    @objc dynamic private var reach: Int = 0
    @objc dynamic private var profileId: String?
    @objc dynamic private var hails: [HailsEntity]?
    
    /// MARK: - Getters Start.
    
    public func getId() -> String? {
        return id
    }

    public func getVersion() -> String? {
        return version
    }

    public func getUpdatedTime() -> Int {
        return updatedTime
    }

    public func getVibeName() -> String? {
        return vibeName
    }

    public func getIsSender() -> Bool {
        return isSender
    }
    
    public func getIsAnonymous() -> Bool {
        return isAnonymous
    }

    public func getIsSeen() -> Bool {
        return isSeen
    }

    public func getReach() -> Int {
        return reach
    }

    public func getProfileId() -> String? {
        return profileId
    }

    public func getVibeTypeGsiPK() -> String? {
        return vibeTypeGsiPK
    }

    public func getVibeTypeTagGsiPK() -> String? {
        return vibeTypeTagGsiPK
    }

    public func getAllHails() -> [HailsEntity]? {
        return hails
    }
    
    /// MARK: - Getters End.
    
    /// MARK: - Setters Start.
    
    public func setVibeId(_ id: String?) {
        self.id = id
    }

    public func setVersion(_ version: String?) {
        self.version = version
    }

    public func setUpdatedTime(_ updatedTime: Int) {
        self.updatedTime = updatedTime
    }

    public func setVibeName(_ vibeName: String?) {
        self.vibeName = vibeName
    }

    public func setIsSender(_ isSender: Bool) {
        self.isSender = isSender
    }

    public func setIsSeen(_ isSeen: Bool) {
        self.isSeen = isSeen
    }

    public func setIsAnonymous(_ isAnonymous: Bool) {
        self.isAnonymous = isAnonymous
    }

    public func setReach(_ reach: Int) {
        self.reach = reach
    }

    public func setProfileId(_ profileId: String?) {
        self.profileId = profileId
    }

    public func setVibeTypeGsiPK(_ gsiPK: String?) {
        self.vibeTypeGsiPK = gsiPK
    }

    public func setVibeTypeTagGsiPK(_ gsiPK: String?) {
        self.vibeTypeTagGsiPK = gsiPK
    }
    
    public func setHails(hails: [HailsEntity]) {
        self.hails = hails
    }

    // MARK: - Setters End.

    /// Increments the reach of the Vibe by the Number.
    /// - Parameters:
    ///     - incrementBy - Number by which the reach needs to be incremented.
    public func incrementReach(incrementBy: Int) {
        self.reach = self.reach + incrementBy
    }

    /// Adds a single hail to the vibe.
    /// - Parameters:
    ///     - hail: Hail.
    public func addHailToVibe(hail: HailsEntity) {
        if self.hails == nil {
            self.hails = [HailsEntity]()
        }
        self.hails?.append(hail)
    }

    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["vibeTypeGsiPK", "vibeTypeTagGsiPK"]
    }
}
