//
//  VibeHailInputViewController.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 27/12/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit

class VibeHailInputViewController: UIViewController {

    @IBOutlet weak var bgView: UIView!

    var gradientLayer: CAGradientLayer?
    var vibeModel: VibeModel?
    @IBOutlet weak var hailTextView: UITextView!
    @IBOutlet weak var hailUserLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hailUserLabel.text = "Hail \(vibeModel!.from?.getUsername() != nil ? vibeModel!.from?.getUsername()! : "The User")"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        createToolbarForTextView(textView: hailTextView)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        gradientLayer = CAGradientLayer()
        gradientLayer?.frame = bgView.bounds
        gradientLayer?.colors = [UIColor(displayP3Red: 41/225, green: 50/255, blue: 60/255, alpha: 1.0).cgColor, UIColor(displayP3Red: 72/255, green: 85/255, blue: 99/255, alpha: 1.0).cgColor]
        bgView.layer.addSublayer(gradientLayer!)

        hailTextView.layer.borderColor = UIColor.white.cgColor
        hailTextView.layer.borderWidth = 2.0
        hailTextView.layer.cornerRadius = 5.0
    }

    @IBAction func dismissPressed(_ sender: Any) {
        presentClosingAlert()
    }

    @IBAction func hailPressed(_ sender: UIButton) {
        AppSyncHelper.shared.sendHail(hailText: hailTextView.text, vibeId: vibeModel!.id, sender: UserDefaults.standard.string(forKey: DeviceConstants.USER_ID)!) { [weak self] (success) in
            DispatchQueue.main.async {
                if success {
                    self?.dismissVCAction(sendPressed: true)
                } else {
                    APPUtilites.displayErrorSnackbar(message: "Could not send the hail. Please try again.")
                }
            }
        }
    }

    func dismissVCAction(sendPressed: Bool) {
        AudioControls.shared.stopMusic()
        var presentingVC: UIViewController?

        if vibeModel!.isLetterPresent && vibeModel!.isPhotosPresent {
            if vibeModel!.getSeenIds().count == 0 {
                presentingVC = self.presentingViewController!.presentingViewController!.presentingViewController!.presentingViewController!.presentingViewController!
            } else {
                presentingVC = self.presentingViewController!.presentingViewController!.presentingViewController!.presentingViewController!
            }
        } else if vibeModel!.isPhotosPresent && vibeModel!.imageBackdrop == 1 && vibeModel!.getSeenIds().count == 0 {
            presentingVC = self.presentingViewController!.presentingViewController!.presentingViewController!.presentingViewController!
        }
        else {
            presentingVC = self.presentingViewController!.presentingViewController!.presentingViewController!
        }
        presentingVC?.dismiss(animated: true, completion: {
            self.dismiss(animated: true, completion: nil)
        })
    }

    func presentClosingAlert() {
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        let closeAction = UIAlertAction(title: "Yes", style: .destructive) { [weak self] (action) in
            self?.dismissKeyboard()
            self?.dismissVCAction(sendPressed: false)
        }
        let alertController = UIAlertController(title: "Don't send Hail", message: "Are you sure you don't want to hail this vibe?", preferredStyle: .actionSheet)
        alertController.addAction(cancelAction)
        alertController.addAction(closeAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func createToolbarForTextView(textView: UITextView) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.dismissKeyboard))
        let flexButton1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let flexButton2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolbar.setItems([flexButton1, flexButton2, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        textView.inputAccessoryView = toolbar
    }
}
