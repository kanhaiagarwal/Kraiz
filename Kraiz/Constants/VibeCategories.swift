//
//  VibeCategories.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 20/11/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import Foundation
import UIKit

public enum IndexType {
    case VibeType
    case VibeTypeTag
    
    public static func getIndexType(index: IndexType) -> String {
        switch index {
            case .VibeType:
                    return "vibeType"
            case .VibeTypeTag:
                    return "vibeTypeTag"
            default: return "vibeType"
        }
    }
}

public class VibeCategories {
    static public let pickerStrings = ["Love", "Travel", "Good", "Party", "Nostalgic", "Occasion"]
    static public let categoryImages : [String] = ["LoveVibes", "TravelVibes", "GoodVibes", "PartyVibes", "NostalgicVibes", "OccasionVibes"]
    static public let categoryBackground = ["background-love-vibe", "background-travel-vibe", "background-good-vibe", "background-party-vibe", "background-nostalgia-vibe", "background-occasion-vibe"]
    static public let vibeColors : [UIColor] = [UIColor(displayP3Red: 187/255, green: 10/255, blue: 30/255, alpha: 1.0), UIColor(displayP3Red: 0/255, green: 114/255, blue: 54/255, alpha: 1.0), UIColor(displayP3Red: 68/255, green: 140/255, blue: 203/255, alpha: 1.0), UIColor(displayP3Red: 78/255, green: 46/255, blue: 40/255, alpha: 1.0), UIColor(displayP3Red: 240/255, green: 126/255, blue: 7/255, alpha: 1.0), UIColor(displayP3Red: 46/255, green: 66/255, blue: 100/255, alpha: 1.0)]
    static public let UNHIGHLIGHTED_VIBE_COLOR = UIColor(displayP3Red: 149/255, green: 149/255, blue: 149/255, alpha: 1.0)
    
    static public let TAG_INDEX = ["LOVE", "TRAVEL", "GOOD", "PARTY", "NOSTALGIC", "OCCASION"]
    static public let TYPE_INDEX = ["PRIVATE", "PUBLIC"]
    
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

    static public func getVibeCategoryImage(vibeCategory: String) -> String {
        switch vibeCategory {
            case "LOVE": return categoryImages[0]
            case "TRAVEL": return categoryImages[1]
            case "GOOD": return categoryImages[2]
            case "PARTY": return categoryImages[3]
            case "NOSTALGIC": return categoryImages[4]
            case "OCCASION": return categoryImages[5]
            default: return categoryImages[0]
        }
    }
    
    static public func getVibeCategoryColor(vibeCategory: String) -> UIColor {
        switch vibeCategory {
            case "LOVE": return vibeColors[0]
            case "TRAVEL": return vibeColors[1]
            case "GOOD": return vibeColors[2]
            case "PARTY": return vibeColors[3]
            case "NOSTALGIC": return vibeColors[4]
            case "OCCASION": return vibeColors[5]
            default: return vibeColors[0]
        }
    }

    static public func getVibeCategoryDisplayName(vibeCategory: String) -> String {
        switch vibeCategory {
            case "LOVE": return pickerStrings[0]
            case "TRAVEL": return pickerStrings[1]
            case "GOOD": return pickerStrings[2]
            case "PARTY": return pickerStrings[3]
            case "NOSTALGIC": return pickerStrings[4]
            case "OCCASION": return pickerStrings[5]
            default: return pickerStrings[0]
        }
    }
}
