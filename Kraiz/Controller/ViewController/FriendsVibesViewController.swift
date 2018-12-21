//
//  FriendsVibesViewController.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 11/11/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit
import RealmSwift

class FriendsVibesViewController: UIViewController {

    @IBOutlet weak var vibeCategoriesCollectionView: UICollectionView!
    @IBOutlet weak var vibesTable: UITableView!

    var privateVibes = [String : Results<VibeDataEntity>]()
    var unseenPrivateVibes = [String : Results<VibeDataEntity>]()
    var notifications = [NotificationToken]()
    var unseenVibesNotification = [NotificationToken]()
    var NUMBER_OF_VIBES_IN_ONE_PAGE = 10

    var vibesTableBackgroundImageView = UIImageView(image: UIImage(named: VibeCategories.categoryBackground[0]))
    private var selectedCategory : Int = 0
    private let DEFAULT_PROFILE_PIC = "profile-default"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for i in 0 ..< VibeCategories.TAG_INDEX.count {
            let privateVibeIndex : String = APPUtilites.getVibeIndex(indexType: "vibeTypeTag", vibeType: "PRIVATE", vibeTag: i)

            if let results = CacheHelper.shared.getVibesByIndex(index: "vibeTypeTagGsiPK", value: privateVibeIndex) {
                if results.count == 0 {
                    AppSyncHelper.shared.getUserVibesPaginated(requestedVibeTag: VibeCategories.getVibeTag(index: i), requestedVibeType: VibeType.private, first: NUMBER_OF_VIBES_IN_ONE_PAGE, after: nil, completionHandler: nil)
                }
                privateVibes["\(VibeCategories.TAG_INDEX[i])_\(VibeCategories.TYPE_INDEX[1])"] = results

                notifications.append(results.observe { [weak self] (change) in
                    self?.vibesTable.reloadData()
                })
            }
            
            if let unseenResults = CacheHelper.shared.getUnseenVibesByIndex(index: "vibeTypeTagGsiPK", value: privateVibeIndex) {
                print("=======> unseen vibes: \(unseenResults.count)")
                unseenPrivateVibes["\(VibeCategories.TAG_INDEX[i])_\(VibeCategories.TYPE_INDEX[1])"] = unseenResults
                unseenVibesNotification.append(unseenResults.observe({ [weak self] (change) in
                    let cell = self?.vibeCategoriesCollectionView.cellForItem(at: IndexPath(row: (self?.selectedCategory)!, section: 0)) as? VibeCategoryCollectionViewCell
                    if self?.unseenPrivateVibes["\(VibeCategories.TAG_INDEX[(self?.selectedCategory)!])_\(VibeCategories.TYPE_INDEX[1])"]?.count == 0 {
                        cell?.notificationLabel.isHidden = true
                        cell?.notificationLabelBackgroundView.isHidden = true
                    } else {
                        cell?.notificationLabel.isHidden = false
                        cell?.notificationLabelBackgroundView.isHidden = false
                    }
                }))
            }
            
            if selectedCategory == i {
                vibesTable.reloadData()
            }
        }

        vibeCategoriesCollectionView.register(UINib(nibName: "VibeCategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "vibeCategoryCell")
        vibeCategoriesCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        AppSyncHelper.shared.getUserChannel()
        vibeCategoriesCollectionView.layer.cornerRadius = 10
        vibesTableBackgroundImageView.frame = vibesTable.frame
        vibesTableBackgroundImageView.contentMode = .scaleAspectFill
        vibesTable.backgroundView = vibesTableBackgroundImageView
    }
}

extension FriendsVibesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return privateVibes["\(VibeCategories.TAG_INDEX[selectedCategory])_\(VibeCategories.TYPE_INDEX[1])"]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("FriendsVibesTableViewCell", owner: self, options: nil)?.first as! FriendsVibesTableViewCell
        let vibe = privateVibes["\(VibeCategories.TAG_INDEX[selectedCategory])_\(VibeCategories.TYPE_INDEX[1])"]![indexPath.row]
        let profileId = vibe.getProfileId()!
        if let profile = CacheHelper.shared.getProfileById(id: profileId) {
            cell.senderName.text = profile.getUsername()!
            if profile.getProfilePicId() != "NONE" {
                MediaHelper.shared.downloadProfileImage(publicId: profile.getProfilePicId()!, success: { (image) in
                    DispatchQueue.main.async {
                        cell.profileImage.image = image
                    }
                }) { [weak self] (error) in
                    DispatchQueue.main.async {
                        cell.profileImage.image = UIImage(named: self!.DEFAULT_PROFILE_PIC)
                    }
                }
            }
        } else {
            cell.senderName.text = "None"
        }

