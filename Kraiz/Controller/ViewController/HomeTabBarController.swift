//
//  HomeTabBarController.swift
//  StoryFi
//
//  Created by Kumar Agarwal, Kanhai on 30/06/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//
// Main Tab Bar Controller for the Home Page.

import UIKit
import AWSAppSync
import RxSwift

class HomeTabBarController: UITabBarController {

    let CREATE_VIBE_INDEX : Int = 2
    let PROFILE_SELECTED_INDEX : Int = 3

    var appSyncClient: AWSAppSyncClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.itemPositioning = .centered
        appSyncClient = AppSyncHelper.shared.getAppSyncClient()
        setTabBarSelection(isProfilePresent: UserDefaults.standard.bool(forKey: DeviceConstants.IS_PROFILE_PRESENT))
    }
    
    func setTabBarSelection(isProfilePresent: Bool) {
        if isProfilePresent {
            self.selectedIndex = DeviceConstants.DEFAULT_SELECTED_INDEX
            self.addCreateVibeButton()
        } else {
            self.selectedIndex = PROFILE_SELECTED_INDEX
            self.tabBar.isHidden = true
        }
    }
}

extension UITabBarController {
    
    /// Create a Custom Button to be added in the centre.
    /// On pressing the button, we will open the CreateVibe.
    func addCreateVibeButton() {
        
        print("height: \(view.frame.height)")
        print("width: \(view.frame.width)")
        
        var createButton : UIButton = UIButton()
        let itemWidth = self.view.frame.width / 5
        let itemHeight = self.tabBar.frame.height
        
        if self.view.frame.height == DeviceConstants.IPHONEX_HEIGHT {
            createButton = UIButton(frame: CGRect(x: itemWidth * 2 + 5, y: self.tabBar.frame.origin.y - (self.tabBar.frame.height / 2), width: itemWidth - 10, height: itemHeight - 10))
        } else if self.view.frame.height == DeviceConstants.IPHONEXR_HEIGHT {
            createButton = UIButton(frame: CGRect(x: itemWidth * 2 + 5, y: self.tabBar.frame.origin.y - (self.tabBar.frame.height / 2) - 5, width: itemWidth - 10, height: itemHeight - 10))
        }else {
            createButton = UIButton(frame: CGRect(x: itemWidth * 2 + 5, y: self.tabBar.frame.origin.y + 5, width: itemWidth - 10, height: itemHeight - 10))
        }
        
        createButton.setBackgroundImage(UIImage(named: "CreateButton"), for: .normal)
        createButton.adjustsImageWhenHighlighted = false
        createButton.addTarget(self, action: #selector(self.onClickCreateButton), for: .touchUpInside)
        self.view.addSubview(createButton)
    }
    
    // Goto the create story view controller
    @objc func onClickCreateButton() {
        if !APPUtilites.isInternetConnectionAvailable() {
            APPUtilites.displayElevatedErrorSnackbar(message: "Please check your Internet Connection")
        } else {
            performSegue(withIdentifier: DeviceConstants.GOTO_VIBE_DETAILS_FROM_HOME_SEGUE, sender: self)
        }
    }
}
