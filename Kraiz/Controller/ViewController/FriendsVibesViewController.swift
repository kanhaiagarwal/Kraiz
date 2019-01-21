//
//  FriendsVibesViewController.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 11/11/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit
import MaterialShowcase
import RealmSwift
import RxSwift

class FriendsVibesViewController: UIViewController, MaterialShowcaseDelegate {

    @IBOutlet weak var vibeCategoriesCollectionView: UICollectionView!
    @IBOutlet weak var vibesTable: UITableView!

    var viewHeight : CGFloat = 0

    var privateVibes = [String : Results<VibeDataEntity>]()
    var unseenPrivateVibes = [String : Results<VibeDataEntity>]()
    var notifications = [NotificationToken]()
    var unseenVibesNotification = [NotificationToken]()
    var NUMBER_OF_VIBES_IN_ONE_PAGE = 10

    var vibesTableBackgroundImageView = UIImageView(image: UIImage(named: VibeCategories.categoryBackground[0]))
    private var selectedCategory : Int = 0
    private let DEFAULT_PROFILE_PIC = "profile-default"
    private let EMPTY_VIBES_IMAGE = "empty-vibes-private"
    let emptyImageView = UIImageView()
    
    var demoVibeSeen = false
    
    let firstShowcase = MaterialShowcase()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if UserDefaults.standard.bool(forKey: DeviceConstants.IS_FCM_TOKEN_UPDATE_REQUIRED) {
            AppSyncHelper.shared.updateFcmToken()
        }

        viewHeight = view.frame.height
        print("viewHeight: \(viewHeight)")
        for i in 0 ..< VibeCategories.TAG_INDEX.count {
            let privateVibeIndex : String = APPUtilites.getVibeIndex(indexType: "vibeTypeTag", vibeType: "PRIVATE", vibeTag: i)

            if let results = CacheHelper.shared.getVibesByIndex(index: "vibeTypeTagGsiPK", value: privateVibeIndex) {
                print("results.count for privateVibeIndex: \(privateVibeIndex): \(results.count)")
                if results.count == 0 {
                    AppSyncHelper.shared.getUserVibesPaginated(requestedVibeTag: VibeCategories.getVibeTag(index: i), requestedVibeType: VibeType.private, first: NUMBER_OF_VIBES_IN_ONE_PAGE, after: nil, completionHandler: nil)
                }
                privateVibes["\(VibeCategories.TAG_INDEX[i])_\(VibeCategories.TYPE_INDEX[1])"] = results

                notifications.append(results.observe { [weak self] (change) in
                    self?.vibesTable.reloadData()
                    self?.updateEmptyVibeBackground()
                })
            }

            if let unseenResults = CacheHelper.shared.getUnseenVibesByIndex(index: "vibeTypeTagGsiPK", value: privateVibeIndex) {
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
                updateEmptyVibeBackground()
            }
        }

