//
//  ImageCaptionCollectionViewCell.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 28/10/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit

class ImageCaptionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!

    override var isSelected: Bool {
        didSet {
            if isSelected {
                layer.borderWidth = 3.0
                layer.borderColor = UIColor.blue.cgColor
            } else {
                layer.borderWidth = 0.0
            }
        }
    }
}
