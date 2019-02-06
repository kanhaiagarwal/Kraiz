//
//  AppUtilities.swift
//  Kraiz
//
//  Created by Kumar Agarwal, Kanhai on 22/08/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import Foundation
import TTGSnackbar
import Photos
import Reachability
import RealmSwift
import AWSAppSync

public class APPUtilites {
    /// Displays an elevated Error Snackbar for the message.
    /// - Parameters:
    ///     - message: Message to be displayed in the snackbar.
    public static func displayElevatedErrorSnackbar(message: String) {
        let errorBar = TTGSnackbar()
        errorBar.message = message
        errorBar.backgroundColor = UIColor.red
        errorBar.messageTextAlign = .center
        errorBar.duration = .short
        errorBar.bottomMargin = 50.0
        errorBar.show()
    }
    
    /// Displays an Error Snackbar for the message.
    /// - Parameters:
    ///     - message: Message to be displayed in the snackbar.
    public static func displayErrorSnackbar(message: String) {
        let errorBar = TTGSnackbar()
        errorBar.message = message
        errorBar.backgroundColor = UIColor.red
        errorBar.messageTextAlign = .center
        errorBar.duration = .short
        errorBar.show()
    }
    
    /// Displays an elevated Error Snacbar for the message with a long duration
    /// - Parameters:
    ///     - message: Message to be displayed in the snackbar.
    public static func displayElevatedErrorSnackbarForLongDuration(message: String) {
        let errorBar = TTGSnackbar()
        errorBar.message = message
        errorBar.backgroundColor = UIColor.red
        errorBar.messageTextAlign = .center
        errorBar.duration = .middle
        errorBar.bottomMargin = 50.0
        errorBar.show()
    }

    /// Displays an elevated Error Snacbar for the message with a long duration
    /// - Parameters:
    ///     - message: Message to be displayed in the snackbar.
    public static func displayErrorSnackbarForLongDuration(message: String) {
        let errorBar = TTGSnackbar()
        errorBar.message = message
        errorBar.backgroundColor = UIColor.red
        errorBar.messageTextAlign = .center
        errorBar.duration = .middle
        errorBar.show()
    }

    /// Displays an Elevated Success Snackbar for the message.
    /// - Parameters:
    ///     - message: Message to be displayed in the snackbar.
    public static func displayElevatedSuccessSnackbar(message: String) {
        let successBar = TTGSnackbar()
        successBar.message = message
        successBar.backgroundColor = UIColor(displayP3Red: 103/255, green: 186/255, blue: 38/255, alpha: 1.0)
        successBar.messageTextAlign = .center
        successBar.duration = .short
        successBar.bottomMargin = 50.0
        successBar.show()
    }

    /// Displays a Success Snackbar for the message.
    /// - Parameters:
    ///     - message: Message to be displayed in the snackbar.
    public static func displaySuccessSnackbar(message: String) {
        let successBar = TTGSnackbar()
        successBar.message = message
        successBar.backgroundColor = UIColor(displayP3Red: 103/255, green: 186/255, blue: 38/255, alpha: 1.0)
        successBar.messageTextAlign = .center
        successBar.duration = .short
        successBar.show()
    }

    /// Displays a Loading Activity Spinner on the view which comes as input. Returns the loading spinner view.
    /// - Parameters:
    ///     - onView: The view on which the loading spinner needs to be displayed.
    /// - Returns: Loading Spinner UIView.
    public static func displayLoadingSpinner(onView: UIView) -> UIView {
        let spinnerView = UIView(frame: onView.frame)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        spinnerView.addSubview(ai)
        onView.addSubview(spinnerView)
        
        return spinnerView
    }
    
    /// Removes the Loading Activity Spinner.
    /// - Parameters:
    ///     - spinner: Spinner
    public static func removeLoadingSpinner(spinner: UIView) {
        spinner.removeFromSuperview()
    }
    
    /// Inverses the Date for presentation purposes.
    /// - Parameters:
    ///     - inputDate: Date which needs to be inversed.
    /// - Returns: Inversed Date.
    public static func inverseDate(inputDate: String) -> String {
        let dateParts = inputDate.split(separator: "-")
        let newDate = dateParts[2] + "-" + dateParts[1] + "-" + dateParts[0]
        return newDate
    }
    
    /// Returns a UIImage from the PHAsset if it exists.
    /// - Parameters:
    ///     - asset: PHAsset of the Image.
    ///     - Returns: UIImage if it exists.
    public static func getUIImage(asset: PHAsset) -> UIImage? {
        var img: UIImage?
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = true
        manager.requestImageData(for: asset, options: options) { data, _, _, _ in
            
            if let data = data {
                img = UIImage(data: data)
            }
        }
        return img
    }
    
