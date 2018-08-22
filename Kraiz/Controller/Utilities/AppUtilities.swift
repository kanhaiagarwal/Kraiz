//
//  AppUtilities.swift
//  Kraiz
//
//  Created by Kumar Agarwal, Kanhai on 22/08/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import Foundation
import TTGSnackbar

public class APPUtilites {
    public static func displayErrorSnackbar(message: String) {
        let errorBar = TTGSnackbar()
        errorBar.message = message
        errorBar.backgroundColor = UIColor.red
        errorBar.messageTextAlign = .center
        errorBar.duration = .middle
        errorBar.show()
    }
    
    public static func displaySuccessSnackbar(message: String) {
        let errorBar = TTGSnackbar()
        errorBar.message = message
        errorBar.backgroundColor = UIColor(displayP3Red: 103/255, green: 186/255, blue: 38/255, alpha: 1.0)
        errorBar.messageTextAlign = .center
        errorBar.duration = .middle
        errorBar.show()
    }
}
