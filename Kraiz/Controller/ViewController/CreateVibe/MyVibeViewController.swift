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
    let friendsVibeTagPicker = UIPickerView()
    let publicVibeTagPicker = UIPickerView()
    let friendsMusicPicker = UIPickerView()
    let publicMusicPicker = UIPickerView()
    var countryCodeSelected : Int?
    var friendsVibeTagSelected : Int?
    var publicVibeTagSelected : Int?
    var vibeTypeSelected : Int?
    var friendsMusicSelected : Int?
    var publicMusicSelected : Int?
    let GRADIENT_TOP_COLOR = UIColor(displayP3Red: 230/255, green: 158/255, blue: 55/255, alpha: 1.0)
    let GRADIENT_BOTTOM_COLOR = UIColor(displayP3Red: 227/255, green: 121/255, blue: 11/255, alpha: 1.0)
    let PLAY_IMAGE = "myvibe-play-music"
    let PAUSE_IMAGE = "myvibe-pause-music"

    @IBOutlet weak var friendsDetailsContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var friendsPhoneNumberIcon: UIImageView!
    @IBOutlet weak var friendsToLabel: UILabel!
    @IBOutlet weak var vibeTypeSegment: UISegmentedControl!
    @IBOutlet weak var friendsMusicArrowLabel: UILabel!
    @IBOutlet weak var publicMusicArrowLabel: UILabel!
    @IBOutlet weak var friendsPlayImageView: UIImageView!
    @IBOutlet weak var publicPlayImageView: UIImageView!
    @IBOutlet weak var friendsVibeDetailsContainer: CardView!
    @IBOutlet weak var publicVibeDetailsContainer: CardView!
    @IBOutlet weak var usernameFieldLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var usernameFieldTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var friendsCountryCodeField: UITextField!
    @IBOutlet weak var friendsUsernameField: UITextField!
    @IBOutlet weak var publicVibeTagField: UITextField!
    @IBOutlet weak var friendsVibeTagField: UITextField!
    @IBOutlet weak var friendsMusicField: UITextField!
    @IBOutlet weak var publicMusicField: UITextField!
    @IBOutlet weak var contactListIcon: UIImageView!
    @IBOutlet weak var friendsVibeNameField: UITextField!
    @IBOutlet weak var publicVibeNameField: UITextField!
    @IBOutlet weak var friendsBackgroundMusicSwitch: UISwitch!
    @IBOutlet weak var publicBackgroundMusicSwitch: UISwitch!
    @IBOutlet weak var nextButton: UIButton!
    
    var audioPlayer : AVAudioPlayer!
    var delegate : VibeDetailsProtocol?
    
    var isUsernameInputNumbers : Bool = false
    var isAnonymousEnabled : Bool = false
    
    let gradientLayer = CAGradientLayer()
    
    var vibeModel = VibeModel()
    var isSourceCreateVibe = false
    var isAudioPlaying = false
    var isPreferredUser = false

    let MAX_VIBE_NAME_LIMIT = 50

    override func viewDidLoad() {
        super.viewDidLoad()

        print("UserDefaults.standard.string(forKey: DeviceConstants.USER_ID): \(UserDefaults.standard.string(forKey: DeviceConstants.USER_ID))")
        vibeModel.from?.setId(id: UserDefaults.standard.string(forKey: DeviceConstants.USER_ID))
        vibeModel.from?.setUsername(username: UserDefaults.standard.string(forKey: DeviceConstants.USER_NAME))
        vibeModel.from?.setMobileNumber(mobileNumber: UserDefaults.standard.string(forKey: DeviceConstants.MOBILE_NUMBER))

        let attr = NSDictionary(object: UIFont(name: "Helvetica Neue", size: 16.0)!, forKey: NSAttributedString.Key.font as NSCopying)
        vibeTypeSegment.setTitleTextAttributes(attr as? [NSAttributedString.Key : Any], for: .normal)
        if !isPreferredUser {
            vibeTypeSegment.isHidden = true
        } else {
            vibeTypeSegment.isHidden = false
        }

        countryCodePicker.tag = 0
        friendsVibeTagPicker.tag = 1
        friendsMusicPicker.tag = 2
        publicVibeTagPicker.tag = 3
        publicMusicPicker.tag = 4

        friendsMusicPicker.delegate = self
        publicMusicPicker.delegate = self
        countryCodePicker.delegate = self
        friendsVibeTagPicker.delegate = self
        publicVibeTagPicker.delegate = self
        friendsUsernameField.delegate = self
        friendsVibeNameField.delegate = self
        publicVibeNameField.delegate = self
        
        createToolbarForPickerView()
        addGestureToContactListIcon()
        
        // Set the Vibe Type Segment during the loading of the view.
        vibeTypeSelected = vibeModel.type
        vibeTypeSegment.selectedSegmentIndex = vibeModel.type

        // Set the mobile number field during the loading of the view.
        if vibeModel.to?.getMobileNumber() == nil ||  vibeModel.to?.getMobileNumber()! == "" {
            displayCountryCodeTextField()
            friendsUsernameField.text = nil
        } else {
            removeCountryCodeTextField()
            friendsUsernameField.text = vibeModel.to?.getMobileNumber()!
        }
        
        // Set the vibe name field during the loading of the view.
        if vibeModel.vibeName == "" {
            friendsVibeNameField.text = nil
            publicVibeNameField.text = nil
        } else {
            friendsVibeNameField.text = vibeModel.vibeName
            publicVibeNameField.text = vibeModel.vibeName
        }
        
        countryCodeSelected = 0
        friendsCountryCodeField.text = CountryCodes.countryCodes[countryCodeSelected!]
        friendsVibeTagSelected = 0
        publicVibeTagSelected = 0
        friendsVibeTagField.text = VibeCategories.pickerStrings[friendsVibeTagSelected!]
        publicVibeTagField.text = VibeCategories.pickerStrings[publicVibeTagSelected!]
        friendsCountryCodeField.inputView = countryCodePicker
        friendsVibeTagField.inputView = friendsVibeTagPicker
        publicVibeTagField.inputView = publicVibeTagPicker
        friendsMusicField.inputView = friendsMusicPicker
        publicMusicField.inputView = publicMusicPicker
        
        // Make the play image views tappable to play the audio
        addGestureToPlayIcon()
        
        chooseDetailsContainer(shouldTransferData: false)
    }

    func chooseDetailsContainer(shouldTransferData: Bool) {
        if vibeTypeSegment.selectedSegmentIndex == 0 {
            friendsVibeDetailsContainer.isHidden = false
            publicVibeDetailsContainer.isHidden = true
            if shouldTransferData {
                friendsVibeNameField.text = publicVibeNameField.text
                friendsVibeTagField.text = publicVibeTagField.text
            }
        } else {
            friendsVibeDetailsContainer.isHidden = true
            publicVibeDetailsContainer.isHidden = false
            if shouldTransferData {
                publicVibeNameField.text = friendsVibeNameField.text
                publicVibeTagField.text = friendsVibeTagField.text
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        
        // Set the Vibe Category field during load. This is set here because the category was not getting updated in the view in viewDidLoad().
        friendsVibeTagPicker.selectRow(vibeModel.category, inComponent: 0, animated: false)
        friendsVibeTagSelected = vibeModel.category
        friendsVibeTagField.text = VibeCategories.pickerStrings[vibeModel.category]
        
        publicVibeTagPicker.selectRow(vibeModel.category, inComponent: 0, animated: false)
        publicVibeTagSelected = vibeModel.category
        publicVibeTagField.text = VibeCategories.pickerStrings[vibeModel.category]
        
        // Set the background music selected during load. This is set here because the music field was not getting updated in the view in viewDidLoad()
        // Set the background music field during load.
        print("=========> vibeModel.backgroundMusicIndex: \(vibeModel.backgroundMusicIndex)")
        if vibeModel.isBackgroundMusicEnabled {
            friendsBackgroundMusicSwitch.isOn = true
            friendsMusicField.isHidden = false
            friendsMusicField.text = BackgroundMusic.musicList[vibeModel.backgroundMusicIndex]
            friendsMusicPicker.selectRow(vibeModel.backgroundMusicIndex, inComponent: 0, animated: false)
            friendsMusicSelected = vibeModel.backgroundMusicIndex
            friendsMusicArrowLabel.isHidden = false
            friendsPlayImageView.isHidden = false

            publicBackgroundMusicSwitch.isOn = true
            publicMusicField.isHidden = false
            publicMusicField.text = BackgroundMusic.musicList[vibeModel.backgroundMusicIndex]
            publicMusicPicker.selectRow(vibeModel.backgroundMusicIndex, inComponent: 0, animated: false)
            publicMusicSelected = vibeModel.backgroundMusicIndex
            publicMusicArrowLabel.isHidden = false
            publicPlayImageView.isHidden = false
        } else {
            friendsBackgroundMusicSwitch.isOn = false
            friendsMusicField.isHidden = true
            friendsMusicSelected = 0
            friendsMusicField.text = BackgroundMusic.musicFiles[friendsMusicSelected!]
            friendsMusicPicker.selectRow(0, inComponent: 0, animated: false)
            friendsMusicArrowLabel.isHidden = true
            friendsPlayImageView.isHidden = true

            publicBackgroundMusicSwitch.isOn = false
            publicMusicField.isHidden = true
            publicMusicSelected = 0
            publicMusicField.text = BackgroundMusic.musicFiles[friendsMusicSelected!]
            publicMusicPicker.selectRow(0, inComponent: 0, animated: false)
            publicMusicArrowLabel.isHidden = true
            publicPlayImageView.isHidden = true
        }

        vibeTypeSegment.selectedSegmentIndex = vibeModel.type
        setupNextButton()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 1 || textField.tag == 2 {
            if vibeTypeSegment.selectedSegmentIndex == 0 {
                let str = ((friendsVibeNameField.text != nil ? friendsVibeNameField.text! : "") + string)
                if str.count <= MAX_VIBE_NAME_LIMIT {
                    return true
                } else {
                    return false
                }
            } else {
                let str = ((friendsVibeNameField.text != nil ? friendsVibeNameField.text! : "") + string)
                if str.count <= MAX_VIBE_NAME_LIMIT {
                    return true
                } else {
                    return false
                }
            }
        }
        return true
    }

    @IBAction func vibeTypePressed(_ sender: UISegmentedControl) {
        dismissKeyboard()
        if vibeTypeSegment.selectedSegmentIndex != vibeTypeSelected! {
            vibeTypeSelected = vibeTypeSegment.selectedSegmentIndex
            chooseDetailsContainer(shouldTransferData: true)
        }
        
    }

    @IBAction func friendsMusicFieldTapped(_ sender: Any) {
        musicFieldTappedCommonAction()
    }

    @IBAction func publicMusicFieldTapped(_ sender: UITextField) {
        musicFieldTappedCommonAction()
    }

    func musicFieldTappedCommonAction() {
        if audioPlayer != nil && audioPlayer.isPlaying {
            isAudioPlaying = false
            audioPlayer.pause()
            friendsPlayImageView.image = UIImage(named: PLAY_IMAGE)
            publicPlayImageView.image = UIImage(named: PLAY_IMAGE)
        }
    }

    func addGestureToPlayIcon() {
        let friendsPlayTapGesture = UITapGestureRecognizer(target: self, action: #selector(playImageTapped))
        let publicPlayTapGesture = UITapGestureRecognizer(target: self, action: #selector(playImageTapped))
        friendsPlayImageView.addGestureRecognizer(friendsPlayTapGesture)
        publicPlayImageView.addGestureRecognizer(publicPlayTapGesture)
    }
    
    @objc func playImageTapped() {
        dismissKeyboard()
        if isAudioPlaying {
            friendsPlayImageView.image = UIImage(named: PLAY_IMAGE)
            publicPlayImageView.image = UIImage(named: PLAY_IMAGE)
            pauseAudio()
        } else {
            let audioFileName = vibeTypeSegment.selectedSegmentIndex == 0 ? BackgroundMusic.musicFiles[friendsMusicSelected!] : BackgroundMusic.musicFiles[publicMusicSelected!]
            let url = APPUtilites.getUrlForFileName(fileName: audioFileName, type: "mp3")
            if url != nil {
                playAudioForUrl(url: url!)
            } else {
                print("File not found for the file name \(BackgroundMusic.musicFiles[friendsMusicSelected!]) of type .mp3")
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
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.duckOthers)
            try AVAudioSession.sharedInstance().setActive(true, options: AVAudioSession.SetActiveOptions.notifyOthersOnDeactivation)
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer!.numberOfLoops = -1
            audioPlayer!.prepareToPlay()
            audioPlayer!.setVolume(1.0, fadeDuration: 0)
            audioPlayer!.play()

            friendsPlayImageView.image = UIImage(named: PAUSE_IMAGE)
            publicPlayImageView.image = UIImage(named: PAUSE_IMAGE)
            isAudioPlaying = true
        } catch {
            print("Cannot play the file")
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
            friendsPlayImageView.image = UIImage(named: PLAY_IMAGE)
            publicPlayImageView.image = UIImage(named: PLAY_IMAGE)
            audioPlayer.pause()
        }
    }

    func stopAudio() {
        if audioPlayer != nil && audioPlayer.isPlaying {
            isAudioPlaying = false
            friendsPlayImageView.image = UIImage(named: PLAY_IMAGE)
            publicPlayImageView.image = UIImage(named: PLAY_IMAGE)
            audioPlayer.stop()
        }
    }

    @IBAction func friendsBackgroundMusicSwitchPressed(_ sender: UISwitch) {
        if friendsBackgroundMusicSwitch.isOn {
            showMusicFields()
            publicBackgroundMusicSwitch.setOn(true, animated: false)
        } else {
            dismissKeyboard()
            stopAudio()
            hideMusicFields()
            publicBackgroundMusicSwitch.setOn(false, animated: false)
        }
    }

    @IBAction func publicBackgroundMusicSwitchPressed(_ sender: UISwitch) {
        if publicBackgroundMusicSwitch.isOn {
            friendsBackgroundMusicSwitch.setOn(true, animated: false)
            showMusicFields()
        } else {
            dismissKeyboard()
            stopAudio()
            hideMusicFields()
            friendsBackgroundMusicSwitch.setOn(false, animated: false)
        }
    }

    func showMusicFields() {
        friendsMusicField.isHidden = false
        friendsMusicArrowLabel.isHidden = false
        friendsPlayImageView.isHidden = false
        publicMusicField.isHidden = false
        publicMusicArrowLabel.isHidden = false
        publicPlayImageView.isHidden = false
    }

    func hideMusicFields() {
        friendsMusicField.isHidden = true
        friendsMusicArrowLabel.isHidden = true
        friendsPlayImageView.isHidden = true
        publicMusicField.isHidden = true
        publicMusicArrowLabel.isHidden = true
        publicPlayImageView.isHidden = true
    }

    @IBAction func nextPressed(_ sender: UIButton) {
        if vibeTypeSegment.selectedSegmentIndex == 0 {
            if !APPUtilites.isInternetConnectionAvailable() {
                APPUtilites.displayErrorSnackbar(message: "Please check your internet connection")
                return
            }
            if friendsUsernameField.text == nil || friendsUsernameField.text! == "" {
                APPUtilites.displayErrorSnackbar(message: "Please make sure you are giving a valid mobile number")
                return
            }

            if !friendsUsernameField.text!.starts(with: "+") && (Int(friendsUsernameField.text!) == nil) {
                APPUtilites.displayErrorSnackbar(message: "Please make sure you are giving a valid mobile number")
                return
            }

            if friendsVibeNameField.text == nil || friendsVibeNameField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                APPUtilites.displayErrorSnackbar(message: "Please give a name to the Vibe")
                return
            }

            vibeModel.setReceiverMobileNumber(mobileNumber: friendsUsernameField.text!.starts(with: "+") ? friendsUsernameField.text! : (CountryCodes.countryCodes[countryCodeSelected!] + friendsUsernameField.text!))
            vibeModel.to?.setMobileNumber(mobileNumber: friendsUsernameField.text!.starts(with: "+") ? friendsUsernameField.text! : (CountryCodes.countryCodes[countryCodeSelected!] + friendsUsernameField.text!))
        } else {
            if publicVibeNameField.text == nil || publicVibeNameField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                APPUtilites.displayErrorSnackbar(message: "Please give a name to the Vibe")
                return
            }
        }

        vibeModel.setSenderId(sender: UserDefaults.standard.string(forKey: DeviceConstants.MOBILE_NUMBER)!)
        vibeModel.setVibeType(type: vibeTypeSegment.selectedSegmentIndex)
        vibeModel.setVibeName(name: vibeTypeSegment.selectedSegmentIndex == 0 ? friendsVibeNameField.text! : publicVibeNameField.text!)
        vibeModel.setCategory(category: vibeTypeSegment.selectedSegmentIndex == 0 ?friendsVibeTagSelected! : publicVibeTagSelected!)
        vibeModel.setBackgroundMusicEnabled(isBackgroundMusicEnabled: vibeTypeSegment.selectedSegmentIndex == 0 ? friendsBackgroundMusicSwitch.isOn : publicBackgroundMusicSwitch.isOn)
        if vibeModel.isBackgroundMusicEnabled {
            vibeModel.setBackgroundMusic(index: vibeTypeSegment.selectedSegmentIndex == 0 ? friendsMusicSelected! : publicMusicSelected!)
        }
        vibeModel.setAnonymous(isSenderAnonymous: false)
        
        stopAudio()

        dismissKeyboard()

        /// Check if the user exists before going forward to create the vibe.
        if vibeTypeSegment.selectedSegmentIndex == 0 {
            let loadingSpinner = APPUtilites.displayLoadingSpinner(onView: view)
            AppSyncHelper.shared.getUserProfileByMobileNumber(mobileNumber: (vibeModel.to?.getMobileNumber())!) { [weak self] (error, profileModel) in
                DispatchQueue.main.async {
                    APPUtilites.removeLoadingSpinner(spinner: loadingSpinner)
                    if error != nil {
                        APPUtilites.displayErrorSnackbar(message: "Oops, something went wrong.")
                    } else if profileModel == nil || profileModel?.getUsername() == nil {
                        APPUtilites.displayErrorSnackbar(message: "The user does not exist. Please create the vibe for an existing user.")
                    } else {
                        self?.vibeModel.receiverUsername = profileModel!.getUsername()!
                        self?.gotoCreateVibe()
                    }
                }
            }
        } else {
            gotoCreateVibe()
        }
    }
    
    func gotoCreateVibe() {
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
        dismissKeyboard()
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    @IBAction func phoneNumberValueChanged(_ sender: UITextField) {
        if friendsUsernameField.text != nil && friendsUsernameField.text!.starts(with: "+") {
            removeCountryCodeTextField()
        } else if friendsCountryCodeField.isHidden == true {
            displayCountryCodeTextField()
        }
    }

    /// Displays the country code field when the text is totally numeric.
    func displayCountryCodeTextField() {
        friendsCountryCodeField.isHidden = false
        isUsernameInputNumbers = true
        usernameFieldLeadingConstraint.constant = 70
        
        if countryCodeSelected == nil {
            countryCodeSelected = 0
        }
        friendsCountryCodeField.text = CountryCodes.countryCodes[countryCodeSelected!]
        countryCodePicker.selectRow(countryCodeSelected!, inComponent: 0, animated: false)
        friendsCountryCodeField.textAlignment = .center
        friendsCountryCodeField.adjustsFontSizeToFitWidth = true
        friendsCountryCodeField.minimumFontSize = 14
        friendsCountryCodeField.inputView = countryCodePicker
    }

    /// Removes the country code field when the text is totally alpha-numeric.
    func removeCountryCodeTextField() {
        friendsCountryCodeField.isHidden = true
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

        friendsCountryCodeField.inputAccessoryView = toolbar
        friendsVibeTagField.inputAccessoryView = toolbar
        publicVibeTagField.inputAccessoryView = toolbar
        friendsMusicField.inputAccessoryView = toolbar
        publicMusicField.inputAccessoryView = toolbar
        friendsUsernameField.inputAccessoryView = toolbar
        friendsVibeNameField.inputAccessoryView = toolbar
        publicVibeNameField.inputAccessoryView = toolbar
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    /// Give styles to the next button.
    func setupNextButton() {
        if nextButton.layer.sublayers != nil && nextButton.layer.sublayers!.count > 0 {
            print("Layers present on the next button")
            print("Layers count: \(nextButton.layer.sublayers!.count)")
        } else {
            print("No layers on the next button")
            nextButton.layer.cornerRadius = 10
            nextButton.clipsToBounds = true

            gradientLayer.frame = nextButton.bounds
            gradientLayer.colors = [GRADIENT_TOP_COLOR.cgColor, GRADIENT_BOTTOM_COLOR.cgColor]
            nextButton.layer.insertSublayer(gradientLayer, above: nil)
            nextButton.setTitle("Next", for: .normal)
        }
    }
}

extension MyVibeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return CountryCodes.countryCodes.count
        } else if pickerView.tag == 1 || pickerView.tag == 3 {
            return VibeCategories.pickerStrings.count
        } else if pickerView.tag == 2 || pickerView.tag == 4 {
            return BackgroundMusic.musicList.count
        }
        return 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return CountryCodes.pickerStrings[row]
        } else if pickerView.tag == 1 || pickerView.tag == 3 {
            return VibeCategories.pickerStrings[row]
        } else if pickerView.tag == 2 || pickerView.tag == 4 {
            return BackgroundMusic.musicList[row]
        }
        return nil
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            countryCodeSelected = row
            friendsCountryCodeField.text = CountryCodes.countryCodes[countryCodeSelected!]
        } else if pickerView.tag == 1 || pickerView.tag == 3 {
            friendsVibeTagSelected = row
            publicVibeTagSelected = row
            friendsVibeTagField.text = VibeCategories.pickerStrings[row]
            publicVibeTagField.text = VibeCategories.pickerStrings[row]
            friendsVibeTagPicker.selectRow(row, inComponent: 0, animated: true)
            publicVibeTagPicker.selectRow(row, inComponent: 0, animated: true)
        } else if pickerView.tag == 2 || pickerView.tag == 4 {
            friendsMusicSelected = row
            publicMusicSelected = row
            friendsMusicField.text = BackgroundMusic.musicList[row]
            publicMusicField.text = BackgroundMusic.musicList[row]
            friendsMusicPicker.selectRow(row, inComponent: 0, animated: true)
            publicMusicPicker.selectRow(row, inComponent: 0, animated: true)
        }
    }
}

extension MyVibeViewController: CNContactPickerDelegate {
    @objc func contactListPressed() {
        if isAudioPlaying {
            stopAudio()
        }
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
        contactNumber = contactNumber.replacingOccurrences(of: "(", with: "")
        contactNumber = contactNumber.replacingOccurrences(of: ")", with: "")
        if contactNumber.starts(with: "+") {
            removeCountryCodeTextField()
        } else {
            displayCountryCodeTextField()
            if contactNumber.starts(with: "0") {
                while (contactNumber.starts(with: "0")) {
                    contactNumber.removeFirst()
                }
            }
        }
        friendsUsernameField.text = contactNumber
    }
}
