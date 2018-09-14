
//
//  HomeProfileViewController.swift
//  StoryFi
//
//  Created by Kumar Agarwal, Kanhai on 07/07/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//
// Class to show the user profile.

import UIKit
import AWSAppSync

class ProfileViewController: UIViewController {

    let headingLabels = ["Full Name", "Username", "Date of Birth", "Phone Number", "Gender"]
    let icons = ["fullname", "username", "date_of_birth", "phone_number", "gender"]
    
    let placeholders = ["Enter your Full Name Here", "Enter your Username Here", "Enter you Date Of Birth", "Enter Your Phone Number", "Enter Your Gender"]
    
    let genders = ["MALE", "FEMALE", "OTHERS"]
    
    var genderSelected : String?
    var dobSelected : String?
    
    let genderPickerView = UIPickerView()
    let dobDatePicker = UIDatePicker()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        genderPickerView.delegate = self
        dobDatePicker.maximumDate = Date()
    }
    
    override func viewDidLayoutSubviews() {
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let sv = APPUtilites.displayLoadingSpinner(onView: self.view)
        AppSyncHelper.shared.getUserProfile(userId: UserDefaults.standard.string(forKey: DeviceConstants.USER_ID)!, success: { (result: ProfileModel) in
            APPUtilites.removeLoadingSpinner(spinner: sv)
            self.populateProfileTable(profile: result)
            
        }) { (error: NSError) in
            APPUtilites.removeLoadingSpinner(spinner: sv)
            print(error.localizedDescription)
            APPUtilites.displayErrorSnackbar(message: error.localizedDescription)
        }
    }

    /// Populates the profile fields with the values in the ProfileModel.
    /// - Parameter profile: The Profile Values of the user.
    func populateProfileTable(profile: ProfileModel) {
        let nameCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! ProfileTableViewCell
        let usernameCell = tableView.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! ProfileTableViewCell
        let dobCell = tableView.cellForRow(at: IndexPath.init(row: 2, section: 0)) as! ProfileTableViewCell
        let mobileCell = tableView.cellForRow(at: IndexPath.init(row: 3, section: 0)) as! ProfileTableViewCell
        let genderCell = tableView.cellForRow(at: IndexPath.init(row: 4, section: 0)) as! ProfileTableViewCell
        
        if let name = profile.getName() {
            nameCell.inputField.text = name
        }
        
        if let username = profile.getUsername() {
            usernameCell.inputField.text = username
        }
        
        if let dob = profile.getDob() {
            dobCell.inputField.text = dob
        }
        
        mobileCell.inputField.text = UserDefaults.standard.string(forKey: DeviceConstants.MOBILE_NUMBER)
        
        if let gender = profile.getGender() {
            genderCell.inputField.text = gender
        }
    }
    
    /// On pressing the Save Button.
    @IBAction func savePressed(_ sender: UIButton) {
        
        let nameCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! ProfileTableViewCell
        let usernameCell = tableView.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! ProfileTableViewCell
        let dobCell = tableView.cellForRow(at: IndexPath.init(row: 2, section: 0)) as! ProfileTableViewCell
        let mobileCell = tableView.cellForRow(at: IndexPath.init(row: 3, section: 0)) as! ProfileTableViewCell
        let genderCell = tableView.cellForRow(at: IndexPath.init(row: 4, section: 0)) as! ProfileTableViewCell
        
        if mobileCell.inputField.text == nil || mobileCell.inputField.text == "" {
            APPUtilites.displayErrorSnackbar(message: "Mobile number is mandatory")
            return
        }
        
        if usernameCell.inputField.text == nil || usernameCell.inputField.text == "" {
            APPUtilites.displayErrorSnackbar(message: "Username is mandatory")
            return
        } else if (usernameCell.inputField.text?.contains(" "))! {
            APPUtilites.displayErrorSnackbar(message: "Username cannot contain spaces")
            return
        }
        
        let inputProfile = ProfileModel()
        inputProfile.setId(id: UserDefaults.standard.string(forKey: DeviceConstants.USER_ID))
        inputProfile.setUsername(username: usernameCell.inputField.text)
        inputProfile.setName(name: nameCell.inputField.text != "" ? nameCell.inputField.text : nil)
        inputProfile.setMobileNumber(mobileNumber: mobileCell.inputField.text)
        inputProfile.setGender(gender: genderCell.inputField.text != "" ? genderCell.inputField.text : nil)
        inputProfile.setProfilePicUrl(profilePic: nil)
        
        if dobCell.inputField.text != nil && dobCell.inputField.text != "" {
            inputProfile.setDob(dob: APPUtilites.inverseDate(inputDate: dobCell.inputField.text!))
        } else {
            inputProfile.setDob(dob: nil)
        }
        
        let sv = APPUtilites.displayLoadingSpinner(onView: self.view)
        
        // Check if the profile was not present initially. If not, then add it and goto to the Default Tab Bar.
        if !UserDefaults.standard.bool(forKey: DeviceConstants.IS_PROFILE_PRESENT) {
            AppSyncHelper.shared.createUserProfile(profile: inputProfile, success: { (success) in
                APPUtilites.removeLoadingSpinner(spinner: sv)
                if success == true {
                    APPUtilites.displaySuccessSnackbar(message: "Profile Creation Succeeded!")
                    self.tabBarController?.selectedIndex = DeviceConstants.DEFAULT_SELECTED_INDEX
                    self.tabBarController?.addCreateVibeButton()
                    self.tabBarController?.tabBar.isHidden = false
                    UserDefaults.standard.set(true, forKey: DeviceConstants.IS_PROFILE_PRESENT)
                } else {
                    APPUtilites.displayErrorSnackbar(message: "Profile Creation Failed. Please Check your inputs")
                }
            }, failure: { (error) in
                APPUtilites.removeLoadingSpinner(spinner: sv)
                APPUtilites.displayErrorSnackbar(message: error.localizedDescription)
            })
        } else {
            AppSyncHelper.shared.createUserProfile(profile: inputProfile, success: { (success) in
                APPUtilites.removeLoadingSpinner(spinner: sv)
                if success == true {
                    APPUtilites.displaySuccessSnackbar(message: "Profile Update Succeeded!")
                } else {
                    APPUtilites.displayErrorSnackbar(message: "Profile Update Failed")
                }
            }, failure: { (error) in
                APPUtilites.removeLoadingSpinner(spinner: sv)
                APPUtilites.displayErrorSnackbar(message: error.localizedDescription)
            })
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("ProfileTableViewCell", owner: self, options: nil)?.first as! ProfileTableViewCell
        
        cell.selectionStyle = .none
        cell.headingLabel.text = headingLabels[indexPath.row]
        cell.iconImage.image = UIImage(named: icons[indexPath.row])
        cell.inputField.placeholder = placeholders[indexPath.row]
        cell.inputField.layer.borderColor = UIColor.clear.cgColor
        cell.inputField.delegate = self
            
        // Create a date picker for the DOB field in the Profile.
        if indexPath.row == 2 {
            cell.inputField.inputView = dobDatePicker
            createToolbarForDatePicker(dobCell: cell)
        }

        // Keep the phone number uneditable in the Profile.
        else if indexPath.row == 3 {
            cell.inputField.isEnabled = false
            cell.inputField.text = UserDefaults.standard.string(forKey: DeviceConstants.MOBILE_NUMBER)
            cell.inputField.textColor = UIColor(displayP3Red: 149/255, green: 149/255, blue: 149/255, alpha: 1.0)
        }
        
        // Create a custom picker for the gender field in the Profile.
        if indexPath.row == 4 {
            cell.inputField.inputView = genderPickerView
            createToolbarForGenderPickerView(genderCell: cell)
        }
        
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

/// Code for the Gender Picker of the Gender Field.
extension ProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderSelected = genders[row]
        
        let cell = tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as! ProfileTableViewCell
        cell.inputField.text = genderSelected
    }
    
    func createToolbarForGenderPickerView(genderCell: ProfileTableViewCell) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.dismissKeyboardForGenderPickerView))
        
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        genderCell.inputField.inputAccessoryView = toolbar
    }
    
    @objc func dismissKeyboardForGenderPickerView() {
        genderSelected = genders[genderPickerView.selectedRow(inComponent: 0)]
        let cell = tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as! ProfileTableViewCell
        cell.inputField.text = genderSelected
        view.endEditing(true)
    }
}

/// Code for the date picker of the DOB Field.
extension ProfileViewController {
    func createToolbarForDatePicker(dobCell: ProfileTableViewCell) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.selectDate))
        
        toolbar.setItems([done], animated: true)
        toolbar.isUserInteractionEnabled = true
        
        dobCell.inputField.inputAccessoryView = toolbar
        dobCell.inputField.inputView = dobDatePicker
        dobDatePicker.datePickerMode = .date
    }
    
    @objc func selectDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYY"
        let selectedDate = dateFormatter.string(from: dobDatePicker.date)
        let cell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! ProfileTableViewCell
        cell.inputField.text = selectedDate
        view.endEditing(true)
    }
}
