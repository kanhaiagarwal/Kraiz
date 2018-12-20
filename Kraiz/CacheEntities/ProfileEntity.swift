//
//  ProfileEntity.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 16/12/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class ProfileEntity: Object {

    @objc dynamic var id: String?
    @objc dynamic private var name: String?
    @objc dynamic private var username: String?
    @objc dynamic private var mobileNumber: String?
    @objc dynamic private var dob: String?
    @objc dynamic private var profilePicId: String?
    @objc dynamic private var gender: String?
    
    // MARK: - Getters Start.

    public func getId() -> String? {
        return id
    }

    public func getName() -> String? {
        return name
    }

    public func getUsername() -> String? {
        return username
    }

    public func getMobileNumber() -> String? {
        return mobileNumber
    }

    public func getDob() -> String? {
        return dob
    }

    public func getProfilePicId() -> String? {
        return profilePicId
    }

    public func getGender() -> String? {
        return gender
    }

    // MARK: - Getters End.

    // MARK: - Setters Start.

    public func setId(_ id: String?) {
        self.id = id
    }

    public func setName(_ name: String?) {
        self.name = name
    }

    public func setUsername(_ username: String?) {
        self.username = username
    }

    public func setMobileNumber(_ mobileNumber: String?) {
        self.mobileNumber = mobileNumber
    }

    public func setDob(_ dob: String?) {
        self.dob = dob
    }

    public func setProfilePicId(_ profilePicId: String?) {
        self.profilePicId = profilePicId
    }

    public func setGender(_ gender: String?) {
        self.gender = gender
    }

    // MARK: - Setters End.

    override static func primaryKey() -> String? {
        return "id"
    }
}
