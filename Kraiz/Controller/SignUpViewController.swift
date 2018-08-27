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
    @IBOutlet weak var hideKeyboardButton: UIButton!
    
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
        createToolbarForPickerView()
        hideKeyboardButton.isHidden = true
        
        pool = AWSCognitoIdentityUserPool(forKey: AWSConstants.COGNITO_USER_POOL_NAME)
        pool?.delegate = self
    }
    
    func createToolbarForPickerView() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.dismissKeyboard))
        
        
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        countryCodeField.inputAccessoryView = toolbar
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func setupViews() {
        usernameField.layer.cornerRadius = usernameField.frame.width / 15
        usernameField.clipsToBounds = true
        usernameField.textColor = UIColor.white
        usernameField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: usernameField.frame.height))
        usernameField.leftViewMode = UITextFieldViewMode.always
        usernameField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.4)])
        
        passwordField.layer.cornerRadius = usernameField.frame.width / 15
        passwordField.clipsToBounds = true
        passwordField.textColor = UIColor.white
        passwordField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: passwordField.frame.height))
        passwordField.leftViewMode = UITextFieldViewMode.always
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.4)])
        
        signUpButton.layer.cornerRadius = usernameField.frame.width / 15
        signUpButton.clipsToBounds = true

        setupFontSize()
    }
    
    @IBAction func generateOTPPressed(_ sender: UIButton) {
        if usernameField.text == nil || passwordField.text == nil || usernameField.text == "" || passwordField.text == "" {
            APPUtilites.displayErrorSnackbar(message: "Username and Password cannot be left blank")
            return
        }
        generateOTPButton.isEnabled = false
        let username = countryCodeField.text! + usernameField.text!
        print("****************************************")
        print("username: \(username)")
        
        self.pool?.signUp(username, password: passwordField.text!, userAttributes: nil, validationData: nil).continueWith(block: { (task: AWSTask<AWSCognitoIdentityUserPoolSignUpResponse>) -> Any? in
            print("task.result \(String(describing: task.result))")
            DispatchQueue.main.async(execute: {
                if let error = task.error as? NSError {
                    print("Error")
                    print(error.debugDescription)
                    if String(describing: error.userInfo["__type"]!) == "UsernameExistsException" {
                        print("Inside the UsernameExistsException")
                        APPUtilites.displayErrorSnackbar(message: "User with the same username or phone number already exists")
                    } else if String(describing: error.userInfo["__type"]!) == "InvalidPasswordException" || String(describing: error.userInfo["__type"]!) == "InvalidParameterException" {
                        APPUtilites.displayErrorSnackbar(message: "Please make sure that the password is minimum 6 characters.")
                    }
                    self.generateOTPButton.isEnabled = true
                } else if let result = task.result  {
                    // handle the case where user has to confirm his identity via email / SMS
                    if (result.user.confirmedStatus != AWSCognitoIdentityUserStatus.confirmed) {
                        print("Status Not Confirmed")
                    } else {
                        print("Status Confirmed")
                    }
                    self.user = task.result?.user
                    self.gotoVerifyOTPPage()
                }
            })
            return nil
        })
        
        print("After the sign up method")
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
    @IBAction func hideKeyboardButtonPressed(_ sender: UIButton) {
        view.endEditing(true)
        hideKeyboardButton.isHidden = true
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideKeyboardButton.isHidden = false
    }
}
