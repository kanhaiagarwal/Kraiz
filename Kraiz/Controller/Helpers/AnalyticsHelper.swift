//
//  AnalyticsHelper.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 15/01/19.
//  Copyright © 2019 Kumar Agarwal, Kanhai. All rights reserved.
//

import Foundation
import FirebaseAnalytics

public class AnalyticsHelper {
    static let shared = AnalyticsHelper()

    private init() {}

    /// Log the event when the user has sent the vibe.
    /// - Parameters:
    ///     - vibeModel: Vibe Model.
    ///     - hasPreviewed: Has the user Previewed the vibe even once before sending it.
    public func logCreateVibeEvent(vibeModel: VibeModel, hasPreviewed: Bool) {
        var params = [String : Any]()
        params[AnalyticsConstants.VIBE_COUNT] = 1
        params[AnalyticsConstants.PREVIEWED] = hasPreviewed ? 1 : 0
        params[VibeTypesLocal.getVibeType(index: vibeModel.type).rawValue.lowercased()] = 1
        params["\(AnalyticsConstants.TAG)\(VibeCategories.getVibeTag(index: vibeModel.category).rawValue.lowercased())"] = 1
        params[AnalyticsConstants.VIBE_NAME_CHARACTER_COUNT] = vibeModel.vibeName.count

        if vibeModel.isBackgroundMusicEnabled {
            params[BackgroundMusic.musicList[vibeModel.backgroundMusicIndex].lowercased()] = 1
        }

        if vibeModel.isLetterPresent {
            params["\(AnalyticsConstants.LETTER_TEMPLATE)\(VibeTextBackgrounds.getLetterTemplate(index: vibeModel.getLetter().background!).rawValue.lowercased())"] = 1
            params[AnalyticsConstants.LETTER_CHARACTER_COUNT] = vibeModel.getLetter().text!.count
        }

        if vibeModel.isPhotosPresent {
            params["\(AnalyticsConstants.IMAGE_TEMPLATE)\(VibeImagesBackdrop.getImagesBackdrop(index: vibeModel.imageBackdrop).rawValue.lowercased())"] = 1
            params[AnalyticsConstants.IMAGE_COUNT] = vibeModel.getImages().count

            var captionsCount = 0
            var maxCaptionSize = 0

            for entity in vibeModel.getImages() {
                if let caption = entity.caption {
                    captionsCount = captionsCount + 1
                    if caption.count > maxCaptionSize {
                        maxCaptionSize = caption.count
                    }
                }
            }

            params[AnalyticsConstants.MAX_IMAGE_CAPTION_SIZE] = maxCaptionSize
            params[AnalyticsConstants.IMAGE_CAPTIONS_COUNT] = captionsCount
        }

        Analytics.logEvent(AnalyticsEvents.VIBE_CREATION.rawValue.lowercased(), parameters: params)
    }

    /// Logs the send hail event.
    /// - Parameters:
    ///     - vibeModel: Vibe Model.
    ///     - hailText: Hail Text.
    func logSendHailEvent(vibeModel: VibeModel, hailText: String) {
        var params = [String : Any]()

        params[AnalyticsConstants.HAIL_COUNT] = 1
        params[VibeTypesLocal.getVibeType(index: vibeModel.type).rawValue.lowercased()] = 1
        params["\(AnalyticsConstants.TAG)\(VibeCategories.getVibeTag(index: vibeModel.category).rawValue.lowercased())"] = 1
        params[AnalyticsConstants.HAIL_CHARACTER_COUNT] = hailText.count

        Analytics.logEvent(AnalyticsEvents.HAILS.rawValue, parameters: params)
    }

    /// Logs the events related to the Random Public Vibe Activity of the User.
    /// - Parameters:
    ///     - action: Action performed by the user to see the random public vibe.
    ///     - tag: (Optional) The tag chosen by the user. This is not nil if the action is TAG_CHOSEN.
    func logRandomPublicVibeEvent(action: RandomPublicVibeActions, tag: Int?) {
        var params = [String : Any]()
        switch action {
            case .READY_BUTTON_CLICKED:
                params[action.rawValue.lowercased()] = 1
                break
            case .SEEN:
                params[action.rawValue.lowercased()] = 1
                break
            case .TAG_CHOSEN:
                params[VibeCategories.getVibeTag(index: tag!).rawValue.lowercased()] = 1
                break
        }

        Analytics.logEvent(AnalyticsEvents.RANDOM_PUBLIC_VIBES.rawValue.lowercased(), parameters: params)
    }

    /// Logs the event when the user is seeing the vibe.
    /// The event will be logged only if the user is the receiver, and the user is seeing the vibe for the first time.
    /// - Parameters:
    ///     - vibeModel: Vibe Model.
    ///     - action: Action related to seeing the vibe.
    func logViewVibeEvent(vibeModel: VibeModel, action: ViewVibeActions) {
        var params = [String : Any]()

        if vibeModel.from?.getUsername()! == UserDefaults.standard.string(forKey: DeviceConstants.USER_NAME)! || CacheHelper.shared.getSeenStatusOfVibe(vibeId: vibeModel.id) {
            return
        }

        switch action {
            case .ADD_ALL:
                params[AnalyticsConstants.VIEW_VIBES_COUNT] = 1
                if vibeModel.isLetterPresent {
                    params[ViewVibeActions.LETTER_PAGE.rawValue.lowercased()] = 1
                }
                if vibeModel.isPhotosPresent {
                    params[ViewVibeActions.IMAGES_PAGE.rawValue.lowercased()] = 1
                }
                params[ViewVibeActions.HAILS_VIBE.rawValue.lowercased()] = 1
                break
            case .LETTER_PAGE:
                params[ViewVibeActions.LETTER_PAGE.rawValue.lowercased()] = -1
                break
            case .IMAGES_PAGE:
                params[ViewVibeActions.IMAGES_PAGE.rawValue.lowercased()] = -1
                break
            case .HAILS_VIBE:
                params[ViewVibeActions.HAILS_VIBE.rawValue.lowercased()] = -1
                break
        }
        Analytics.logEvent(AnalyticsEvents.VIEW_VIBES.rawValue.lowercased(), parameters: params)
    }

    /// Logs the Save Vibe Event.
    public func logSaveVibeEvent() {
        var params = [String : Any]()

        params[AnalyticsConstants.SAVED_COUNT] = 1
        Analytics.logEvent(AnalyticsEvents.SAVED.rawValue.lowercased(), parameters: params)
    }
}
