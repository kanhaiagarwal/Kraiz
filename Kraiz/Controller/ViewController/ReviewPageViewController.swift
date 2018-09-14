//
//  ReviewPageViewController.swift
//  Kraiz
//
//  Created by Kumar Agarwal, Kanhai on 14/08/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//
//  Class for the Review Page of the Vibe.

import UIKit

class ReviewPageViewController: UIViewController {

    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var storyNameField1: UITextField!
    @IBOutlet weak var storyNameField2: UITextField!
    @IBOutlet weak var storyNameField3: UITextField!
    @IBOutlet weak var storyNameContainer1: UIView!
    @IBOutlet weak var storyNameContainer2: UIView!
    @IBOutlet weak var storyNameContainer3: UIView!
    @IBOutlet weak var scheduleContainer: UIView!
    @IBOutlet weak var sendContainer: UIView!
    
    var sendLater : Bool = false
    var sendDate : String = ""
    var sendTime : String = ""
    
    let dateTimePicker = UIDatePicker()
    let dummyField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateTimePicker.minimumDate = Date()
        dateTimePicker.timeZone = TimeZone(abbreviation: "IST")
        
        usernameField.borderStyle = .none
        storyNameField1.borderStyle = .none
        storyNameField2.borderStyle = .none
        storyNameField3.borderStyle = .none
        addLineBelowTextField(textField: usernameField, parentView: nameView)
        addLineBelowTextField(textField: storyNameField1, parentView: storyNameContainer1)
        addLineBelowTextField(textField: storyNameField2, parentView: storyNameContainer2)
        addLineBelowTextField(textField: storyNameField3, parentView: storyNameContainer3)
        
        let sendTapGesture = UITapGestureRecognizer(target: self, action: #selector(sendPressed))
        let scheduleTapGesture = UITapGestureRecognizer(target: self, action: #selector(schedulePressed))
        
        scheduleContainer.addGestureRecognizer(scheduleTapGesture)
        sendContainer.addGestureRecognizer(sendTapGesture)
        
    }
    
    func addLineBelowTextField(textField: UITextField, parentView: UIView) {
        let path = UIBezierPath()
        let layer = CAShapeLayer()
        let startingPoint = CGPoint(x: textField.frame.minX, y: usernameField.frame.maxY)
        let endingPoint = CGPoint(x: textField.frame.maxX, y: textField.frame.maxY)
        
        path.move(to: startingPoint)
        path.addLine(to: endingPoint)
        path.stroke()
        
        layer.path = path.cgPath
        layer.lineWidth = 2
        layer.strokeColor = UIColor(displayP3Red: 149/255, green: 149/255, blue: 149/255, alpha: 1.0).cgColor
        layer.fillColor = UIColor.clear.cgColor
        
        parentView.layer.addSublayer(layer)
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func schedulePressed() {
        view.addSubview(dummyField)
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(selectSendTime))
        let flexibleButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTimePicker))
        toolbar.setItems([done, flexibleButton, cancel], animated: true)
        toolbar.isUserInteractionEnabled = true
        dateTimePicker.datePickerMode = .dateAndTime
        
        dummyField.inputAccessoryView = toolbar
        dummyField.inputView = dateTimePicker
        dummyField.becomeFirstResponder()
    }
    
    @objc func sendPressed() {
        let alert = UIAlertController(title: "Send Story", message: "Are you sure you want to Send The Sutta Gang's story now?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: nil)
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func selectSendTime() {
        dummyField.removeFromSuperview()
        let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
        let selectedDate = dateFormatter.string(from: dateTimePicker.date)
        
        let alert = UIAlertController(title: "Send Story", message: "Are you sure you want to Send The Sutta Gang's story at " + selectedDate + "?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: nil)
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func cancelTimePicker() {
        dummyField.removeFromSuperview()
        view.endEditing(true)
    }
}
