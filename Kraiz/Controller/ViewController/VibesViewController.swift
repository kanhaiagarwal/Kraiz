//
//  StoriesViewController.swift
//  StoryFi
//
//  Created by Kumar Agarwal, Kanhai on 30/06/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//
//  Class to Show all the Vibes for the user.

import UIKit

class VibesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var vibesTable: UITableView!
    @IBOutlet weak var topBarView: UIView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("VibesTableViewCell", owner: self, options: nil)?.first as! VibesTableViewCell
        
        cell.usernameField.text = "username" + String(indexPath.row)
        cell.profileImage.image = UIImage(named: "Disha")
        cell.timestampField.text = "Yesterday"
        cell.vibeNameField.text = "Happy Birthday Subramanium" + String(indexPath.row) + "😃😃🕺"
        cell.vibeComponent1.image = UIImage(named: "letter-on-all-vibes")
        cell.vibeComponent2.image = UIImage(named: "photos-on-all-vibes")
        cell.vibeComponent3.image = UIImage(named: "video-on-all-vibes")
        cell.vibeComponent4.image = UIImage(named: "audio-on-all-vibes")
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
        print("row selected: \(indexPath.row)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        vibesTable.delegate = self
        vibesTable.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        let topBarBackground = UIView(frame: CGRect(x: 0, y: topBarView.frame.height, width: topBarView.frame.width, height: 1))
        topBarBackground.backgroundColor = DeviceConstants.DEFAULT_SEPERATOR_COLOR
        topBarView.addSubview(topBarBackground)
    }
}
