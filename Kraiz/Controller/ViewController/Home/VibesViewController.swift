//
//  StoriesViewController.swift
//  StoryFi
//
//  Created by Kumar Agarwal, Kanhai on 30/06/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//
//  Class to Show all the Vibes for the user.

import UIKit
import FirebaseAnalytics

class VibesViewController: UIViewController {

    @IBOutlet weak var vibesSegment: UISegmentedControl!
    @IBOutlet weak var viewContainers: UIView!
    @IBOutlet weak var publicVibeButton: UIButton!
    
    let PUBLIC_VIBE_READY_COLOR = UIColor(displayP3Red: 37/255, green: 40/255, blue: 69/255, alpha: 1.0)

    var isPublicVibeReady = false
    var timer : Timer?
    
    private lazy var friendsVibesVC : FriendsVibesViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "friendsView") as! FriendsVibesViewController
        self.add(asChildViewController: viewController)
        return viewController
    }()

    private lazy var publicVibesVC : PublicVibesViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "publicView") as! PublicVibesViewController
        self.add(asChildViewController: viewController)
        return viewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()

        Analytics.logEvent("SampleIOSEvent", parameters: [AnalyticsParameterItemID: "id-title", AnalyticsParameterItemName: "parameterItemName", AnalyticsParameterContentType: "cont"])
        print("inside viewDidLoad of VibeViewController")

        let attr = NSDictionary(object: UIFont(name: "Helvetica Neue", size: 16.0)!, forKey: NSAttributedString.Key.font as NSCopying)
        vibesSegment.setTitleTextAttributes(attr as? [NSAttributedString.Key : Any], for: .normal)

        /// Fetch the last accessed time here from the server, and cache it. Schedule the timer only if the server time and current time difference is less than the decided time to the public vibe.
        var publicVibeTimer = CacheHelper.shared.getPublicVibeTimeEntity()
        if publicVibeTimer == nil {
            CacheHelper.shared.initializePublicVibeEntity()
            publicVibeTimer = CacheHelper.shared.getPublicVibeTimeEntity()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("inside viewWillAppear of VibeViewController")
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if timer != nil {
            timer!.invalidate()
        }
        timer = nil
    }

    @objc func updateTimer() {
        let currentTime = Int(Date().timeIntervalSince1970)
        let lastTime = CacheHelper.shared.getPublicVibeLastAccessedTime() / 1000

        let timeDifference = currentTime - lastTime
        print("timeDifference: \(timeDifference)")
        if timeDifference >= DeviceConstants.TIME_TO_NEXT_PUBLIC_VIBE_IN_SECONDS {
            publicVibeButton.setTitleColor(PUBLIC_VIBE_READY_COLOR, for: .normal)
            if timer != nil {
                timer!.invalidate()
            }
            timer = nil
            isPublicVibeReady = true
        } else {
            publicVibeButton.setTitleColor(UIColor.gray, for: .normal)
            isPublicVibeReady = false
        }
    }

    @IBAction func publicVibeButtonPressed(_ sender: UIButton) {
        if isPublicVibeReady {
            if !APPUtilites.isInternetConnectionAvailable() {
                APPUtilites.displayElevatedErrorSnackbar(message: "Please Check your Internet Connection.")
                return
            }
            CacheHelper.shared.clearLastPublicVibe()
            AnalyticsHelper.shared.logRandomPublicVibeEvent(action: .READY_BUTTON_CLICKED, tag: nil)
            let choosePublicTagVC = self.storyboard?.instantiateViewController(withIdentifier: "PublicVibeTagsViewController")
            self.present(choosePublicTagVC!, animated: true, completion: nil)
        } else {
            let currentTime = Int(Date().timeIntervalSince1970)
            let lastTime = CacheHelper.shared.getPublicVibeLastAccessedTime() / 1000
            let timeDifference = DeviceConstants.TIME_TO_NEXT_PUBLIC_VIBE_IN_SECONDS - (currentTime - lastTime)
            let hours = timeDifference / 3600
            let minutes = (timeDifference % 3600) / 60
            let seconds = (timeDifference % 60) % 60
            let okayAction = UIAlertAction(title: "Okay", style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            let lastPublicVibeEntity = CacheHelper.shared.getPublicVibeTimeEntity()
            let vibeId = lastPublicVibeEntity?.getLastPublicVibeId()
            if let id = vibeId {
                CacheHelper.shared.getVibeModelForRandomPublicVibe(vibeId: id, completionHandler: { (vibeModel) in
                    let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
                    let vibesWelcomeVC = storyboard.instantiateViewController(withIdentifier: "VibeWelcomeViewController") as! VibeWelcomeViewController
                    vibeModel.setVibeType(type: 1)
                    vibesWelcomeVC.vibeModel = vibeModel
                    self.present(vibesWelcomeVC, animated: true, completion: nil)
                })
            }
//            let alertController = UIAlertController(title: "Public Vibe Not ready", message: "The public vibe will be ready in \(hours):\(minutes):\(seconds)", preferredStyle: .alert)
//            alertController.addAction(okayAction)
//            self.present(alertController, animated: true, completion: nil)
        }
    }

    @IBAction func segmentValueChanged(_ sender: Any) {
        updateView()
    }

    private func updateView() {
        if vibesSegment.selectedSegmentIndex == 0 {
            remove(asChildViewController: publicVibesVC)
            add(asChildViewController: friendsVibesVC)
        } else {
            remove(asChildViewController: friendsVibesVC)
            add(asChildViewController: publicVibesVC)
        }
    }

    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChild(viewController)

        // Add Child View as Subview
        viewContainers.addSubview(viewController.view)

        // Configure Child View
        viewController.view.frame = viewContainers.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParent()
    }
}
