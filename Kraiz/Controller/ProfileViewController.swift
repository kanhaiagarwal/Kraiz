
//
//  HomeProfileViewController.swift
//  StoryFi
//
//  Created by Kumar Agarwal, Kanhai on 07/07/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//
// Class to show the user profile.

import UIKit

class ProfileViewController: UIViewController {

    let headingLabels = ["Full Name", "Username", "Date of Birth", "Phone Number", "Gender"]
    let icons = ["fullname", "username", "date_of_birth", "phone_number", "gender"]
    
    let placeholders = ["Enter your Full Name Here", "Enter your Username Here", "Enter you Date Of Birth", "Enter Your Phone Number", "Enter Your Gender"]
    
    let genders = ["Male", "Female", "Other"]
    
    var genderSelected : String?
    var dobSelected : String?
    
    let genderPickerView = UIPickerView()
    let dobDatePicker = UIDatePicker()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        
        tableView.delegate = self
        tableView.dataSource = self
        genderPickerView.delegate = self
        dobDatePicker.maximumDate = Date()
        
        // Listen to the keyboard events
//        NotificationCenter.default.addObserver(self, selector: #selector(moveViewOnKeyboardShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(moveViewOnKeyboardShow), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(moveViewOnKeyboardShow), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
//    deinit {
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
//    }
    
    // Tasks to perform on Keyboard events
//    @objc func moveViewOnKeyboardShow(notification: Notification) {
//        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
//            return
//        }
//
//        if notification.name == Notification.Name.UIKeyboardWillShow ||
//            notification.name == Notification.Name.UIKeyboardWillChangeFrame {
//            self.view.frame.origin.y = -keyboardRect.height
//        } else {
//            self.view.frame.origin.y = 0
//        }
//    }
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
        
        // Keep the username uneditable in the Profile..
        if indexPath.row == 1 {
            cell.inputField.isEnabled = false
            cell.inputField.text = "username1"
            cell.inputField.textColor = UIColor(displayP3Red: 149/255, green: 149/255, blue: 149/255, alpha: 1.0)
            
        }
        // Keep the phone number uneditable in the Profile.
        else if indexPath.row == 3 {
            cell.inputField.isEnabled = false
            cell.inputField.text = "+919003194776"
            cell.inputField.textColor = UIColor(displayP3Red: 149/255, green: 149/255, blue: 149/255, alpha: 1.0)
        }
        
        // Create a custom picker for the gender field in the Profile.
        if indexPath.row == 4 {
            cell.inputField.inputView = genderPickerView
            createToolbarForGenderPickerView(genderCell: cell)
        }
        
        // Create a date picker for the DOB field in the Profile.
        if indexPath.row == 2 {
            cell.inputField.inputView = dobDatePicker
            createToolbarForDatePicker(dobCell: cell)
        }
        
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// Code for the Gender Picker of the Gender Field.
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

// Code for the date picker of the DOB Field.
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
        print("selected date: \(selectedDate)")
        let cell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! ProfileTableViewCell
        cell.inputField.text = selectedDate
        view.endEditing(true)
    }
}
