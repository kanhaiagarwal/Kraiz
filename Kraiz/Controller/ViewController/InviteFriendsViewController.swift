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
        print("Whatsapp Tapped")
    }
    
    @objc func fbTapped() {
        print("Whatsapp Tapped")
    }
    
    @objc func instagramTapped() {
        print("Whatsapp Tapped")
    }
    
    @objc func commonShareTapped() {
        print("Whatsapp Tapped")
    }
}
