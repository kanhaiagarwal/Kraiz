//
//  DraftsViewController.swift
//  StoryFi
//
//  Created by Kumar Agarwal, Kanhai on 02/07/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//
// Class to show all the Drafts for the user.

import UIKit

class DraftsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var draftsTable: UITableView!
    @IBOutlet weak var topBar: UIView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
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
        cell.usernameField.text = "Username" + String(indexPath.row)
        cell.timestampField.text = "1 day ago"
        cell.vibeNameField.text = "Our Vibes together!!!"
        cell.textPresentImage.image = UIImage(named: "letter-on-all-vibes")
        cell.photosPresentImage.image = UIImage(named: "photos-on-all-vibes")
        cell.videoPresentImage.image = UIImage(named: "video-on-all-vibes")
        cell.audioPresentImage.image = UIImage(named: "audio-on-all-vibes")
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 6
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        draftsTable.delegate = self
        draftsTable.dataSource = self
    }

}
