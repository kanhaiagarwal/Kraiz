//
//  StoriesTableViewCell.swift
//  StoryFi
//
//  Created by Kumar Agarwal, Kanhai on 01/07/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit

class FriendsVibesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var unseenDot: UIView!
    @IBOutlet weak var vibeName: UILabel!
    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var vibeStatus: UILabel!
    @IBOutlet weak var hailButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()

        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.clipsToBounds = true

        unseenDot.layer.cornerRadius = unseenDot.frame.height / 2
        unseenDot.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setFontSizeForLabels() {
        let height = self.superview?.superview?.frame.height
        timestamp.font = UIFont(name: "Times New Roman", size: 10)
        switch height! {
        case DeviceConstants.IPHONE7_HEIGHT:
            
            vibeName.font = UIFont(name: "Times New Roman", size: 15)
            break
        case DeviceConstants.IPHONE7PLUS_HEIGHT:
            vibeName.font = UIFont(name: "Times New Roman", size: 24)
            break
        case DeviceConstants.IPHONEX_HEIGHT:
            vibeName.font = UIFont(name: "Times New Roman", size: 13)
            break
        default:
            print("Hello")
            vibeName.font = UIFont(name: "Times New Roman", size: 20)
        }
    }
    
}
