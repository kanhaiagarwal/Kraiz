//
//  DisplayImageViewController.swift
//  Kraiz
//
//  Created by Kumar Agarwal, Kanhai on 15/09/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit

protocol DisplayImageViewControllerProtocol {
    func profileImageDeleted();
    func backPressedOnDisplayProfileImage();
}

class DisplayImageViewController: UIViewController {
    
    public var profileImage : UIImage = UIImage()
    
    var delegate: DisplayImageViewControllerProtocol?
    
    @IBOutlet weak var profileImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.image = profileImage
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deletePressed))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = false
    }
    
    @objc func backPressed() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.delegate?.backPressedOnDisplayProfileImage()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func deletePressed() {
        let yesAction = UIAlertAction(title: "Yes", style: .cancel) { (action) in
            print("Inside the yes action of the DisplayImageViewController")
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.delegate?.profileImageDeleted()
            self.navigationController?.popViewController(animated: true)
        }
        
        let noAction = UIAlertAction(title: "No", style: .default, handler: nil)
        let alert = UIAlertController(title: "Delete Profile Picture", message: "Are you sure you want to delete your Profile Picture", preferredStyle: .actionSheet)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
    }

}
