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
import RxSwift

class CreateVibeViewController: UIViewController, VibeDetailsProtocol {

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
    
    var vibeModel = VibeModel()
    var isLetterSelected : Bool = false
    var isImagesSelected : Bool = false
    
    var letterText : String = ""
    var letterBackground : Int = 0
    
    let selectedColor = UIColor(displayP3Red: 46/255, green: 66/255, blue: 100/255, alpha: 1.0)
    let unselectedColor = UIColor(displayP3Red: 149/255, green: 149/255, blue: 149/255, alpha: 1.0)
    
    /// Segues
    let FINAL_APPROVAL_SEGUE : String = "gotoFinalApprovalPage"
    let IMAGE_PICKER_SEGUE : String = "gotoImagePicker"
    let MY_VIBE_SEGUE : String = "gotoMyVibeFromCreateVibe"
    let PHOTOS_INPUT_SEGUE : String = "gotoPhotosInput"
    let TEXT_INPUT_SEGUE : String = "gotoTextInput"
    
    let MAX_IMAGES_TO_BE_SELECTED = 9

    var photosSelected = [PhotoEntity]()
    var imageBackdropSelected = 0
    
    func setVibeDetails(vibeModel: VibeModel) {
        self.vibeModel.from = vibeModel.from
        self.vibeModel.to = vibeModel.to
        self.vibeModel.category = vibeModel.category
        self.vibeModel.isBackgroundMusicEnabled = vibeModel.isBackgroundMusicEnabled
        self.vibeModel.backgroundMusicIndex = vibeModel.backgroundMusicIndex
    }
    
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
    
    @IBAction func myVibePressed(_ sender: UIButton) {
        performSegue(withIdentifier: DeviceConstants.GOTO_MY_VIBE_FROM_CREATE_VIBE, sender: self)
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if !APPUtilites.isInternetConnectionAvailable() {
            APPUtilites.displayErrorSnackbar(message: "Please check your internet connection.")
            return
        }
        if !isLetterSelected && !isImagesSelected {
            APPUtilites.displayErrorSnackbar(message: "Please select atleast the Letter or the Photos")
            return
        }
        if isLetterSelected {
            vibeModel.setLetter(letterString: letterText, background: letterBackground)
            vibeModel.isLetterPresent = true
        }
        if isImagesSelected {
            vibeModel.setImages(photos: photosSelected)
            vibeModel.setImageBackdrop(backdrop: imageBackdropSelected)
            vibeModel.isPhotosPresent = true
            for i in 0 ..< vibeModel.images.count {
                let timeNow = String(Int(Date().timeIntervalSince1970))
                vibeModel.images[i].imageLink = "IMG_" + timeNow + "_" + NSUUID().uuidString
            }
        }

        let sv = APPUtilites.displayLoadingSpinner(onView: self.view)
        var totalUpload = 0
        let counter = Variable(0)
        counter.asObservable().subscribe(onNext: { (counter) in
            totalUpload = totalUpload + 1
            if (self.isImagesSelected && totalUpload == self.vibeModel.images.count + 2) || (!self.isImagesSelected && totalUpload == 2) {
                APPUtilites.removeLoadingSpinner(spinner: sv)
                self.performSegue(withIdentifier: self.FINAL_APPROVAL_SEGUE, sender: self)
            }
        }, onError: { (error) in
            print("error in uploading the picture")
        }, onCompleted: {
            print("upload completed")
        }) {
            print("disposed")
        }

        // Start the image upload in the background(if any images present).
        MediaHelper.shared.uploadImagesAsync(images: vibeModel.images, folder: MediaHelperConstants.VIBE_IMAGES_FOLDER, counter: counter)
        AppSyncHelper.shared.createVibe(vibe: vibeModel, success: { (success) in
            DispatchQueue.main.async {
                
                if success {
                    counter.value = 1
                } else {
                    APPUtilites.displayErrorSnackbar(message: "Vibe Creation is not successful. Please check the receiver is present in the App. Or Check the Internet Connection.")
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                APPUtilites.removeLoadingSpinner(spinner: sv)
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    /// Action to perform on pressing the Preview Button
    @IBAction func previewPressed(_ sender: UIButton) {
        if vibeModel.isLetterPresent && vibeModel.letter.text != nil {
            performSegue(withIdentifier: DeviceConstants.GOTO_TEXT_PREVIEW_FROM_CREATE, sender: self)
        } else if vibeModel.isPhotosPresent && vibeModel.images.count > 0 {
            performSegue(withIdentifier: DeviceConstants.GOTO_IMAGES_PREVIEW_FROM_CREATE, sender: self)
        }
    }

    @IBAction func crossButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Exit", message: "Do you want to exit right now? You can edit this Vibe later", preferredStyle: .actionSheet)
        
        let saveAndCloseAction = UIAlertAction(title: "Save and Exit", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        let justCloseAction = UIAlertAction(title: "Exit", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(saveAndCloseAction)
        alertController.addAction(justCloseAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
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
            self.vibeModel.isLetterPresent = false
            self.vibeModel.letter.background = nil
            self.vibeModel.letter.text = nil
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
            self.vibeModel.isPhotosPresent = false
            self.vibeModel.images.removeAll()
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
        if isImagesSelected {
            performSegue(withIdentifier: PHOTOS_INPUT_SEGUE, sender: self)
        } else {
            performSegue(withIdentifier: DeviceConstants.GOTO_IMAGE_BACKDROP_FROM_CREATE_VIBE, sender: self)
        }
    }

    /// Action to perform on clicking the Review Icon
    @objc func onClickReviewIcon() {
        // Show the vibe here.
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
        vibeModel.isLetterPresent = true
        vibeModel.letter.text = text
        vibeModel.letter.background = backgroundImage
        letterBackground = backgroundImage
        letterText = text
        isLetterSelected = true
        letterCheckbox.isHidden = false
        letterCrossButton.isHidden = false
        letterCrossButton.isEnabled = true
        
        performTickAnimation(checkbox: letterCheckbox, isSelected: isLetterSelected)
    }

    func photosInput(photos: [PhotoEntity], backdropSelected: Int) {
        if photos.count > 0 {
            imageBackdropSelected = backdropSelected
            photosSelected = []
            for i in 0..<photos.count {
                photosSelected.append(photos[i])
                vibeModel.images.append(photos[i])
            }
            vibeModel.isPhotosPresent = true
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
            destinationVC.numberOfImagesSelected = photosSelected.count
            destinationVC.selectedImages = photosSelected
            destinationVC.backdropSelected = imageBackdropSelected
        } else if segue.identifier == DeviceConstants.GOTO_MY_VIBE_FROM_CREATE_VIBE {
            let destinationVC = segue.destination as! MyVibeViewController
            destinationVC.vibeModel = vibeModel
            destinationVC.isSourceCreateVibe = true
        } else if segue.identifier == DeviceConstants.GOTO_IMAGE_BACKDROP_FROM_CREATE_VIBE {
            let destinationVC = segue.destination as! ImageBackdropViewController
            destinationVC.isSourceCreateVibe = true
        } else if segue.identifier == DeviceConstants.GOTO_TEXT_PREVIEW_FROM_CREATE {
            let destinationVC = segue.destination as! VibeTextViewController
            destinationVC.vibeModel = vibeModel
        } else if segue.identifier == DeviceConstants.GOTO_IMAGES_PREVIEW_FROM_CREATE {
            let destinationVC = segue.destination as! VibeImagesViewController
            destinationVC.vibeModel = vibeModel
            destinationVC.isSourceLetter = false
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
