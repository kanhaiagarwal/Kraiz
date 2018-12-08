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

protocol VibeDetailsProtocol {
    func setVibeDetails(vibeModel: VibeModel)
}
class MyVibeViewController: UIViewController, UITextFieldDelegate, AVAudioPlayerDelegate {
    
    let countryCodePicker = UIPickerView()
    let vibeCategoryPicker = UIPickerView()
    let musicPicker = UIPickerView()
    var countryCodeSelected : String?
    var vibeCategorySelected : Int?
    var vibeTypeSelected : Int?
    var musicSelected : Int?
    let GRADIENT_TOP_COLOR = UIColor(displayP3Red: 230/255, green: 158/255, blue: 55/255, alpha: 1.0)
    let GRADIENT_BOTTOM_COLOR = UIColor(displayP3Red: 227/255, green: 121/255, blue: 11/255, alpha: 1.0)
    let PLAY_IMAGE = "recorder-play-enabled"
    let PAUSE_IMAGE = "recorder-pause"
    
    @IBOutlet weak var detailsContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var phoneNumberIcon: UIImageView!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var vibeTypeSegment: UISegmentedControl!
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
    @IBOutlet weak var nextButton: UIButton!
    
    var audioPlayer : AVAudioPlayer!
    var delegate : VibeDetailsProtocol?
    
    var isUsernameInputNumbers : Bool = false
    var isAnonymousEnabled : Bool = false
    
    let gradientLayer = CAGradientLayer()
    
    var vibeModel = VibeModel()
    var isSourceCreateVibe = false
    var isAudioPlaying = false
    
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
        
        // Set the Vibe Type Segment during the loading of the view.
        vibeTypeSelected = vibeModel.type
        vibeTypeSegment.selectedSegmentIndex = vibeModel.type

        // Set the mobile number field during the loading of the view.
        if vibeModel.to == "" {
            displayCountryCodeTextField()
            usernameField.text = nil
        } else {
            removeCountryCodeTextField()
            usernameField.text = vibeModel.to
        }
        
        // Set the vibe name field during the loading of the view.
        if vibeModel.vibeName == "" {
            vibeNameField.text = nil
        } else {
            vibeNameField.text = vibeModel.vibeName
        }
        
        countryCodeSelected = CountryCodes.countryCodes[0]
        countryCodeField.text = countryCodeSelected!
        vibeCategorySelected = 0
        vibeCategoryField.text = VibeCategories.pickerStrings[vibeCategorySelected!]
        countryCodeField.inputView = countryCodePicker
        vibeCategoryField.inputView = vibeCategoryPicker
        musicField.inputView = musicPicker
        
        // Make the play image view tappable to play the audio
        addGestureToPlayIcon()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        // Set the Vibe Category field during load. This is set here because the category was not getting updated in the view in viewDidLoad().
        vibeCategoryPicker.selectRow(vibeModel.category, inComponent: 0, animated: false)
        vibeCategorySelected = vibeModel.category
        vibeCategoryField.text = VibeCategories.pickerStrings[vibeModel.category]
        
        // Set the background music selected during load. This is set here because the music field was not getting updated in the view in viewDidLoad()
        // Set the background music field during load.
        if vibeModel.isBackgroundMusicEnabled {
            backgroundMusicSwitch.isOn = true
            musicField.isHidden = false
            musicField.text = BackgroundMusic.musicList[vibeModel.backgroundMusicIndex]
            musicSelected = vibeModel.backgroundMusicIndex
            musicArrowLabel.isHidden = false
            playImageView.isHidden = false
        } else {
            backgroundMusicSwitch.isOn = false
            musicField.isHidden = true
            musicSelected = 0
            musicField.text = BackgroundMusic.musicFiles[musicSelected!]
            musicArrowLabel.isHidden = true
            playImageView.isHidden = true
        }
        
