//
//  HamburgerViewController.swift
//  StoryFi
//
//  Created by Kumar Agarwal, Kanhai on 03/07/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//
// Class showing the Hamburger Tab Menu options.

import UIKit
import AWSCognitoIdentityProvider
import Instabug

class HamburgerViewController: UIViewController, AWSCognitoIdentityInteractiveAuthenticationDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    var viewHeight : CGFloat = 0
    
    let NUMBER_OF_ROWS : Int = 5
    let ROW_HEIGHT : CGFloat = 60.5
    let DEFAULT_PROFILE_IMAGE = UIImage(named: "profile-default")
    
    let iconImageNames = ["invite-friends", "contact-us", "about-us", "feedback", "sign-out"]
    let cellSegues = ["gotoInviteFriends", "gotoContactUs", "gotoAboutUs", "gotoFeedback", "gotoSignOut"]
    let cellInformationLabel = ["Invite Friends", "Contact Us", "About Us", "Feedback", "Sign Out"]
    
    var pool: AWSCognitoIdentityUserPool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        viewHeight = view.frame.height
        pool = AWSCognitoIdentityUserPool(forKey: AWSConstants.COGNITO_USER_POOL_NAME)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        AppSyncHelper.shared.getUserProfile(userId: UserDefaults.standard.string(forKey: DeviceConstants.USER_ID)!, success: { (profileModel) in
            DispatchQueue.main.async {
                if let name = profileModel.getName() {
                    self.usernameLabel.text = name
                } else {
                    self.usernameLabel.text = profileModel.getUsername()!
                }
                if profileModel.getProfilePicId() != nil && profileModel.getProfilePicId()! != "none" {
                    MediaHelper.shared.getProfileImage(publicId: profileModel.getProfilePicId()!, success: { (image) in
                        DispatchQueue.main.async {
                            self.profileImage.image = image
                        }
                    }, failure: { (error) in
                        DispatchQueue.main.async {
                            print("Error in loading the image: \(error)")
                            APPUtilites.displayElevatedErrorSnackbar(message: "Error in loading the Profile Picture. Please try again later")
                            self.profileImage.image = self.DEFAULT_PROFILE_IMAGE
                        }
                    })
                } else {
                    self.profileImage.image = self.DEFAULT_PROFILE_IMAGE
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                print("Error: \(error)")
                APPUtilites.displayElevatedErrorSnackbar(message: "Error in loading the User Data")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
    }
    
    override func viewDidLayoutSubviews() {
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
    }

}

extension HamburgerViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NUMBER_OF_ROWS
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("HamburgerTableViewCell", owner: self, options: nil)?.first as! HamburgerTableViewCell
        switch viewHeight {
        case DeviceConstants.IPHONEXR_HEIGHT:
            cell.informationLabel.font = UIFont(name: "Helvetica Neue", size: 20)
            break
        default:
            cell.informationLabel.font = UIFont(name: "Helvetica Neue", size: 17)
            break
        }
        cell.informationLabel.text = cellInformationLabel[indexPath.row]
        cell.icon.image = UIImage(named: iconImageNames[indexPath.row])
        cell.accessoryType = .disclosureIndicator
        return cell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ROW_HEIGHT
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 4 {
            performSignOut()
        } else if indexPath.row == 3 {
            BugReporting.invoke(with: .newFeedback, options: IBGBugReportingInvocationOption.none)
            print("Feedback pressed")
        } else {
            performSegue(withIdentifier: cellSegues[indexPath.row], sender: self)
        }
    }
    
    func performSignOut() {
        if !APPUtilites.isInternetConnectionAvailable() {
            APPUtilites.displayElevatedErrorSnackbar(message: "Please Check your Internet Connection")
        }
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            if !APPUtilites.isInternetConnectionAvailable() {
                APPUtilites.displayElevatedErrorSnackbar(message: "Please Check your Internet Connection")
                return
            }
            DispatchQueue.main.async {
                let sv = APPUtilites.displayLoadingSpinner(onView: self.view)
                UserDefaults.standard.set(nil, forKey: DeviceConstants.ID_TOKEN)
                UserDefaults.standard.set(nil, forKey: DeviceConstants.USER_ID)
                UserDefaults.standard.set(nil, forKey: DeviceConstants.USER_NAME)
                UserDefaults.standard.set(nil, forKey: DeviceConstants.MOBILE_NUMBER)
                CognitoHelper.shared.signOut(success: {
                    UserDefaults.standard.set(nil, forKey: DeviceConstants.ID_TOKEN)
                    self.pool?.clearAll()
                    DispatchQueue.main.async {
                        APPUtilites.removeLoadingSpinner(spinner: sv)
                        CacheHelper.shared.clearCache()
                        self.tabBarController?.navigationController?.popToRootViewController(animated: true)
                    }
                }, failure: { (error) in
                    UserDefaults.standard.set(nil, forKey: DeviceConstants.ID_TOKEN)
                    self.pool?.clearAll()
                    DispatchQueue.main.async {
                        print("error in sign out: \(error)")
                        APPUtilites.displayElevatedErrorSnackbar(message: "Sorry, cannot Sign Out right now. Please try again")
                        APPUtilites.removeLoadingSpinner(spinner: sv)
                    }
                })
            }
        }
        let noAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        let alert = UIAlertController(title: "Sign Out", message: "Are you sure you want to Sign Out from Kraiz?", preferredStyle: .alert)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
    }
}
