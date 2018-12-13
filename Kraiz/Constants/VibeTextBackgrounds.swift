//
//  VibeTextBackgrounds.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 02/12/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import Foundation
import UIKit

public class VibeTextBackgrounds {
    public static let TEXT_BACKGROUNDS = ["letter-love", "letter-royal", "letter-ancient", "letter-basic", "letter-starry"]
    public static let TEXT_FONTS = ["Monotype Corsiva", "Freestyle Script", "French Script MT", "French Script MT", "Hero"]
    public static let FONT_COLORS = [UIColor(displayP3Red: 0, green: 4/255, blue: 0, alpha: 1.0),
                                                                  UIColor(displayP3Red: 191/255, green: 134/255, blue: 52/255, alpha: 1.0),
                                                                  UIColor.black,
                                                                  UIColor(displayP3Red: 10/255, green: 9/255, blue: 22/255, alpha: 1.0),
                                                                  UIColor.white]
    public static func getLetterTemplate(index: Int) -> VibeComponentTemplate {
        switch index {
            case 0: return VibeComponentTemplate.love
            case 1: return VibeComponentTemplate.royal
            case 2: return VibeComponentTemplate.parchment
            case 3: return VibeComponentTemplate.basic
            case 4: return VibeComponentTemplate.dreamy
            default: return VibeComponentTemplate.basic
        }
        return VibeComponentTemplate.basic
    }
}
