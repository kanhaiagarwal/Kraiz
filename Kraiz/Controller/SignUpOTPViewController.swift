//
//  StartSignUpOTPViewController.swift
//  StoryFi
//
//  Created by Kumar Agarwal, Kanhai on 30/06/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//
//  Class for the OTP View for Sign Up.

import UIKit

class SignUpOTPViewController: UIViewController {

    @IBOutlet weak var otpButton: UIButton!
    @IBOutlet weak var resendOTPButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onClickOTPButton(_ sender: UIButton) {
        performSegue(withIdentifier: "gotoHomeFromSignUp", sender: self)
    }
    
    @IBAction func onClickResendOTP(_ sender: UIButton) {
    }
}
