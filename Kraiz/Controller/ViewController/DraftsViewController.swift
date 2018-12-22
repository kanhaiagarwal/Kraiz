//
//  DraftsViewController.swift
//  StoryFi
//
//  Created by Kumar Agarwal, Kanhai on 02/07/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//
// Class to show all the Drafts for the user.

import UIKit
import RealmSwift

class DraftsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var draftsTable: UITableView!
    @IBOutlet weak var topBar: UIView!

    var drafts : Results<DraftEntity>?
    var notification: NotificationToken?

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drafts != nil ? drafts!.count : 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let topBorderView = UIView(frame: CGRect(x: 0, y: topBar.frame.height,
                                                 width: topBar.frame.size.width,
                                                 height: 1))
        topBorderView.backgroundColor = DeviceConstants.DEFAULT_SEPERATOR_COLOR
        topBar.addSubview(topBorderView)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("DraftsTableViewCell", owner: self, options: nil)?.first as! DraftsTableViewCell
        let draft = drafts![indexPath.row]
        cell.usernameLabel.text = draft.getVibeEntity()!.getType()! == 1 ? "You" : draft.getVibeEntity()?.getReceiverUsername()!
        cell.timestampLabel.text = APPUtilites.getDateFromEpochTime(epochTime: draft.getlastUpdatedTime(), isTimeInMiliseconds: false)
        cell.vibeNameLabel.text = draft.getVibeEntity()!.getVibeName()!
        cell.vibeTypeLabel.text = VibeTypesLocal.vibeTypes[draft.getVibeEntity()!.getType()!]
        cell.vibeTagLabel.text = VibeCategories.pickerStrings[draft.getVibeEntity()!.getCategory()!]
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let createVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateVibeViewController") as? CreateVibeViewController
        createVC?.draftId = drafts![indexPath.row].getId()!
        self.present(createVC!, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 6
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drafts = CacheHelper.shared.getDraftsFromCache()
        notification = drafts?._observe({ [weak self] (changes) in
            self?.draftsTable.reloadData()
        })

        draftsTable.delegate = self
        draftsTable.dataSource = self
    }

}
