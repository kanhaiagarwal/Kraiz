//
//  CornerRadiusView.swift
//  Kraiz
//
//  Created by Kumar Agarwal, Kanhai on 01/10/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit

class CornerRadiusView: UIView {

    @IBInspectable var hasTopRightCornerRadius : Bool = false
    @IBInspectable var hasTopLeftCornerRadius : Bool = false
    @IBInspectable var hasBottomRightCornerRadius : Bool = false
    @IBInspectable var hasBottomLeftCornerRadius : Bool = false
    @IBInspectable var cornerRadius : CGFloat = 0
    
    override func layoutSubviews() {
        var corners = UIRectCorner()
        if hasTopRightCornerRadius {
            corners.insert(.topRight)
        }
        if hasTopLeftCornerRadius {
            corners.insert(.topLeft)
        }
        if hasBottomRightCornerRadius {
            corners.insert(.bottomRight)
        }
        if hasBottomLeftCornerRadius {
            corners.insert(.bottomLeft)
        }
        self.roundCorners(corners: corners, radius: cornerRadius)
    }
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }

}
