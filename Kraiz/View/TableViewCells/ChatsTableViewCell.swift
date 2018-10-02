//
//  ChatsTableViewCell.swift
//  Kraiz
//
//  Created by Kumar Agarwal, Kanhai on 01/10/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit

class ChatsTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var vibeComponent1: UIImageView!
    @IBOutlet weak var vibeComponent2: UIImageView!
    @IBOutlet weak var vibeComponent3: UIImageView!
    @IBOutlet weak var vibeComponent4: UIImageView!
    @IBOutlet weak var vibeNameLabel: UILabel!
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var topInfoContainer: UIView!
    
    // Fonts
    let USERNAME_LABEL_FONT = "TimesNewRomanPS-BoldMT"
    let TIME_LABEL_FONT = "Times New Roman"
    let DATE_LABEL_FONT = "Times New Roman"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        setFontSize()
        topInfoContainer.add(Border: .bottom, withColor: DeviceConstants.DEFAULT_SEPERATOR_COLOR, andWidth: 1.0)
    }
    
    func setFontSize() {
        let height = self.superview?.superview?.superview?.superview?.frame.height
        
        switch height! {
        case DeviceConstants.IPHONE7PLUS_HEIGHT:
            usernameLabel.font = UIFont(name: USERNAME_LABEL_FONT, size: 20)
            timeLabel.font = UIFont(name: TIME_LABEL_FONT, size: 20)
            dateLabel.font = UIFont(name: DATE_LABEL_FONT, size: 20)
        case DeviceConstants.IPHONE7_HEIGHT:
            usernameLabel.font = UIFont(name: USERNAME_LABEL_FONT, size: 18)
            timeLabel.font = UIFont(name: TIME_LABEL_FONT, size: 18)
            dateLabel.font = UIFont(name: DATE_LABEL_FONT, size: 18)
        case DeviceConstants.IPHONEX_HEIGHT:
            usernameLabel.font = UIFont(name: USERNAME_LABEL_FONT, size: 18)
            timeLabel.font = UIFont(name: TIME_LABEL_FONT, size: 18)
            dateLabel.font = UIFont(name: DATE_LABEL_FONT, size: 18)
        default:
            usernameLabel.font = UIFont(name: USERNAME_LABEL_FONT, size: 18)
            timeLabel.font = UIFont(name: TIME_LABEL_FONT, size: 18)
            dateLabel.font = UIFont(name: DATE_LABEL_FONT, size: 18)
        }
    }
}

extension UIView {
    
    enum ViewBorder: String {
        case left, right, top, bottom
    }
    
    func add(Border border: ViewBorder, withColor color: UIColor = UIColor.lightGray, andWidth width: CGFloat = 1.0) {
        
        let borderView = UIView()
        borderView.backgroundColor = color
        borderView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(borderView)
        NSLayoutConstraint.activate(getConstrainsFor(forView: borderView, WithBorderType: border, andWidth: width))
    }
    
    private func getConstrainsFor(forView borderView: UIView, WithBorderType border: ViewBorder, andWidth width: CGFloat) -> [NSLayoutConstraint] {
        
        let height = borderView.heightAnchor.constraint(equalToConstant: width)
        let widthAnchor = borderView.widthAnchor.constraint(equalToConstant: width)
        let leading = borderView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        let trailing = borderView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        let top = borderView.topAnchor.constraint(equalTo: self.topAnchor)
        let bottom = borderView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        
        switch border {
            
        case .bottom:
            return [bottom, leading, trailing, height]
            
        case .top:
            return [top, leading, trailing, height]
            
        case .left:
            return [top, bottom, leading, widthAnchor]
            
        case .right:
            return [top, bottom, trailing, widthAnchor]
        }
    }
}
