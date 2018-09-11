//
//  ProfileModel.swift
//  Kraiz
//
//  Created by Kumar Agarwal, Kanhai on 10/09/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import Foundation

class ProfileModel {
    private var id: String
    private var username: String
    private var mobileNumber: String
    private var name: String
    private var gender: String
    private var dob: Date
    private var profilePicUrl: String
    
    public init() {
        id = ""
        username = ""
        mobileNumber = ""
        name = ""
        gender = ""
        dob = Date.init()
        profilePicUrl = ""
    }
    
    public init(id: String, username: String, mobileNumber: String, name: String, gender: String, dob: Date, profilePicUrl: String) {
        self.id = id
        self.username = username
        self.mobileNumber = mobileNumber
        self.name = name
        self.gender = gender
        self.dob = dob
        self.profilePicUrl = profilePicUrl
    }
    
    public func getId() -> String {
        return self.id
    }
    
    public func setId(id: String) {
        self.id = id
    }
    
    public func getUsername() -> String {
        return self.username
    }
    
    public func setUsername(username: String) {
        self.username = username
    }
    
    public func getMobileNumber() -> String {
        return self.mobileNumber
    }
    
    public func setMobileNumber(mobileNumber: String) {
        self.mobileNumber = mobileNumber
    }
    
    public func getName() -> String {
        return self.name
    }
    
    public func setName(name: String) {
        self.name = name
    }
    
    public func getGender() -> String {
        return self.gender
    }
    
    public func setGender(id: String) {
        self.id = id
    }
    
    public func getDob() -> Date {
        return self.dob
    }
    
    public func getProfilePicUrl() -> String {
        return self.profilePicUrl
    }
}
