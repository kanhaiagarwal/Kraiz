//
//  ContactUsViewController.swift
//  StoryFi
//
//  Created by Kumar Agarwal, Kanhai on 08/07/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController {

    let icons = ["contact", "email", "link"]
    let labels = ["+91-9023161611", "storyfi.company@gmail.com", "https://www.storyfi.app"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    @IBAction func onClickBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension ContactUsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("ContactUsTableViewCell", owner: self, options: nil)?.first as! ContactUsTableViewCell
        cell.icon.image = UIImage(named: icons[indexPath.row])
        cell.informationLabel.text = labels[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.selectionStyle = UITableViewCellSelectionStyle.none
    }
}
