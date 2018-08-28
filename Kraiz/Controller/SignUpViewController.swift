//
//  SignUpViewController.swift
//  StoryFi
//
//  Created by Kumar Agarwal, Kanhai on 13/06/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//
//  Class for the Sign Up View.

import UIKit
import AWSCognitoIdentityProvider

class SignUpViewController: UIViewController, AWSCognitoIdentityInteractiveAuthenticationDelegate, UIPickerViewDelegate {

    var pool: AWSCognitoIdentityUserPool?
    var user: AWSCognitoIdentityUser?
    @IBOutlet weak var generateOTPButton: UIButton!
    @IBOutlet weak var countryCodeField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    let pickerStrings = ["India (+91)", "USA (+1)", "Pakistan (+92)", "Bangladesh (+123)"]
    let countryCodes = ["+91", "+1", "+92", "+123"]
    
    var countryCodeSelected = "+91"
    
    let countryCodePicker = UIPickerView()
    
    // Segues
    let GOTO_OTP_SEGUE = "gotoVerifyOtpFromSignUp"
    let SIGN_UP_TO_SIGN_IN_SEGUE = "signUpToSignIn"
    var viewHeight : CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewHeight = view.frame.height
        
        setupViews()
        usernameField.delegate = self
        passwordField.delegate = self
        countryCodePicker.delegate = self
        countryCodeField.inputView = countryCodePicker
        countryCodeField.text = "+91"
        createToolbarForTextField(textField: countryCodeField)
        createToolbarForTextField(textField: usernameField)
        createToolbarForTextField(textField: passwordField)
        
        pool = AWSCognitoIdentityUserPool(forKey: AWSConstants.COGNITO_USER_POOL_NAME)
        pool?.delegate = self
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
    
    func setupViews() {
        countryCodeField.layer.cornerRadius = countryCodeField.frame.height / 2
        countryCodeField.clipsToBounds = true
        
        usernameField.layer.cornerRadius = usernameField.frame.height / 2
        usernameField.clipsToBounds = true
        usernameField.setPadding(left: 10, right: 10)
        usernameField.attributedPlaceholder = NSAttributedString(string: "Mobile Number", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        passwordField.layer.cornerRadius = passwordField.frame.height / 2
        passwordField.clipsToBounds = true
        passwordField.setPadding(left: 10, right: 10)
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        generateOTPButton.layer.cornerRadius = generateOTPButton.frame.height / 2
        generateOTPButton.clipsToBounds = true
        
        setupFontSize()
    }
    
    @IBAction func generateOTPPressed(_ sender: UIButton) {
        if usernameField.text == nil || passwordField.text == nil || usernameField.text == "" || passwordField.text == "" {
            APPUtilites.displayErrorSnackbar(message: "Username and Password cannot be left blank")
            return
        }
        generateOTPButton.isEnabled = false
        let usernameText = countryCodeField.text! + usernameField.text!
        
        CognitoHelper.shared.generateOTPForSignUp(pool: pool!, usernameText: usernameText, passwordText: passwordField.text!, success: { (sessionUser: AWSCognitoIdentityUser) in
            self.user = sessionUser
            self.gotoVerifyOTPPage()
        }) { (error: NSError) in
            if String(describing: error.userInfo["__type"]!) == "UsernameExistsException" {
                APPUtilites.displayErrorSnackbar(message: "User with the phone number already exists")
            } else if String(describing: error.userInfo["__type"]!) == "InvalidPasswordException" || String(describing: error.userInfo["__type"]!) == "InvalidParameterException" {
                APPUtilites.displayErrorSnackbar(message: "Please make sure that the password is minimum 6 characters.")
            }
            self.generateOTPButton.isEnabled = true
        }
    }
    @IBAction func gotoSignIn(_ sender: UIButton) {
        performSegue(withIdentifier: SIGN_UP_TO_SIGN_IN_SEGUE, sender: self)
    }
    
    func gotoVerifyOTPPage() {
        performSegue(withIdentifier: self.GOTO_OTP_SEGUE, sender: self)
    }
    
    func setupFontSize() {
        switch viewHeight {
        case DeviceConstants.IPHONE5S_HEIGHT:
            usernameField.font = UIFont(name: "Times New Roman", size: 20)
            passwordField.font = UIFont(name: "Times New Roman", size: 20)
            countryCodeField.font = UIFont(name: "Times New Roman", size: 20)
            break
        case DeviceConstants.IPHONE7_HEIGHT:
            usernameField.font = UIFont(name: "Times New Roman", size: 22)
            passwordField.font = UIFont(name: "Times New Roman", size: 22)
            countryCodeField.font = UIFont(name: "Times New Roman", size: 22)
            break
        case DeviceConstants.IPHONE7PLUS_HEIGHT:
            usernameField.font = UIFont(name: "Times New Roman", size: 26)
            passwordField.font = UIFont(name: "Times New Roman", size: 26)
            countryCodeField.font = UIFont(name: "Times New Roman", size: 26)
            break
        case DeviceConstants.IPHONEX_HEIGHT:
            usernameField.font = UIFont(name: "Times New Roman", size: 26)
            passwordField.font = UIFont(name: "Times New Roman", size: 26)
            countryCodeField.font = UIFont(name: "Times New Roman", size: 26)
        default:
            usernameField.font = UIFont(name: "Times New Roman", size: 20)
            passwordField.font = UIFont(name: "Times New Roman", size: 20)
            countryCodeField.font = UIFont(name: "Times New Roman", size: 20)
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == GOTO_OTP_SEGUE {
            let destinationVC = segue.destination as! SignUpOTPViewController
            destinationVC.username = countryCodeField.text! + usernameField.text!
            destinationVC.cognitoUser = user
        }
    }
}

extension SignUpViewController: UIPickerViewDataSource, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryCodes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerStrings[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        countryCodeSelected = countryCodes[row]
        countryCodeField.text = countryCodeSelected
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
