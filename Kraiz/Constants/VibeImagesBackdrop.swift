
//
//  VibeImagesBackdrop.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 10/12/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import Foundation

public class VibeImagesBackdrop {
    public static let BACKDROPS = ["Polaroid", "Up Your Caption Game"]
    
    public static func getImagesBackdrop(index: Int) -> VibeComponentTemplate {
        switch(index) {
            case 0: return VibeComponentTemplate.polaroid
            case 1: return VibeComponentTemplate.upYourCaptionGame
            default: return VibeComponentTemplate.polaroid
        }
    }
    
    public static func getImagesBackdropIndex(template: VibeComponentTemplate) -> Int {
        switch(template) {
            case .polaroid: return 0
            case .upYourCaptionGame: return 1
            default: return 0
        }
    }

}
