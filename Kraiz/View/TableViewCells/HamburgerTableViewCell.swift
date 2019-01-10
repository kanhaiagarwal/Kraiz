//
//  HamburgerTableViewCell.swift
//  StoryFi
//
//  Created by Kumar Agarwal, Kanhai on 04/07/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit

class HamburgerTableViewCell: UITableViewCell {

    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
