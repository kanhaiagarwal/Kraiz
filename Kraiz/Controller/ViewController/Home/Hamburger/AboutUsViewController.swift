//
//  AboutUsViewController.swift
//  StoryFi
//
//  Created by Kumar Agarwal, Kanhai on 04/07/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//
// About Us Class.

import UIKit

class AboutUsViewController: UIViewController {
    
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onBackClick(_ sender: UIButton) {
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
                UIApplication.shared.open(appSchemeUrl!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            } else {
                UIApplication.shared.open(URL(string: "http://facebook.com")!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
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
                UIApplication.shared.open(appSchemeUrl!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            } else {
                UIApplication.shared.open(URL(string: "http://instagram.com")!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            }
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
