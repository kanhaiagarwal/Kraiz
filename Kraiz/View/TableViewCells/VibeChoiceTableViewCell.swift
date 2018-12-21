//
//  VibeChoiceTableViewCell.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 21/12/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit

class VibeChoiceTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var vibeNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.clipsToBounds = true
    }

}
