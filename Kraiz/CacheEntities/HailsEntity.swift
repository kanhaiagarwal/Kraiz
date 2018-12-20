//
//  HailsEntity.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 18/12/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import Foundation
import RealmSwift

class HailsEntity: Object {
    @objc private dynamic var id : String = ""
    @objc private dynamic var comment :  String = ""
    @objc private dynamic var vibeId: String = ""
    @objc private dynamic var author: String = ""
    @objc private dynamic var createdAt: Int = 0

    // MARK:- Getters Start.

    public func getId() -> String {
        return id
    }

    public func getComment() -> String {
        return comment
    }

    public func getVibeId() -> String {
        return vibeId
    }

    public func getAuthor() -> String {
        return author
    }

    public func getCreatedAt() -> Int {
        return createdAt
    }

    // MARK :- Getters End.

    // MARK :- Setters Start.

    public func setId(id: String) {
        self.id = id
    }
    
    public func setComment(comment: String) {
        self.comment = comment
    }

    public func setVibeId(vibeId: String) {
        self.vibeId = vibeId
    }

    public func setAuthor(author: String) {
        self.author = author
    }

    public func setCreatedAt(createdAt: Int) {
        self.createdAt = createdAt
    }

    // MARK :- Setters End.

    override static func primaryKey() -> String? {
        return "id"
    }

    override static func indexedProperties() -> [String] {
        return ["vibeId", "author"]
    }
}