    /// Checks if the Internet Connection is available or not
    /// - Returns: Availability.
    public static func isInternetConnectionAvailable() -> Bool {
        let reachability = Reachability()
        if reachability?.connection == Reachability.Connection.none {
            return false
        }
        return true
    }
    
    /// Only alphanumeric and special characters like .-_@ are allowed.
    /// Special characters should not be present in the end.
    /// - Parameters:
    ///     - username: The username to be checked.
    /// - Returns: Valid or Not.
    public static func isUsernameValid(username: String) -> Bool {
        if username.count > 30 {
            return false
        }

        var isValid = true
        for ch in username {
            if (ch >= "a" && ch <= "z") || (ch >= "A" && ch <= "Z") || (ch >= "0" && ch <= "9") || ch == "@" || ch == "-" || ch == "." || ch == "_"  {
                isValid = true
            } else {
                isValid = false
                break
            }
        }
        return isValid
    }
    
    /// Gets the Vibe Image Ids as an GraphQL ID Array.
    /// - Parameters:
    ///     - images: Images.
    /// - Returns: Ids.
    public static func getVibeImageIds(images: [PhotoEntity]) -> [GraphQLID] {
        var ids = [GraphQLID]()
        for i in 0 ..< images.count {
            print("imageLink: \(images[i].imageLink!)")
            ids.append(images[i].imageLink != nil ? images[i].imageLink! : "null")
        }
        for i in 0 ..< ids.count {
            print("imageID: \(ids[i])")
        }
        return ids
    }
    
    /// Gets the Vibe Image Ids as an GraphQL ID Array.
    /// - Parameters:
    ///     - images: Images.
    /// - Returns: Ids.
    public static func getVibeImageCaptions(images: [PhotoEntity]) -> [String] {
        var captions = [String]()
        print("image captions")
        for i in 0 ..< images.count {
            if images[i].caption != nil {
                captions.append(images[i].caption!)
            } else {
                captions.append("NULL")
            }
        }
        return captions
    }
    
    /// Gets the file url for the fileName and the file type.
    /// - Parameters:
    ///     - fileName: Name of the file.
    ///     - type: File Type.
    /// - Returns: NSURL of the File.
    public static func getUrlForFileName(fileName: String, type: String) -> URL? {
        if Bundle.main.path(forResource: fileName, ofType: type) != nil {
            print("File exists")
        } else {
            print("No File exists")
            return nil
        }
        let path = Bundle.main.path(forResource: fileName, ofType: type)!
        return URL(fileURLWithPath: path)
    }

    /// Gets the date from the epoch time. The epoch time can be in seconds or milliseconds
    /// - Parameters:
    ///     - epochTime: Epoch Time.
    ///     - isTimeInMilliseconds - Is the time in milliseconds.
    public static func getDateFromEpochTime(epochTime: Int, isTimeInMiliseconds: Bool) -> String {
        let calendar = Calendar.current
        let date = Date(timeIntervalSince1970: TimeInterval(exactly: isTimeInMiliseconds ? (epochTime / 1000) : epochTime)!)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        if calendar.isDateInToday(date) {
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter.string(from: date)
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return dateFormatter.string(from: date)
        }
    }

    /// Gets the Vibe Index to query in the Cache.
    /// - Parameters:
    ///     - indexType: Index is vibeTypeGsiPK or vibeTypeTagGsiPK.
    ///     - vibeType: Vibe is PUBLIC or PRIVATE.
    ///     - vibeTag: Position of the Vibe Tag. Can be nil if indexType is vibeTypeGsiPK.
    public static func getVibeIndex(indexType: String, vibeType: String, vibeTag: Int?) -> String {
        let userId = UserDefaults.standard.string(forKey: DeviceConstants.USER_ID)!
        switch indexType {
        case "vibeType":
            return "\(userId)_\(vibeType)"
        case "vibeTypeTag":
            return "\(userId)_\(VibeCategories.TAG_INDEX[vibeTag!])_\(vibeType)"
        default: return ""
        }
    }

    public static func getAccessHashForBidirectional(key1: String, key2: String) -> String {
        return key1 < key2 ? (key1 + "#" + key2).sha1 : (key2 + "#" + key1).sha1
    }
    
    public static func getAccessHashForAnonymous(key: String) -> String {
        return (key + "_a").sha1
    }

