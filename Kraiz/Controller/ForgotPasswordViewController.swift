//
//  StartForgotPasswordViewController.swift
//  StoryFi
//
//  Created by Kumar Agarwal, Kanhai on 14/06/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//
// Class For the Forgot Password View.

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var otpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    func setupViews() {
        phoneNumberField.layer.cornerRadius = phoneNumberField.frame.width / 15
        phoneNumberField.clipsToBounds = true
        phoneNumberField.textColor = UIColor.white
        phoneNumberField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: phoneNumberField.frame.height))
        phoneNumberField.leftViewMode = UITextFieldViewMode.always
        phoneNumberField.attributedPlaceholder = NSAttributedString(string: "Phone Number", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.4)])
        
        otpButton.layer.cornerRadius = otpButton.frame.width / 20
        otpButton.clipsToBounds = true
    }
    
    @IBAction func onBackClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
