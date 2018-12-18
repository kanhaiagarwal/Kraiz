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
        
        let range = NSRange(location: 0, length: username.utf16.count)
        let regex = try! NSRegularExpression(pattern: "([A-Za-z0-9\\@\\-\\_\\.])*(?<![.@_-])$", options: .allowCommentsAndWhitespace)
        let matches = regex.firstMatch(in: username, options: [], range: range)
        if matches != nil {
            return true
        }
        return false
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

    public static func getDateFromEpochTime(epochTime: Int) -> String {
        let calendar = Calendar.current
        let date = Date(timeIntervalSince1970: TimeInterval(exactly: epochTime / 1000)!)
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
