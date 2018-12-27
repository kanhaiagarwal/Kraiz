//
//  MyPublicVibeTableViewCell.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 16/12/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit
import LinearProgressBarMaterial

class MyPublicVibeTableViewCell: UITableViewCell {

    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var vibeCategoryImage: UIImageView!
    @IBOutlet weak var vibeCategoryName: UILabel!
    @IBOutlet weak var vibeName: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var hailButton: UIButton!
    @IBOutlet weak var reachCount: UILabel!
    @IBOutlet weak var unseenHailsDot: UIView!

    let progressBar = LinearProgressBar()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()

        vibeCategoryImage.layer.cornerRadius = vibeCategoryImage.frame.height / 2
        unseenHailsDot.layer.cornerRadius = unseenHailsDot.frame.height / 2
        unseenHailsDot.clipsToBounds = true

        cardView.addSubview(progressBar)
        progressBar.frame = CGRect(x: 0, y: progressBar.superview!.frame.height - 5, width: progressBar.superview!.frame.width, height: 2)
        progressBar.progressBarColor = UIColor(displayP3Red: 227/255, green: 121/255, blue: 11/255, alpha: 1.0)
        progressBar.backgroundProgressBarColor = UIColor(displayP3Red: 227/255, green: 121/255, blue: 11/255, alpha: 0.5)
        progressBar.widthForLinearBar = cardView.frame.width
        progressBar.heightForLinearBar = 2
    }
}
