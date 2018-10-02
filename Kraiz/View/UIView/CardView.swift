//
//  CardView.swift
//  Kraiz
//
//  Created by Kumar Agarwal, Kanhai on 01/10/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit

class CardView: UIView {
    @IBInspectable var cornerRadius : CGFloat = 5.0
    @IBInspectable var shadowColor : UIColor = UIColor.black
    @IBInspectable var shadowOffsetWidth : CGFloat = 0
    @IBInspectable var shadowOffsetHeight : CGFloat = 0
    @IBInspectable var shadowOpacity : Float = 0.5
    

    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        layer.shadowOpacity = shadowOpacity
    }

}
