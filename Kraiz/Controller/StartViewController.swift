//
//  StartViewController.swift
//  StoryFi
//
//  Created by Kumar Agarwal, Kanhai on 11/06/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//
//  Starting View Controller.

import UIKit
import Reachability

class StartViewController: UIViewController {

    @IBOutlet weak var logoContainer: UIView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    var viewHeight : CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewHeight = view.frame.height
        
        checkInternetConnection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setButtonsCornerRadius()
        setButtonFontSize()
    }
    
//    override func viewDidLayoutSubviews() {
//        setButtonsCornerRadius()
//        setButtonFontSize()
//    }
    
    func checkInternetConnection() {
        let reachability = Reachability()
        if reachability?.connection == Reachability.Connection.none {
            APPUtilites.displayErrorSnackbar(message: "No Internet Connection")
            return
        }
    }
    
    @IBAction func onSignInClick(_ sender: UIButton) {
        performSegue(withIdentifier: "gotoSignIn", sender: self)
    }
    
    @IBAction func onSignUpClick(_ sender: UIButton) {
        performSegue(withIdentifier: "gotoSignUp", sender: self)
    }
    
    func setButtonsCornerRadius() {
        signInButton.clipsToBounds = true
        signInButton.layer.cornerRadius = signInButton.frame.height / 2
        
        signUpButton.layer.borderColor = UIColor.clear.cgColor
        signUpButton.layer.cornerRadius = signUpButton.frame.height / 2
        signUpButton.clipsToBounds = true
    }
    
    func setButtonFontSize() {
        switch viewHeight {
            case DeviceConstants.IPHONE5S_HEIGHT:
                signInButton.titleLabel?.font = UIFont(name: "Times New Roman", size: 20)
                signUpButton.titleLabel?.font = UIFont(name: "Times New Roman", size: 20)
                break
            case DeviceConstants.IPHONE7_HEIGHT:
                signInButton.titleLabel?.font = UIFont(name: "Times New Roman", size: 24)
                signUpButton.titleLabel?.font = UIFont(name: "Times New Roman", size: 24)
                break
            case DeviceConstants.IPHONE7PLUS_HEIGHT:
                signInButton.titleLabel?.font = UIFont(name: "Times New Roman", size: 30)
                signUpButton.titleLabel?.font = UIFont(name: "Times New Roman", size: 30)
                break
            case DeviceConstants.IPHONEX_HEIGHT:
                signInButton.titleLabel?.font = UIFont(name: "Times New Roman", size: 30)
                signUpButton.titleLabel?.font = UIFont(name: "Times New Roman", size: 30)
                break
            default:
                signInButton.titleLabel?.font = UIFont(name: "Times New Roman", size: 20)
                signUpButton.titleLabel?.font = UIFont(name: "Times New Roman", size: 20)
                break
        }
    }
}
