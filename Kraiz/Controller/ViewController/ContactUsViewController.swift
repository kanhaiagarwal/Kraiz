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
    let labels = ["+91-9023161611", "storyfi.company@gmail.com", "https://www.storyfi.app"]
    
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
        if let appURL = URL(string: "facebook://") {
            let canOpenURL = UIApplication.shared.canOpenURL(appURL)
            print("\(canOpenURL)")
            
            let appName = "Facebook"
            let appScheme = "\(appName)://"
            let appSchemeUrl = URL(string: appScheme)
            
            if UIApplication.shared.canOpenURL(appSchemeUrl as! URL) {
                UIApplication.shared.open(appSchemeUrl!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.open(URL(string: "http://facebook.com")!, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func instagramPressed(_ sender: UIButton) {
        if let appURL = URL(string: "instagram://") {
            let canOpenURL = UIApplication.shared.canOpenURL(appURL)
            print("\(canOpenURL)")
            
            let appName = "Instagram"
            let appScheme = "\(appName)://"
            let appSchemeUrl = URL(string: appScheme)
            
            if UIApplication.shared.canOpenURL(appSchemeUrl as! URL) {
                UIApplication.shared.open(appSchemeUrl!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.open(URL(string: "http://instagram.com")!, options: [:], completionHandler: nil)
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
        tableView.cellForRow(at: indexPath)?.selectionStyle = UITableViewCellSelectionStyle.none
    }
}
