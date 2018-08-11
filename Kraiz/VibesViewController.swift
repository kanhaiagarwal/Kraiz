//
//  StoriesViewController.swift
//  StoryFi
//
//  Created by Kumar Agarwal, Kanhai on 30/06/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit

class VibesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var vibesTable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("VibesTableViewCell", owner: self, options: nil)?.first as! VibesTableViewCell
        
        cell.profileImage.image = UIImage(named: "Disha")
        cell.timestampField.text = "10/12/2048"
        cell.statusLabel.text = "Scheduled"
        cell.storyNameLabel.text = "The Story of Us"
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        vibesTable.delegate = self
        vibesTable.dataSource = self
        
    }
}
