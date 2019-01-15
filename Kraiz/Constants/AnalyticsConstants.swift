//
//  AnalyticsConstants.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 15/01/19.
//  Copyright © 2019 Kumar Agarwal, Kanhai. All rights reserved.
//

import Foundation

public enum AnalyticsEvents: String {
    case VIBE_CREATION, HAILS, RANDOM_PUBLIC_VIBES, VIEW_VIBES, SAVED
}

public enum RandomPublicVibeActions: String {
    case READY_BUTTON_CLICKED, TAG_CHOSEN, SEEN
}

public enum ViewVibeActions: String {
    case ADD_ALL, LETTER_PAGE, IMAGES_PAGE, HAILS_VIBE
}

public class AnalyticsConstants {

    /// Common Params.
    public static let EMPTY : String = ""
    public static let TAG : String = "tag_"
    public static let LETTER_TEMPLATE : String = "letter_template_"
    public static let IMAGE_TEMPLATE : String = "image_template_"

    /// Vibe Creation Params.
    public static let IMAGE_CAPTIONS_COUNT : String = "image_captions_count"
    public static let IMAGE_COUNT : String = "image_count"
    public static let LETTER_CHARACTER_COUNT : String = "letter_character_count"
    public static let MAX_IMAGE_CAPTION_SIZE : String = "max_image_caption_size"
    public static let PREVIEWED : String = "previewed"
    public static let VIBE_COUNT : String = "vibe_count"
    public static let VIBE_NAME_CHARACTER_COUNT : String = "vibe_name_character_count"

    /// Send Hails Params.
    public static let HAIL_COUNT : String = "hail_count"
    public static let HAIL_CHARACTER_COUNT : String = "hail_character_count"

    /// Vibe Views Params.
    public static let VIEW_VIBES_COUNT : String = "view_vibes_count"

    /// Saved Vibes Params.
    public static let SAVED_COUNT : String = "saved_count"
}
