//
//  PublicVibesChoiceViewController.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 21/12/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit

class PublicVibesChoiceViewController: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var publicVibesTableView: UITableView!
    
    let gradientColors = [[UIColor(displayP3Red: 1, green: 65/255, blue: 108/255, alpha: 1.0).cgColor, UIColor(displayP3Red: 1, green: 75/255, blue: 43/255, alpha: 1.0).cgColor], [UIColor(displayP3Red: 17/255, green: 153/255, blue: 142/255, alpha: 1.0).cgColor, UIColor(displayP3Red: 56/255, green: 239/255, blue: 135/255, alpha: 1.0).cgColor], [UIColor(displayP3Red: 0, green: 131/255, blue: 176/255, alpha: 1.0).cgColor, UIColor(displayP3Red: 0, green: 180/255, blue: 219/255, alpha: 1.0).cgColor], [UIColor(displayP3Red: 119/255, green: 47/255, blue: 26/255, alpha: 1.0).cgColor, UIColor(displayP3Red: 242/255, green: 166/255, blue: 90/255, alpha: 1.0).cgColor], [UIColor(displayP3Red: 243/255, green: 115/255, blue: 53/255, alpha: 1.0).cgColor, UIColor(displayP3Red: 253/255, green: 200/255, blue: 48/255, alpha: 1.0).cgColor], [UIColor(displayP3Red: 2/255, green: 27/255, blue: 121/255, alpha: 1.0).cgColor, UIColor(displayP3Red: 5/255, green: 117/255, blue: 230/255, alpha: 1.0).cgColor]]
    var gradientLayer: CAGradientLayer?
    @IBOutlet weak var heading: UILabel!
    
    var tagSelected : Int = 0
    var publicVibes: [VibeDataEntity]?
    override func viewDidLoad() {
        super.viewDidLoad()

        heading.text = VibeCategories.pickerStrings[tagSelected]
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        gradientLayer = CAGradientLayer()
        gradientLayer?.frame = view.bounds
        gradientLayer?.colors = gradientColors[tagSelected]
        bgView.layer.addSublayer(gradientLayer!)
    }

    @IBAction func backPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        gradientLayer?.removeFromSuperlayer()
    }
}

extension PublicVibesChoiceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return publicVibes != nil ? publicVibes!.count : 0
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("VibeChoiceTableViewCell", owner: self, options: nil)?.first as! VibeChoiceTableViewCell
        cell.profileImage.image = UIImage(named: "profile-default")
        cell.usernameLabel.text = "helloWorld"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 6
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
