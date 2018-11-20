//
//  FriendsVibesViewController.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 11/11/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit

class FriendsVibesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var vibeCategoriesTable: UITableView!

    private let vibeCategories : [String] = ["Love Vibes", "Travel Vibes", "Good Vibes", "Party Vibes", "Nostalgic Vibes", "Occasion Vibes"]
    private let categoryImages : [String] = ["LoveVibes", "TravelVibes", "GoodVibes", "PartyVibes", "NostalgicVibes", "OccasionVibes"]
    private let vibeColors : [UIColor] = [UIColor(displayP3Red: 187/255, green: 10/255, blue: 30/255, alpha: 1.0), UIColor(displayP3Red: 0/255, green: 114/255, blue: 54/255, alpha: 1.0), UIColor(displayP3Red: 68/255, green: 140/255, blue: 203/255, alpha: 1.0), UIColor(displayP3Red: 78/255, green: 46/255, blue: 40/255, alpha: 1.0), UIColor(displayP3Red: 240/255, green: 126/255, blue: 7/255, alpha: 1.0), UIColor(displayP3Red: 46/255, green: 66/255, blue: 100/255, alpha: 1.0)]
    private var selectedCategory : Int = 0
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vibeCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("VibesCategoryTableViewCell", owner: self, options: nil)?.first as! VibesCategoryTableViewCell
        cell.categoryLabel.text = vibeCategories[indexPath.row]
        cell.categoryLabel.textColor = vibeColors[indexPath.row]
        cell.categoryArrow.textColor = vibeColors[indexPath.row]
        cell.categoryImage.image = UIImage(named: categoryImages[indexPath.row])
        cell.categoryImage.layer.borderColor = vibeColors[indexPath.row].cgColor
        if selectedCategory == indexPath.row {
            cell.categoryImage.layer.borderWidth = 4.0
            cell.categoryArrow.isHidden = false
        } else {
            cell.categoryImage.layer.borderWidth = 0.0
            cell.categoryArrow.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 6
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let previousSelectedCell = tableView.cellForRow(at: IndexPath(row: selectedCategory, section: 0)) as! VibesCategoryTableViewCell
        let currentSelectedCell = tableView.cellForRow(at: indexPath) as! VibesCategoryTableViewCell
        previousSelectedCell.categoryImage.layer.borderWidth = 0.0
        previousSelectedCell.categoryArrow.isHidden = true
        currentSelectedCell.categoryImage.layer.borderWidth = 4.0
        currentSelectedCell.categoryArrow.isHidden = false
        selectedCategory = indexPath.row
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vibeCategoriesTable.delegate = self
        vibeCategoriesTable.dataSource = self
    }
}
