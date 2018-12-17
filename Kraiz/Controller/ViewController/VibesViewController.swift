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
