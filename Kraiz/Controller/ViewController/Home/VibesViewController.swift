//
//  StoriesViewController.swift
//  StoryFi
//
//  Created by Kumar Agarwal, Kanhai on 30/06/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//
//  Class to Show all the Vibes for the user.

import UIKit

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
            let choosePublicTagVC = self.storyboard?.instantiateViewController(withIdentifier: "PublicVibeTagsViewController")
            self.present(choosePublicTagVC!, animated: true, completion: nil)
        } else {
            let currentTime = Int(Date().timeIntervalSince1970)
            let lastTime = CacheHelper.shared.getPublicVibeLastAccessedTime() / 1000
            let timeDifference = (DeviceConstants.TIME_TO_NEXT_PUBLIC_VIBE_IN_SECONDS - (currentTime - lastTime)) / 60 > 0 ? "\((DeviceConstants.TIME_TO_NEXT_PUBLIC_VIBE_IN_SECONDS - (currentTime - lastTime)) / 60 > 0)" : "\((DeviceConstants.TIME_TO_NEXT_PUBLIC_VIBE_IN_SECONDS - (currentTime - lastTime)) / 3600)"
            APPUtilites.displayElevatedErrorSnackbar(message: "There are still \(timeDifference) minutes to go")
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
