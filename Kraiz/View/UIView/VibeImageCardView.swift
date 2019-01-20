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
    @IBOutlet weak var captionContainer: UIView!
    
    @IBInspectable var cornerRadius : CGFloat = 10
    @IBInspectable var shadowWidth : CGFloat = 1
    @IBInspectable var shadowHeight : CGFloat = 1
    @IBInspectable var shadowOpacity : CGFloat = 0.2
    @IBInspectable var shadowColor : UIColor = UIColor.black

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imageView.frame = CGRect(x: 20, y: 20, width: Int(round(frame.width - 40)), height: Int(round(frame.width - 40)))
        self.caption.frame = CGRect(x: 20, y: Int(round(frame.width - 20)), width: Int(round(frame.width - 40)), height: Int(round(frame.height - (frame.width - 20))))
        imageView.layer.allowsEdgeAntialiasing = true
        captionContainer.layer.allowsEdgeAntialiasing = true
        caption.layer.allowsEdgeAntialiasing = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize(width: shadowWidth, height: shadowHeight)
        layer.shadowOpacity = Float(shadowOpacity)
    }
}
