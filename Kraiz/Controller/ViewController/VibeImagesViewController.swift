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
    
    var overlayView: UIView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        overlayView = createOverlayView()
        backgroundImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeDismissViewStatus))
        backgroundImage.addGestureRecognizer(tapGesture)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func setViews() {
        for i in (0 ..< vibeModel!.images.count) {
            if let card = Bundle.main.loadNibNamed("VibeImageCardView", owner: self, options: nil)?.first as? VibeImageCardView {

                card.frame.origin.x = view.frame.width / 20
                card.frame.size.width = 0.95 * view.frame.width
                card.frame.origin.y = view.frame.height / 8
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

    func createOverlayView() -> UIView {
        let overlayView = UIView(frame: CGRect(x: 0, y: -view.frame.height / 10, width: view.frame.width, height: view.frame.height / 10))
        overlayView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.5)
        let dismissButton = UIButton(frame: CGRect(x: overlayView.frame.width / 20, y: overlayView.frame.height / 2 - 5, width: overlayView.frame.height / 2, height: overlayView.frame.height / 2))
        dismissButton.backgroundColor = UIColor.white
        dismissButton.setTitle("X", for: .normal)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onCloseClick))
        dismissButton.addGestureRecognizer(tapGesture)
        dismissButton.setTitleColor(UIColor.black, for: .normal)
        dismissButton.layer.cornerRadius = dismissButton.frame.height / 2
        overlayView.addSubview(dismissButton)
        view.addSubview(overlayView)
        overlayView.isHidden = true
        return overlayView
    }

    @objc func onCloseClick() {
        print("Clicked on the close button")
        self.dismiss(animated: true, completion: nil)
    }

    @objc func changeDismissViewStatus() {
        UIView.animate(withDuration: 0.2, animations: {
            if self.isDismissOverlayVisible {
                self.isDismissOverlayVisible = false
                self.overlayView.frame.origin.y = -self.overlayView.frame.height
            } else {
                self.isDismissOverlayVisible = true
                self.overlayView.isHidden = false
                self.overlayView.frame.origin.y = 0
            }
        }) { (success) in
            if !self.isDismissOverlayVisible {
                self.overlayView.isHidden = true
            }
        }
    }
}
