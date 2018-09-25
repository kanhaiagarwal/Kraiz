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

        activityIndicator.startAnimating()
        pool = AWSCognitoIdentityUserPool(forKey: AWSConstants.COGNITO_USER_POOL_NAME)
        
        UserDefaults.standard.string(forKey: DeviceConstants.MOBILE_NUMBER)
        UserDefaults.standard.string(forKey: DeviceConstants.USER_NAME)
        
        print("UserDefaults")
        print("UserDefaults.standard.string(forKey: DeviceConstants.MOBILE_NUMBER): \(UserDefaults.standard.string(forKey: DeviceConstants.MOBILE_NUMBER))")
        print("UserDefaults.standard.string(forKey: DeviceConstants.USER_NAME): \(UserDefaults.standard.string(forKey: DeviceConstants.USER_NAME))")
        
        /// Use the IDToken of the previous session if the internet is not available
        if !APPUtilites.isInternetConnectionAvailable() {
            // The ID Token for the session was already set previously
            if UserDefaults.standard.string(forKey: DeviceConstants.ID_TOKEN) != nil {
                AppSyncHelper.shared.setAppSyncClient()
                
                // Check if the ID token might have expired. The UserDefaults will be set to nil if the setAppClient() fails because of token expiry.
                if UserDefaults.standard.string(forKey: DeviceConstants.ID_TOKEN) != nil {
                    AppSyncHelper.shared.getUserProfile(userId: UserDefaults.standard.string(forKey: DeviceConstants.USER_ID)!, success: { (profile) in
                        DispatchQueue.main.async {
                            print("******************************************")
                            print("profile id: \(profile.getId())")
                            print("profile name: \(profile.getName())")
                            print("profile username: \(profile.getUsername())")
                            if profile.getId() != nil {
                                UserDefaults.standard.set(true, forKey: DeviceConstants.IS_PROFILE_PRESENT)
                            } else {
                                UserDefaults.standard.set(false, forKey: DeviceConstants.IS_PROFILE_PRESENT)
                            }
                            self.performSegue(withIdentifier: self.HOME_PAGE_SEGUE, sender: self)
                        }
                    }, failure: { (error) in
                        DispatchQueue.main.async {
                            print("Error: \(error)")
                            APPUtilites.displayErrorSnackbar(message: "Error in network connection. Please check your internet connection")
                        }
                    })
                } else {
                    performSegue(withIdentifier: WELCOME_PAGE_SEGUE, sender: self)
                }
            } else {
                performSegue(withIdentifier: WELCOME_PAGE_SEGUE, sender: self)
            }
        } else {
            
            let currentUser = pool?.currentUser()
            
            if currentUser != nil {
                print("Current User is not nil")
                let result = currentUser?.getSession().result
                if result != nil {
                    print("result is not nil")
                    UserDefaults.standard.set(result?.idToken?.tokenString, forKey: DeviceConstants.ID_TOKEN)
                    CognitoHelper.shared.currentUser = currentUser
                    currentUser?.getDetails().continueOnSuccessWith(block: { (task: AWSTask<AWSCognitoIdentityUserGetDetailsResponse>) -> Any? in
                        if let taskResult = task.result {
                            if let userAttributes = taskResult.userAttributes {
                                for i in 0 ..< userAttributes.count {
                                    print("\(userAttributes[i].name): \(userAttributes[i].value)")
                                    if userAttributes[i].name == "phone_number" {
                                        print("Phone Number inside StartViewController: \(userAttributes[i].value)")
                                        UserDefaults.standard.set(userAttributes[i].value!, forKey: DeviceConstants.MOBILE_NUMBER)
                                        break
                                    }
                                }
                            }
                        }
                        return nil
                    }).continueWith(block: { (task: AWSTask<AnyObject>) -> Any? in
                        if let error = task.error {
                            print("Error: \(error.localizedDescription)")
                        }
                        return nil
                    })
                    UserDefaults.standard.set(currentUser?.username!, forKey: DeviceConstants.USER_ID)
                    AppSyncHelper.shared.setAppSyncClient()
                    AppSyncHelper.shared.getUserProfile(userId: UserDefaults.standard.string(forKey: DeviceConstants.USER_ID)!, success: { (profile) in
                        print("Inside the getUserProfile of StartViewController where the Internet Connection is available")
                        DispatchQueue.main.async {
                            print("******************************************")
                            print("profile id: \(profile.getId())")
                            print("profile name: \(profile.getName())")
                            print("profile username: \(profile.getUsername())")
                            if profile.getId() != nil {
                                UserDefaults.standard.set(true, forKey: DeviceConstants.IS_PROFILE_PRESENT)
                            } else {
                                UserDefaults.standard.set(false, forKey: DeviceConstants.IS_PROFILE_PRESENT)
                            }
                            self.performSegue(withIdentifier: self.HOME_PAGE_SEGUE, sender: self)
                        }
                    }, failure: { (error) in
                        DispatchQueue.main.async {
                            print("Error: \(error)")
                            APPUtilites.displayErrorSnackbar(message: "Error in network connection. Please check your internet connection")
                        }
                    })
                } else {
                    performSegue(withIdentifier: self.WELCOME_PAGE_SEGUE, sender: self)
                }
            } else {
                print("Current User is nil")
                performSegue(withIdentifier: WELCOME_PAGE_SEGUE, sender: self)
            }
        }
    }
}
