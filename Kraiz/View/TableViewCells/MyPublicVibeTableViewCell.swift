//
//  MyPublicVibeTableViewCell.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 16/12/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit

class MyPublicVibeTableViewCell: UITableViewCell {

    @IBOutlet weak var vibeCategoryImage: UIImageView!
    @IBOutlet weak var vibeCategoryName: UILabel!
    @IBOutlet weak var vibeName: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var hailButton: UIButton!
    @IBOutlet weak var hailsCount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()

        vibeCategoryImage.layer.cornerRadius = vibeCategoryImage.frame.height / 2
    }
    
}
