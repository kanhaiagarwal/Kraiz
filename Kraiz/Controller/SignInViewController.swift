//
//  StartSignInViewController.swift
//  StoryFi
//
//  Created by Kumar Agarwal, Kanhai on 14/06/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//
// Class for the Sign In View.

import UIKit
import AWSCognitoIdentityProvider
import TTGSnackbar

class SignInViewController: UIViewController, UITextFieldDelegate, AWSCognitoIdentityInteractiveAuthenticationDelegate {

    var pool: AWSCognitoIdentityUserPool?
    var user: AWSCognitoIdentityUser?
    var passwordAuthenticationCompletion: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>?
    
    @IBOutlet weak var countryCodeField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var usernameContainer: UIView!
    @IBOutlet weak var hideKeyboardButton: UIButton!
    
    let countryCodePicker = UIPickerView()
    var countryCodeTextField: UITextField!
    var countryCodeSelected : String?
    var isUsernameInputNumbers : Bool = false
    
    /// Segues
    let GOTO_HOME_FROM_SIGN_IN = "gotoHomeFromSignIn"
    let GOTO_OTP_FROM_SIGN_IN = "gotoOTPFromSignIn"
    
    let pickerStrings = ["India (+91)", "USA (+1)", "Pakistan (+92)", "Bangladesh (+123)"]
    
    let countryCodes = ["+91", "+1", "+92", "+123"]
    
    var viewHeight : CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.delegate = self
        
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
        user = pool?.getUser()
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
        view.endEditing(true)
    }
    
    @IBAction func hideKeyboardPressed(_ sender: UIButton) {
        view.endEditing(true)
        hideKeyboardButton.isHidden = true
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
    
    func setupViews() {
        usernameField.layer.cornerRadius = usernameField.frame.width / 20
        usernameField.clipsToBounds = true
        usernameField.textColor = UIColor.white
        usernameField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: usernameField.frame.height))
        usernameField.leftViewMode = UITextFieldViewMode.always
        usernameField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.4)])
        
        passwordField.layer.cornerRadius = usernameField.frame.width / 20
        passwordField.clipsToBounds = true
        passwordField.textColor = UIColor.white
        passwordField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: passwordField.frame.height))
        passwordField.leftViewMode = UITextFieldViewMode.always
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.4)])
        
        signInButton.layer.cornerRadius = signInButton.frame.width / 20
        signInButton.clipsToBounds = true
        
        setupFontSize()
    }
    
    @IBAction func onClickSignIn(_ sender: UIButton) {
        dismissKeyboard()
        print("Inside sign in")
        if usernameField.text == nil || passwordField.text == nil || usernameField.text == "" || passwordField.text == "" {
            print("UsernameField.text and passwordField.text are not nil")
            APPUtilites.displayErrorSnackbar(message: "Username or password are empty")
            return
        }
        let usernameText = countryCodeField.text! + usernameField.text!
        print("usernameText: \(usernameText)")
        let authDetails = AWSCognitoIdentityPasswordAuthenticationDetails(username: usernameText, password: passwordField.text!)
        user?.getSession(usernameText, password: passwordField.text!, validationData: nil)
            .continueOnSuccessWith(block: { (task: AWSTask<AWSCognitoIdentityUserSession>) -> Any? in
                DispatchQueue.main.async(execute: {
                    if let result = task.result {
                        print("access token: \(result.accessToken)")
                        print("expiration time: \(result.expirationTime)")
                        print("id token: \(result.idToken)")
                        print(result.debugDescription)
                        self.gotoHomePage()
                    }
                })
                return nil
            })
            .continueWith(block: { (task: AWSTask<AnyObject>) -> Any? in
                DispatchQueue.main.async {
                    if let error = task.error as? NSError {
                        print("Error")
                        print(error)
                        if error.userInfo["__type"] as! String == "UserNotConfirmedException" {
                            self.gotoOTPPage()
                        }
                        APPUtilites.displayErrorSnackbar(message: error.userInfo["message"] as! String)
                    }
                }
                return nil
            })
    }
    
    func gotoHomePage() {
        performSegue(withIdentifier: GOTO_HOME_FROM_SIGN_IN, sender: self)
    }
    
    func gotoOTPPage() {
        performSegue(withIdentifier: GOTO_OTP_FROM_SIGN_IN, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == GOTO_OTP_FROM_SIGN_IN {
            let destinationVC = segue.destination as? SignUpOTPViewController
            
            let usernameText = countryCodeField.text! + usernameField.text!
            destinationVC?.username = usernameText
        }
    }
    
    @IBAction func gotoSignUp(_ sender: UIButton) {
        performSegue(withIdentifier: "signInToSignUp", sender: self)
    }
    
    @IBAction func gotoForgotPassword(_ sender: UIButton) {
        performSegue(withIdentifier: "gotoForgotPassword", sender: self)
    }
}

extension SignInViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
}

extension SignInViewController {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideKeyboardButton.isHidden = false
    }
}
