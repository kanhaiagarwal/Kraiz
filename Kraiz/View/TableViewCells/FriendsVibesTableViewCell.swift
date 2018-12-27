//
//  StoriesTableViewCell.swift
//  StoryFi
//
//  Created by Kumar Agarwal, Kanhai on 01/07/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit
import LinearProgressBarMaterial

class FriendsVibesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var unseenVibeDot: UIView!
    @IBOutlet weak var unseenHailDot: UIView!
    @IBOutlet weak var vibeName: UILabel!
    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var vibeStatus: UILabel!
    @IBOutlet weak var hailButton: UIButton!
    @IBOutlet weak var vibeSeenImage: UIImageView!

    let progressBar = LinearProgressBar()
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

        unseenVibeDot.layer.cornerRadius = unseenVibeDot.frame.height / 2
        unseenVibeDot.clipsToBounds = true

        unseenHailDot.layer.cornerRadius = unseenHailDot.frame.height / 2
        unseenHailDot.clipsToBounds = true

        cardView.addSubview(progressBar)
        progressBar.frame = CGRect(x: 0, y: progressBar.superview!.frame.height - 5, width: progressBar.superview!.frame.width, height: 2)
        progressBar.progressBarColor = UIColor(displayP3Red: 227/255, green: 121/255, blue: 11/255, alpha: 1.0)
        progressBar.backgroundProgressBarColor = UIColor(displayP3Red: 227/255, green: 121/255, blue: 11/255, alpha: 0.5)
        progressBar.widthForLinearBar = cardView.frame.width
        progressBar.heightForLinearBar = 2
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
