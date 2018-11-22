//
//  CreateStoryViewController.swift
//  StoryFi
//
//  Created by Kumar Agarwal, Kanhai on 08/07/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//
// Class corresponding to the Create Story View.

import UIKit
import AVFoundation
import BSImagePicker
import Photos

class CreateVibeViewController: UIViewController {
    
    @IBOutlet weak var squaresContainer: UIView!
    @IBOutlet weak var imagesView: UIView!
    @IBOutlet weak var letterView: UIView!
    @IBOutlet weak var letterImageView: UIImageView!
    @IBOutlet weak var photosImageView: UIImageView!
    @IBOutlet weak var letterLabel: UILabel!
    @IBOutlet weak var photosLabel: UILabel!
    
    @IBOutlet weak var letterCheckbox: UIView!
    @IBOutlet weak var photosCheckbox: UIView!
    @IBOutlet weak var letterCrossButton: UIButton!
    @IBOutlet weak var photosCrossButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    var isLetterSelected : Bool = false
    var isImagesSelected : Bool = false
    
    var letterText : String = "Hello World"
    var letterBackground : Int = 0
    
    let selectedColor = UIColor(displayP3Red: 46/255, green: 66/255, blue: 100/255, alpha: 1.0)
    let unselectedColor = UIColor(displayP3Red: 149/255, green: 149/255, blue: 149/255, alpha: 1.0)
    
    /// Segues
    let AUDIO_RECORDER_SEGUE : String = "gotoAudioRecorder"
    let FINAL_APPROVAL_SEGUE : String = "gotoFinalApprovalPage"
    let IMAGE_PICKER_SEGUE : String = "gotoImagePicker"
    let MY_VIBE_SEGUE : String = "gotoMyVibeFromCreateVibe"
    let PHOTOS_INPUT_SEGUE : String = "gotoPhotosInput"
    let TEXT_INPUT_SEGUE : String = "gotoTextInput"
    
    let MAX_IMAGES_TO_BE_SELECTED = 9

    var photosSelected = [PhotoEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInputViewShadow(inputView: letterView)
        setInputViewShadow(inputView: imagesView)
        setupCheckboxes()
        addGesturesToIcons()
        setupCrossButtons()
    }
    
    override func viewDidLayoutSubviews() {
        continueButton.layer.cornerRadius = continueButton.frame.height / 2
        squaresContainer.clipsToBounds = true
        squaresContainer.roundCorners([.bottomLeft, .bottomRight], radius: squaresContainer.frame.height / 4)
    }
    
    @IBAction func continuePressed(_ sender: UIButton) {
        performSegue(withIdentifier: FINAL_APPROVAL_SEGUE, sender: self)
    }
    
    @IBAction func crossButtonPressed(_ sender: UIButton) {
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickLetterCross(_ sender: UIButton) {
        let alert = UIAlertController(title: "Remove Letter", message: "Are you sure you want to remove the letter from the story", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.letterText = ""
            self.letterBackground = 0
            self.isLetterSelected = false
            self.letterCheckbox.isHidden = true
            self.letterCrossButton.isHidden = true
            self.letterCrossButton.isEnabled = false
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onClickPhotosCross(_ sender: UIButton) {
        let alert = UIAlertController(title: "Remove Photos", message: "Are you sure you want to remove the photos from the vibe", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.photosSelected = []
            self.isImagesSelected = false
            self.photosCheckbox.isHidden = true
            self.photosCrossButton.isHidden = true
            self.photosCrossButton.isEnabled = false
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
        }))
        self.present(alert, animated: true, completion: nil)
    }

    func setupCrossButtons() {
        letterCrossButton.isHidden = true
        letterCrossButton.isEnabled = false
        photosCrossButton.isHidden = true
        photosCrossButton.isEnabled = false
        
        letterCrossButton.layer.cornerRadius = letterCrossButton.frame.height / 2
        letterCrossButton.layer.borderWidth = 1.0
        letterCrossButton.layer.borderColor = UIColor.gray.cgColor
        
        photosCrossButton.layer.cornerRadius = photosCrossButton.frame.height / 2
        photosCrossButton.layer.borderWidth = 1.0
        photosCrossButton.layer.borderColor = UIColor.gray.cgColor
    }
    
    /// Adds Tap Gestures to icon views and selection button
    func addGesturesToIcons() {
        let letterTapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickLetterIcon))
        let imagesTapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickImagesIcon))
        letterView.addGestureRecognizer(letterTapGesture)
        imagesView.addGestureRecognizer(imagesTapGesture)
    }
    
    ///Initially hides the checkboxes initially.
    func setupCheckboxes() {
        letterCheckbox.isHidden = true
        photosCheckbox.isHidden = true
    }
}

