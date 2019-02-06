
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
import BSImagePicker
import CropViewController
import Reachability

class ProfileViewController: UIViewController, CropViewControllerDelegate, DisplayImageViewControllerProtocol {
    
    /// Protocp; method called when back is pressed on the DisplayImageViewController
    func backPressedOnDisplayProfileImage() {
        self.updateProfilePicFromViewWillAppear = false
        self.updateTableViewCells = false
    }
    
    
    func profileImageDeleted() {
        DispatchQueue.main.async {
            print("Profile Image Deleted")
            self.profileImage.image = UIImage(named: self.DEFAULT_PROFILE_IMAGE)
            self.uploadPhotoButton.setTitle("Upload Photo", for: .normal)
            self.updateProfilePicFromViewWillAppear = false
            self.updateTableViewCells = false
            self.profilePicId = nil
            if UserDefaults.standard.bool(forKey: DeviceConstants.IS_PROFILE_PRESENT) {
                AppSyncHelper.shared.updateUserProfilePicture(profilePictureId: "none", success: { (success) in
                    DispatchQueue.main.async {
                        APPUtilites.displayElevatedSuccessSnackbar(message: "Profile Picture Removed")
                    }
                }, failure: { (error) in
                    DispatchQueue.main.async {
                        APPUtilites.displayElevatedErrorSnackbar(message: "Profile Picture Removal Failed")
                    }
                })
            }
        }
        
    }
    
    let headingLabels = ["Full Name", "Username", "Date of Birth", "Phone Number", "Gender"]
    let icons = ["fullname", "username", "date_of_birth", "phone_number", "gender"]
    
    let placeholders = ["Enter your Full Name", "Enter your Username", "Enter your Date Of Birth", "Enter Your Phone Number", "Enter Your Gender"]
    
    let genders = ["MALE", "FEMALE", "OTHERS"]
    
    let DEFAULT_PROFILE_IMAGE = "profile-default"
    
    let MIN_AGE_LIMIT_IN_YEARS = 13
    
    var genderSelected : String?
    var dobSelected : String?
    var profilePicId : String? = nil
    
    var updateProfilePicFromViewWillAppear : Bool = true
    var updateTableViewCells : Bool = true
    
    let genderPickerView = UIPickerView()
    let dobDatePicker = UIDatePicker()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var uploadPhotoButton: UIButton!
    @IBOutlet weak var topBar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        genderPickerView.delegate = self
        
        let calendar = Calendar(identifier: .gregorian)
        var comps = DateComponents()
        comps.year = -(MIN_AGE_LIMIT_IN_YEARS)
        dobDatePicker.maximumDate = calendar.date(byAdding: comps, to: Date())
        
        addTapGestureToProfilePicture()
        getProfile(shouldUpdateProfilePicture: true, shouldUpdateTableViewCells: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        getProfile(shouldUpdateProfilePicture: updateProfilePicFromViewWillAppear, shouldUpdateTableViewCells: updateTableViewCells)
    }
    
    func getProfile(shouldUpdateProfilePicture: Bool, shouldUpdateTableViewCells: Bool) {
        if shouldUpdateTableViewCells {
            let sv = APPUtilites.displayLoadingSpinner(onView: (self.tabBarController?.view)!)
            AppSyncHelper.shared.getUserProfile(userId: UserDefaults.standard.string(forKey: DeviceConstants.USER_ID)!, success: { (result: ProfileModel) in
                DispatchQueue.main.async {
                    APPUtilites.removeLoadingSpinner(spinner: sv)
                    self.populateProfileTable(profile: result, spinner: sv, shouldUpdateProfilePicture: shouldUpdateProfilePicture)
                }
                
            }) { (error: NSError) in
                DispatchQueue.main.async {
                    APPUtilites.removeLoadingSpinner(spinner: sv)
                    print(error.localizedDescription)
                    APPUtilites.displayElevatedErrorSnackbar(message: error.localizedDescription)
                }
            }
        } else {
            updateTableViewCells = true
        }
    }
    
