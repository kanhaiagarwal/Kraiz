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
    
    public static func getVibeCategory(index: Int) -> VibeCategory {
        switch index {
            case 0: return VibeCategory.love
            case 1: return VibeCategory.travel
            case 2: return VibeCategory.good
            case 3: return VibeCategory.party
            case 4: return VibeCategory.nostalgic
            case 5: return VibeCategory.occassion
            default: return VibeCategory.love
        }
    }
}
