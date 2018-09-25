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
    public var password: String = ""
    var pool: AWSCognitoIdentityUserPool?
    
    let standardText = "Please type the OTP sent to your number "
    
    @IBOutlet weak var typeOTPLabel: UITextView!
    @IBOutlet weak var otpField: UITextField!
    @IBOutlet weak var otpButton: UIButton!
    @IBOutlet weak var resendOTPButton: UIButton!
    
    // Segues
    let GOTO_HOME_PAGE: String = "gotoHomeFromSignUp"
    
    let OTP_LENGTH = 6
    let PLACEHOLDER_COLOR = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.4)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        typeOTPLabel.text = standardText + username
        pool = AWSCognitoIdentityUserPool(forKey: AWSConstants.COGNITO_USER_POOL_NAME)
        pool?.delegate = self
    self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViews()
        otpField.becomeFirstResponder()
    }
    
    func setupViews() {
        otpField.layer.cornerRadius = otpField.frame.height / 2
        otpField.clipsToBounds = true
        otpField.setPadding(left: 10, right: 10)
        otpField.attributedPlaceholder = NSAttributedString(string: "OTP", attributes: [NSAttributedStringKey.foregroundColor: PLACEHOLDER_COLOR])
        
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
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickOTPButton(_ sender: UIButton) {
        dismissKeyboard()
        if otpField.text == nil || otpField.text == "" {
            APPUtilites.displayErrorSnackbar(message: "OTP Field cannot be blank")
            return
        } else if (otpField.text?.count)! != OTP_LENGTH {
            APPUtilites.displayErrorSnackbar(message: "OTP must be of \(OTP_LENGTH) digits")
            return
        }

        let sv = APPUtilites.displayLoadingSpinner(onView: self.view)
        CognitoHelper.shared.verifyOTPForSignUp(pool: pool!, user: self.cognitoUser!, otp: otpField.text!, success: {
            APPUtilites.removeLoadingSpinner(spinner: sv)
            UserDefaults.standard.set(false, forKey: DeviceConstants.IS_PROFILE_PRESENT)
            CognitoHelper.shared.signIn(pool: self.pool!, usernameText: self.username, passwordText: self.password, success: {
                let currentUser = self.pool?.currentUser()
                CognitoHelper.shared.currentUser = currentUser!
                if let userId = currentUser?.username {
                    UserDefaults.standard.set(userId, forKey: DeviceConstants.USER_ID)
                    AppSyncHelper.shared.setAppSyncClient()
                    self.setMobileNumberInUserDefaults()
                }
                self.gotoHomePage()
            }, failure: { (error) in
                APPUtilites.displayErrorSnackbar(message: "Error in Sign In after Sign Up")
            })
        }) { (error: NSError) in
            print(error)
            APPUtilites.removeLoadingSpinner(spinner: sv)
            if String(describing: error.userInfo["__type"]!) == "NoInternetConnectionException" {
                APPUtilites.displayErrorSnackbar(message: "No Internet Connection")
            } else {
                APPUtilites.displayErrorSnackbar(message: "Wrong OTP Entered. Please enter the correct OTP")
            }
        }
    }
    
    func setMobileNumberInUserDefaults() {
        print("Inside setMobileNumberInUserDefaults")
        pool?.currentUser()?.getDetails().continueOnSuccessWith(block: { (task: AWSTask<AWSCognitoIdentityUserGetDetailsResponse>) -> Any? in
            print("Inside constinueOnSuccessWith of setMobileNumberInUserDefaults")
            if let taskResult = task.result {
                print("taskResult is not nil inside setMobileNumberInUserDefaults")
                if let userAttributes = taskResult.userAttributes {
                    print("userAttributes is not nil inside setMobileNumberInUserDefaults")
                    for i in 0 ..< userAttributes.count {
                        if userAttributes[i].name == "phone_number" {
                            UserDefaults.standard.set(userAttributes[i].value!, forKey: DeviceConstants.MOBILE_NUMBER)
                            break
                        }
                    }
                }
            }
            return nil
        })
    }
    
    func gotoHomePage() {
        let homePageVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeTabBarController")
        self.navigationController?.pushViewController(homePageVC!, animated: true)
    }
    
    @IBAction func onClickResendOTP(_ sender: UIButton) {
        dismissKeyboard()
        let sv = APPUtilites.displayLoadingSpinner(onView: self.view)
        
        CognitoHelper.shared.resendOTPForSignUp(pool: pool!, user: self.cognitoUser!, success: {
            APPUtilites.removeLoadingSpinner(spinner: sv)
            APPUtilites.displaySuccessSnackbar(message: "The confirmation code has been sent again to " + self.username)
        }) { (error: NSError) in
            APPUtilites.removeLoadingSpinner(spinner: sv)
            print(error.debugDescription)
            if String(describing: error.userInfo["__type"]!) == "NoInternetConnectionException" {
                APPUtilites.displayErrorSnackbar(message: "No Internet Connection")
            } else {
                APPUtilites.displayErrorSnackbar(message: "OTP could not be sent. Please try again")
            }
        }
    }
}

extension SignUpOTPViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
