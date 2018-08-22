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
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var usernameContainer: UIView!
    @IBOutlet weak var usernameFieldLeadingConstraint: NSLayoutConstraint!
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
        countryCodePicker.delegate = self
        
        pool = AWSCognitoIdentityUserPool(forKey: "Kraiz")
        user = pool?.getUser()
        pool?.delegate = self
    }

    @IBAction func onChangeUsername(_ sender: UITextField) {
        
         if Int(sender.text!) != nil && !isUsernameInputNumbers {
            isUsernameInputNumbers = true
            usernameFieldLeadingConstraint.constant = 100
            print("numbers inside the username textfield")
            displayCountryCodeTextField()
            
        } else if Int(sender.text!) == nil && isUsernameInputNumbers {
            isUsernameInputNumbers = false

            usernameFieldLeadingConstraint.constant = 50
            removeCountryCodeTextField()
            print("alpha numeric values inside the username textfield")
        }
    }
    
    
    // TODO: Fix the case when the user inputs the +9
    // Then the country code dropdown appears.
    // The country code picker should not appear when the user inputs the +9 something.
    func displayCountryCodeTextField() {
        countryCodeTextField = UITextField(frame: CGRect(x: usernameField.frame.minX, y: usernameField.frame.minY, width: 50, height: usernameField.frame.height))
        countryCodeSelected = "+91"
        countryCodeTextField.text = "+91"
        countryCodeTextField.textAlignment = .center
        countryCodeTextField.adjustsFontSizeToFitWidth = true
        countryCodeTextField.minimumFontSize = 14
        countryCodeTextField.inputView = countryCodePicker
        createToolbarForPickerView()
        countryCodeTextField.layer.cornerRadius = countryCodeTextField.frame.height / 10
        countryCodeTextField.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.24)
        countryCodeTextField.textColor = UIColor.white
        usernameContainer.addSubview(countryCodeTextField)
    }
    
    func removeCountryCodeTextField() {
        countryCodeTextField.removeFromSuperview()
    }
    
    func createToolbarForPickerView() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.dismissKeyboard))
        
        
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        countryCodeTextField.inputAccessoryView = toolbar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupFontSize() {
        switch viewHeight {
        case DeviceConstants.IPHONE5S_HEIGHT:
            usernameField.font = UIFont(name: "Times New Roman", size: 20)
            passwordField.font = UIFont(name: "Times New Roman", size: 20)
            break
        case DeviceConstants.IPHONE7_HEIGHT:
            usernameField.font = UIFont(name: "Times New Roman", size: 22)
            passwordField.font = UIFont(name: "Times New Roman", size: 22)
            break
        case DeviceConstants.IPHONE7PLUS_HEIGHT:
            usernameField.font = UIFont(name: "Times New Roman", size: 26)
            passwordField.font = UIFont(name: "Times New Roman", size: 26)
            break
        case DeviceConstants.IPHONEX_HEIGHT:
            usernameField.font = UIFont(name: "Times New Roman", size: 26)
            passwordField.font = UIFont(name: "Times New Roman", size: 26)
        default:
            usernameField.font = UIFont(name: "Times New Roman", size: 20)
            passwordField.font = UIFont(name: "Times New Roman", size: 20)
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
        print("Inside sign in")
        if usernameField.text == nil || passwordField.text == nil || usernameField.text == "" || passwordField.text == "" {
            print("UsernameField.text and passwordField.text are not nil")
            APPUtilites.displayErrorSnackbar(message: "Username or password are empty")
            return
        }
        let authDetails = AWSCognitoIdentityPasswordAuthenticationDetails(username: usernameField.text!, password: passwordField.text!)
        user?.getSession(usernameField.text!, password: passwordField.text!, validationData: nil)
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
            destinationVC?.username = usernameField.text!
            destinationVC?.phoneNumber = "+919003194776"
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
        countryCodeTextField.text = countryCodeSelected
    }
}