        cell.vibeName.text = vibe.getVibeName()!
        cell.timestamp.text = APPUtilites.getDateFromEpochTime(epochTime: vibe.getCreatedAt())
        cell.vibeSeenImage.isHidden = true
        if vibe.getIsSender() {
            cell.unseenVibeDot.isHidden = true
            if vibe.getHasNewHails() {
                cell.unseenHailDot.isHidden = false
            } else {
                cell.unseenHailDot.isHidden = true
            }
            if vibe.getIsSeen() {
                cell.vibeStatus.isHidden = true
                cell.vibeSeenImage.isHidden = false
            } else {
                cell.vibeStatus.isHidden = false
                cell.vibeSeenImage.isHidden = true
            }
        } else {
            cell.unseenHailDot.isHidden = true
            cell.vibeStatus.isHidden = true
            if !vibe.getIsSeen() {
                cell.unseenVibeDot.isHidden = false
            } else {
                cell.unseenVibeDot.isHidden = true
            }
        }
        cell.hailButton.tag = indexPath.row
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hailButtonPressed(sender:)))
        cell.hailButton.addGestureRecognizer(tapGesture)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return vibesTable.frame.height / 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        let vibe = privateVibes["\(VibeCategories.TAG_INDEX[selectedCategory])_\(VibeCategories.TYPE_INDEX[1])"]![indexPath.row]
        if !vibe.getIsSender() {
            if !vibe.getIsSeen() {
                let cell = tableView.cellForRow(at: indexPath) as? FriendsVibesTableViewCell
                cell?.unseenVibeDot.isHidden = true
                CacheHelper.shared.updateVibeSeenStatus(vibeId: vibe.getId()!, seenStatus: true)
//                AppSyncHelper.shared.updateSeenStatusOfVibe(vibeId: vibe.getId()!, seenStatus: true)
            }
        }
    }

    @objc func hailButtonPressed(sender: UITapGestureRecognizer) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tag = sender.view?.tag
        let cell = vibesTable.cellForRow(at: IndexPath(row: tag!, section: 0)) as? FriendsVibesTableViewCell
        cell?.unseenHailDot.isHidden = true
        CacheHelper.shared.setHasNewHailsInVibe(hasNewHails: false, vibeId: privateVibes["\(VibeCategories.TAG_INDEX[selectedCategory])_\(VibeCategories.TYPE_INDEX[1])"]![tag!].getId()!)
        let hailVC = storyboard.instantiateViewController(withIdentifier: "HailsViewController") as! HailsViewController
        hailVC.modalPresentationStyle = .overCurrentContext
        hailVC.vibeId = privateVibes["\(VibeCategories.TAG_INDEX[selectedCategory])_\(VibeCategories.TYPE_INDEX[1])"]![tag!].getId()!
        
        present(hailVC, animated: false, completion: nil)
    }

}

extension FriendsVibesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return VibeCategories.pickerStrings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 6, height: vibeCategoriesCollectionView.frame.height)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = vibeCategoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "vibeCategoryCell", for: indexPath) as! VibeCategoryCollectionViewCell
        cell.layoutIfNeeded()
        cell.categoryName.text = VibeCategories.pickerStrings[indexPath.row]
        cell.categoryImage.image = UIImage(named: VibeCategories.categoryImages[indexPath.row])
        cell.categoryName.textColor = VibeCategories.vibeColors[indexPath.row]
        cell.categoryImage.layer.borderColor = VibeCategories.vibeColors[indexPath.row].cgColor
        if unseenPrivateVibes["\(VibeCategories.TAG_INDEX[indexPath.row])_\(VibeCategories.TYPE_INDEX[1])"] == nil || unseenPrivateVibes["\(VibeCategories.TAG_INDEX[indexPath.row])_\(VibeCategories.TYPE_INDEX[1])"]!.count == 0 {
            cell.notificationLabelBackgroundView.isHidden = true
            cell.notificationLabel.isHidden = true
        } else {
            cell.notificationLabelBackgroundView.isHidden = false
            cell.notificationLabel.isHidden = false
        }
        if selectedCategory != indexPath.row {
            cell.categoryName.textColor = VibeCategories.UNHIGHLIGHTED_VIBE_COLOR
            cell.categoryImage.layer.borderWidth = 0.0
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 40, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentSelectedCell = collectionView.cellForItem(at: indexPath) as! VibeCategoryCollectionViewCell
        currentSelectedCell.categoryImage.layer.borderWidth = 4.0
        currentSelectedCell.categoryName.textColor = VibeCategories.vibeColors[indexPath.row]
        selectedCategory = indexPath.row
        vibesTableBackgroundImageView.image = UIImage(named: VibeCategories.categoryBackground[indexPath.row])
        vibeCategoriesCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        vibesTable.reloadData()
        if privateVibes["\(VibeCategories.TAG_INDEX[selectedCategory])_\(VibeCategories.TYPE_INDEX[1])"] != nil && privateVibes["\(VibeCategories.TAG_INDEX[selectedCategory])_\(VibeCategories.TYPE_INDEX[1])"]!.count > 0 {
            vibesTable.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let previousSelectedCell = collectionView.cellForItem(at: indexPath) as? VibeCategoryCollectionViewCell
        if previousSelectedCell != nil {
            previousSelectedCell!.categoryImage.layer.borderWidth = 0.0
        }
    }
}
