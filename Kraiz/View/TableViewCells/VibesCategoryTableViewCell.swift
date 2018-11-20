//
//  VibesCategoryTableViewCell.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 12/11/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit

class VibesCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var categoryArrow: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        print("layoutIfNeeded called")
        categoryImage.layer.cornerRadius = categoryImage.frame.height / 2
        notificationLabel.clipsToBounds = true
        notificationLabel.layer.cornerRadius = notificationLabel.frame.height / 2
    }
}
