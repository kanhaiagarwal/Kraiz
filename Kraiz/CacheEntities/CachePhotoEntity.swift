//
//  CachePhotoEntity.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 22/12/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import Foundation
import RealmSwift

class CachePhotoEntity: Object {
    @objc dynamic var caption: String?
    @objc dynamic var imageLink: String?
    @objc dynamic var localPath: String?

    /// MARK: - Getters Start.

    public func getCaption() -> String? {
        return self.caption
    }

    public func getImageLink() -> String? {
        return self.imageLink
    }

    public func getLocalPath() -> String? {
        return self.localPath
    }

    /// MARK: - Getters End.
    
    /// MARK: - Setters Start.

    public func setCaption(_ caption: String?) {
        self.caption = caption
    }

    public func setImageLink(_ link: String?) {
        self.imageLink = link
    }

    public func setLocalPath(_ path: String?) {
        self.localPath = path
    }

    /// MARK: - Setters End.
}
