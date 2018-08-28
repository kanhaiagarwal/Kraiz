//
//  StartForgotPasswordViewController.swift
//  StoryFi
//
//  Created by Kumar Agarwal, Kanhai on 14/06/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//
// Class For the Forgot Password View.

import UIKit
import AWSCognitoIdentityProvider

class ForgotPasswordViewController: UIViewController, UIPickerViewDelegate, AWSCognitoIdentityInteractiveAuthenticationDelegate {
    
    @IBOutlet weak var countryCodeField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var generateOTPButton: UIButton!
    
    let countryCodePicker = UIPickerView()
    var countryCodeSelected : String?
    
    var pool: AWSCognitoIdentityUserPool?
    var user: AWSCognitoIdentityUser?
    
    /// Segues
    let FORGOT_PASSWORD_OTP_SEGUE = "gotoEnterOTPFromForgotPassword"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pool = AWSCognitoIdentityUserPool(forKey: "Kraiz-2")
        pool?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViews()
        
        countryCodePicker.delegate = self
        countryCodeField.inputView = countryCodePicker
        countryCodeField.text = "+91"
        createToolbarForTextField(textField: countryCodeField)
        createToolbarForTextField(textField: phoneNumberField)
        
    }
    
    func setupViews() {
        phoneNumberField.layer.cornerRadius = phoneNumberField.frame.height / 2
        phoneNumberField.clipsToBounds = true
        phoneNumberField.textColor = UIColor.white
        phoneNumberField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: phoneNumberField.frame.height))
        phoneNumberField.leftViewMode = UITextFieldViewMode.always
        phoneNumberField.attributedPlaceholder = NSAttributedString(string: "Mobile Number", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        countryCodeField.clipsToBounds = true
        countryCodeField.layer.cornerRadius = countryCodeField.frame.height / 2
        
        generateOTPButton.clipsToBounds = true
        generateOTPButton.layer.cornerRadius = generateOTPButton.frame.height / 2
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
        view.endEditing(true)
    }
    
    @IBAction func otpButtonPressed(_ sender: UIButton) {
        if phoneNumberField.text == nil || phoneNumberField.text == "" {
            APPUtilites.displayErrorSnackbar(message: "Mobile Number cannot be blank")
        }
        let username = countryCodeField.text! +
             phoneNumberField.text!
        
        self.user = pool?.getUser(username)
        
        CognitoHelper.shared.forgotPassword(user: user!, success: {
            self.gotoForgotPasswordOTPPage()
        }) { (error: NSError) in
            print(error)
            let errorType = error.userInfo["__type"] as! String
            if  errorType == "LimitExceededException" {
                APPUtilites.displayErrorSnackbar(message: "You have exceeded the number of retries. Please try again after sometime")
            } else if errorType == "UserNotFoundException" {
                APPUtilites.displayErrorSnackbar(message: "User with this mobile number does not exist")
            }
        }
    }
    
    @IBAction func onBackClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func gotoForgotPasswordOTPPage() {
        performSegue(withIdentifier: FORGOT_PASSWORD_OTP_SEGUE, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == FORGOT_PASSWORD_OTP_SEGUE {
            let destinationVC = segue.destination as? ForgotPasswordOTPViewController
            destinationVC?.user = user!
            destinationVC?.username = countryCodeField.text! + phoneNumberField.text!
        }
    }
}

extension ForgotPasswordViewController: UIPickerViewDataSource, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CountryCodes.countryCodes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return CountryCodes.pickerStrings[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        countryCodeSelected = CountryCodes.countryCodes[row]
        countryCodeField.text = countryCodeSelected
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
