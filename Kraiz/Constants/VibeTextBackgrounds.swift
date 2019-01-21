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
    public static let TEXT_FONTS = ["Gemelli", "Dancing Script", "Mordred", "Times New Roman", "Hero"]
    public static let FONT_COLORS = [UIColor.black.withAlphaComponent(0.8),
                                                                  UIColor(displayP3Red: 216/255, green: 149/255, blue: 70/255, alpha: 1.0),
                                                                  UIColor(displayP3Red: 94/255, green: 41/255, blue: 4/255, alpha: 1.0),
                                                                  UIColor.black.withAlphaComponent(0.8),
                                                                  UIColor.white]
    public static let FONT_ALPHAS = [0.8, 1.0, 1.0, 0.8, 1.0]
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

    public static func getletterTemplateIndexFromTemplate(template: VibeComponentTemplate) -> Int {
        switch template {
            case .love: return 0
            case .royal: return 1
            case .parchment: return 2
            case .basic: return 3
            case .dreamy: return 4
            default: return 3
        }
    }
}
