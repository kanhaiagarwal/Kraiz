//
//  Entity.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 22/11/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import Foundation
import UIKit

public struct PhotoEntity {
    var image: UIImage?
    var caption: String?
    var imageLink: String?
    var localPath: String?
    
    init() {
        image = nil
        caption = nil
        imageLink = nil
        localPath = nil
    }
    
    init(image: UIImage) {
        self.image = image
        self.caption = nil
        self.imageLink = nil
        self.localPath = nil
    }
    
    init(image: UIImage, caption: String) {
        self.image = image
        self.caption = caption
        self.localPath = nil
    }
    
    init(image: UIImage, caption: String, link: String) {
        self.image = image
        self.caption = caption
        self.imageLink = link
        self.localPath = nil
    }
}

public struct LetterEntity {
    var text: String?
    var background: Int?
    
    init() {
        text = nil
        background = nil
    }
}
