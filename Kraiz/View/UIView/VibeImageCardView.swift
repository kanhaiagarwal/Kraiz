//
//  VibeImageCardView.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 07/12/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit

class VibeImageCardView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var caption: UITextView!

    @IBInspectable var cornerRadius : CGFloat = 10
    @IBInspectable var shadowWidth : CGFloat = 1
    @IBInspectable var shadowHeight : CGFloat = 1
    @IBInspectable var shadowOpacity : CGFloat = 0.2
    @IBInspectable var shadowColor : UIColor = UIColor.black

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize(width: shadowWidth, height: shadowHeight)
        layer.shadowOpacity = Float(shadowOpacity)
    }
}
