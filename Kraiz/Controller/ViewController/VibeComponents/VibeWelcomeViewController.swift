//
//  VibeWelcomeViewController.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 26/12/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit

class VibeWelcomeViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var vibeTag: UILabel!
    @IBOutlet weak var vibeName: UILabel!
    @IBOutlet weak var senderUsername: UILabel!
    var isPreview = false

    var vibeModel: VibeModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        vibeTag.text = VibeCategories.pickerStrings[vibeModel!.category]
        vibeName.text = vibeModel!.vibeName
        backgroundImage.image = UIImage(named: VibeCategories.vibeWelcomebackground[vibeModel!.category])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        print("vibeModel?.from?.getUsername(): \(vibeModel?.from?.getUsername())")
        print("vibeModel.from.getUserId(): \(vibeModel?.from?.getId())")
        if vibeModel?.from?.getUsername() != nil {
            senderUsername.text = vibeModel?.from?.getUsername()
        } else {
            let profile = CacheHelper.shared.getProfileById(id: (vibeModel?.from?.getId())!)
            print("profile: \(profile)")
            print("profile?.getUsername()!: \(profile?.getUsername()!)")
            senderUsername.text = profile?.getUsername()!
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        // Create a line below the label.
        let spacing = 1 // will be added as negative bottom margin for more spacing between label and line
        
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = vibeTag.textColor
        vibeTag.addSubview(line)
        vibeTag.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[line]|", metrics: nil, views: ["line":line]))
        vibeTag.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[line(1)]-(\(-spacing))-|", metrics: nil, views: ["line": line]))
    }

    @IBAction func nextPressed(_ sender: UIButton) {
        if vibeModel!.isLetterPresent {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vibeTextVC = storyboard.instantiateViewController(withIdentifier: "VibeTextViewController") as! VibeTextViewController
            vibeTextVC.vibeModel = vibeModel!
            if isPreview {
                vibeTextVC.isPreview = true
            }
            self.present(vibeTextVC, animated: true, completion: nil)
        } else if vibeModel!.isPhotosPresent && vibeModel!.imageBackdrop == 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vibeImagesVC = storyboard.instantiateViewController(withIdentifier: "VibeImagesViewController") as! VibeImagesViewController
            vibeImagesVC.vibeModel = vibeModel!
            if isPreview {
                vibeImagesVC.isPreview = true
            }
            self.present(vibeImagesVC, animated: true, completion: nil)
        } else if vibeModel!.isPhotosPresent && vibeModel!.imageBackdrop == 1 {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vibeImagesVC = storyboard.instantiateViewController(withIdentifier: "VibeImagesGameCaptionsViewController") as! VibeImagesGameCaptionsViewController
            vibeImagesVC.vibeModel = vibeModel!
            if isPreview {
                vibeImagesVC.isPreview = true
            }
            self.present(vibeImagesVC, animated: true, completion: nil)
        }
    }
    @IBAction func dismissPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
