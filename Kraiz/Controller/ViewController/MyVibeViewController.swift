//
//  MyVibeViewController.swift
//  Kraiz
//
//  Created by Kumar Agarwal, Kanhai on 19/08/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit
import TTGSnackbar
import ContactsUI
import AVFoundation

protocol VibeDetails {
    func setVibeDetails(vibeName: String, toUser: String, isAnonymous: Bool, isBackgroundAudioEnabled: Bool, backgroundAudio: URL)
}
class MyVibeViewController: UIViewController {

    let countryCodePicker = UIPickerView()
    var countryCodeSelected : String?
    let GRADIENT_TOP_COLOR = UIColor(displayP3Red: 230/255, green: 158/255, blue: 55/255, alpha: 1.0)
    let GRADIENT_BOTTOM_COLOR = UIColor(displayP3Red: 227/255, green: 121/255, blue: 11/255, alpha: 1.0)
    
    @IBOutlet weak var usernameFieldLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var usernameFieldTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var countryCodeField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var contactListIcon: UIImageView!
    @IBOutlet weak var vibeNameField: UITextField!
    @IBOutlet weak var backgroundMusicSwitch: UISwitch!
    @IBOutlet weak var anonymousSwitch: UISwitch!
    @IBOutlet weak var nextButton: UIButton!
    
    var isUsernameInputNumbers : Bool = false
    var isAnonymousEnabled : Bool = false
    
    let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryCodePicker.delegate = self
        removeCountryCodeTextField()
        createToolbarForPickerView()
        addGestureToContactListIcon()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNextButton()
    }
    
    override func viewDidLayoutSubviews() {
        gradientLayer.frame = nextButton.bounds
    }
    
    func addGestureToContactListIcon() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(contactListPressed))
        contactListIcon.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func backgroundMusicSwitchPressed(_ sender: UISwitch) {
    }
    
    @IBAction func anonymousSwitchPressed(_ sender: UISwitch) {
        isAnonymousEnabled = sender.isOn
        print("isAnonymous: \(isAnonymousEnabled)")
    }
    @IBAction func nextPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// Event triggered when value inside the username field changes.
    @IBAction func onChangeUsername(_ sender: UITextField) {
        if Int(sender.text!) != nil && !isUsernameInputNumbers {
            displayCountryCodeTextField()
            
        } else if Int(sender.text!) == nil && isUsernameInputNumbers {
            removeCountryCodeTextField()
            print("alpha numeric values inside the username textfield")
        }
    }
    
    /// Displays the country code field when the text is totally numeric.
    func displayCountryCodeTextField() {
        countryCodeField.isHidden = false
        isUsernameInputNumbers = true
        usernameFieldLeadingConstraint.constant = 70
        
        countryCodeSelected = "+91"
        countryCodeField.text = "+91"
        countryCodeField.textAlignment = .center
        countryCodeField.adjustsFontSizeToFitWidth = true
        countryCodeField.minimumFontSize = 14
        countryCodeField.inputView = countryCodePicker
    }
    
    /// Removes the country code field when the text is totally alpha-numeric.
    func removeCountryCodeTextField() {
        countryCodeField.isHidden = true
        isUsernameInputNumbers = false
        usernameFieldLeadingConstraint.constant = 20
    }
    
    /// Creates a toolbar for the picker view to choose the country code for the Username.
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
    
    /// Give styles to the next button.
    func setupNextButton() {
        nextButton.layer.cornerRadius = 10
        nextButton.clipsToBounds = true

        gradientLayer.frame = nextButton.bounds
        gradientLayer.colors = [GRADIENT_TOP_COLOR.cgColor, GRADIENT_BOTTOM_COLOR.cgColor]
        nextButton.layer.insertSublayer(gradientLayer, above: nil)
    }
}

extension MyVibeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
}

extension MyVibeViewController: CNContactPickerDelegate {
    @objc func contactListPressed() {
        let entity = CNEntityType.contacts
        let authorizationStatus = CNContactStore.authorizationStatus(for: entity)
        
        if authorizationStatus == CNAuthorizationStatus.notDetermined {
            let contactStore = CNContactStore.init()
            contactStore.requestAccess(for: entity, completionHandler: { (success, error) in
                if success {
                    self.openContacts()
                } else {
                    print("Not Auhtorized")
                }
            })
        } else if authorizationStatus == CNAuthorizationStatus.authorized {
            openContacts()
        }
    }
    
    func openContacts() {
        let contactPicker = CNContactPickerViewController.init()
        contactPicker.delegate = self
        self.present(contactPicker, animated: true, completion: nil)
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    /// When the user selects the contact
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        var contactNumber = contact.phoneNumbers[0].value.stringValue
        contactNumber = contactNumber.replacingOccurrences(of: "-", with: "")
        contactNumber = contactNumber.replacingOccurrences(of: " ", with: "")
        contactNumber = contactNumber.replacingOccurrences(of: "+", with: "")
        contactNumber = contactNumber.replacingOccurrences(of: "(", with: "")
        contactNumber = contactNumber.replacingOccurrences(of: ")", with: "")
        usernameField.text = contactNumber
        displayCountryCodeTextField()
        picker.dismiss(animated: true, completion: nil)
    }
}
