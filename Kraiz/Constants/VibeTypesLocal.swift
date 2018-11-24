//
//  VibeTypesLocal.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 24/11/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import Foundation

public class VibeTypesLocal {
    static public let vibeTypes = ["Friends", "Public"]
    
    public static func getVibeType(index: Int) -> VibeType {
        switch index {
            case 0: return VibeType.private
            case 1: return VibeType.public
            default: return VibeType.private
        }
    }
}