    func addTapGestureToProfilePicture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImage.addGestureRecognizer(tapGesture)
    }
    
    /// Event which catches the tap on the Profile Image.
    ///     If the image is the Placeholder image, then call the upload function.
    ///     If the image is a profile image set by the user, then call the DisplayImageViewController.
    @objc func profileImageTapped() {
        if profileImage.image != UIImage(named: DEFAULT_PROFILE_IMAGE) {
            let displayImageVC = self.storyboard?.instantiateViewController(withIdentifier: "DisplayImageViewController") as! DisplayImageViewController
            displayImageVC.profileImage = profileImage.image!
            displayImageVC.delegate = self
            self.navigationController?.pushViewController(displayImageVC, animated: true)
        } else {
            uploadPhotoPressed(uploadPhotoButton)
        }
    }
    
    override func viewDidLayoutSubviews() {
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
    }

    /// Populates the profile fields with the values in the ProfileModel.
    /// - Parameter profile: The Profile Values of the user.
    func populateProfileTable(profile: ProfileModel, spinner: UIView, shouldUpdateProfilePicture: Bool) {
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
            dobCell.inputField.text = APPUtilites.inverseDate(inputDate: dob)
        } else {
            dobCell.inputField.text = nil
        }
        
        mobileCell.inputField.text = UserDefaults.standard.string(forKey: DeviceConstants.MOBILE_NUMBER)

        if let gender = profile.getGender() {
            genderCell.inputField.text = gender
        } else {
            genderCell.inputField.text = nil
        }
        
        if shouldUpdateProfilePicture {
            if profile.getProfilePicId() == nil || profile.getProfilePicId()! == "none" {
                APPUtilites.removeLoadingSpinner(spinner: spinner)
                profileImage.image = UIImage(named: DEFAULT_PROFILE_IMAGE)
                uploadPhotoButton.setTitle("Upload Photo", for: .normal)
                return
            }
            MediaHelper.shared.getProfileImage(publicId: profile.getProfilePicId()!, success: { (image) in
                DispatchQueue.main.async {
                    self.uploadPhotoButton.setTitle("Change Photo", for: .normal)
                    APPUtilites.removeLoadingSpinner(spinner: spinner)
                    self.profileImage.image = image
                }
            }) { (error) in
                DispatchQueue.main.async {
                    self.uploadPhotoButton.setTitle("Change Photo", for: .normal)
                    APPUtilites.removeLoadingSpinner(spinner: spinner)
                    APPUtilites.displayElevatedErrorSnackbar(message: error.localizedDescription)
                }
            }
        } else {
            updateProfilePicFromViewWillAppear = true
        }
    }
    
    /// Upload Photo Pressed.
    @IBAction func uploadPhotoPressed(_ sender: UIButton) {
        let vc = BSImagePickerViewController()
        vc.maxNumberOfSelections = 1
        let profileVC = self
        
        bs_presentImagePickerController(vc, animated: true, select: nil, deselect: nil, cancel: nil, finish: { (assets) in
            let imageSelected = APPUtilites.getUIImage(asset: assets[0])
            if let image = imageSelected {
                DispatchQueue.main.async {
                    let cropVC = CropViewController(croppingStyle: .default, image: image)
                    cropVC.delegate = profileVC
                    cropVC.aspectRatioLockEnabled = true
                    cropVC.aspectRatioPickerButtonHidden = true
                    cropVC.aspectRatioPreset = CropViewControllerAspectRatioPreset.presetSquare
                    cropVC.resetAspectRatioEnabled = false
                    self.present(cropVC, animated: true, completion: nil)
                }
            } else {
                APPUtilites.displayElevatedErrorSnackbar(message: "Error in selecting the image from the image picker")
            }
        }, completion: nil)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        updateTableViewCells = false
        let sv = APPUtilites.displayLoadingSpinner(onView: (self.tabBarController?.view)!)
        if !APPUtilites.isInternetConnectionAvailable() {
            APPUtilites.removeLoadingSpinner(spinner: sv)
            APPUtilites.displayElevatedErrorSnackbar(message: "Please Check your Internet Connection")
            cropViewController.dismiss(animated: true, completion: nil)
            return
        }
        cropViewController.dismiss(animated: true, completion: nil)
        MediaHelper.shared.uploadProfileImage(fileData: image.jpegData(compressionQuality: 0.5)!, success: { (publicId) in
            APPUtilites.removeLoadingSpinner(spinner: sv)
            self.profilePicId = publicId
            self.profileImage.image = image
            self.uploadPhotoButton.setTitle("Change Photo", for: .normal)
            if UserDefaults.standard.bool(forKey: DeviceConstants.IS_PROFILE_PRESENT) {
                AppSyncHelper.shared.updateUserProfilePicture(profilePictureId: self.profilePicId!, success: { (success) in
                    DispatchQueue.main.async {
                        APPUtilites.displayElevatedSuccessSnackbar(message: "Profile Picture Updated")
                    }
                }, failure: { (error) in
                    DispatchQueue.main.async {
                        print("Error: \(error)")
                        APPUtilites.displayElevatedErrorSnackbar(message: "Profile Picture Update Failed")
                    }
                })
            }
        }) { (error) in
            print("Error: \(error)")
            APPUtilites.removeLoadingSpinner(spinner: sv)
            APPUtilites.displayElevatedErrorSnackbar(message: error.userInfo["message"] as! String)
        }
    }
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true, completion: nil)
        APPUtilites.displayElevatedErrorSnackbar(message: "Didn't pick the image")
    }
    
    /// On pressing the Save Button.
    @IBAction func savePressed(_ sender: UIButton) {
        dismissKeyboard()
        
        if !APPUtilites.isInternetConnectionAvailable() {
            APPUtilites.displayElevatedErrorSnackbar(message: "Please Check your Internet Connection")
            return
        }
        
        let nameCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! ProfileTableViewCell
        let usernameCell = tableView.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! ProfileTableViewCell
        let dobCell = tableView.cellForRow(at: IndexPath.init(row: 2, section: 0)) as! ProfileTableViewCell
        let mobileCell = tableView.cellForRow(at: IndexPath.init(row: 3, section: 0)) as! ProfileTableViewCell
        let genderCell = tableView.cellForRow(at: IndexPath.init(row: 4, section: 0)) as! ProfileTableViewCell
        
        if mobileCell.inputField.text == nil || mobileCell.inputField.text == "" {
            APPUtilites.displayElevatedErrorSnackbar(message: "Mobile number is mandatory")
            return
        }
        
        if usernameCell.inputField.text == nil || usernameCell.inputField.text == "" {
            APPUtilites.displayElevatedErrorSnackbar(message: "Username is mandatory")
            return
        } else if (usernameCell.inputField.text?.contains(" "))! {
            APPUtilites.displayElevatedErrorSnackbar(message: "Username cannot contain spaces")
            return
        } else if !APPUtilites.isUsernameValid(username: usernameCell.inputField.text!) {
            APPUtilites.displayElevatedErrorSnackbarForLongDuration(message: "Username should contain only alphanumeric and special characters like . - @ _")
            return
        }

        if dobCell.inputField.text == nil || dobCell.inputField.text == "" {
            APPUtilites.displayElevatedErrorSnackbar(message: "Date of Birth is mandatory")
            return
        }
        let sv = APPUtilites.displayLoadingSpinner(onView: (self.tabBarController?.view)!)
        
        AppSyncHelper.shared.getUserProfileByUsername(username: usernameCell.inputField.text!, success: { (profile) in
            DispatchQueue.main.async {
                APPUtilites.removeLoadingSpinner(spinner: sv)
                if profile.getUsername() == nil || profile.getId() == UserDefaults.standard.string(forKey: DeviceConstants.USER_ID) {
                    print("Inside if profile.getUsername() == nil || profile.getUsername() == usernameCell.inputField.text!")
                    let inputProfile = ProfileModel()
                    inputProfile.setId(id: UserDefaults.standard.string(forKey: DeviceConstants.USER_ID))
                    inputProfile.setUsername(username: usernameCell.inputField.text)
                    inputProfile.setName(name: nameCell.inputField.text != "" ? nameCell.inputField.text : nil)
                    inputProfile.setMobileNumber(mobileNumber: mobileCell.inputField.text)
                    inputProfile.setGender(gender: genderCell.inputField.text != "" ? genderCell.inputField.text : nil)
                    if (self.profileImage.image != UIImage(named: self.DEFAULT_PROFILE_IMAGE)) {
                        inputProfile.setProfilePicId(profilePicId: self.profilePicId)
                    } else {
                        inputProfile.setProfilePicId(profilePicId: "none")
                    }
                    
                    if dobCell.inputField.text != nil && dobCell.inputField.text != "" {
                        inputProfile.setDob(dob: APPUtilites.inverseDate(inputDate: dobCell.inputField.text!))
                    } else {
                        inputProfile.setDob(dob: nil)
                    }
                    
                    let sv = APPUtilites.displayLoadingSpinner(onView: (self.tabBarController?.view)!)
                    
                    // Check if the profile was not present initially. If not, then add it and goto to the Default Tab Bar.
                    if !UserDefaults.standard.bool(forKey: DeviceConstants.IS_PROFILE_PRESENT) {
                        AppSyncHelper.shared.createUserProfile(profile: inputProfile, success: { (success) in
                            DispatchQueue.main.async {
                                APPUtilites.removeLoadingSpinner(spinner: sv)
                                if success == true {
                                    APPUtilites.displayElevatedSuccessSnackbar(message: "Profile Creation Succeeded!")
                                    self.tabBarController?.selectedIndex = DeviceConstants.DEFAULT_SELECTED_INDEX
                                    self.tabBarController?.addCreateVibeButton()
                                    self.tabBarController?.tabBar.isHidden = false
                                    UserDefaults.standard.set(true, forKey: DeviceConstants.IS_PROFILE_PRESENT)
                                    UserDefaults.standard.set(inputProfile.getUsername(), forKey: DeviceConstants.USER_NAME)
                                } else {
                                    APPUtilites.displayElevatedErrorSnackbar(message: "Profile Creation Failed. Please Check your inputs")
                                }
                            }
                        }, failure: { (error) in
                            APPUtilites.removeLoadingSpinner(spinner: sv)
                            APPUtilites.displayElevatedErrorSnackbar(message: error.localizedDescription)
                        })
                    } else {
                        AppSyncHelper.shared.updateUserProfile(profile: inputProfile, success: { (success) in
                            DispatchQueue.main.async {
                                APPUtilites.removeLoadingSpinner(spinner: sv)
                                if success == true {
                                    UserDefaults.standard.set(inputProfile.getUsername(), forKey: DeviceConstants.USER_NAME)
                                    APPUtilites.displayElevatedSuccessSnackbar(message: "Profile Update Succeeded!")
                                } else {
                                    APPUtilites.displayElevatedErrorSnackbar(message: "Profile Update Failed")
                                }
                            }
                        }, failure: { (error) in
                            DispatchQueue.main.async {
                                APPUtilites.removeLoadingSpinner(spinner: sv)
                                APPUtilites.displayErrorSnackbar(message: error.localizedDescription)
                            }
                        })
                    }
                } else {
                    APPUtilites.displayElevatedErrorSnackbar(message: "This username is not available")
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                APPUtilites.displayElevatedErrorSnackbar(message: error.localizedDescription)
            }
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
        
        // remove the autocorrect feature from the username.
        if indexPath.row == 1 {
            cell.inputField.autocorrectionType = .no
        }
        
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
//        genderSelected = genders[row]
        
//        let cell = tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as! ProfileTableViewCell
//        cell.inputField.text = genderSelected
    }
    
    func createToolbarForGenderPickerView(genderCell: ProfileTableViewCell) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.dismissKeyboardForGenderPickerView))
        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissKeyboard))
        
        toolbar.setItems([doneButton, flexButton, cancelButton], animated: false)
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
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissKeyboard))
        
        toolbar.setItems([done, flex, cancel], animated: true)
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

extension UIView {
    
    // Example use: myView.addBorder(toSide: .Left, withColor: UIColor.redColor().CGColor, andThickness: 1.0)
    
    enum ViewSide {
        case Left, Right, Top, Bottom
    }
    
    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = color
        
        switch side {
        case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
        case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
        case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness); break
        case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness); break
        }
        
        layer.addSublayer(border)
    }
}

