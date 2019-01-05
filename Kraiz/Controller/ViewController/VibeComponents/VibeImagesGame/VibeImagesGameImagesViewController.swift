//
//  VibeImagesGameImagesViewController.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 03/01/19.
//  Copyright © 2019 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit

class VibeImagesGameImagesViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    @IBOutlet weak var imageCard: CardView!
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var captionLabel: UILabel!

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
        imageScrollView.decelerationRate = .normal
        overlayCloseView = createOverlayCloseView()
        prepareImagesArray()
        backgroundImage.image = imagesToDisplay[0].image
        
        // Add Tap Gestures to all the view for the overlay effect
        let blurEffectTapGesture = UITapGestureRecognizer(target: self, action: #selector(changeDismissViewStatus))
        blurEffect.addGestureRecognizer(blurEffectTapGesture)

        let captionLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(changeDismissViewStatus))
        captionLabel.addGestureRecognizer(captionLabelTapGesture)

        let scrollViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(changeDismissViewStatus))
        imageScrollView.addGestureRecognizer(scrollViewTapGesture)
        
        startMusic()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupScrollView()
    }

    func setupScrollView() {
        if imageScrollView.contentSize.height == 0 && imageScrollView.contentSize.width == 0 {
            imageScrollView.showsVerticalScrollIndicator = false
            imageScrollView.contentSize = CGSize(width: imageScrollView.frame.width * CGFloat(imagesToDisplay.count), height: imageScrollView.frame.width)
            imageScrollView.isPagingEnabled = false
            for i in 0 ..< imagesToDisplay.count {
                let imageView = UIImageView(frame: CGRect(x: imageScrollView.frame.width * CGFloat(i), y: 0, width: imageScrollView.frame.width, height: imageScrollView.frame.height))
                imageView.contentMode = .scaleAspectFit
                imageView.image = imagesToDisplay[i].image
                imageScrollView.addSubview(imageView)
            }
            setCaptionLabel(currentIndex: selectedImage)
        }
    }

    func prepareImagesArray() {
        for i in 0 ..< vibeModel!.getImages().count {
            if captionsSelected![i]! {
                imagesToDisplay.append(vibeModel!.getImages()[i])
            }
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollPoint = imageScrollView.contentOffset
        selectedImage = Int(scrollPoint.x / imageScrollView.frame.width)
        backgroundImage.image = imagesToDisplay[selectedImage].image
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setCaptionLabel(currentIndex: selectedImage)
    }

    func setCaptionLabel(currentIndex: Int) {
        captionLabel.text = imagesToDisplay[currentIndex].caption == nil ? "" : imagesToDisplay[currentIndex].caption!
    }

    /// Creates the Overlay View which will contain the close button.
    func createOverlayCloseView() -> UIView {
        let overlayCloseView = UIView(frame: CGRect(x: 0, y: -view.frame.height / 10, width: view.frame.width, height: view.frame.height / 10))
        overlayCloseView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.5)
        
        let dismissButton = UIButton(frame: CGRect(x: overlayCloseView.frame.width / 20, y: overlayCloseView.frame.height / 2 - 5, width: overlayCloseView.frame.height / 2, height: overlayCloseView.frame.height / 2))
        dismissButton.setTitle("╳", for: .normal)
        dismissButton.setTitleColor(UIColor.white, for: .normal)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onCloseClick))
        dismissButton.addGestureRecognizer(tapGesture)
        dismissButton.layer.cornerRadius = dismissButton.frame.height / 2
        overlayCloseView.addSubview(dismissButton)
        
        let nextButton = UIButton(frame: CGRect(x: overlayCloseView.frame.width - (overlayCloseView.frame.width / 20 + overlayCloseView.frame.height / 2), y: overlayCloseView.frame.height / 2 - 5, width: overlayCloseView.frame.height / 2, height: overlayCloseView.frame.height / 2))
        nextButton.setTitle("→", for: .normal)
        nextButton.setTitleColor(UIColor.white, for: .normal)
        
        if !isPreview {
            let nextTapGesture = UITapGestureRecognizer(target: self, action: #selector(onCloseClick))
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
            let presentingVC = self.presentingViewController!.presentingViewController!.presentingViewController!
            presentingVC.dismiss(animated: true) {
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
