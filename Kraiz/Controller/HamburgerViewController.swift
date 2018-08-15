//
//  HamburgerViewController.swift
//  StoryFi
//
//  Created by Kumar Agarwal, Kanhai on 03/07/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//
// Class showing the Hamburger Tab Menu options.

import UIKit

class HamburgerViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let NUMBER_OF_ROWS : Int = 4
    let ROW_HEIGHT : CGFloat = 60.5
    
    let iconImageNames = ["invite-friends", "contact-us", "about-us", "sign-out"]
    let cellSegues = ["gotoInviteFriends", "gotoContactUs", "gotoAboutUs", "gotoSignOut"]
    let cellInformationLabel = ["Invite Friends", "Contact Us", "About Us", "Sign Out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.clipsToBounds = true
        profileImage.layer.masksToBounds = false
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        
        tableView.delegate = self
        tableView.dataSource = self
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
        performSegue(withIdentifier: cellSegues[indexPath.row], sender: self)
    }
}
