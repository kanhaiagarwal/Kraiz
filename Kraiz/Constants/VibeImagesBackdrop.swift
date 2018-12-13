
//
//  VibeImagesBackdrop.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 10/12/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import Foundation

public class VibeImagesBackdrop {
    public static let BACKDROPS = ["Polaroid", "Tuner"]
    
    public static func getImagesBackdrop(index: Int) -> VibeComponentTemplate {
        switch(index) {
            case 0: return VibeComponentTemplate.polaroid
            case 1: return VibeComponentTemplate.tuner
            default: return VibeComponentTemplate.polaroid
        }
        return VibeComponentTemplate.polaroid
    }
}
