//
//  StartSignUpOTPViewController.swift
//  StoryFi
//
//  Created by Kumar Agarwal, Kanhai on 30/06/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//
//  Class for the OTP View for Sign Up.

import UIKit
import AWSCognitoIdentityProvider
import TTGSnackbar

class SignUpOTPViewController: UIViewController, AWSCognitoIdentityInteractiveAuthenticationDelegate {

    public var cognitoUser: AWSCognitoIdentityUser?
    public var username: String = ""
    var pool: AWSCognitoIdentityUserPool?
    
    let standardText = "Please type the OTP sent to your number "
    
    @IBOutlet weak var typeOTPLabel: UITextView!
    @IBOutlet weak var otpField: UITextField!
    @IBOutlet weak var otpButton: UIButton!
    @IBOutlet weak var resendOTPButton: UIButton!
    
    // Segues
    let GOTO_HOME_PAGE: String = "gotoHomeFromSignUp"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        typeOTPLabel.text = standardText + username
        pool = AWSCognitoIdentityUserPool(forKey: AWSConstants.COGNITO_USER_POOL_NAME)
        pool?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViews()
    }
    
    func setupViews() {
        otpField.layer.cornerRadius = otpField.frame.height / 2
        otpField.clipsToBounds = true
        otpField.setPadding(left: 10, right: 10)
        otpField.attributedPlaceholder = NSAttributedString(string: "Enter the OTP Here", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        otpButton.layer.cornerRadius = otpButton.frame.height / 2
        otpButton.clipsToBounds = true
        
        createToolbarForTextField(textField: otpField)
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
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickOTPButton(_ sender: UIButton) {
        if otpField.text == nil || otpField.text == "" {
            APPUtilites.displayErrorSnackbar(message: "OTP Field cannot be blank")
            return
        }

        CognitoHelper.shared.verifyOTPForSignUp(pool: pool!, user: self.cognitoUser!, otp: otpField.text!, success: {
            self.gotoHomePage()
        }) { (error: NSError) in
            print(error)
            APPUtilites.displayErrorSnackbar(message: "Wrong OTP Entered. Please enter the correct OTP")
        }
    }
    
    func gotoHomePage() {
        performSegue(withIdentifier: GOTO_HOME_PAGE, sender: self)
    }
    
    @IBAction func onClickResendOTP(_ sender: UIButton) {
        CognitoHelper.shared.resendOTPForSignUp(pool: pool!, user: self.cognitoUser!, success: {
            APPUtilites.displaySuccessSnackbar(message: "The confirmation code has been sent again to " + self.username)
        }) { (error: NSError) in
            print(error.debugDescription)
            APPUtilites.displayErrorSnackbar(message: "Error in sending the code. Please try again")
        }
    }
}

extension SignUpOTPViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
