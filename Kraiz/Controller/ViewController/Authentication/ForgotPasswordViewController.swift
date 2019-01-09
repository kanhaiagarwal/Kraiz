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
    
    let PLACEHOLDER_COLOR = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.4)

    var viewHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pool = AWSCognitoIdentityUserPool(forKey: "Kraiz-2")
        pool?.delegate = self
    self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
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
        phoneNumberField.leftViewMode = UITextField.ViewMode.always
        phoneNumberField.attributedPlaceholder = NSAttributedString(string: "Mobile Number", attributes: [NSAttributedString.Key.foregroundColor: PLACEHOLDER_COLOR])
        countryCodeField.clipsToBounds = true
        countryCodeField.layer.cornerRadius = countryCodeField.frame.height / 2
        
        generateOTPButton.clipsToBounds = true
        generateOTPButton.layer.cornerRadius = generateOTPButton.frame.height / 2
        
        viewHeight = view.frame.height
        setupFontSize()
    }

    func setupFontSize() {
        switch viewHeight {
        case DeviceConstants.IPHONE5S_HEIGHT:
            countryCodeField.font = UIFont(name: "Helvetica Neue", size: 20)
            phoneNumberField.font = UIFont(name: "Helvetica Neue", size: 20)
            break
        case DeviceConstants.IPHONE7_HEIGHT:
            phoneNumberField.font = UIFont(name: "Helvetica Neue", size: 22)
            countryCodeField.font = UIFont(name: "Helvetica Neue", size: 22)
            break
        case DeviceConstants.IPHONE7PLUS_HEIGHT:
            phoneNumberField.font = UIFont(name: "Helvetica Neue", size: 26)
            countryCodeField.font = UIFont(name: "Helvetica Neue", size: 26)
            break
        case DeviceConstants.IPHONEX_HEIGHT:
            phoneNumberField.font = UIFont(name: "Helvetica Neue", size: 22)
            countryCodeField.font = UIFont(name: "Helvetica Neue", size: 22)
            break
        default:
            phoneNumberField.font = UIFont(name: "Helvetica Neue", size: 22)
            countryCodeField.font = UIFont(name: "Helvetica Neue", size: 22)
            break
        }
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
        dismissKeyboard()
        if phoneNumberField.text == nil || phoneNumberField.text == "" {
            APPUtilites.displayErrorSnackbar(message: "Mobile Number cannot be blank")
            return
        }
        let username = countryCodeField.text! +
             phoneNumberField.text!
        
        self.user = pool?.getUser(username)
        
        let sv = APPUtilites.displayLoadingSpinner(onView: self.view)
        CognitoHelper.shared.forgotPassword(user: user!, success: {
            APPUtilites.removeLoadingSpinner(spinner: sv)
            self.gotoForgotPasswordOTPPage()
        }) { (error: NSError) in
            APPUtilites.removeLoadingSpinner(spinner: sv)
            print(error)
            let errorType = error.userInfo["__type"] as! String
            if errorType == "NoInternetConnectionException" {
                APPUtilites.displayErrorSnackbar(message: "No Internet Connection")
            } else if  errorType == "LimitExceededException" {
                APPUtilites.displayErrorSnackbar(message: "You have exceeded maximum number of failed attempts.Please try again later")
            } else if errorType == "UserNotFoundException" {
                APPUtilites.displayErrorSnackbar(message: "Mobile number is not registered")
            } else if errorType == "InvalidParameterException" {
                APPUtilites.displayErrorSnackbar(message: "Mobile Number not verified or incorrect")
            }
        }
    }
    
    @IBAction func onBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
