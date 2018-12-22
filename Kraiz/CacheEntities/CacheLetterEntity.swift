//
//  CacheLetterEntity.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 22/12/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import Foundation
import RealmSwift

class CacheLetterEntity: Object {
    @objc dynamic var text: String?
    @objc dynamic var background: Int = 0

    /// MARK: - Getters Start.

    public func getText() -> String? {
        return self.text
    }

    public func getBackground() -> Int {
        return self.background
    }

    /// MARK: - Getters End.
    
    /// MARK: - Setters Start.

    public func setText(_ text: String?) {
        self.text = text
    }

    public func setBackground(_ background: Int) {
        self.background = background
    }

    /// MARK: - Setters End.
}
