//
//  ImageBackdropTableViewCell.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 25/11/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit

class ImageBackdropTableViewCell: UITableViewCell {

    @IBOutlet weak var backdropImage: UIImageView!
    @IBOutlet weak var backdropTitle: UILabel!
    @IBOutlet weak var backdropCheckbox: UIView!
    
    var isBackdropSelected : Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
