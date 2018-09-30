//
//  StoriesTableViewCell.swift
//  StoryFi
//
//  Created by Kumar Agarwal, Kanhai on 01/07/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit

class VibesTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var vibeNameField: UITextField!
    @IBOutlet weak var usernameField: UILabel!
    @IBOutlet weak var timestampField: UILabel!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var vibeComponent1: UIImageView!
    @IBOutlet weak var vibeComponent2: UIImageView!
    @IBOutlet weak var vibeComponent3: UIImageView!
    @IBOutlet weak var vibeComponent4: UIImageView!
    @IBOutlet weak var vibeNameOuterView: UIView!
    @IBOutlet weak var vibeNameContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        vibeNameOuterView.layer.masksToBounds = true
        vibeNameOuterView.layer.cornerRadius = vibeNameOuterView.frame.height / 2
        vibeNameContainer.layer.masksToBounds = true
        vibeNameContainer.layer.cornerRadius = vibeNameContainer.frame.height / 2
        setFontSizeForLabels()
    }
    
    func setFontSizeForLabels() {
        let height = self.superview?.superview?.frame.height
        timestampField.font = UIFont(name: "Times New Roman", size: 10)
        switch height! {
        case DeviceConstants.IPHONE7_HEIGHT:
            
            vibeNameField.font = UIFont(name: "Times New Roman", size: 15)
            break
        case DeviceConstants.IPHONE7PLUS_HEIGHT:
            vibeNameField.font = UIFont(name: "Times New Roman", size: 24)
            break
        case DeviceConstants.IPHONEX_HEIGHT:
            vibeNameField.font = UIFont(name: "Times New Roman", size: 13)
            break
        default:
            print("Hello")
            vibeNameField.font = UIFont(name: "Times New Roman", size: 20)
        }
    }
    
}