        vibeTypeSegment.selectedSegmentIndex = vibeModel.type
        setupNextButton()
        setUsernameVisibility()
    }

    @IBAction func vibeTypePressed(_ sender: UISegmentedControl) {
        setUsernameVisibility()
    }
    
    func setUsernameVisibility() {
        // If the selected index is Friends, then show receiver fields
        if vibeTypeSegment.selectedSegmentIndex == 0 {
            toLabel.isHidden = false
            contactListIcon.isHidden = false
            phoneNumberIcon.isHidden = false
            usernameField.isHidden = false
            if usernameField.text == nil || (usernameField.text != nil && usernameField.text!.starts(with: "+")) {
                removeCountryCodeTextField()
            } else {
                displayCountryCodeTextField()
            }
        } else {
            toLabel.isHidden = true
            phoneNumberIcon.isHidden = true
            countryCodeField.isHidden = true
            usernameField.isHidden = true
            contactListIcon.isHidden = true
        }
    }

    @IBAction func musicFieldTapped(_ sender: Any) {
        print("music field editing began")
        if audioPlayer != nil && audioPlayer.isPlaying {
            isAudioPlaying = false
            audioPlayer.pause()
            playImageView.image = UIImage(named: PLAY_IMAGE)
        }
    }

    func addGestureToPlayIcon() {
        let playTapGesture = UITapGestureRecognizer(target: self, action: #selector(playImageTapped))
        playImageView.addGestureRecognizer(playTapGesture)
    }
    
    @objc func playImageTapped() {
        if isAudioPlaying {
            playImageView.image = UIImage(named: PLAY_IMAGE)
            pauseAudio()
        } else {
            let url = APPUtilites.getUrlForFileName(fileName: BackgroundMusic.musicFiles[musicSelected!], type: "mp3")
            if url != nil {
                playAudioForUrl(url: url!)
            } else {
                print("File not found for the file name \(BackgroundMusic.musicFiles[musicSelected!]) of type .mp3")
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        gradientLayer.frame = nextButton.bounds
        
    }
    
    func addGestureToContactListIcon() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(contactListPressed))
        contactListIcon.addGestureRecognizer(tapGesture)
    }
    
    func playAudioForUrl(url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            playImageView.image = UIImage(named: PAUSE_IMAGE)
            isAudioPlaying = true
        } catch {
            print("Error in playing the audio. Please try again!!")
        }
    }
    
    func playAudio() {
        if audioPlayer != nil {
            isAudioPlaying = true
            audioPlayer.play()
        }
    }
    
    func pauseAudio() {
        if audioPlayer != nil && audioPlayer.isPlaying {
            isAudioPlaying = false
            playImageView.image = UIImage(named: PLAY_IMAGE)
            audioPlayer.pause()
        }
    }
    
    func stopAudio() {
        if audioPlayer != nil && audioPlayer.isPlaying {
            isAudioPlaying = false
            playImageView.image = UIImage(named: PLAY_IMAGE)
            audioPlayer.stop()
        }
    }
    
    @IBAction func backgroundMusicSwitchPressed(_ sender: UISwitch) {
        if backgroundMusicSwitch.isOn {
            musicContainer.isHidden = false
            musicField.isHidden = false
            musicArrowLabel.isHidden = false
            playImageView.isHidden = false
        } else {
            stopAudio()
            musicContainer.isHidden = true
            musicField.isHidden = true
            musicArrowLabel.isHidden = true
            playImageView.isHidden = true
        }
    }

    @IBAction func nextPressed(_ sender: UIButton) {
        if vibeTypeSegment.selectedSegmentIndex == 0 {
            if usernameField.text == nil || usernameField.text == "" {
                APPUtilites.displayErrorSnackbar(message: "The phone number cannot be empty")
                return
            }
            
            if !usernameField.text!.starts(with: "+") {
                APPUtilites.displayErrorSnackbar(message: "Please make sure you are giving a valid mobile number")
                return
            }
        }
        if vibeNameField.text == nil || vibeNameField.text == "" {
            APPUtilites.displayErrorSnackbar(message: "The Vibe Name cannot be nil")
            return
        }

        vibeModel.setVibeType(type: vibeTypeSegment.selectedSegmentIndex)
        vibeModel.setReceiver(receiver: usernameField.text!.starts(with: "+") ? usernameField.text! : (countryCodeSelected! + usernameField.text!))
        vibeModel.setSender(sender: UserDefaults.standard.string(forKey: DeviceConstants.MOBILE_NUMBER)!)
        vibeModel.setVibeName(name: vibeNameField.text!)
        vibeModel.setCategory(category: vibeCategorySelected!)
        vibeModel.setAnonymous(isSenderAnonymous: false)
        vibeModel.setBackgroundMusicEnabled(isBackgroundMusicEnabled: backgroundMusicSwitch.isOn)
        if backgroundMusicSwitch.isOn {
            vibeModel.setBackgroundMusic(index: musicSelected!)
        }
        
        stopAudio()
        
        if isSourceCreateVibe {
            delegate?.setVibeDetails(vibeModel: vibeModel)
            self.dismiss(animated: true, completion: nil)
        }

        let createVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateVibeViewController") as! CreateVibeViewController
        createVC.vibeModel = self.vibeModel
        let presentingVC = self.presentingViewController

        self.dismiss(animated: true) {
            presentingVC?.present(createVC, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == DeviceConstants.GOTO_CREATE_VIBE_FROM_VIBE_DETAILS {
            let destinationVC = segue.destination as! CreateVibeViewController
            destinationVC.vibeModel = vibeModel
        }
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
    @IBAction func phoneNumberValueChanged(_ sender: UITextField) {
        if usernameField.text != nil && usernameField.text!.starts(with: "+") {
            removeCountryCodeTextField()
        } else if countryCodeField.isHidden == true {
            displayCountryCodeTextField()
        }
    }
    
    /// Displays the country code field when the text is totally numeric.
    func displayCountryCodeTextField() {
        countryCodeField.isHidden = false
        isUsernameInputNumbers = true
        usernameFieldLeadingConstraint.constant = 70
        
        countryCodeSelected = CountryCodes.countryCodes[0]
        countryCodeField.text = CountryCodes.countryCodes[0]
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
            return BackgroundMusic.musicList.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return CountryCodes.pickerStrings[row]
        } else if pickerView.tag == 1 {
            return VibeCategories.pickerStrings[row]
        } else if pickerView.tag == 2 {
            return BackgroundMusic.musicList[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("inside didSelectRow of pickerView")
        print("pickerView.tag: \(pickerView.tag)")
        if pickerView.tag == 0 {
            countryCodeSelected = CountryCodes.countryCodes[row]
            countryCodeField.text = countryCodeSelected
        } else if pickerView.tag == 1 {
            vibeCategorySelected = row
            vibeCategoryField.text = VibeCategories.pickerStrings[row]
        } else if pickerView.tag == 2 {
            musicSelected = row
            musicField.text = BackgroundMusic.musicList[row]
        }
        print("countryCodeSelected: \(countryCodeSelected)")
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
        contactPicker.predicateForEnablingContact = NSPredicate(format: "phoneNumbers.@count > 0")
        contactPicker.predicateForSelectionOfContact = NSPredicate(format: "phoneNumbers.@count > 0")
        contactPicker.predicateForSelectionOfProperty = NSPredicate(format: "key == 'phoneNumbers'")
        self.present(contactPicker, animated: true, completion: nil)
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    /// When the user selects the contact
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        picker.dismiss(animated: true, completion: nil)
        if contact.phoneNumbers.count == 1 {
            addNumberToField(phoneNumber: contact.phoneNumbers[0].value.stringValue)
        } else {
            let alertController = UIAlertController(title: "Choose a Number", message: "Please choose a number from the list", preferredStyle: .actionSheet)
            var actions = [UIAlertAction]()
            for i in 0 ..< contact.phoneNumbers.count {
                actions.append(UIAlertAction(title: contact.phoneNumbers[i].value.stringValue, style: .default, handler: { (action) in
                    self.addNumberToField(phoneNumber: contact.phoneNumbers[i].value.stringValue)
                }))
            }
            for i in 0 ..< contact.phoneNumbers.count {
                alertController.addAction(actions[i])
            }
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func addNumberToField(phoneNumber: String) {
        var contactNumber = phoneNumber.replacingOccurrences(of: "-", with: "")
        contactNumber = contactNumber.replacingOccurrences(of: " ", with: "")
//        contactNumber = contactNumber.replacingOccurrences(of: "+", with: "")
        contactNumber = contactNumber.replacingOccurrences(of: "(", with: "")
        contactNumber = contactNumber.replacingOccurrences(of: ")", with: "")
        usernameField.text = contactNumber
        if contactNumber.starts(with: "+") {
            removeCountryCodeTextField()
        } else {
            displayCountryCodeTextField()
        }
    }
}
