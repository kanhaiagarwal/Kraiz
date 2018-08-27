//
//  ForgotPasswordOTPViewController.swift
//  Kraiz
//
//  Created by Kumar Agarwal, Kanhai on 25/08/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider

class ForgotPasswordOTPViewController: UIViewController, AWSCognitoIdentityInteractiveAuthenticationDelegate {

    @IBOutlet weak var otpField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var enterOTPLabel: UITextView!
    
    var username: String?
    var user: AWSCognitoIdentityUser?
    var pool: AWSCognitoIdentityUserPool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pool = AWSCognitoIdentityUserPool(forKey: AWSConstants.COGNITO_USER_POOL_NAME)
        pool?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupViews()
    }

    @IBAction func resendOTPPressed(_ sender: UIButton) {
        user?.forgotPassword()
            .continueOnSuccessWith(block: { (task: AWSTask<AWSCognitoIdentityUserForgotPasswordResponse>) -> Any? in
                DispatchQueue.main.async {
                    APPUtilites.displaySuccessSnackbar(message: "OTP has been resent to your mobile number")
                }
            })
            .continueWith(block: { (task: AWSTask<AnyObject>) -> Any? in
                if let error = task.error as? NSError {
                    print("Error")
                    print(error.userInfo)
                }
                return nil
            })
    }
    
    @IBAction func donePressed(_ sender: UIButton) {
        if otpField.text == nil || otpField.text == "" || newPasswordField.text == nil || newPasswordField.text == "" {
            APPUtilites.displayErrorSnackbar(message: "OTP Field and Password cannot be blank")
            return
        }

        user?.confirmForgotPassword(otpField.text!, password: newPasswordField.text!)
            .continueOnSuccessWith(block: { (task: AWSTask<AWSCognitoIdentityUserConfirmForgotPasswordResponse>) -> Any? in
                DispatchQueue.main.async(execute: {
                    APPUtilites.displaySuccessSnackbar(message: "Your password has been changed. Use the new password to login.")
                    self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                })
            })
        .continueWith(block: { (task: AWSTask<AnyObject>) -> Any? in
            if let error = task.error as? NSError {
                print("Error")
                print(error.userInfo)
                let errorType = error.userInfo["__type"] as! String
                if errorType == "CodeMismatchException" {
                    APPUtilites.displayErrorSnackbar(message: "The OTP entered is wrong. Please enter the correct OTP ")
                }
            }
            return nil
        })
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupViews() {
        doneButton.clipsToBounds = true
        doneButton.layer.cornerRadius = doneButton.frame.height / 2
        
        otpField.clipsToBounds = true
        otpField.layer.cornerRadius = otpField.frame.height / 2
        otpField.setPadding(left: 20, right: 20)
        otpField.attributedPlaceholder = NSAttributedString(string: "OTP", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        newPasswordField.clipsToBounds = true
        newPasswordField.layer.cornerRadius = newPasswordField.frame.height / 2
        newPasswordField.setPadding(left: 20, right: 20)
        newPasswordField.attributedPlaceholder = NSAttributedString(string: "New Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
    }
}

extension UITextField {
    func setPadding(left: CGFloat? = nil, right: CGFloat? = nil){
        if let left = left {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: self.frame.size.height))
            self.leftView = paddingView
            self.leftViewMode = .always
        }
        
        if let right = right {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: right, height: self.frame.size.height))
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    }
}
