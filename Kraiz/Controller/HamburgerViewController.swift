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

class HamburgerViewController: UIViewController, AWSCognitoIdentityInteractiveAuthenticationDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let NUMBER_OF_ROWS : Int = 4
    let ROW_HEIGHT : CGFloat = 60.5
    
    let iconImageNames = ["invite-friends", "contact-us", "about-us", "sign-out"]
    let cellSegues = ["gotoInviteFriends", "gotoContactUs", "gotoAboutUs", "gotoSignOut"]
    let cellInformationLabel = ["Invite Friends", "Contact Us", "About Us", "Sign Out"]
    
    var pool: AWSCognitoIdentityUserPool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.clipsToBounds = true
        profileImage.layer.masksToBounds = false
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        
        tableView.delegate = self
        tableView.dataSource = self
        
        pool = AWSCognitoIdentityUserPool(forKey: AWSConstants.COGNITO_USER_POOL_NAME)
    }

}

extension HamburgerViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NUMBER_OF_ROWS
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("HamburgerTableViewCell", owner: self, options: nil)?.first as! HamburgerTableViewCell
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
        if indexPath.row == 3 {
            let sv = APPUtilites.displayLoadingSpinner(onView: self.view)
            CognitoHelper.shared.signOut(success: {
                APPUtilites.removeLoadingSpinner(spinner: sv)
                
                if self.tabBarController != nil {
                print("*************v****************************************************")
                    print("TabBarController is not nil")
                    
                    if self.tabBarController?.navigationController != nil {
                        print("*************v****************************************************")
                        print("NavigationControlleris not nil")
                        self.tabBarController?.navigationController?.popToRootViewController(animated: true)
                        
                    } else {
                        print("*************v****************************************************")
                        print("NavigationController is nil")
                    }
               
                     self.navigationController?.popToRootViewController(animated: true)
                } else {
                print("*************v****************************************************")
                    print("TabBarController is nil")
                self.tabBarController?.navigationController?.popToRootViewController(animated: true)
                }
            }, failure: { (error) in
                APPUtilites.displayErrorSnackbar(message: "Sorry, cannot Sign Out right now. Please try again")
                APPUtilites.removeLoadingSpinner(spinner: sv)
            })
        } else {
            performSegue(withIdentifier: cellSegues[indexPath.row], sender: self)
        }
    }
}
