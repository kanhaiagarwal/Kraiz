//
//  VibeImagesViewController.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 07/12/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit

class VibeImagesViewController: UIViewController {
    
    let CHANGE_ANGLE : Float = Float(CGFloat.pi / 2500)
    var divisor : CGFloat!
    var cards = [VibeImageCardView]()
    var vibeModel: VibeModel?
    var cardOutside : Int = -1
    var isSourceLetter = false
    var isDismissOverlayVisible = false
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var overlayCloseView: UIView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        overlayCloseView = createOverlayCloseView()
        backgroundImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeDismissViewStatus))
        backgroundImage.addGestureRecognizer(tapGesture)
        startMusic()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(resumeMusicIfPaused), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    /// Creates all the Image Cards with the images and captions.
    /// Gives the swiping gestures to the cards.
    func setViews() {
        for i in (0 ..< vibeModel!.images.count) {
            if let card = Bundle.main.loadNibNamed("VibeImageCardView", owner: self, options: nil)?.first as? VibeImageCardView {

                card.frame.origin.x = view.frame.width / 20
                card.frame.size.width = 0.95 * view.frame.width
                card.frame.origin.y = view.frame.height / 8
                card.layer.borderWidth = 3
                card.layer.borderColor = UIColor.clear.cgColor
                card.layer.shouldRasterize = true
                view.layer.rasterizationScale = UIScreen.main.scale
                cards.append(card)
                cards[i].imageView.image = vibeModel?.images[i].image!
                if let caption = vibeModel?.images[i].caption {
                    cards[i].caption.text = caption
                } else {
                    cards[i].caption.text = nil
                }
                cards[i].center = view.center
                cards[i].tag = i
                if cards[i].tag % 2 == 0 {
                    cards[i].transform = CGAffineTransform(rotationAngle: CGFloat.pi / 40)
                } else {
                    cards[i].transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 40)
                }
                let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(self.onSwipeCard(sender:)))
                cards[i].addGestureRecognizer(swipeGesture)
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeDismissViewStatus))
                cards[i].addGestureRecognizer(tapGesture)
                view.addSubview(cards[i])
                
            }
        }
        
        let swipeViewGesture = UIPanGestureRecognizer(target: self, action: #selector(self.onSwipeView(sender:)))
        view.addGestureRecognizer(swipeViewGesture)
    }

    @objc func onSwipeCard(sender: UIPanGestureRecognizer) {
        
        let tag = sender.view!.tag
        
        // This gives the point relative to the point where the touch first happended
        let point = sender.translation(in: view)
        
        // When the user has swiped left
        if point.x < 0 {
            cards[tag].center.x = view.center.x + point.x
        }
        
        if sender.state == .ended {
            if cards[tag].center.x < view.center.x / 20 && cards[tag].tag > 0 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.cards[tag].center = CGPoint(x: -self.view.center.x, y: self.self.cards[tag].center.y)
                    self.self.cards[tag].alpha = 0
                })
                cardOutside = tag
            } else if point.x > 0 && cardOutside < vibeModel!.images.count && cardOutside >= 0 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.cards[self.cardOutside].center = self.view.center
                    self.self.cards[self.cardOutside].alpha = 1
                    self.cardOutside += 1
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.cards[tag].center = self.view.center
                })
            }
        }
    }
    
    @objc func onSwipeView(sender: UIPanGestureRecognizer) {
        
        let point = sender.translation(in: view)
        
        // When the finger is swiped to the right of the point where the touch first came
        if sender.state == .ended {
            if point.x > 0 && cardOutside < vibeModel!.images.count && cardOutside >= 0 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.cards[self.cardOutside].center = self.view.center
                    self.cards[self.cardOutside].alpha = 1
                    self.cardOutside += 1
                })
            }
        }
    }
}

extension VibeImagesViewController {

    @objc func resumeMusicIfPaused() {
        if AudioControls.shared.getPlayAudioOnForeground() {
            AudioControls.shared.resumeMusic()
            AudioControls.shared.setPlayAudioOnForeground(playAudio: false)
        }
    }

    /// Creates the Overlay View which will contain the close button.
    func createOverlayCloseView() -> UIView {
        let overlayCloseView = UIView(frame: CGRect(x: 0, y: -view.frame.height / 10, width: view.frame.width, height: view.frame.height / 10))
        overlayCloseView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.0)

        let dismissButton = UIButton(frame: CGRect(x: overlayCloseView.frame.width / 20, y: overlayCloseView.frame.height / 2 - 5, width: overlayCloseView.frame.height / 2, height: overlayCloseView.frame.height / 2))
        dismissButton.setTitle("╳", for: .normal)
        dismissButton.setTitleColor(UIColor.white, for: .normal)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onCloseClick))
        dismissButton.addGestureRecognizer(tapGesture)
        dismissButton.layer.cornerRadius = dismissButton.frame.height / 2
        overlayCloseView.addSubview(dismissButton)
        view.addSubview(overlayCloseView)
        overlayCloseView.isHidden = true
        return overlayCloseView
    }

    @objc func onCloseClick() {
        AudioControls.shared.stopMusic()
        if !vibeModel!.isLetterPresent {
            let presentingVC = self.presentingViewController!.presentingViewController!
            presentingVC.dismiss(animated: true) {
                self.dismiss(animated: false, completion: nil)
            }
        } else {
            let presentingVC = self.presentingViewController!.presentingViewController!.presentingViewController!
            presentingVC.dismiss(animated: true) {
                self.dismiss(animated: false, completion: nil)
            }
        }
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
