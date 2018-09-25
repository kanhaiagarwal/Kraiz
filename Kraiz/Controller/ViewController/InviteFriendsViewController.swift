//
//  InviteFriendsViewController.swift
//  Kraiz
//
//  Created by Kumar Agarwal, Kanhai on 14/09/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit

class InviteFriendsViewController: UIViewController {

    @IBOutlet weak var whatsappImage: UIImageView!
    @IBOutlet weak var facebookImage: UIImageView!
    @IBOutlet weak var instagramImage: UIImageView!
    @IBOutlet weak var commonShareImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let whatsappGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(whatsappTapped))
        let fbGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(fbTapped))
        let instagramGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(instagramTapped))
        let commonShareGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(commonShareTapped))
        
        whatsappImage.addGestureRecognizer(whatsappGestureRecognizer)
        facebookImage.addGestureRecognizer(fbGestureRecognizer)
        instagramImage.addGestureRecognizer(instagramGestureRecognizer)
        commonShareImage.addGestureRecognizer(commonShareGestureRecognizer)
    }

    @IBAction func backPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func whatsappTapped() {
        if let appURL = URL(string: "whatsapp://") {
            let canOpenURL = UIApplication.shared.canOpenURL(appURL)
            print("\(canOpenURL)")
            
            let appName = "Whatsapp"
            let appScheme = "\(appName)://"
            let appSchemeUrl = URL(string: appScheme)
            
            if UIApplication.shared.canOpenURL(appSchemeUrl as! URL) {
                UIApplication.shared.open(appSchemeUrl!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.open(URL(string: "http://whatsapp.com")!, options: [:], completionHandler: nil)
            }
        }
    }
    
    @objc func fbTapped() {
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
    
    @objc func instagramTapped() {
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
    
    @objc func commonShareTapped() {
        let activityViewController = UIActivityViewController(activityItems: ["Please download Kraiz. Its a really cool and awesome app." as NSString], applicationActivities: nil)
        present(activityViewController, animated: true, completion: {})
    }
}
