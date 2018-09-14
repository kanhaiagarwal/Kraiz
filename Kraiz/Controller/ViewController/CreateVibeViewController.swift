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
    
    @IBOutlet weak var audioView: UIView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var imagesView: UIView!
    @IBOutlet weak var letterView: UIView!
    @IBOutlet weak var letterImageView: UIImageView!
    @IBOutlet weak var photosImageView: UIImageView!
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var audioImageView: UIImageView!
    @IBOutlet weak var appreciationImageView: UIImageView!
    @IBOutlet weak var storyTagImageView: UIImageView!
    @IBOutlet weak var letterLabel: UILabel!
    @IBOutlet weak var photosLabel: UILabel!
    @IBOutlet weak var videoLabel: UILabel!
    @IBOutlet weak var audioLabel: UILabel!
    @IBOutlet weak var appreciationLabel: UILabel!
    @IBOutlet weak var vibeTagLabel: UILabel!
    @IBOutlet weak var reviewImageView: UIImageView!
    @IBOutlet weak var continueImageView: UIImageView!
    
    @IBOutlet weak var letterCheckbox: UIView!
    @IBOutlet weak var photosCheckbox: UIView!
    @IBOutlet weak var videoCheckbox: UIView!
    @IBOutlet weak var audioCheckbox: UIView!
    @IBOutlet weak var selectionButtonView: UIView!
    
    @IBOutlet weak var letterCrossButton: UIButton!
    @IBOutlet weak var photosCrossButton: UIButton!
    @IBOutlet weak var videoCrossButton: UIButton!
    @IBOutlet weak var audioCrossButton: UIButton!
    
    var isLetterSelected : Bool = false
    var isImagesSelected : Bool = false
    var isVideoSelected : Bool = false
    var isAudioSelected : Bool = false
    var isAppreciationSelected : Bool = false
    var isSelectionToggleOn : Bool = false
    
    var videoFromPhone : URL? = nil
    var audioFromPhone : URL? = nil
    
    var letterText : String = "Hello World"
    var letterBackground : Int = 0
    
    let TICK : String = "tick"
    let CROSS : String = "cross"
    
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
    
    var imagesSelectedFromGallery = [PHAsset]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInputViewShadow(inputView: letterView)
        setInputViewShadow(inputView: videoView)
        setInputViewShadow(inputView: audioView)
        setInputViewShadow(inputView: imagesView)
        setupCheckboxes()
        addGesturesToIcons()
        setSelectionButtonView()
        setupCrossButtons()
        
        reviewImageView.alpha = 0
        continueImageView.alpha = 0
    }
    
    override func viewDidLayoutSubviews() {
        selectionButtonView.layer.cornerRadius = selectionButtonView.frame.height / 2
    }
    
    @IBAction func crossButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickLetterCross(_ sender: UIButton) {
        let alert = UIAlertController(title: "Remove Letter", message: "Are you sure you want to remove the letter from the story", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.letterText = ""
            self.letterBackground = 0
            self.isLetterSelected = false
            self.letterCheckbox.isHidden = true
            self.letterImageView.image = UIImage(named: "letter-unselected")
            self.letterLabel.textColor = self.unselectedColor
            self.letterCrossButton.isHidden = true
            self.letterCrossButton.isEnabled = false
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onClickPhotosCross(_ sender: UIButton) {
        imagesSelectedFromGallery = []
        isImagesSelected = false
        performTickAnimation(checkbox: photosCheckbox, isSelected: isImagesSelected)
    }
    
    @IBAction func onClickVideoCross(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Remove Video", message: "Are you sure you want to remove the video", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.videoFromPhone = nil
            self.isVideoSelected = false
            self.videoCheckbox.isHidden = true
            self.videoImageView.image = UIImage(named: "video-unselected")
            self.videoLabel.textColor = self.unselectedColor
            self.videoCrossButton.isHidden = true
            self.videoCrossButton.isEnabled = false
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func onClickAudioCross(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Remove Video", message: "Are you sure you want to remove the video", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.audioFromPhone = nil
            self.isAudioSelected = false
            self.audioCheckbox.isHidden = true
            self.audioImageView.image = UIImage(named: "audio-unselected")
            self.audioLabel.textColor = self.unselectedColor
            self.audioCrossButton.isHidden = true
            self.audioCrossButton.isEnabled = false
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
        }))
        self.present(alert, animated: true, completion: nil)
        performTickAnimation(checkbox: audioCheckbox, isSelected: isAudioSelected)
    }
    
    func setupCrossButtons() {
        letterCrossButton.isHidden = true
        letterCrossButton.isEnabled = false
        photosCrossButton.isHidden = true
        photosCrossButton.isEnabled = false
        videoCrossButton.isHidden = true
        videoCrossButton.isEnabled = false
        audioCrossButton.isHidden = true
        audioCrossButton.isEnabled = false
        
        letterCrossButton.layer.cornerRadius = letterCrossButton.frame.height / 2
        letterCrossButton.layer.borderWidth = 1.0
        letterCrossButton.layer.borderColor = UIColor.gray.cgColor
        
        photosCrossButton.layer.cornerRadius = photosCrossButton.frame.height / 2
        photosCrossButton.layer.borderWidth = 1.0
        photosCrossButton.layer.borderColor = UIColor.gray.cgColor
        
        videoCrossButton.layer.cornerRadius = videoCrossButton.frame.height / 2
        videoCrossButton.layer.borderWidth = 1.0
        videoCrossButton.layer.borderColor = UIColor.gray.cgColor
        
        audioCrossButton.layer.cornerRadius = audioCrossButton.frame.height / 2
        audioCrossButton.layer.borderWidth = 1.0
        audioCrossButton.layer.borderColor = UIColor.gray.cgColor
    }
    
    /// Adds Tap Gestures to icon views and selection button
    func addGesturesToIcons() {
        let letterTapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickLetterIcon))
        let imagesTapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickImagesIcon))
        let videoTapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickVideoIcon))
        let audioTapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickAudioIcon))
        let reviewTapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickReviewIcon))
        let myVibeImageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickMyVibeIcon))
        let myVibeLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickMyVibeIcon))
        let continueTapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickContinueIcon))
        let appreciationTapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickAppreciationIcon))
        let selectionButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickSelectionButton))
        letterView.addGestureRecognizer(letterTapGesture)
        imagesView.addGestureRecognizer(imagesTapGesture)
        videoView.addGestureRecognizer(videoTapGesture)
        audioView.addGestureRecognizer(audioTapGesture)
        appreciationImageView.addGestureRecognizer(appreciationTapGesture)
        appreciationLabel.addGestureRecognizer(appreciationTapGesture)
        
        storyTagImageView.addGestureRecognizer(myVibeImageViewTapGesture)
        vibeTagLabel.addGestureRecognizer(myVibeLabelTapGesture)
        selectionButtonView.addGestureRecognizer(selectionButtonTapGesture)
        reviewImageView.addGestureRecognizer(reviewTapGesture)
        continueImageView.addGestureRecognizer(continueTapGesture)
    }
    
    ///Initially hides the checkboxes initially.
    func setupCheckboxes() {
        letterCheckbox.isHidden = true
        photosCheckbox.isHidden = true
        videoCheckbox.isHidden = true
        audioCheckbox.isHidden = true
    }
    
    /// Sets the shadow and tick icon inside the selection button view.
    func setSelectionButtonView() {
        setShadowLayerOfSelectionButton()
        drawInSelectionButton(pathName: TICK)
    }
}

