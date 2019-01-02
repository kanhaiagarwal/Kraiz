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

    let EMPTY_VIBES_IMAGE : String = "empty-vibes-public"

    override func viewDidLoad() {
        super.viewDidLoad()

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

        AppSyncHelper.shared.getUserChannel()
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
            if self.publicVibes == nil || self.publicVibes!.count == 0 {
                self.emptyImageView.isHidden = false
            } else {
                self.emptyImageView.isHidden = true
            }
        }
    }
}

extension PublicVibesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return publicVibes != nil ? publicVibes!.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("MyPublicVibeTableViewCell", owner: self, options: nil)?.first as! MyPublicVibeTableViewCell
        let vibe = publicVibes![indexPath.row]
        cell.reachCount.text = String(vibe.getReach())
        cell.timestamp.text = APPUtilites.getDateFromEpochTime(epochTime: vibe.getCreatedAt(), isTimeInMiliseconds: true)
        cell.vibeName.text = vibe.getVibeName()!
        let vibeCategory = APPUtilites.getVibeTag(vibeTypeTag: vibe.getVibeTypeTagGsiPK()!)
        cell.vibeCategoryImage.image = UIImage(named: VibeCategories.getVibeCategoryImage(vibeCategory: vibeCategory))
        cell.vibeCategoryName.text = VibeCategories.getVibeCategoryDisplayName(vibeCategory: vibeCategory)
        cell.vibeCategoryName.textColor = VibeCategories.getVibeCategoryColor(vibeCategory: vibeCategory)
        cell.hailButton.tag = indexPath.row
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hailButtonPressed(sender:)))
        cell.hailButton.addGestureRecognizer(tapGesture)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 4.5
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        let cell = tableView.cellForRow(at: indexPath) as! MyPublicVibeTableViewCell

        let vibe = publicVibes![indexPath.row]

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hailButtonPressed(sender:)))
        cell.hailButton.addGestureRecognizer(tapGesture)
        
        let vibeTag = VibeCategories.getVibeTagIndex(vibeTag: VibeTag(rawValue: String(vibe.getVibeTypeTagGsiPK()!.split(separator: "_")[1]))!)
        
        if !vibe.getIsDownloadInProgress() {
            let spinnerView = APPUtilites.displayLoadingSpinner(onView: view)
            AppSyncHelper.shared.getUserVibe(vibeId: vibe.getId()!, vibeType: 0, vibeTag: vibeTag) { (error, vibeModel) in
                DispatchQueue.main.async {
                    print("====> inside the completionHandler of getUserVibe")
                    APPUtilites.removeLoadingSpinner(spinner: spinnerView)
                    if error != nil {
                        APPUtilites.displayErrorSnackbar(message: "Error in fetching the vibe.")
                    }
                    if vibeModel == nil {
                        APPUtilites.displayErrorSnackbar(message: "Cannot get the vibe components. Please try again")
                    }
                    if !vibeModel!.isLetterPresent && !vibeModel!.isPhotosPresent {
                        APPUtilites.displayErrorSnackbar(message: "No data present in the vibe. Please try again")
                    }
                    if !vibeModel!.isPhotosPresent {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vibeWelcomeVC = storyboard.instantiateViewController(withIdentifier: "VibeWelcomeViewController") as! VibeWelcomeViewController
                        vibeWelcomeVC.vibeModel = vibeModel
                        CacheHelper.shared.updateVibeDownloadStatus(vibe: vibe, isDownloadInProgress: false)
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
            cell.progressBar.startAnimation()
            cell.progressBar.isHidden = false
        }

    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? MyPublicVibeTableViewCell
        let vibe = publicVibes![indexPath.row]
    
        if vibe.getIsDownloadInProgress() {
            cell?.progressBar.stopAnimation()
            cell?.progressBar.isHidden = true
        } else {
            cell?.progressBar.startAnimation()
            cell?.progressBar.isHidden = false
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
