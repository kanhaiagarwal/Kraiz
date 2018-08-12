//
//  DraftsViewController.swift
//  StoryFi
//
//  Created by Kumar Agarwal, Kanhai on 02/07/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit

class DraftsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var draftsTable: UITableView!

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("DraftsTableViewCell", owner: self, options: nil)?.first as! DraftsTableViewCell
        
        cell.profileImage.image = UIImage(named: "Disha")
        cell.timestamp.text = "10/12/2048"
        cell.storyName.text = "The Story of Us"
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

        draftsTable.delegate = self
        draftsTable.dataSource = self
    }

}
