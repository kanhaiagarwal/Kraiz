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
    
    init() {
        image = nil
        caption = nil
        imageLink = nil
    }
    
    init(image: UIImage) {
        self.image = image
        self.caption = nil
        self.imageLink = nil
    }
    
    init(image: UIImage, caption: String) {
        self.image = image
        self.caption = caption
    }
    
    init(image: UIImage, caption: String, link: String) {
        self.image = image
        self.caption = caption
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

public enum VibeComponentTemplate {
    case LETTER_LOVE
    case LETTER_ROYAL
    case LETTER_PARCHMENT
    case LETTER_BASIC
    case LETTER_DREAMY
}
