//
//  ContactUsViewController.swift
//  StoryFi
//
//  Created by Kumar Agarwal, Kanhai on 08/07/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//
// Contact Us Class.

import UIKit

class ContactUsViewController: UIViewController {

    let icons = ["contact", "email", "link"]
    let labels = ["+91-9023161611", "kraiz.company@gmail.com", "https://kraiz.app"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    @IBAction func onClickBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func fbPressed(_ sender: UIButton) {
        let appName = "fb"
        if let appURL = URL(string: "\(appName)://") {
            let canOpenURL = UIApplication.shared.canOpenURL(appURL)
            print("\(canOpenURL)")
            
            let appScheme = "\(appName)://profile/\(DeviceConstants.FB_PAGE_ID)"
            let appSchemeUrl = URL(string: appScheme)
            
            if UIApplication.shared.canOpenURL(appSchemeUrl as! URL) {
                UIApplication.shared.open(appSchemeUrl!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            } else {
                UIApplication.shared.open(URL(string: "http://facebook.com")!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            }
        }
    }
    
    @IBAction func instagramPressed(_ sender: UIButton) {
        let appName = "instagram"
        if let appURL = URL(string: "\(appName)://") {
            let canOpenURL = UIApplication.shared.canOpenURL(appURL)
            print("\(canOpenURL)")
            
            let appScheme = "\(appName)://user?username=\(DeviceConstants.INSTAGRAM_PAGE_USER_NAME)"
            let appSchemeUrl = URL(string: appScheme)
            
            if UIApplication.shared.canOpenURL(appSchemeUrl as! URL) {
                UIApplication.shared.open(appSchemeUrl!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            } else {
                UIApplication.shared.open(URL(string: "http://instagram.com")!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            }
        }
    }
}

extension ContactUsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("ContactUsTableViewCell", owner: self, options: nil)?.first as! ContactUsTableViewCell
        cell.icon.image = UIImage(named: icons[indexPath.row])
        cell.informationLabel.text = labels[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.selectionStyle = UITableViewCell.SelectionStyle.none
        
        // Open the dialler with the number of the Company.
        if indexPath.row == 0 {
            UIApplication.shared.open(URL(string: "tel://9023161611")!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        }
        
        // Open the default Mail App.
        if indexPath.row == 1 {
            UIApplication.shared.open(URL(string: "mailto:kraiz.company@gmail.com")!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        }
        
        // Open the Kraiz Website URL.
        if indexPath.row == 2 {
            UIApplication.shared.open(URL(string: "http://kraiz.app")!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
