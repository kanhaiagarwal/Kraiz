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

public class APPUtilites {
    /// Displays an Error Snackbar for the message.
    /// - Parameters
    ///     - message: Message to be displayed in the snackbar.
    public static func displayErrorSnackbar(message: String) {
        let errorBar = TTGSnackbar()
        errorBar.message = message
        errorBar.backgroundColor = UIColor.red
        errorBar.messageTextAlign = .center
        errorBar.duration = .short
        errorBar.bottomMargin = 50.0
        errorBar.show()
    }
    
    /// Displays an Error Snacbar for the message with a long duration
    /// - Parameters
    ///     - message: Message to be displayed in the snackbar.
    public static func displayErrorSnackbarForLongDuration(message: String) {
        let errorBar = TTGSnackbar()
        errorBar.message = message
        errorBar.backgroundColor = UIColor.red
        errorBar.messageTextAlign = .center
        errorBar.duration = .middle
        errorBar.bottomMargin = 50.0
        errorBar.show()
    }
    
    /// Displays a Success Snackbar for the message.
    /// - Parameters
    ///     - message: Message to be displayed in the snackbar.
    public static func displaySuccessSnackbar(message: String) {
        let successBar = TTGSnackbar()
        successBar.message = message
        successBar.backgroundColor = UIColor(displayP3Red: 103/255, green: 186/255, blue: 38/255, alpha: 1.0)
        successBar.messageTextAlign = .center
        successBar.duration = .short
        successBar.bottomMargin = 50.0
        successBar.show()
    }
    
    public static func displayLoadingSpinner(onView: UIView) -> UIView {
        let spinnerView = UIView(frame: onView.frame)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        spinnerView.addSubview(ai)
        onView.addSubview(spinnerView)
        
        return spinnerView
    }
    
    public static func removeLoadingSpinner(spinner: UIView) {
        spinner.removeFromSuperview()
    }
    
    public static func inverseDate(inputDate: String) -> String {
        let dateParts = inputDate.split(separator: "-")
        let newDate = dateParts[2] + "-" + dateParts[1] + "-" + dateParts[0]
        return newDate
    }
    
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
    
    public static func isInternetConnectionAvailable() -> Bool {
        let reachability = Reachability()
        if reachability?.connection == Reachability.Connection.none {
            return false
        }
        return true
    }
    
    /// Only alphanumeric and special characters like .-_@ are allowed.
    /// Special characters should not be present in the end.
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
}

extension Date {
    func asString(style: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self)
    }
}
