//
//  HailsViewController.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 15/12/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit
import RealmSwift

class HailsViewController: UIViewController {

    
    @IBOutlet weak var hailsView: CornerRadiusView!
    @IBOutlet weak var hailsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var hailsTable: UITableView!
    
    let HAILS_VIEW_MIN_HEIGHT_PROPORTION = 0.2
    let HAILS_VIEW_HEIGHT_INCREASE_STEPS = 0.1
    let HAILS_VIEW_MAX_HEIGHT_PROPORTION = 0.8
    let MAX_HAILS_IN_SINGLE_VIEW = 8
    let NUMBER_OF_HAILS = 3
    
    var hails : Results<HailsEntity>?
    var vibeId : String?
    var notification = NotificationToken()

    override func viewDidLoad() {
        super.viewDidLoad()

        hailsView.isUserInteractionEnabled = true
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(dismissVC))
        hailsView.addGestureRecognizer(swipeGesture)
        if let hailResult = CacheHelper.shared.getHailsOfVibe(vibeId: vibeId!) {
            hails = hailResult
            notification = hailResult.observe { [weak self] (changes) in
                self!.hailsTable.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (hails == nil) || ((hails!.count) <= MAX_HAILS_IN_SINGLE_VIEW / 2) {
            hailsHeightConstraint = hailsHeightConstraint.setMultiplier(multiplier: 0.5)
        } else {
            hailsHeightConstraint = hailsHeightConstraint.setMultiplier(multiplier: 1.0)
        }
        
        hailsTable.estimatedRowHeight = UITableView.automaticDimension
        hailsTable.rowHeight = UITableView.automaticDimension
    }
    
    @objc func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func dismissPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension HailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hails != nil ? hails!.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("HailsTableViewCell", owner: self, options: nil)?.first as! HailsTableViewCell
        print("inside cellForRowAt")
        let profile = CacheHelper.shared.getProfileById(id: hails![indexPath.row].getAuthor())
        cell.senderName.text = profile?.getUsername()!
        cell.hailText.text = hails![indexPath.row].getComment()
        cell.timestamp.text = APPUtilites.getDateFromEpochTime(epochTime: hails![indexPath.row].getCreatedAt())
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
