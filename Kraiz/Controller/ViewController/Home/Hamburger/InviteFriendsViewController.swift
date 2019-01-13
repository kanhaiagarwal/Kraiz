//
//  InviteFriendsViewController.swift
//  Kraiz
//
//  Created by Kumar Agarwal, Kanhai on 14/09/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit

class InviteFriendsViewController: UIViewController {
    
    @IBOutlet weak var facebookImage: UIImageView!
    @IBOutlet weak var whatsappImage: UIImageView!
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("view.layer.sublayers: \(view.layer.sublayers)")
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(displayP3Red: 100/255, green: 43/255, blue: 115/255, alpha: 1.0).cgColor, UIColor(displayP3Red: 198/255, green: 66/255, blue: 110/255, alpha: 1.0).cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    @IBAction func backPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func whatsappTapped() {
        var str = "Please download Kraiz to create Vibes that you feel everyday. Share them with your friends and people who want to receive the same vibes."
        str=str.addingPercentEncoding(withAllowedCharacters: (NSCharacterSet.urlQueryAllowed))!
        let whatsappURL = URL(string: "whatsapp://send?text=\(str)")
        if let url = whatsappURL {
            UIApplication.shared.open(url, options: [:]) { (success) in
                print("success: \(success)")
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
                UIApplication.shared.open(appSchemeUrl!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            } else {
                UIApplication.shared.open(URL(string: "http://facebook.com")!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
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
                UIApplication.shared.open(appSchemeUrl!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            } else {
                UIApplication.shared.open(URL(string: "http://instagram.com")!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            }
        }
    }
    
    @objc func commonShareTapped() {
        let activityViewController = UIActivityViewController(activityItems: ["Please download Kraiz. Its a really cool and awesome app." as NSString], applicationActivities: nil)
        present(activityViewController, animated: true, completion: {})
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
