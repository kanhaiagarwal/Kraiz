//
//  DraftsTableViewCell.swift
//  StoryFi
//
//  Created by Kumar Agarwal, Kanhai on 02/07/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit

class DraftsTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameField: UILabel!
    @IBOutlet weak var timestampField: UILabel!
    @IBOutlet weak var textPresentImage: UIImageView!
    @IBOutlet weak var photosPresentImage: UIImageView!
    @IBOutlet weak var videoPresentImage: UIImageView!
    @IBOutlet weak var audioPresentImage: UIImageView!
    @IBOutlet weak var vibeNameField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupFontSize()
    }
    
    func setupFontSize() {
    }
}