    /// Get the Vibe Tag from the vibeTypeTag.
    /// - Parameters:
    ///     - vibeTypeTag: The vibeTagType index of the vibe.
    public static func getVibeTag(vibeTypeTag: String) -> String {
        let splitStrings = vibeTypeTag.split(separator: "_")
        return String(splitStrings[1])
    }

    public static func getVibeModelForDemoVibe(vibeTag: Int, viewHeight: CGFloat) -> VibeModel {
        print("viewHeight: \(viewHeight)")
        let vibe = VibeModel()
        vibe.backgroundMusicIndex = 4
        vibe.category = vibeTag
        vibe.imageBackdrop = 0
        vibe.isBackgroundMusicEnabled = true
        vibe.isLetterPresent = true
        vibe.isPhotosPresent = true
        switch viewHeight {
            case DeviceConstants.IPHONEX_HEIGHT: vibe.setLetterText(letterString: "\n \n Please curl from right to left. \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \nTap anywhere on the screen and press the next arrow at the top right.")
                break
            case DeviceConstants.IPHONEXR_HEIGHT: vibe.setLetterText(letterString: "\n \n Please curl from right to left. \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \nTap anywhere on the screen and press the next arrow at the top right..")
                break
            case DeviceConstants.IPHONE7PLUS_HEIGHT: vibe.setLetterText(letterString: "\n \n Please curl from right to left. \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \nTap anywhere on the screen and press the next arrow at the top right.")
                break
            case DeviceConstants.IPHONE7_HEIGHT: vibe.setLetterText(letterString: "\n \n Please curl from right to left. \n \n \n \n \n \n \n \n \n \nTap anywhere on the screen and press the next arrow at the top right.")
                break
        default: vibe.setLetterText(letterString: "\n \n Please curl from right to left. \n \n \n \n \n \n \n \n \n \n \n \n \n \nTap anywhere on the screen and press the next arrow at the top right.")
        }
        vibe.setLetterBackground(background: 0)
        vibe.setVibeName(name: "Hello. This is a Sample Love Vibe")

        var photos = [PhotoEntity]()
        var photoNames = ["demo-image-1", "demo-image-2", "demo-image-3"]
        var captions = ["This area is to give a cool caption to the image.", "Captions give a different essence to the image.", ""]
        for i in 0 ..< 3 {
            var photo = PhotoEntity()
            photo.image = UIImage(named: photoNames[i])
            photo.caption = captions[i]
            photos.append(photo)
        }
        vibe.setImages(photos: photos)
        return vibe
    }

    static func getRemoteConfigKey() -> String? {
        if let userId = UserDefaults.standard.string(forKey: DeviceConstants.USER_ID) {
            var key = "Kraiz"
            for i in userId.utf8 {
                key.append(String(i))
            }
            return key
        }
        return nil
    }

    static func getCacheEntityForDemoVibe() -> VibeDataEntity {
        let vibeEntity = VibeDataEntity()
        vibeEntity.setReach(0)
        vibeEntity.setIsSeen(true)
        vibeEntity.setVibeId(DeviceConstants.DEMO_VIBE_ID)
        vibeEntity.setVersion(1)
        vibeEntity.setIsSender(false)
        vibeEntity.setVibeName("Hello. This is a Sample Love Vibe")
        vibeEntity.setCreatedAt(0)
        vibeEntity.setProfileId("demoProfile")
        vibeEntity.setHails(hails: List<HailsEntity>())
        vibeEntity.setIsAnonymous(false)
        vibeEntity.setUpdatedTime(0)
        vibeEntity.setVibeTypeGsiPK(getVibeIndex(indexType: "vibeType", vibeType: VibeType.private.rawValue, vibeTag: nil))
        vibeEntity.setVibeTypeTagGsiPK(getVibeIndex(indexType: "vibeTypeTag", vibeType: VibeType.private.rawValue, vibeTag: 0))
        vibeEntity.setIsDownloadInProgress(false)
        return vibeEntity
    }
}

extension Date {
    func asString(style: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self)
    }
}

extension String {
    
    var sha1: String {
        guard let data = data(using: .utf8, allowLossyConversion: false) else {
            return ""
        }
        return data.digestSHA1.hexString
    }
    
}

fileprivate extension Data {
    
    var digestSHA1: Data {
        var bytes: [UInt8] = Array(repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        
        withUnsafeBytes {
            _ = CC_SHA1($0, CC_LONG(count), &bytes)
        }
        
        return Data(bytes: bytes)
    }
    
    var hexString: String {
        return map { String(format: "%02x", UInt8($0)) }.joined()
    }
    
}
