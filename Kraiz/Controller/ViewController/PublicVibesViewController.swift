//
//  PublicVibesViewController.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 11/11/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit

class PublicVibesViewController: UIViewController {

    @IBOutlet weak var vibesTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension PublicVibesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("MyPublicVibeTableViewCell", owner: self, options: nil)?.first as! MyPublicVibeTableViewCell
        cell.hailButton.tag = indexPath.row
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hailButtonPressed(sender:)))
        cell.hailButton.addGestureRecognizer(tapGesture)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 6
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    @objc func hailButtonPressed(sender: UITapGestureRecognizer) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let hailVC = storyboard.instantiateViewController(withIdentifier: "HailsViewController") as! HailsViewController
        hailVC.modalPresentationStyle = .overCurrentContext
        
        present(hailVC, animated: true, completion: nil)
    }
}
