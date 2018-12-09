//
//  VibeCategories.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 20/11/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import Foundation

public class VibeCategories {
    static public let pickerStrings = ["Love", "Travel", "Good", "Party", "Nostalgic", "Occasion"]
    
    public static func getVibeTag(index: Int) -> VibeTag {
        switch index {
            case 0: return VibeTag.love
            case 1: return VibeTag.travel
            case 2: return VibeTag.good
            case 3: return VibeTag.party
            case 4: return VibeTag.nostalgic
            case 5: return VibeTag.occasion
            default: return VibeTag.love
        }
    }
}
