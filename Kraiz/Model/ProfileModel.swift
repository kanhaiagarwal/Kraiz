//
//  ProfileModel.swift
//  Kraiz
//
//  Created by Kumar Agarwal, Kanhai on 10/09/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import Foundation

class ProfileModel {
    private var id: String?
    private var username: String?
    private var mobileNumber: String?
    private var name: String?
    private var gender: String?
    private var dob: String?
    private var profilePicId: String?
    
    public init() {
        id = nil
        username = nil
        mobileNumber = nil
        name = nil
        gender = nil
        dob = nil
        profilePicId = nil
    }
    
    public init(id: String? = nil, username: String? = nil, mobileNumber: String? = nil, name: String? = nil, gender: String? = nil, dob: String? = nil, profilePicId: String? = nil) {
        self.id = id
        self.username = username
        self.mobileNumber = mobileNumber
        self.name = name
        self.gender = gender
        self.dob = dob
        self.profilePicId = profilePicId
    }
    
    public func getId() -> String? {
        return self.id
    }
    
    public func setId(id: String?) {
        self.id = id
    }
    
    public func getUsername() -> String? {
        return self.username
    }
    
    public func setUsername(username: String?) {
        self.username = username
    }
    
    public func getMobileNumber() -> String? {
        return self.mobileNumber
    }
    
    public func setMobileNumber(mobileNumber: String?) {
        self.mobileNumber = mobileNumber
    }
    
    public func getName() -> String? {
        return self.name
    }
    
    public func setName(name: String?) {
        self.name = name
    }
    
    public func getGender() -> String? {
        return self.gender
    }
    
    public func setGender(gender: String?) {
        self.gender = gender
    }
    
    public func getDob() -> String? {
        return self.dob
    }
    
    public func setDob(dob: String?) {
        self.dob = dob
    }
    
    public func getProfilePicId() -> String? {
        return self.profilePicId
    }
    
    public func setProfilePicId(profilePicId: String?) {
        self.profilePicId = profilePicId
    }
}
