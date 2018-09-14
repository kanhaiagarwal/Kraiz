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
    let PROFILE_SELECTED_INDEX : Int = 0

    var appSyncClient: AWSAppSyncClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.itemPositioning = .centered
        appSyncClient = AppSyncHelper.shared.getAppSyncClient()
        let sv = APPUtilites.displayLoadingSpinner(onView: self.view)
        
        AppSyncHelper.shared.getUserProfile(userId: UserDefaults.standard.string(forKey: DeviceConstants.USER_ID)!, success: { (profile) in
            APPUtilites.removeLoadingSpinner(spinner: sv)
            var isProfilePresent = false
            if profile.getId() != nil {
                isProfilePresent = true
            }
            UserDefaults.standard.set(isProfilePresent, forKey: DeviceConstants.IS_PROFILE_PRESENT)
            self.setTabBarSelection(isProfilePresent: isProfilePresent)
        }) { (error) in
            APPUtilites.displayErrorSnackbar(message: error.userInfo["NSLocalizedDescription"] as! String)
            print("error: \(error.userInfo)")
        }
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
        
        var createButton : UIButton = UIButton()
        let itemWidth = self.view.frame.width / 5
        let itemHeight = self.tabBar.frame.height
        
        if self.view.frame.height == DeviceConstants.IPHONEX_HEIGHT {
            createButton = UIButton(frame: CGRect(x: itemWidth * 2 + 5, y: self.tabBar.frame.origin.y - (self.tabBar.frame.height / 2), width: itemWidth - 10, height: itemHeight - 10))
        } else {
            createButton = UIButton(frame: CGRect(x: itemWidth * 2 + 5, y: self.tabBar.frame.origin.y + 5, width: itemWidth - 10, height: itemHeight - 10))
        }
        
        createButton.setBackgroundImage(UIImage(named: "CreateButton"), for: .normal)
        createButton.adjustsImageWhenHighlighted = false
        createButton.addTarget(self, action: #selector(self.onClickCreateButton), for: .touchUpInside)
        self.view.addSubview(createButton)
    }
    
    // Goto the create story view controller
    @objc func onClickCreateButton() {
        performSegue(withIdentifier: DeviceConstants.CREATE_STORY_SEGUE, sender: self)
    }
}
