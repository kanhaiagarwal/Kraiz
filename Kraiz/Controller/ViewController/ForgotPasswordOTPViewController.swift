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
    @IBOutlet weak var hidePasswordButton: UIButton!
    
    var username: String?
    var user: AWSCognitoIdentityUser?
    var pool: AWSCognitoIdentityUserPool?
    
    let PLACEHOLDER_COLOR = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.4)
    
    let OTP_LENGTH = 6
    let MIN_PASSSWORD_LENGTH = 8
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pool = AWSCognitoIdentityUserPool(forKey: AWSConstants.COGNITO_USER_POOL_NAME)
        pool?.delegate = self
    self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        enterOTPLabel.text = "Please enter the OTP sent to the mobile number \(username!)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        otpField.becomeFirstResponder()
        setupViews()
    }

    @IBAction func hidePasswordPressed(_ sender: UIButton) {
        newPasswordField.isSecureTextEntry = !newPasswordField.isSecureTextEntry
        if newPasswordField.isSecureTextEntry == true {
            hidePasswordButton.setImage(UIImage(named: "hide-password"), for: .normal)
        } else {
            
            // The position of the cursor on unsecured text is shown wrong. This is because the width of the secured text and unsecured text are different.
            let tempText = newPasswordField.text
            newPasswordField.text = ""
            newPasswordField.text = tempText
            hidePasswordButton.setImage(UIImage(named: "show-password"), for: .normal)
        }
    }
    
    @IBAction func resendOTPPressed(_ sender: UIButton) {
        dismissKeyboard()
        let sv = APPUtilites.displayLoadingSpinner(onView: self.view)
        CognitoHelper.shared.resendOTPForForgotPassword(user: user!, success: {
            APPUtilites.removeLoadingSpinner(spinner: sv)
            APPUtilites.displaySuccessSnackbar(message: "OTP has been resent to your mobile number!")
        }) { (error: NSError) in
            APPUtilites.removeLoadingSpinner(spinner: sv)
            print("Error")
            print(error.userInfo)
            let errorType = error.userInfo["__type"] as! String
            if errorType == "NoInternetConnectionException" {
                APPUtilites.displayErrorSnackbar(message: "No Internet Connection")
            } else {
                APPUtilites.displayErrorSnackbar(message: "OTP could not be sent. Please try again")
            }
        }
    }
    
    @IBAction func donePressed(_ sender: UIButton) {
        dismissKeyboard()
        if otpField.text == nil || otpField.text == "" || newPasswordField.text == nil || newPasswordField.text == "" {
            APPUtilites.displayErrorSnackbar(message: "OTP Field and Password cannot be blank")
            return
        }
        
        if otpField.text?.count != OTP_LENGTH {
            APPUtilites.displayErrorSnackbar(message: "OTP must be of \(OTP_LENGTH) digits")
            return
        }
        
        let sv = APPUtilites.displayLoadingSpinner(onView: self.view)
        CognitoHelper.shared.confirmForgotPassword(user: user!, otp: otpField.text!, newPassword: newPasswordField.text!, success: {
            APPUtilites.removeLoadingSpinner(spinner: sv)
            APPUtilites.displaySuccessSnackbar(message: "Your password has been changed. Use the new password to login.")
            self.navigationController?.popToRootViewController(animated: true)
        }) { (error: NSError) in
            APPUtilites.removeLoadingSpinner(spinner: sv)
            print(error.userInfo)
            let errorType = error.userInfo["__type"] as! String
            if errorType == "NoInternetConnectionException" {
                APPUtilites.displayErrorSnackbar(message: "No Internet Connection")
            } else if errorType == "CodeMismatchException" {
                APPUtilites.displayErrorSnackbar(message: "The OTP entered is wrong. Please enter the correct OTP ")
            } else if errorType == "InvalidParameterException" {
                APPUtilites.displayErrorSnackbar(message: "Please enter a password of minimum \(self.MIN_PASSSWORD_LENGTH) characters")
            }
        }
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupViews() {
        doneButton.clipsToBounds = true
        doneButton.layer.cornerRadius = doneButton.frame.height / 2
        
        otpField.clipsToBounds = true
        otpField.layer.cornerRadius = otpField.frame.height / 2
        otpField.setPadding(left: 20, right: 20)
        otpField.attributedPlaceholder = NSAttributedString(string: "OTP", attributes: [NSAttributedStringKey.foregroundColor: PLACEHOLDER_COLOR])
        
        newPasswordField.clipsToBounds = true
        newPasswordField.layer.cornerRadius = newPasswordField.frame.height / 2
        newPasswordField.setPadding(left: 20, right: 20)
        newPasswordField.attributedPlaceholder = NSAttributedString(string: "New Password", attributes: [NSAttributedStringKey.foregroundColor: PLACEHOLDER_COLOR])
        
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
