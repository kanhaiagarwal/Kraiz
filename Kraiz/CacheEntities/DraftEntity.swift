//
//  DraftEntity.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 22/12/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import Foundation
import RealmSwift

class DraftEntity: Object {
    @objc dynamic private var id: String?
    @objc dynamic private var lastUpdatedTime: Int = 0
    @objc dynamic private var vibeEntity: VibeComponentEntity?
    
    /// MARK: - Getters Start.
    public func getId() -> String? {
        return id
    }

    public func getlastUpdatedTime() -> Int {
        return lastUpdatedTime
    }

    public func getVibeEntity() -> VibeComponentEntity? {
        return vibeEntity
    }

    /// MARK: - Getters End.

    /// MARK: - Setters Start.

    public func setId(_ id: String) {
        self.id = id
    }

    public func setLastUpdatedTime(_ lastTime: Int) {
        self.lastUpdatedTime = lastTime
    }

    public func setVibeEntity(_ vibeEntity: VibeComponentEntity) {
        self.vibeEntity = vibeEntity
    }

    /// MARK: - Setters End.

    override static func primaryKey() -> String? {
        return "id"
    }
}
