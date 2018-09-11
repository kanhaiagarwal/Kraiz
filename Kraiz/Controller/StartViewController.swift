//
//  StartViewController.swift
//  Kraiz
//
//  Created by Kumar Agarwal, Kanhai on 04/09/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.

import UIKit
import AWSCognitoIdentityProvider
    
class StartViewController: UIViewController, AWSCognitoIdentityInteractiveAuthenticationDelegate  {
    
    // Segues
    let WELCOME_PAGE_SEGUE = "gotoWelcomePage"
    let HOME_PAGE_SEGUE = "gotoHomePage"

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var pool: AWSCognitoIdentityUserPool?
    var currentUser: AWSCognitoIdentityUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// Executed everytime the user arrives on this view controller.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        print("Inside the viewWillAppear of StartViewController")

        activityIndicator.startAnimating()
        pool = AWSCognitoIdentityUserPool(forKey: AWSConstants.COGNITO_USER_POOL_NAME)
        let currentUser = pool?.currentUser()
        
        if currentUser != nil {
            print("Current User is not nil")
            
            let result = currentUser?.getSession().result
            if result != nil {
                print("result is not nil")
                CognitoHelper.shared.currentUser = currentUser
                UserDefaults.standard.set(currentUser?.username!, forKey: DeviceConstants.USER_ID)
                AppSyncHelper.shared.setAppSyncClient()
                performSegue(withIdentifier: self.HOME_PAGE_SEGUE, sender: self)
            } else {
                performSegue(withIdentifier: self.WELCOME_PAGE_SEGUE, sender: self)
            }
        } else {
            print("Current User is nil")
            performSegue(withIdentifier: WELCOME_PAGE_SEGUE, sender: self)
        }
    }
}