extension CreateVibeViewController {
    
    /// Set shadows on all the icon views
    /// - Parameter inputView: The view whose shadow has to be drawn.
    func setInputViewShadow(inputView: UIView) {
        let cornerRadius : CGFloat = inputView.frame.height / 15
        inputView.layer.cornerRadius = cornerRadius
        inputView.layer.shadowColor = UIColor.black.cgColor
        inputView.layer.shadowOffset = CGSize(width: 0, height: 0)
        inputView.layer.shadowOpacity = 0.5
    }
    
    
}

extension CreateVibeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /// Action performed on click of the Letter View
    @objc func onClickLetterIcon() {
        performSegue(withIdentifier: TEXT_INPUT_SEGUE, sender: self)
    }
    
    /// Action performed on click of the Photos View
    @objc func onClickImagesIcon() {
        if isImagesSelected {
            performSegue(withIdentifier: PHOTOS_INPUT_SEGUE, sender: self)
            isImagesSelected = false
            photosCheckbox.isHidden = true
            photosImageView.image = UIImage(named: "photos-unselected")
            photosLabel.textColor = unselectedColor
            photosCrossButton.isHidden = true
            photosCrossButton.isEnabled = false
        } else {
//            openImagePicker()
            isImagesSelected = true
            self.isImagesSelected = true
            self.photosCheckbox.isHidden = false
            self.photosImageView.image = UIImage(named: "photos-selected")
            self.photosLabel.textColor = self.selectedColor
            self.photosCrossButton.isHidden = false
            self.photosCrossButton.isEnabled = true
        }
        performTickAnimation(checkbox: photosCheckbox, isSelected: isImagesSelected)
    }
    
    /// Action performed on click of the Video View
    @objc func onClickVideoIcon() {
            pickVideoFromPhone()
    }
    
    /// Action performed on click of the Audio View
    @objc func onClickAudioIcon() {
        performSegue(withIdentifier: AUDIO_RECORDER_SEGUE, sender: self)
    }
    
    /// Action performed on click of the Appreciation View
    @objc func onClickAppreciationIcon() {
        if isAppreciationSelected {
            isAppreciationSelected = false
            appreciationImageView.image = UIImage(named: "appreciation-unselected")
            appreciationLabel.textColor = unselectedColor
        } else {
            isAppreciationSelected = true
            appreciationImageView.image = UIImage(named: "appreciation-selected")
            appreciationLabel.textColor = selectedColor
        }
    }
    
    /// Action to perform on clicking the Review Icon
    @objc func onClickReviewIcon() {
        // Show the story here.
    }
    
    /// Action to perform on clicking the Continue Icon
    @objc func onClickContinueIcon() {
        performSegue(withIdentifier: FINAL_APPROVAL_SEGUE, sender: self)
    }
    
    /// Action to perform on clicking the My Vibe Icon
    @objc func onClickMyVibeIcon() {
        performSegue(withIdentifier: MY_VIBE_SEGUE, sender: self)
    }
    
    /// Action performed on click of the Selection Button.
    @objc func onClickSelectionButton() {
        selectionButtonView.layer.sublayers = nil
        selectionButtonView.layer.cornerRadius = selectionButtonView.frame.height / 2
        if isSelectionToggleOn {
            isSelectionToggleOn = false
            drawInSelectionButton(pathName: TICK)
            UIView.animate(withDuration: 0.5, animations: {
                self.reviewImageView.alpha = 0
                self.continueImageView.alpha = 0
                self.appreciationImageView.alpha = 1
                self.appreciationLabel.alpha = 1
                self.storyTagImageView.alpha = 1
                self.vibeTagLabel.alpha = 1
            }, completion: nil)
        } else {
            isSelectionToggleOn = true
            drawInSelectionButton(pathName: CROSS)
            UIView.animate(withDuration: 0.5, animations: {
                self.reviewImageView.alpha = 1
                self.continueImageView.alpha = 1
                self.appreciationImageView.alpha = 0
                self.appreciationLabel.alpha = 0
                self.storyTagImageView.alpha = 0
                self.vibeTagLabel.alpha = 0
            })
        }
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
            pathAnimation.fillMode = kCAFillModeForwards
            pathAnimation.isRemovedOnCompletion = false
            layer.add(pathAnimation, forKey: "pathanimation")
        }
    }
    
    /// Draws path in selection button
    /// - Parameter: Path Name
    func drawInSelectionButton(pathName: String) {
        let path = (pathName == TICK) ? getSelectionButtonTickPath() : getSelectionButtonCrossPath()
        let layer = CAShapeLayer()
        
        layer.path = path.cgPath
        layer.lineWidth = 5
        layer.strokeColor = UIColor.white.cgColor
        layer.fillColor = UIColor.clear.cgColor
        
        selectionButtonView.layer.addSublayer(layer)
    }
    
    /// Sets the shadow layer of the selection button.
    func setShadowLayerOfSelectionButton() {
        selectionButtonView.layer.shadowColor = UIColor.black.cgColor
        selectionButtonView.layer.shadowOffset = CGSize(width: 0, height: 0)
        selectionButtonView.layer.shadowOpacity = 1
    }
    
    /// Get the path for the tick mark of the selection button.
    /// - Returns: Tick Path.
    func getSelectionButtonTickPath() -> UIBezierPath {
        let path = UIBezierPath()
        let width = selectionButtonView.frame.width
        let height = selectionButtonView.frame.height
        
        path.move(to: CGPoint(x: width / 6, y: height / 2))
        path.addLine(to: CGPoint(x: width / 3, y: 3 * height / 4))
        path.addLine(to: CGPoint(x: 4 * width / 5, y: height / 3))
        path.stroke()
        
        return path
    }
    
    /// Gets the path for the cross mark of the selection button.
    /// - Returns: Cross Path
    func getSelectionButtonCrossPath() -> UIBezierPath {
        let path = UIBezierPath()
        let width = selectionButtonView.frame.width
        let height = selectionButtonView.frame.height
        
        path.move(to: CGPoint(x: width / 4, y: height / 4))
        path.addLine(to: CGPoint(x: 3 * width / 4, y: 3 * height / 4))
        path.move(to: CGPoint(x: 3 * width / 4, y: height / 4))
        path.addLine(to: CGPoint(x: width / 4, y: 3 * height / 4))
        path.stroke()
        
        return path
    }
    
    /// Function to pick the video from the Photo Library.
    public func pickVideoFromPhone() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = ["public.movie"]
        
        self.present(imagePickerController, animated: true) {
        }
    }
    
    /// Method called after video picking is completed from the Photo Library.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let videoUrl = info[UIImagePickerControllerMediaURL] as? URL {
            print("Media URL: \(videoUrl.absoluteString)")
            videoFromPhone = videoUrl
            self.dismiss(animated: true, completion: nil)
            isVideoSelected = true
            videoCheckbox.isHidden = false
            videoImageView.image = UIImage(named: "video-selected")
            videoLabel.textColor = selectedColor
            videoCrossButton.isHidden = false
            videoCrossButton.isEnabled = true
        } else {
            isVideoSelected = false
            videoCheckbox.isHidden = true
            videoImageView.image = UIImage(named: "video-unselected")
            videoLabel.textColor = unselectedColor
            videoCrossButton.isHidden = true
            videoCrossButton.isEnabled = false
        }
        performTickAnimation(checkbox: videoCheckbox, isSelected: isVideoSelected)
    }
    
    /// Method to open a custom Image Picker
    func openImagePicker() {
        let imagePicker = BSImagePickerViewController()
        
        imagePicker.maxNumberOfSelections = MAX_IMAGES_TO_BE_SELECTED
        imagePicker.selectionCharacter = "√"
        
        bs_presentImagePickerController(imagePicker, animated: true, select: { (asset: PHAsset) -> Void in
            print("Select: \(asset)")
        }, deselect: { (asset: PHAsset) -> Void in
            print("Deselect: \(asset)")
        }, cancel: { (assets: [PHAsset]) -> Void in
            print("Cancel: \(assets)")
        }, finish: { (assets: [PHAsset]) -> Void in
            print("Finish: \(assets)")
            self.imagesSelectedFromGallery = assets
            self.isImagesSelected = true
        }, completion: nil)
    }
}

