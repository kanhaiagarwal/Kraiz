//
//  StartViewController.swift
//  StoryFi
//
//  Created by Kumar Agarwal, Kanhai on 11/06/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//
//  Starting View Controller.

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var logoContainer: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleContainer: UIView!
    @IBOutlet weak var appTitle: UILabel!
    @IBOutlet weak var tagLineContainer: UILabel!
    @IBOutlet weak var tagLine: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    var viewHeight : CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMainViewHeight()
        setFonts()
        setButtonsCornerRadius()
        setButtonFontSize()
    }
    
    @IBAction func onSignInClick(_ sender: UIButton) {
        performSegue(withIdentifier: "gotoSignIn", sender: self)
    }
    
    @IBAction func onSignUpClick(_ sender: UIButton) {
        performSegue(withIdentifier: "gotoSignUp", sender: self)
    }
    
    func setFonts() {
        switch viewHeight {
            case DeviceConstants.IPHONE5S_HEIGHT:
                appTitle.font = UIFont(name: "Times New Roman", size: 50)
                tagLine.font = UIFont(name: "Times New Roman", size: 20)
                break
            case DeviceConstants.IPHONE7_HEIGHT:
                appTitle.font = UIFont(name: "Times New Roman", size: 60)
                tagLine.font = UIFont(name: "Times New Roman", size: 24)
                break
            case DeviceConstants.IPHONE7PLUS_HEIGHT:
                appTitle.font = UIFont(name: "Times New Roman", size: 60)
                tagLine.font = UIFont(name: "Times New Roman", size: 28)
                break
            case DeviceConstants.IPHONEX_HEIGHT:
                appTitle.font = UIFont(name: "Times New Roman", size: 60)
                tagLine.font = UIFont(name: "Times New Roman", size: 28)
            default:
                appTitle.font = UIFont(name: "Times New Roman", size: 50)
                tagLine.font = UIFont(name: "Times New Roman", size: 20)
                break
        }
    }
    
    func setMainViewHeight() {
        viewHeight = view.frame.height
    }
    
    func setButtonsCornerRadius() {
        switch viewHeight {
        case DeviceConstants.IPHONE5S_HEIGHT:
            signInButton.layer.cornerRadius = signInButton.frame.width / 50
            signUpButton.layer.cornerRadius = signInButton.frame.width / 50
            break
        case DeviceConstants.IPHONE7_HEIGHT:
            signInButton.layer.cornerRadius = signInButton.frame.width / 30
            signUpButton.layer.cornerRadius = signInButton.frame.width / 30
            break
        case DeviceConstants.IPHONE7PLUS_HEIGHT:
            signInButton.layer.cornerRadius = signInButton.frame.width / 20
            signUpButton.layer.cornerRadius = signInButton.frame.width / 20
            break
        case DeviceConstants.IPHONEX_HEIGHT:
            signInButton.layer.cornerRadius = signInButton.frame.width / 20
            signUpButton.layer.cornerRadius = signInButton.frame.width / 20
            break
        default:
            appTitle.font = UIFont(name: "Times New Roman", size: 50)
            tagLine.font = UIFont(name: "Times New Roman", size: 20)
            break
        }
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
