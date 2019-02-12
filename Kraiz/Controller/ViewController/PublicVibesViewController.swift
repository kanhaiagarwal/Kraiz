//
//  PublicVibesViewController.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 11/11/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit
import RealmSwift
import RxSwift

class PublicVibesViewController: UIViewController {

    @IBOutlet weak var vibesTable: UITableView!

    var emptyImageView = UIImageView()

    var publicVibes: Results<VibeDataEntity>?
    var notification: NotificationToken?
    var allPendingVibes = [VibeModel]()

    let EMPTY_VIBES_IMAGE : String = "empty-vibes-public"
    var viewHeight : CGFloat = 0
    
    let REVIEW_COLOR = UIColor(displayP3Red: 149/255, green: 149/255, blue: 149/255, alpha: 1.0)

    override func viewDidLoad() {
        super.viewDidLoad()

        viewHeight = view.frame.height
        let indexValue = APPUtilites.getVibeIndex(indexType: "vibeType", vibeType: "PUBLIC", vibeTag: nil)
        print("indexValue: \(indexValue)")
        if let vibeResults = CacheHelper.shared.getVibesByIndex(index: "vibeTypeGsiPK", value: indexValue) {
            if vibeResults.count == 0 {
                AppSyncHelper.shared.getUserVibesPaginated(requestedVibeTag: nil, requestedVibeType: VibeType.public, first: 10, after: nil, completionHandler: nil)
            }
            publicVibes = vibeResults
            notification = vibeResults._observe({ [weak self] (changes) in
                self?.vibesTable.reloadData()
                self?.updateEmptyVibeBackground()
            })
        } else {
            AppSyncHelper.shared.getUserVibesPaginated(requestedVibeTag: nil, requestedVibeType: VibeType.public, first: 10, after: nil, completionHandler: nil)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("========> inside the viewWillAppear of PublicVibesViewController")

        AppSyncHelper.shared.getUserChannel()
        allPendingVibes = [VibeModel]()
        AppSyncHelper.shared.getAllPendingPublicVibes { [weak self] (error, vibes) in
            if error != nil {
                print("Error in fetching the public pending vibes from the server")
                DispatchQueue.main.async {
                    self!.allPendingVibes = [VibeModel]()
                    self?.vibesTable.reloadData()
                    self?.updateEmptyVibeBackground()
                }
            } else if vibes != nil && vibes!.count > 0 {
                self!.allPendingVibes = [VibeModel]()
                DispatchQueue.main.async {
                    self?.allPendingVibes = vibes!
                    self?.vibesTable.reloadData()
                    self?.updateEmptyVibeBackground()
                }
            } else {
                self!.allPendingVibes = [VibeModel]()
                DispatchQueue.main.async {
                    self?.vibesTable.reloadData()
                    self?.updateEmptyVibeBackground()
                }
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        vibesTable.addSubview(emptyImageView)
        emptyImageView.frame = CGRect(x: 30, y: emptyImageView.superview!.frame.height / 4, width: emptyImageView.superview!.frame.width - 60, height: emptyImageView.superview!.frame.height / 3)
        emptyImageView.contentMode = .scaleAspectFit
        emptyImageView.image = UIImage(named: EMPTY_VIBES_IMAGE)
        updateEmptyVibeBackground()
    }

    func updateEmptyVibeBackground() {
        DispatchQueue.main.async {
            if (self.publicVibes == nil && self.allPendingVibes.count == 0) || (self.publicVibes != nil && self.publicVibes!.count == 0 && self.allPendingVibes.count == 0) {
                self.emptyImageView.isHidden = false
            } else {
                self.emptyImageView.isHidden = true
            }
        }
    }
}

extension PublicVibesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return publicVibes != nil ? publicVibes!.count + allPendingVibes.count : allPendingVibes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("MyPublicVibeTableViewCell", owner: self, options: nil)?.first as! MyPublicVibeTableViewCell
        if publicVibes != nil && indexPath.row < publicVibes!.count {
            print("indexPath.row inside publicVibes: \(indexPath.row)")
            let vibe = publicVibes![indexPath.row]
            switch viewHeight {
                case DeviceConstants.IPHONE7_HEIGHT: cell.reachCount.font = UIFont(name: "Helvetica Neue", size: 13.0)
                case DeviceConstants.IPHONE7PLUS_HEIGHT: cell.reachCount.font = UIFont(name: "Helvetica Neue", size: 13.0)
                case DeviceConstants.IPHONEX_HEIGHT: cell.reachCount.font = UIFont(name: "Helvetica Neue", size: 15.0)
                case DeviceConstants.IPHONEXR_HEIGHT: cell.reachCount.font = UIFont(name: "Helvetica Neue", size: 15.0)
                default: cell.reachCount.font = UIFont(name: "Helvetica Neue", size: 13.0)
            }
            cell.reachCount.text = String(vibe.getReach())
            cell.timestamp.text = APPUtilites.getDateFromEpochTime(epochTime: vibe.getCreatedAt(), isTimeInMiliseconds: true)
            cell.vibeName.text = vibe.getVibeName()!
            let vibeCategory = APPUtilites.getVibeTag(vibeTypeTag: vibe.getVibeTypeTagGsiPK()!)
            cell.vibeCategoryImage.image = UIImage(named: VibeCategories.getVibeCategoryImage(vibeCategory: vibeCategory))
            cell.vibeCategoryName.text = VibeCategories.getVibeCategoryDisplayName(vibeCategory: vibeCategory)
            cell.vibeCategoryName.textColor = VibeCategories.getVibeCategoryColor(vibeCategory: vibeCategory)
            cell.hailButton.tag = indexPath.row
            
            if vibe.getHasNewHails() {
                cell.unseenHailsDot.isHidden = false
            } else {
                cell.unseenHailsDot.isHidden = true
            }
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hailButtonPressed(sender:)))
            cell.hailButton.addGestureRecognizer(tapGesture)
        } else {
            print("indexPath.row inside allPendingVibes: \(indexPath.row)")
            let vibeIndex = publicVibes != nil && publicVibes!.count > 0 ? indexPath.row - publicVibes!.count : indexPath.row
            if vibeIndex < allPendingVibes.count {
                let vibe = allPendingVibes[vibeIndex]
                cell.timestamp.text = APPUtilites.getDateFromEpochTime(epochTime: vibe.getCreatedAt(), isTimeInMiliseconds: true)
                cell.vibeName.text = vibe.vibeName
                let vibeCategory = VibeCategories.getVibeTag(index: vibe.category).rawValue
                cell.vibeCategoryImage.image = UIImage(named: VibeCategories.getVibeCategoryImage(vibeCategory: vibeCategory))
                cell.vibeCategoryName.text = VibeCategories.getVibeCategoryDisplayName(vibeCategory: vibeCategory)
            } else {
                vibesTable.reloadData()
            }
            switch viewHeight {
                case DeviceConstants.IPHONE7_HEIGHT: cell.reachCount.font = UIFont(name: "Helvetica Neue", size: 14.0)
                case DeviceConstants.IPHONE7PLUS_HEIGHT: cell.reachCount.font = UIFont(name: "Helvetica Neue", size: 14.0)
                case DeviceConstants.IPHONEX_HEIGHT: cell.reachCount.font = UIFont(name: "Helvetica Neue", size: 16.0)
                case DeviceConstants.IPHONEXR_HEIGHT: cell.reachCount.font = UIFont(name: "Helvetica Neue", size: 16.0)
                default: cell.reachCount.font = UIFont(name: "Helvetica Neue", size: 14.0)
            }
            cell.reachCount.textColor = REVIEW_COLOR
            cell.reachCount.text = "Pending"
            cell.reachIcon.image = UIImage(named: "pending-vibe")
            cell.vibeName.textColor = REVIEW_COLOR
            cell.vibeCategoryName.textColor = REVIEW_COLOR
            cell.unseenHailsDot.isHidden = true
            cell.hailButton.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch viewHeight {
            case DeviceConstants.IPHONE7_HEIGHT: return view.frame.height / 4.5
            case DeviceConstants.IPHONE7PLUS_HEIGHT: return view.frame.height / 4.5
            case DeviceConstants.IPHONEX_HEIGHT: return view.frame.height / 5.5
            case DeviceConstants.IPHONEXR_HEIGHT: return view.frame.height / 5.5
            default: return view.frame.height / 5.5
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        let cell = tableView.cellForRow(at: indexPath) as! MyPublicVibeTableViewCell
        
        if publicVibes != nil && indexPath.row < publicVibes!.count {
            let vibe = publicVibes![indexPath.row]
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hailButtonPressed(sender:)))
            cell.hailButton.addGestureRecognizer(tapGesture)
            
            let vibeTag = VibeCategories.getVibeTagIndex(vibeTag: VibeTag(rawValue: String(vibe.getVibeTypeTagGsiPK()!.split(separator: "_")[1]))!)
            
            if !vibe.getIsDownloadInProgress() {
                let spinnerView = APPUtilites.displayLoadingSpinner(onView: view)
                AppSyncHelper.shared.getUserVibe(vibeId: vibe.getId()!, vibeType: 0, vibeTag: vibeTag) { (error, vibeModel) in
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
                            CacheHelper.shared.updateVibeDownloadStatus(vibe: vibe, isDownloadInProgress: false)
                            AnalyticsHelper.shared.logRandomPublicVibeEvent(action: .SEEN, tag: nil)
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
                                CacheHelper.shared.updateVibeDownloadStatus(vibe: vibe, isDownloadInProgress: false)
                                AnalyticsHelper.shared.logRandomPublicVibeEvent(action: .SEEN, tag: nil)
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
                                            AnalyticsHelper.shared.logRandomPublicVibeEvent(action: .SEEN, tag: nil)
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
                cell.progressBar.startAnimation()
                cell.progressBar.isHidden = false
            }
        } else {
            let vibeIndex = publicVibes != nil ? indexPath.row - publicVibes!.count : indexPath.row
            let vibe = allPendingVibes[vibeIndex]
            AppSyncHelper.shared.fetchPendingPublicVibe(vibeId: vibe.id) { (error, vibeModel) in
                DispatchQueue.main.async {
                    if error != nil {
                        APPUtilites.displayErrorSnackbar(message: "Error in fetching the vibe.")
                        return
                    }
                    if vibeModel == nil || vibeModel!.id == "" {
                        APPUtilites.displayElevatedErrorSnackbar(message: "Sorry, could not fetch the vibe right now. Please try again later")
                        return
                    }
                    if !vibeModel!.isLetterPresent && !vibeModel!.isPhotosPresent {
                        APPUtilites.displayErrorSnackbar(message: "No data present in the vibe. Please try again")
                        return
                    }
                    if !vibeModel!.isPhotosPresent {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let createVibeVC = storyboard.instantiateViewController(withIdentifier: "CreateVibeViewController") as! CreateVibeViewController
                        createVibeVC.vibeModel = vibeModel!
                        vibe.isDownloadInProgress = false
                        createVibeVC.isReview = true
                        self.present(createVibeVC, animated: true, completion: nil)
                    } else {
                        var imagesToBeDownloaded = [String]()
                        let allImages = vibeModel!.images
                        for i in 0 ..< vibeModel!.getImages().count {
                            if !FileManagerHelper.shared.doesFileExist(filePath: "/\(MediaHelper.shared.COMMON_FOLDER)/\(MediaHelper.shared.VIBE_IMAGES_FOLDER)/\(allImages[i].imageLink!)") {
                                imagesToBeDownloaded.append(allImages[i].imageLink!)
                            }
                        }
                        if imagesToBeDownloaded.count == 0 {
                            for i in 0 ..< allImages.count {
                                vibeModel!.images[i].image = UIImage(data: FileManagerHelper.shared.getImageDataFromPath(filePath: "/\(MediaHelper.shared.COMMON_FOLDER)/\(MediaHelper.shared.VIBE_IMAGES_FOLDER)/\(allImages[i].imageLink!)", isJpgExtensionRequired: false)!)
                            }
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let createVibeVC = storyboard.instantiateViewController(withIdentifier: "CreateVibeViewController") as! CreateVibeViewController
                            createVibeVC.vibeModel = vibeModel!
                            vibe.isDownloadInProgress = false
                            createVibeVC.isReview = true
                            self.present(createVibeVC, animated: true, completion: nil)
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
                                            vibe.isDownloadInProgress = false
                                            vibeModel!.images[i].image = UIImage(data: FileManagerHelper.shared.getImageDataFromPath(filePath: "/\(MediaHelper.shared.COMMON_FOLDER)/\(MediaHelper.shared.VIBE_IMAGES_FOLDER)/\(allImages[i].imageLink!)", isJpgExtensionRequired: false)!)
                                        }
                                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                        let createVibeVC = storyboard.instantiateViewController(withIdentifier: "CreateVibeViewController") as! CreateVibeViewController
                                        createVibeVC.vibeModel = vibeModel!
                                        vibe.isDownloadInProgress = false
                                        createVibeVC.isReview = true
                                        self.present(createVibeVC, animated: true, completion: nil)
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
                            vibe.isDownloadInProgress = true
                        }
                    }
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? MyPublicVibeTableViewCell
        if publicVibes != nil && indexPath.row < publicVibes!.count {
            let vibe = publicVibes![indexPath.row]
            if vibe.getIsDownloadInProgress() {
                cell?.progressBar.stopAnimation()
                cell?.progressBar.isHidden = true
            } else {
                cell?.progressBar.startAnimation()
                cell?.progressBar.isHidden = false
            }
        } else {
            let vibeIndex = publicVibes != nil ? indexPath.row - publicVibes!.count : indexPath.row
            if vibeIndex < allPendingVibes.count {
                let vibe = allPendingVibes[vibeIndex]
                if vibe.getIsDownloadInProgress() {
                    cell?.progressBar.stopAnimation()
                    cell?.progressBar.isHidden = true
                } else {
                    cell?.progressBar.startAnimation()
                    cell?.progressBar.isHidden = false
                }
            } else {
                cell?.progressBar.stopAnimation()
                cell?.progressBar.isHidden = true
                vibesTable.reloadData()
            }
        }
    }

    @objc func hailButtonPressed(sender: UITapGestureRecognizer) {
        
        let tag = sender.view?.tag
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let hailVC = storyboard.instantiateViewController(withIdentifier: "HailsViewController") as! HailsViewController
        CacheHelper.shared.setHasNewHailsInVibe(hasNewHails: false, vibeId: publicVibes![tag!].getId()!)
        hailVC.vibeId = publicVibes![tag!].getId()!
        hailVC.modalPresentationStyle = .overCurrentContext
        
        present(hailVC, animated: false, completion: nil)
    }
}
