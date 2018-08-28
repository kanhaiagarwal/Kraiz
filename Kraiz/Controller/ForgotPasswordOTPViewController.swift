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
        CognitoHelper.shared.resendOTPForForgotPassword(user: user!, success: {
            APPUtilites.displaySuccessSnackbar(message: "OTP has been resent to your mobile number!")
        }) { (error: NSError) in
            print("Error")
            print(error.userInfo)
        }
    }
    
    @IBAction func donePressed(_ sender: UIButton) {
        if otpField.text == nil || otpField.text == "" || newPasswordField.text == nil || newPasswordField.text == "" {
            APPUtilites.displayErrorSnackbar(message: "OTP Field and Password cannot be blank")
            return
        }
        
        CognitoHelper.shared.confirmForgotPassword(user: user!, otp: otpField.text!, newPassword: newPasswordField.text!, success: {
            APPUtilites.displaySuccessSnackbar(message: "Your password has been changed. Use the new password to login.")
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }) { (error: NSError) in
            let errorType = error.userInfo["__type"] as! String
            if errorType == "CodeMismatchException" {
                APPUtilites.displayErrorSnackbar(message: "The OTP entered is wrong. Please enter the correct OTP ")
            }
        }
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
        otpField.attributedPlaceholder = NSAttributedString(string: "Enter the OTP here", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        newPasswordField.clipsToBounds = true
        newPasswordField.layer.cornerRadius = newPasswordField.frame.height / 2
        newPasswordField.setPadding(left: 20, right: 20)
        newPasswordField.attributedPlaceholder = NSAttributedString(string: "New Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        createToolbarForTextField(textField: otpField)
        createToolbarForTextField(textField: newPasswordField)
    }
    
    func createToolbarForTextField(textField: UITextField) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.dismissKeyboard))
        let flexButton1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let flexButton2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolbar.setItems([flexButton1, flexButton2, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        textField.inputAccessoryView = toolbar
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}

extension ForgotPasswordOTPViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
