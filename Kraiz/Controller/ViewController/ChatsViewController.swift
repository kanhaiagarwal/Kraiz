//
//  ChatsViewController.swift
//  Kraiz
//
//  Created by Kumar Agarwal, Kanhai on 01/10/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit

class ChatsViewController: UIViewController {

    @IBOutlet weak var chatsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatsTableView.delegate = self
        chatsTableView.dataSource = self
    }
}

extension ChatsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("ChatsTableViewCell", owner: self, options: nil)?.first as! ChatsTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 4
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: false)
    }
}
