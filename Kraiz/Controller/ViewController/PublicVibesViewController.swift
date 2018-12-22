//
//  PublicVibesViewController.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 11/11/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit
import RealmSwift

class PublicVibesViewController: UIViewController {

    @IBOutlet weak var vibesTable: UITableView!

    var publicVibes: Results<VibeDataEntity>?
    var notification: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()

        let indexValue = APPUtilites.getVibeIndex(indexType: "vibeType", vibeType: "PUBLIC", vibeTag: nil)
        print("indexValue: \(indexValue)")
        if let vibeResults = CacheHelper.shared.getVibesByIndex(index: "vibeTypeGsiPK", value: indexValue) {
            if vibeResults.count == 0 {
                AppSyncHelper.shared.getUserVibesPaginated(requestedVibeTag: nil, requestedVibeType: VibeType.public, first: 10, after: nil, completionHandler: nil)
            }
            publicVibes = vibeResults
            notification = vibeResults._observe({ [weak self] (changes) in
                self?.vibesTable.reloadData()
            })
        } else {
            AppSyncHelper.shared.getUserVibesPaginated(requestedVibeTag: nil, requestedVibeType: VibeType.public, first: 10, after: nil, completionHandler: nil)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        AppSyncHelper.shared.getUserChannel()
    }
}

extension PublicVibesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return publicVibes != nil ? publicVibes!.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("MyPublicVibeTableViewCell", owner: self, options: nil)?.first as! MyPublicVibeTableViewCell
        let vibe = publicVibes![indexPath.row]
        cell.reachCount.text = String(vibe.getReach())
        cell.timestamp.text = APPUtilites.getDateFromEpochTime(epochTime: vibe.getCreatedAt(), isTimeInMiliseconds: true)
        cell.vibeName.text = vibe.getVibeName()!
        let vibeCategory = APPUtilites.getVibeTag(vibeTypeTag: vibe.getVibeTypeTagGsiPK()!)
        cell.vibeCategoryImage.image = UIImage(named: VibeCategories.getVibeCategoryImage(vibeCategory: vibeCategory))
        cell.vibeCategoryName.text = VibeCategories.getVibeCategoryDisplayName(vibeCategory: vibeCategory)
        cell.vibeCategoryName.textColor = VibeCategories.getVibeCategoryColor(vibeCategory: vibeCategory)
        cell.hailButton.tag = indexPath.row
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hailButtonPressed(sender:)))
        if vibe.getHasNewHails() {
            cell.unseenHailsDot.isHidden = false
        } else {
            cell.unseenHailsDot.isHidden = true
        }
        cell.hailButton.addGestureRecognizer(tapGesture)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 4.5
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    @objc func hailButtonPressed(sender: UITapGestureRecognizer) {
        
        let tag = sender.view?.tag
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let hailVC = storyboard.instantiateViewController(withIdentifier: "HailsViewController") as! HailsViewController
        CacheHelper.shared.setHasNewHailsInVibe(hasNewHails: false, vibeId: publicVibes![tag!].getId()!)
        hailVC.vibeId = publicVibes![tag!].getId()!
        hailVC.modalPresentationStyle = .overCurrentContext
        
        present(hailVC, animated: false, completion: nil)
    }
}
