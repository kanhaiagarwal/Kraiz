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

    public var user: AWSCognitoIdentityUser?
    public var phoneNumber: String = ""
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
        typeOTPLabel.text = standardText + phoneNumber
        pool = AWSCognitoIdentityUserPool(forKey: "Kraiz")
        pool?.delegate = self
        user = pool?.getUser(username)
        print("User: \(String(describing: user?.getDetails()))")
        print("Device: \(String(describing: user?.getDevice()))")
    }

    @IBAction func onClickOTPButton(_ sender: UIButton) {
//        performSegue(withIdentifier: "gotoHomeFromSignUp", sender: self)
        print("Inside onClickOTPButton")
        print("OTP Entered: \(otpField.text)")
        if otpField.text == nil && otpField.text == "" {
            let emptyOTPMessage = TTGSnackbar()
            emptyOTPMessage.message = "OTP Field cannot be blank"
            emptyOTPMessage.backgroundColor = UIColor.red
            emptyOTPMessage.messageTextAlign = .center
            emptyOTPMessage.show()
            return
        } else {
            print("OTP is not empty")
        }
        
        self.user?.confirmSignUp(otpField.text!)
            .continueOnSuccessWith(block: { (task: AWSTask<AWSCognitoIdentityUserConfirmSignUpResponse>) -> Any? in
                DispatchQueue.main.async(execute: {
                    print("************************************************************")
                    print("Sign Up has been confirmed")
                    self.gotoHomePage()
                })
                return nil
            }).continueWith(block: { (task: AWSTask<AnyObject>) -> Any? in
                DispatchQueue.main.async(execute: {
                    if let error = task.error as? NSError {
                        print("Error")
                        print(error)
                        APPUtilites.displayErrorSnackbar(message: "Wrong OTP Entered. Please enter the correct OTP")
                    }
                })
                return nil
            })
    }
    
    func gotoHomePage() {
        performSegue(withIdentifier: GOTO_HOME_PAGE, sender: self)
    }
    
    @IBAction func onClickResendOTP(_ sender: UIButton) {
        user?.resendConfirmationCode().continueOnSuccessWith(block: { (task: AWSTask<AWSCognitoIdentityUserResendConfirmationCodeResponse>) -> Any? in
            DispatchQueue.main.async(execute: {
                APPUtilites.displaySuccessSnackbar(message: "The confirmation code has been sent again to " + self.phoneNumber)
            })
            return nil
        }).continueWith(block: { (task: AWSTask<AnyObject>) -> Any? in
            DispatchQueue.main.async(execute: {
                if let error = task.error as? NSError {
                    print(error.debugDescription)
                    APPUtilites.displayErrorSnackbar(message: "Error in sending the code. Please try again")
                }
            })
            return nil
        })
    }
}
