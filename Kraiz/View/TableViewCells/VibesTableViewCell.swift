//
//  StoriesTableViewCell.swift
//  StoryFi
//
//  Created by Kumar Agarwal, Kanhai on 01/07/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit

class VibesTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var storyNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        timestampField.isEnabled = false
        
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