        vibeCategoriesCollectionView.register(UINib(nibName: "VibeCategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "vibeCategoryCell")
        vibeCategoriesCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }

    func updateEmptyVibeBackground() {
        let privateVibeIndex : String = "\(VibeCategories.TAG_INDEX[selectedCategory])_\(VibeCategories.TYPE_INDEX[1])"
        if privateVibes[privateVibeIndex] == nil || privateVibes[privateVibeIndex]!.count == 0 {
            emptyImageView.isHidden = false
        } else {
            emptyImageView.isHidden = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        AppSyncHelper.shared.getUserChannel()
        vibeCategoriesCollectionView.layer.cornerRadius = 10
        vibesTableBackgroundImageView.frame = vibesTable.frame
        vibesTableBackgroundImageView.contentMode = .scaleAspectFill
        vibesTable.backgroundView = vibesTableBackgroundImageView
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if UserDefaults.standard.bool(forKey: DeviceConstants.IS_SIGN_IN) {
            let firstCollectionCell = vibeCategoriesCollectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! VibeCategoryCollectionViewCell
            firstShowcase.backgroundPromptColor = UIColor.red.withAlphaComponent(0.4)
            firstShowcase.tag = 0
            firstShowcase.delegate = self
            firstShowcase.setTargetView(view: firstCollectionCell.categoryImage)
            firstShowcase.primaryText = "This is a Vibe Tag. All the Vibes that you create with this tag appears under it."
            firstShowcase.secondaryText = ""
            firstShowcase.show(animated: true) {
                print("=======> showcase.show has been completed")
            }
        }

        vibesTableBackgroundImageView.addSubview(emptyImageView)
        emptyImageView.frame = CGRect(x: 30, y: emptyImageView.superview!.frame.height / 4, width: emptyImageView.superview!.frame.width - 60, height: emptyImageView.superview!.frame.height / 3)
        emptyImageView.image = UIImage(named: EMPTY_VIBES_IMAGE)
        updateEmptyVibeBackground()

        if !demoVibeSeen {
            demoVibeSeen = true
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vibeWelcomeVC = storyboard.instantiateViewController(withIdentifier: "VibeWelcomeViewController") as! VibeWelcomeViewController
            vibeWelcomeVC.isDemoVibe = true
            vibeWelcomeVC.vibeModel = APPUtilites.getVibeModelForDemoVibe(vibeTag: 0, viewHeight: view.superview!.superview!.superview!.superview!.frame.height)
            self.present(vibeWelcomeVC, animated: true, completion: nil)
        }
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
            cell.profileImage.image = UIImage(named: DEFAULT_PROFILE_PIC)
            if profile.getProfilePicId() != nil && profile.getProfilePicId() != "NONE" && profile.getProfilePicId() != "none" {
                if FileManagerHelper.shared.doesFileExist(filePath: FileManagerHelper.shared.getFileUrl(fileName: profile.getProfilePicId()!, folder: MediaHelper.shared.PROFILE_PIC_FOLDER).absoluteString) {
                    let filePath = FileManagerHelper.shared.getFileUrl(fileName: profile.getProfilePicId()!, folder: MediaHelper.shared.PROFILE_PIC_FOLDER).absoluteString
                    if let data = FileManagerHelper.shared.getImageDataFromPath(filePath: filePath, isJpgExtensionRequired: false) {
                        cell.profileImage.image = UIImage(data: data)
                    } else {
                        cell.profileImage.image = UIImage(named: DEFAULT_PROFILE_PIC)
                    }
                } else {
                    MediaHelper.shared.getProfileImage(publicId: profile.getProfilePicId()!, success: { (image) in
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
                cell.profileImage.image = UIImage(named: DEFAULT_PROFILE_PIC)
            }
        } else {
            cell.profileImage.image = UIImage(named: DEFAULT_PROFILE_PIC)
            cell.senderName.text = "None"
        }

        cell.vibeName.text = vibe.getVibeName()!
        cell.timestamp.text = APPUtilites.getDateFromEpochTime(epochTime: vibe.getCreatedAt(), isTimeInMiliseconds: true)
        cell.vibeSeenImage.isHidden = true
        if vibe.getIsSender() {
            cell.unseenVibeDot.isHidden = true
            cell.vibeStatus.isHidden = false
            if vibe.getHasNewHails() {
                cell.unseenHailDot.isHidden = false
            } else {
                cell.unseenHailDot.isHidden = true
            }
            if vibe.getIsSeen() {
                cell.vibeSeenImage.isHidden = false
            } else {
                cell.vibeSeenImage.isHidden = true
            }
        } else {
            cell.unseenHailDot.isHidden = true
            cell.vibeSeenImage.isHidden = true
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

        if vibe.getIsDownloadInProgress() {
            cell.progressBar.isHidden = false
            cell.progressBar.startAnimation()
        } else {
            cell.progressBar.isHidden = false
            cell.progressBar.stopAnimation()
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch viewHeight {
        case DeviceConstants.IPHONE7_HEIGHT:
            return vibesTable.frame.height / 3
        case DeviceConstants.IPHONE7PLUS_HEIGHT:
            return vibesTable.frame.height / 3
        case DeviceConstants.IPHONEX_HEIGHT:
            return vibesTable.frame.height / 3.25
        case DeviceConstants.IPHONEXR_HEIGHT:
            return vibesTable.frame.height / 3.5
        default:
            return vibesTable.frame.height / 3
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        let cell = tableView.cellForRow(at: indexPath) as? FriendsVibesTableViewCell
        print("cell.progressBar.isHidden: \(cell!.progressBar.isHidden)")
        let vibe = privateVibes["\(VibeCategories.TAG_INDEX[selectedCategory])_\(VibeCategories.TYPE_INDEX[1])"]![indexPath.row]

        if !vibe.getIsDownloadInProgress() {
            let spinnerView = APPUtilites.displayLoadingSpinner(onView: view)
            AppSyncHelper.shared.getUserVibe(vibeId: vibe.getId()!, vibeType: 0, vibeTag: selectedCategory) { (error, vibeModel) in
                DispatchQueue.main.async {
                    APPUtilites.removeLoadingSpinner(spinner: spinnerView)
                    if error != nil {
                        APPUtilites.displayErrorSnackbar(message: "Error in fetching the vibe.")
                        return
                    }
                    if vibeModel == nil {
                        APPUtilites.displayErrorSnackbar(message: "Cannot get the vibe components. Please try again")
                        return
                    }
                    if !vibeModel!.isLetterPresent && !vibeModel!.isPhotosPresent {
                        APPUtilites.displayErrorSnackbar(message: "No data present in the vibe. Please try again")
                        return
                    }
                    if !vibeModel!.isPhotosPresent {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vibeWelcomeVC = storyboard.instantiateViewController(withIdentifier: "VibeWelcomeViewController") as! VibeWelcomeViewController
                        vibeWelcomeVC.vibeModel = vibeModel
                        self.present(vibeWelcomeVC, animated: true, completion: nil)
                    } else {
                        var imagesToBeDownloaded = [String]()
                        let allImages = vibeModel!.images
                        for i in 0 ..< vibeModel!.getImages().count {
                            if !FileManagerHelper.shared.doesFileExist(filePath: "/\(MediaHelper.shared.COMMON_FOLDER)/\(MediaHelper.shared.VIBE_IMAGES_FOLDER)/\(allImages[i].imageLink!)") {
                                imagesToBeDownloaded.append(allImages[i].imageLink!)
                            }
                        }

                        
                        if imagesToBeDownloaded.count == 0 {
                            print("====> All images present in local.")
                            for i in 0 ..< allImages.count {
                                vibeModel!.images[i].image = UIImage(data: FileManagerHelper.shared.getImageDataFromPath(filePath: "/\(MediaHelper.shared.COMMON_FOLDER)/\(MediaHelper.shared.VIBE_IMAGES_FOLDER)/\(allImages[i].imageLink!)", isJpgExtensionRequired: false)!)
                            }
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vibeWelcomeVC = storyboard.instantiateViewController(withIdentifier: "VibeWelcomeViewController") as! VibeWelcomeViewController
                            vibeWelcomeVC.vibeModel = vibeModel
                            self.present(vibeWelcomeVC, animated: true, completion: nil)
                        } else {
                            print("not all images present in local.")
                            print("imagesToBeDownloaded: \(imagesToBeDownloaded)")

                            var totalUpload = 0
                            let counter = Variable(0)
                            counter.asObservable().subscribe(onNext: { (counter) in
                                totalUpload = totalUpload + 1
                                if (totalUpload == imagesToBeDownloaded.count + 1) {
                                    print("all images downloaded")
                                    DispatchQueue.main.async {
                                        for i in 0 ..< allImages.count {
                                            CacheHelper.shared.updateVibeDownloadStatus(vibe: vibe, isDownloadInProgress: false)
                                            vibeModel!.images[i].image = UIImage(data: FileManagerHelper.shared.getImageDataFromPath(filePath: "/\(MediaHelper.shared.COMMON_FOLDER)/\(MediaHelper.shared.VIBE_IMAGES_FOLDER)/\(allImages[i].imageLink!)", isJpgExtensionRequired: false)!)
                                        }
                                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                        let vibeWelcomeVC = storyboard.instantiateViewController(withIdentifier: "VibeWelcomeViewController") as! VibeWelcomeViewController
                                        vibeWelcomeVC.vibeModel = vibeModel
                                        self.present(vibeWelcomeVC, animated: true, completion: nil)
                                    }
                                }
                            }, onError: { (error) in
                                print("error in uploading the picture")
                            }, onCompleted: {
                                print("upload completed")
                            }) {
                                print("disposed")
                            }

                            MediaHelper.shared.getVibeImages(images: imagesToBeDownloaded, counter: counter, completionHandler: nil)
                            CacheHelper.shared.updateVibeDownloadStatus(vibe: vibe, isDownloadInProgress: true)
                        }
                    }
                }
            }
        } else {
            cell?.progressBar.startAnimation()
            cell?.progressBar.isHidden = false
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("inside willDisplay for indexPath: \(indexPath.row)")
        let cell = tableView.cellForRow(at: indexPath) as? FriendsVibesTableViewCell
        print("cell != nil: \(cell != nil)")
        let vibe = privateVibes["\(VibeCategories.TAG_INDEX[selectedCategory])_\(VibeCategories.TYPE_INDEX[1])"]![indexPath.row]

        if vibe.getIsDownloadInProgress() {
            cell?.progressBar.stopAnimation()
            cell?.progressBar.isHidden = true
        } else {
            cell?.progressBar.startAnimation()
            cell?.progressBar.isHidden = false
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
        return UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentSelectedCell = collectionView.cellForItem(at: indexPath) as! VibeCategoryCollectionViewCell
        currentSelectedCell.categoryImage.layer.borderWidth = 4.0
        currentSelectedCell.categoryName.textColor = VibeCategories.vibeColors[indexPath.row]
        selectedCategory = indexPath.row
        vibesTableBackgroundImageView.image = UIImage(named: VibeCategories.categoryBackground[indexPath.row])
        vibeCategoriesCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        AppSyncHelper.shared.getUserChannel()
        vibesTable.reloadData()
        updateEmptyVibeBackground()
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

extension FriendsVibesViewController {
    func showCaseDidDismiss(showcase: MaterialShowcase, didTapTarget: Bool) {
        if showcase.tag == 0 {
            let parent = self.parent as! VibesViewController
            let publicVibeButton = parent.publicVibeButton
            let showcase = MaterialShowcase()
            showcase.backgroundPromptColor = UIColor.red.withAlphaComponent(0.4)
            showcase.setTargetView(view: publicVibeButton!)
            showcase.primaryText = "Clicking on it, you can see vibes created by people from all around the world, after every 2 hours."
            showcase.secondaryText = ""
            showcase.show(animated: true) {
                print("=======> showcase.show has been completed")
            }
        }
        UserDefaults.standard.set(false, forKey: DeviceConstants.IS_SIGN_IN)
    }
}
