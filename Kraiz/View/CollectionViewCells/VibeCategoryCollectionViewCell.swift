//
//  VibeCategoryCollectionViewCell.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 14/12/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit

class VibeCategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var notificationLabelBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryImage.layer.borderWidth = 4.0
    }

    override func layoutIfNeeded() {
        super.layoutIfNeeded()

        categoryImage.layer.cornerRadius = categoryImage.frame.height / 2
        categoryImage.clipsToBounds = true
        notificationLabel.layer.cornerRadius = notificationLabel.frame.height / 2
        notificationLabel.clipsToBounds = true
        notificationLabelBackgroundView.layer.cornerRadius = notificationLabelBackgroundView.frame.height / 2
        notificationLabelBackgroundView.clipsToBounds = true
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                categoryImage.layer.borderWidth = 4.0
            } else {
                categoryName.textColor = VibeCategories.UNHIGHLIGHTED_VIBE_COLOR
                categoryImage.layer.borderWidth = 0.0
            }
        }
    }
}
