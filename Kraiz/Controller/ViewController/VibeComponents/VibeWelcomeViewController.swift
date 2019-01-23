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
    @IBOutlet weak var demoInstructionLabel: UILabel!

    var isPreview = false
    var isDemoVibe = false
    var updateLastPublicVibeTime = false

    var vibeModel: VibeModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        vibeTag.text = VibeCategories.pickerStrings[vibeModel!.category]
        vibeName.text = vibeModel!.vibeName
        backgroundImage.image = UIImage(named: VibeCategories.vibeWelcomebackground[vibeModel!.category])

        if !isPreview && !isDemoVibe {
            if vibeModel!.type == 0 && vibeModel!.from!.getUsername()! != UserDefaults.standard.string(forKey: DeviceConstants.USER_NAME)! {
                if !CacheHelper.shared.getSeenStatusOfVibe(vibeId: vibeModel!.id) {
                    AppSyncHelper.shared.updateSeenStatusOfVibe(vibeId: vibeModel!.id, seenStatus: true)
                }
            }
            if vibeModel!.from!.getUsername() != nil {
                if vibeModel!.type == 1 && vibeModel!.from!.getUsername()! != UserDefaults.standard.string(forKey: DeviceConstants.USER_NAME)! {
                    if updateLastPublicVibeTime {
                        CacheHelper.shared.addRandomPublicVibeToCache(vibeModel: vibeModel!)
                        AppSyncHelper.shared.updateLastSeenPublicVibeTime()
                    }
                }
            } else {
                if vibeModel!.type == 1 && vibeModel!.from!.getId()! != UserDefaults.standard.string(forKey: DeviceConstants.USER_ID)! {
                    if updateLastPublicVibeTime {
                        CacheHelper.shared.addRandomPublicVibeToCache(vibeModel: vibeModel!)
                        AppSyncHelper.shared.updateLastSeenPublicVibeTime()
                    }
                }
            }
        }
        AnalyticsHelper.shared.logViewVibeEvent(vibeModel: vibeModel!, action: .ADD_ALL)
        startMusic()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isDemoVibe {
            senderUsername.text = "From Kraiz"
        } else {
            if vibeModel?.from?.getUsername() != nil {
                if vibeModel?.from?.getUsername() == UserDefaults.standard.string(forKey: DeviceConstants.USER_NAME) {
                    senderUsername.text = "You"
                } else {
                    senderUsername.text = vibeModel?.from?.getUsername()
                }
            } else {
                let profile = CacheHelper.shared.getProfileById(id: (vibeModel?.from?.getId())!)
                senderUsername.text = profile?.getUsername()!
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        demoInstructionLabel.alpha = 0
        if isDemoVibe {
            let messageVC = UIAlertController(title: "Background music", message: "This vibe contains background music" , preferredStyle: .alert)
            present(messageVC, animated: true) {
                Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { (_) in
                    messageVC.dismiss(animated: true, completion: nil)
                    UIView.animate(withDuration: 2.0) {
                        self.demoInstructionLabel.alpha = 1.0
                    }
                })}
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

    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func nextPressed(_ sender: UIButton) {
        if vibeModel!.isLetterPresent {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vibeTextVC = storyboard.instantiateViewController(withIdentifier: "VibeTextViewController") as! VibeTextViewController
            vibeTextVC.vibeModel = vibeModel!
            vibeTextVC.isPreview = isPreview
            vibeTextVC.isDemoVibe = isDemoVibe
            self.present(vibeTextVC, animated: true, completion: nil)
        } else if vibeModel!.isPhotosPresent && vibeModel!.imageBackdrop == 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vibeImagesVC = storyboard.instantiateViewController(withIdentifier: "VibeImagesViewController") as! VibeImagesViewController
            vibeImagesVC.vibeModel = vibeModel!
            vibeImagesVC.isPreview = isPreview
            vibeImagesVC.isDemoVibe = isDemoVibe
            self.present(vibeImagesVC, animated: true, completion: nil)
        } else if vibeModel!.isPhotosPresent && vibeModel!.imageBackdrop == 1 {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            if isPreview || vibeModel?.getSeenIds().count == 0 {
                let captionGameCaptionsVC = storyboard.instantiateViewController(withIdentifier: "VibeImagesGameCaptionsViewController") as! VibeImagesGameCaptionsViewController
                captionGameCaptionsVC.vibeModel = vibeModel!
                captionGameCaptionsVC.isPreview = isPreview
                captionGameCaptionsVC.isDemoVibe = isDemoVibe
                self.present(captionGameCaptionsVC, animated: true, completion: nil)
            } else {
                let seenIds = vibeModel?.getSeenIds()
                var captionsSelected = [Int : Bool]()
                for i in 0 ..< vibeModel!.getImages().count {
                    captionsSelected[i] = false
                }
                for i in 0 ..< seenIds!.count {
                    for j in 0 ..< vibeModel!.getImages().count {
                        if vibeModel!.getImages()[j].imageLink == seenIds![i] {
                            print("seenId \(seenIds![i]) matched")
                            captionsSelected[j] = true
                            break
                        }
                    }
                }
                let captionGameImagesVC = storyboard.instantiateViewController(withIdentifier: "VibeImagesGameImagesViewController") as! VibeImagesGameImagesViewController
                captionGameImagesVC.vibeModel = vibeModel
                captionGameImagesVC.captionsSelected = captionsSelected
                captionGameImagesVC.isPreview = isPreview
                captionGameImagesVC.isDemoVibe = isDemoVibe
                self.present(captionGameImagesVC, animated: true, completion: nil)
            }
        }
    }
    @IBAction func dismissPressed(_ sender: Any) {
        AudioControls.shared.stopMusic()
        self.dismiss(animated: true, completion: nil)
    }

    /// Starts the Music if its enabled in the Vibe.
    func startMusic() {
        if vibeModel!.isBackgroundMusicEnabled {
            AudioControls.shared.playBackgroundMusic(musicIndex: vibeModel!.backgroundMusicIndex)
        }
    }
}