extension CreateVibeViewController {
    
    /// Set shadows on all the icon views
    /// - Parameter inputView: The view whose shadow has to be drawn.
    func setInputViewShadow(inputView: UIView) {
        inputView.layer.shadowColor = UIColor.black.cgColor
        inputView.layer.shadowOffset = CGSize(width: 0, height: 0)
        inputView.layer.shadowOpacity = 0.2
    }
    
    
}

extension CreateVibeViewController {
    
    /// Action performed on click of the Letter View
    @objc func onClickLetterIcon() {
        performSegue(withIdentifier: TEXT_INPUT_SEGUE, sender: self)
    }
    
    /// Action performed on click of the Photos View
    @objc func onClickImagesIcon() {
        performSegue(withIdentifier: PHOTOS_INPUT_SEGUE, sender: self)
    }

    /// Action to perform on clicking the Review Icon
    @objc func onClickReviewIcon() {
        // Show the story here.
    }

    /// Action to perform on clicking the My Vibe Icon
    @objc func onClickMyVibeIcon() {
        performSegue(withIdentifier: MY_VIBE_SEGUE, sender: self)
    }

    /// Performs the tick animation.
    /// Tick is displayed if the view is selected.
    /// - Parameters
    ///     - ckeckbox: The view in which the tick shape has to be drawn or removed.
    ///     - isSelected: If the View is in selection mode or not.
    func performTickAnimation(checkbox: UIView, isSelected: Bool) {
        
        if !isSelected {
            checkbox.layer.sublayers = nil
        } else {
            checkbox.layer.cornerRadius = checkbox.frame.height / 2
            let path = UIBezierPath()
            let layer = CAShapeLayer()
            
            path.move(to: CGPoint(x: 4, y: 9))
            path.addLine(to: CGPoint(x: 8, y: 14))
            path.addLine(to: CGPoint(x: 15, y: 6))
            path.stroke()
            
            layer.path = path.cgPath
            layer.strokeEnd = 0
            layer.lineWidth = 2
            layer.strokeColor = UIColor.white.cgColor
            layer.fillColor = UIColor.clear.cgColor
            
            checkbox.layer.addSublayer(layer)
            
            let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
            pathAnimation.toValue = 1
            pathAnimation.duration = 1.5 // in seconds
            pathAnimation.repeatCount = 1
            pathAnimation.fillMode = CAMediaTimingFillMode.forwards
            pathAnimation.isRemovedOnCompletion = false
            layer.add(pathAnimation, forKey: "pathanimation")
        }
    }
}

extension CreateVibeViewController: LetterInputProtocol, PhotosInputProtocol {

    func letterInput(backgroundImage: Int, text: String) {
        letterBackground = backgroundImage
        letterText = text
        isLetterSelected = true
        letterCheckbox.isHidden = false
        letterCrossButton.isHidden = false
        letterCrossButton.isEnabled = true
        
        performTickAnimation(checkbox: letterCheckbox, isSelected: isLetterSelected)
    }

    func photosInput(photos: [PhotoEntity]) {
        if photos.count > 0 {
            photosSelected = []
            for i in 0..<photos.count {
                photosSelected.append(photos[i])
            }
            isImagesSelected = true
            photosCheckbox.isHidden = false
            photosCrossButton.isHidden = false
            photosCrossButton.isEnabled = true
        }
        performTickAnimation(checkbox: photosCheckbox, isSelected: isImagesSelected)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == TEXT_INPUT_SEGUE {
            let destinationVC = segue.destination as! LetterInputViewController
            destinationVC.delegate = self
            destinationVC.backgroundSelected = letterBackground
            destinationVC.letterFromVC = letterText
        } else if segue.identifier == PHOTOS_INPUT_SEGUE {
            let destinationVC = segue.destination as! PhotosInputViewController
            destinationVC.delegate = self
            print("photosSelected.count inside the prepare method: \(photosSelected.count)")
            destinationVC.numberOfImagesSelected = photosSelected.count
            destinationVC.selectedImages = photosSelected
        }
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
