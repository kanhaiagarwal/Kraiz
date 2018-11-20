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
class MyVibeViewController: UIViewController, UITextFieldDelegate {

    let musicList = ["Shab Tum Ho", "Binte Dil", "Tere Khair Mang Di", "Dil Chahta Hai", "Ruk Jaana Nahi"]
    
    let countryCodePicker = UIPickerView()
    let vibeCategoryPicker = UIPickerView()
    let musicPicker = UIPickerView()
    var countryCodeSelected : String?
    var vibeCategorySelected : String?
    var musicSelected : String?
    let GRADIENT_TOP_COLOR = UIColor(displayP3Red: 230/255, green: 158/255, blue: 55/255, alpha: 1.0)
    let GRADIENT_BOTTOM_COLOR = UIColor(displayP3Red: 227/255, green: 121/255, blue: 11/255, alpha: 1.0)
    
    @IBOutlet weak var musicArrowLabel: UILabel!
    @IBOutlet weak var musicContainer: UITextField!
    @IBOutlet weak var playImageView: UIImageView!
    @IBOutlet weak var detailsContainer: CardView!
    @IBOutlet weak var usernameFieldLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var usernameFieldTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var countryCodeField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var vibeCategoryField: UITextField!
    @IBOutlet weak var musicField: UITextField!
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
        countryCodePicker.tag = 0
        vibeCategoryPicker.tag = 1
        musicPicker.tag = 2

        musicPicker.delegate = self
        countryCodePicker.delegate = self
        vibeCategoryPicker.delegate = self
        usernameField.delegate = self
        vibeNameField.delegate = self
        
        createToolbarForPickerView()
        addGestureToContactListIcon()

        countryCodeSelected = CountryCodes.countryCodes[0]
        countryCodeField.text = countryCodeSelected!
        vibeCategorySelected = VibeCategories.pickerStrings[0]
        vibeCategoryField.text = vibeCategorySelected
        musicSelected = musicList[0]
        musicField.text = musicSelected
        countryCodeField.inputView = countryCodePicker
        vibeCategoryField.inputView = vibeCategoryPicker
        musicField.inputView = musicPicker

        musicContainer.isHidden = true
        musicField.isHidden = true
        musicArrowLabel.isHidden = true
        playImageView.isHidden = true
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
        if backgroundMusicSwitch.isOn {
            musicContainer.isHidden = false
            musicField.isHidden = false
            musicArrowLabel.isHidden = false
            playImageView.isHidden = false
        } else {
            musicContainer.isHidden = true
            musicField.isHidden = true
            musicArrowLabel.isHidden = true
            playImageView.isHidden = true
        }
    }
    
    @IBAction func anonymousSwitchPressed(_ sender: UISwitch) {
        isAnonymousEnabled = sender.isOn
        print("isAnonymous: \(isAnonymousEnabled)")
    }
    @IBAction func nextPressed(_ sender: UIButton) {
        performSegue(withIdentifier: DeviceConstants.GOTO_CREATE_VIBE_FROM_VIBE_DETAILS, sender: self)
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    /// Event triggered when value inside the username field changes.
//    @IBAction func onChangeUsername(_ sender: UITextField) {
//        if Int(sender.text!) != nil && !isUsernameInputNumbers {
//            displayCountryCodeTextField()
//
//        } else if Int(sender.text!) == nil && isUsernameInputNumbers {
//            removeCountryCodeTextField()
//            print("alpha numeric values inside the username textfield")
//        }
//    }
    
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
        vibeCategoryField.inputAccessoryView = toolbar
        musicField.inputAccessoryView = toolbar
        usernameField.inputAccessoryView = toolbar
        vibeNameField.inputAccessoryView = toolbar
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
        if pickerView.tag == 0 {
            return CountryCodes.countryCodes.count
        } else if pickerView.tag == 1 {
            return VibeCategories.pickerStrings.count
        } else if pickerView.tag == 2 {
            return musicList.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return CountryCodes.pickerStrings[row]
        } else if pickerView.tag == 1 {
            return VibeCategories.pickerStrings[row]
        } else if pickerView.tag == 2 {
            return musicList[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            countryCodeSelected = CountryCodes.countryCodes[row]
            countryCodeField.text = countryCodeSelected
        } else if pickerView.tag == 1 {
            vibeCategorySelected = VibeCategories.pickerStrings[row]
            vibeCategoryField.text = vibeCategorySelected
        } else if pickerView.tag == 2 {
            musicSelected = musicList[row]
            musicField.text = musicSelected
        }
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
