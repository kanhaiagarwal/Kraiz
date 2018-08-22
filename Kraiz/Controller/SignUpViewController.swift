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

class SignUpViewController: UIViewController, AWSCognitoIdentityInteractiveAuthenticationDelegate {

    var pool: AWSCognitoIdentityUserPool?
    
    @IBOutlet weak var generateOTPButton: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    // Segues
    let GOTO_OTP_SEGUE = "gotoVerifyOtpFromSignUp"
    let SIGN_UP_TO_SIGN_IN_SEGUE = "signUpToSignIn"
    var viewHeight : CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewHeight = view.frame.height
        
        setupViews()
        
        pool = AWSCognitoIdentityUserPool(forKey: "Kraiz")
        pool?.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        phoneNumberField.layer.cornerRadius = usernameField.frame.width / 15
        phoneNumberField.clipsToBounds = true
        phoneNumberField.textColor = UIColor.white
        phoneNumberField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: phoneNumberField.frame.height))
        phoneNumberField.leftViewMode = UITextFieldViewMode.always
        phoneNumberField.attributedPlaceholder = NSAttributedString(string: "Phone Number", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.4)])
        
        signUpButton.layer.cornerRadius = usernameField.frame.width / 15
        signUpButton.clipsToBounds = true

        setupFontSize()
    }
    
    @IBAction func generateOTPPressed(_ sender: UIButton) {
        var attributes = [AWSCognitoIdentityUserAttributeType]()
        let phone = AWSCognitoIdentityUserAttributeType()
        
        phone?.name = "phone_number"
        phone?.value = phoneNumberField.text
        attributes.append(phone!)
        
        let preferredUsername = AWSCognitoIdentityUserAttributeType()
        preferredUsername?.name = "preferred_username"
        preferredUsername?.value = usernameField.text
        
        attributes.append(preferredUsername!)
        
        generateOTPButton.isEnabled = false
        
        self.pool?.signUp(usernameField.text!, password: passwordField.text!, userAttributes: attributes, validationData: nil).continueWith(block: { (task: AWSTask<AWSCognitoIdentityUserPoolSignUpResponse>) -> Any? in
            print("task.result \(String(describing: task.result))")
            DispatchQueue.main.async(execute: {
                if let error = task.error as? NSError {
                    print("Error")
                    print(error.debugDescription)
                    if String(describing: error.userInfo["__type"]!) == "UsernameExistsException" {
                        print("Inside the UsernameExistsException")
                        APPUtilites.displayErrorSnackbar(message: "User with the same username or phone number already exists")
                    } else if String(describing: error.userInfo["__type"]!) == "InvalidPasswordException" {
                        APPUtilites.displayErrorSnackbar(message: "Please make sure that the password is minimum 8 characters.")
                    }
                    self.generateOTPButton.isEnabled = true
                } else if let result = task.result  {
                    // handle the case where user has to confirm his identity via email / SMS
                    if (result.user.confirmedStatus != AWSCognitoIdentityUserStatus.confirmed) {
                        print("Status Not Confirmed")
                    } else {
                        print("Status Confirmed")
                    }
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
            phoneNumberField.font = UIFont(name: "Times New Roman", size: 20)
            break
        case DeviceConstants.IPHONE7_HEIGHT:
            usernameField.font = UIFont(name: "Times New Roman", size: 22)
            passwordField.font = UIFont(name: "Times New Roman", size: 22)
            phoneNumberField.font = UIFont(name: "Times New Roman", size: 22)
            break
        case DeviceConstants.IPHONE7PLUS_HEIGHT:
            usernameField.font = UIFont(name: "Times New Roman", size: 26)
            passwordField.font = UIFont(name: "Times New Roman", size: 26)
            phoneNumberField.font = UIFont(name: "Times New Roman", size: 26)
            break
        case DeviceConstants.IPHONEX_HEIGHT:
            usernameField.font = UIFont(name: "Times New Roman", size: 26)
            passwordField.font = UIFont(name: "Times New Roman", size: 26)
            phoneNumberField.font = UIFont(name: "Times New Roman", size: 26)
        default:
            usernameField.font = UIFont(name: "Times New Roman", size: 20)
            passwordField.font = UIFont(name: "Times New Roman", size: 20)
            phoneNumberField.font = UIFont(name: "Times New Roman", size: 20)
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == GOTO_OTP_SEGUE {
            let destinationVC = segue.destination as! SignUpOTPViewController
            destinationVC.phoneNumber = self.phoneNumberField.text!
            destinationVC.username = self.usernameField.text!
        }
    }
}
