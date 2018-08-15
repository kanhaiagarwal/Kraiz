//
//  HomeTabBarController.swift
//  StoryFi
//
//  Created by Kumar Agarwal, Kanhai on 30/06/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//
// Main Tab Bar Controller for the Home Page.

import UIKit

class HomeTabBarController: UITabBarController {

    let DEFAULT_SELECTED_INDEX : Int = 3
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var createButton : UIButton
        self.selectedIndex = DEFAULT_SELECTED_INDEX
        
        self.tabBar.itemPositioning = .centered
        
        // Custom Create button
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
        performSegue(withIdentifier: "gotoCreateStory", sender: self)
    }

}
