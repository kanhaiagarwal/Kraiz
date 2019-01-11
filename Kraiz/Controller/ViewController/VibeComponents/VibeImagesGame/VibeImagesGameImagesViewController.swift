//
//  VibeImagesGameImagesViewController.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 03/01/19.
//  Copyright © 2019 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit

class VibeImagesGameImagesViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var imageScrollView: UIScrollView!
    
    var overlayCloseView: UIView = UIView()

    var vibeModel: VibeModel?
    var captionsSelected: [Int : Bool]?
    var imagesToDisplay = [PhotoEntity]()
    var isDismissOverlayVisible = false
    var isPreview = false
    
    var selectedImage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageScrollView.delegate = self
        imageScrollView.decelerationRate = UIScrollView.DecelerationRate(rawValue: 0.1)
        overlayCloseView = createOverlayCloseView()
        prepareImagesArray()
        
        // Add Tap Gestures to all the view for the overlay effect
        let imageScrollViewGesture = UITapGestureRecognizer(target: self, action: #selector(changeDismissViewStatus))
        imageScrollView.addGestureRecognizer(imageScrollViewGesture)
        
        startMusic()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupScrollView()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setupScrollView() {
        if imageScrollView.contentSize.height == 0 && imageScrollView.contentSize.width == 0 {
            imageScrollView.showsVerticalScrollIndicator = false
            let nonSafeArea = view.safeAreaInsets.bottom
            imageScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(imagesToDisplay.count), height: view.frame.width)
            for i in 0 ..< imagesToDisplay.count {
                let gameView = Bundle.main.loadNibNamed("CaptionGameView", owner: self, options: nil)?.first as! CaptionGameView
                gameView.frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: imageScrollView.frame.height + nonSafeArea)
                gameView.backgroundImage.image = imagesToDisplay[i].image
                gameView.mainImage.image = imagesToDisplay[i].image
                gameView.captionLabel.text = imagesToDisplay[i].caption == nil ? "" : imagesToDisplay[i].caption!
                imageScrollView.addSubview(gameView)
            }
        }
    }

    func prepareImagesArray() {
        for i in 0 ..< vibeModel!.getImages().count {
            if captionsSelected![i]! {
                imagesToDisplay.append(vibeModel!.getImages()[i])
            }
        }
    }

    /// Creates the Overlay View which will contain the close button.
    func createOverlayCloseView() -> UIView {
        let overlayCloseView = UIView(frame: CGRect(x: 0, y: -view.frame.height / 10, width: view.frame.width, height: view.frame.height / 10))
        overlayCloseView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.5)
        
        let dismissButton = UIButton(frame: CGRect(x: overlayCloseView.frame.width / 20, y: overlayCloseView.frame.height / 2 - 5, width: overlayCloseView.frame.height / 2, height: overlayCloseView.frame.height / 2))
        
        var dismissButtonTitleAttributes = [NSAttributedString.Key : Any]()
        dismissButtonTitleAttributes[.font] = UIFont.boldSystemFont(ofSize: 30)
        dismissButtonTitleAttributes[.foregroundColor] = UIColor.white
        let dismissButtonAttributedTitle = NSAttributedString(string: "⨯", attributes: dismissButtonTitleAttributes)
        dismissButton.setAttributedTitle(dismissButtonAttributedTitle, for: .normal)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onCloseClick))
        dismissButton.addGestureRecognizer(tapGesture)
        dismissButton.layer.cornerRadius = dismissButton.frame.height / 2
        overlayCloseView.addSubview(dismissButton)
        
        let nextButton = UIButton(frame: CGRect(x: overlayCloseView.frame.width - overlayCloseView.frame.height / 2, y: overlayCloseView.frame.height / 2 - 5, width: overlayCloseView.frame.height / 2, height: overlayCloseView.frame.height / 2))
        
        var nextButtonTitleAttributes = [NSAttributedString.Key : Any]()
        nextButtonTitleAttributes[.font] = UIFont.systemFont(ofSize: 35)
        nextButtonTitleAttributes[.foregroundColor] = UIColor.white
        let nextButtonAttributedTitle = NSAttributedString(string: "→", attributes: nextButtonTitleAttributes)
        nextButton.setAttributedTitle(nextButtonAttributedTitle, for: .normal)

        if !isPreview && (vibeModel!.to?.getUsername() != UserDefaults.standard.string(forKey: DeviceConstants.USER_NAME)){
            let nextTapGesture = UITapGestureRecognizer(target: self, action: #selector(nextPressed))
            nextButton.addGestureRecognizer(nextTapGesture)
            nextButton.layer.cornerRadius = nextButton.frame.height / 2
            overlayCloseView.addSubview(nextButton)
        }
        
        view.addSubview(overlayCloseView)
        overlayCloseView.isHidden = true
        return overlayCloseView
    }

    @objc func onCloseClick() {
        AudioControls.shared.stopMusic()
        if !vibeModel!.isLetterPresent {
            var presentingVC: UIViewController?
            if vibeModel!.seenIds.count == 0 {
                presentingVC = self.presentingViewController!.presentingViewController!.presentingViewController!
            } else {
                presentingVC = self.presentingViewController!.presentingViewController!
            }
            presentingVC!.dismiss(animated: true) {
                self.dismiss(animated: false, completion: nil)
            }
        } else {
            let presentingVC = self.presentingViewController!.presentingViewController!.presentingViewController!.presentingViewController!
            presentingVC.dismiss(animated: true) {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }

    @objc func nextPressed() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let hailsInputVC = storyboard.instantiateViewController(withIdentifier: "VibeHailInputViewController") as! VibeHailInputViewController
        hailsInputVC.vibeModel = vibeModel
        self.present(hailsInputVC, animated: true, completion: nil)
    }

    @objc func changeDismissViewStatus() {
        UIView.animate(withDuration: 0.2, animations: {
            if self.isDismissOverlayVisible {
                self.isDismissOverlayVisible = false
                self.overlayCloseView.frame.origin.y = -self.overlayCloseView.frame.height
            } else {
                self.isDismissOverlayVisible = true
                self.overlayCloseView.isHidden = false
                self.overlayCloseView.frame.origin.y = 0
            }
        }) { (success) in
            if !self.isDismissOverlayVisible {
                self.overlayCloseView.isHidden = true
            }
        }
    }
    func startMusic() {
        if !vibeModel!.isLetterPresent && vibeModel!.isBackgroundMusicEnabled {
            AudioControls.shared.playBackgroundMusic(musicIndex: vibeModel!.backgroundMusicIndex)
        }
    }
}
