//
//  VibeImageGameCaptionsTableViewCell.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 03/01/19.
//  Copyright © 2019 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit

class VibeImageGameCaptionsTableViewCell: UITableViewCell {

    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var selectImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
