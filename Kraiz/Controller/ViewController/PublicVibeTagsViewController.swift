//
//  PublicVibeChoiceViewController.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 21/12/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit

class PublicVibeTagsViewController: UIViewController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var loveImage: UIImageView!
    @IBOutlet weak var partyImage: UIImageView!
    @IBOutlet weak var travelImage: UIImageView!
    @IBOutlet weak var nostalgicImage: UIImageView!
    @IBOutlet weak var goodImage: UIImageView!
    @IBOutlet weak var occasionImage: UIImageView!
    
    var gradientLayer: CAGradientLayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        let loveTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewPressed(sender:)))
        let partyTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewPressed(sender:)))
        let travelTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewPressed(sender:)))
        let nostalgicTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewPressed(sender:)))
        let goodTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewPressed(sender:)))
        let occasionTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewPressed(sender:)))
        loveImage.addGestureRecognizer(loveTapGesture)
        partyImage.addGestureRecognizer(partyTapGesture)
        travelImage.addGestureRecognizer(travelTapGesture)
        nostalgicImage.addGestureRecognizer(nostalgicTapGesture)
        goodImage.addGestureRecognizer(goodTapGesture)
        occasionImage.addGestureRecognizer(occasionTapGesture)
    }

    override func viewDidLayoutSubviews() {
        gradientLayer = CAGradientLayer()
        gradientLayer!.frame = bgView.bounds
        gradientLayer!.colors = [UIColor(displayP3Red: 255/255, green: 95/255, blue: 109/255, alpha: 1.0).cgColor, UIColor(displayP3Red: 255/255, green: 195/255, blue: 113/255, alpha: 1.0).cgColor]
        bgView.layer.addSublayer(gradientLayer!)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if gradientLayer != nil {
            gradientLayer!.removeFromSuperlayer()
        }
    }

    @IBAction func dismissPressed(_ sender: UIButton) {
        print("dismiss pressed")
        self.dismiss(animated: true, completion: nil)
    }

    @objc func imageViewPressed(sender: UITapGestureRecognizer) {
        let tag = sender.view?.tag
        print("tag: \(tag)")
        let vibeChoiceVC = self.storyboard?.instantiateViewController(withIdentifier: "PublicVibesChoiceViewController") as! PublicVibesChoiceViewController
        vibeChoiceVC.tagSelected = tag!
        self.present(vibeChoiceVC, animated: true, completion: nil)
    }
}