extension CreateVibeViewController: AudioRecorderProtocol, LetterInputProtocol {
    func letterInput(backgroundImage: Int, text: String) {
        letterBackground = backgroundImage
        letterText = text
        isLetterSelected = true
        letterCheckbox.isHidden = false
        letterImageView.image = UIImage(named: "letter-selected")
        letterLabel.textColor = selectedColor
        letterCrossButton.isHidden = false
        letterCrossButton.isEnabled = true
        
        performTickAnimation(checkbox: letterCheckbox, isSelected: isLetterSelected)
    }
    
    
    func audioRecording(recordingURL: URL) {
        print("Inside the delegate audioRecording")
        if (recordingURL.absoluteString != "") {
            print("recordingURL.absoluteString is not ''")
            audioFromPhone = recordingURL
            isAudioSelected = true
            audioCheckbox.isHidden = false
            audioImageView.image = UIImage(named: "audio-selected")
            audioLabel.textColor = selectedColor
            audioCrossButton.isHidden = false
            audioCrossButton.isEnabled = true
        } else {
            print("recordingURL.absoluteString is ''")
            audioFromPhone = nil
            isAudioSelected = false
            audioCheckbox.isHidden = true
            audioImageView.image = UIImage(named: "audio-unselected")
            audioLabel.textColor = unselectedColor
            audioCrossButton.isHidden = true
            audioCrossButton.isEnabled = false
        }
        performTickAnimation(checkbox: audioCheckbox, isSelected: isAudioSelected)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == AUDIO_RECORDER_SEGUE {
            let destinationVC = segue.destination as! AudioRecorderViewController
            destinationVC.delegate = self
        } else if segue.identifier == TEXT_INPUT_SEGUE {
            let destinationVC = segue.destination as! LetterInputViewController
            destinationVC.delegate = self
            destinationVC.backgroundSelected = letterBackground
            destinationVC.letterFromVC = letterText
        }
    }
    
}
