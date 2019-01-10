//
//  PublicVibesChoiceViewController.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 21/12/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit
import RxSwift

class PublicVibesChoiceViewController: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var publicVibesTableView: UITableView!
    @IBOutlet weak var quoteLabel: UILabel!
    
    let gradientColors = [[UIColor(displayP3Red: 1, green: 65/255, blue: 108/255, alpha: 1.0).cgColor, UIColor(displayP3Red: 1, green: 75/255, blue: 43/255, alpha: 1.0).cgColor], [UIColor(displayP3Red: 17/255, green: 153/255, blue: 142/255, alpha: 1.0).cgColor, UIColor(displayP3Red: 56/255, green: 239/255, blue: 135/255, alpha: 1.0).cgColor], [UIColor(displayP3Red: 0, green: 131/255, blue: 176/255, alpha: 1.0).cgColor, UIColor(displayP3Red: 0, green: 180/255, blue: 219/255, alpha: 1.0).cgColor], [UIColor(displayP3Red: 119/255, green: 47/255, blue: 26/255, alpha: 1.0).cgColor, UIColor(displayP3Red: 242/255, green: 166/255, blue: 90/255, alpha: 1.0).cgColor], [UIColor(displayP3Red: 243/255, green: 115/255, blue: 53/255, alpha: 1.0).cgColor, UIColor(displayP3Red: 253/255, green: 200/255, blue: 48/255, alpha: 1.0).cgColor], [UIColor(displayP3Red: 2/255, green: 27/255, blue: 121/255, alpha: 1.0).cgColor, UIColor(displayP3Red: 5/255, green: 117/255, blue: 230/255, alpha: 1.0).cgColor]]
    var gradientLayer: CAGradientLayer?
    @IBOutlet weak var heading: UILabel!
    
    var tagSelected : Int = 0
    var allVibes: [VibeModel]?
    var allProfiles: [String : ProfileModel]?
    var loadingLabel = UILabel()
    var viewHeight : CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        viewHeight = view.frame.height
        quoteLabel.text = VibeQuotes.shared.getQuote(tagIndex: tagSelected, quoteIndex: Int.random(in: 0..<VibeQuotes.shared.getNumberOfQuotesForATag(tagIndex: tagSelected)))
        heading.text = VibeCategories.pickerStrings[tagSelected]
        loadingLabel.numberOfLines = 0
        if allVibes != nil {
            for i in 0 ..< allVibes!.count {
                AppSyncHelper.shared.incrementReachOfVibe(vibeId: allVibes![i].id, completionHandler: nil)
            }
        }
        
        AppSyncHelper.shared.getRandomPublicVibes(vibeTag: VibeCategories.getVibeTag(index: tagSelected)) {(error, allVibes, allProfiles)  in
            DispatchQueue.main.async {
                if error != nil {
                    print(error)
                }
                if allVibes != nil && allVibes!.count > 0 {
                    self.allVibes = allVibes
                    self.allProfiles = allProfiles
                    self.publicVibesTableView.backgroundView = nil
                    self.publicVibesTableView.reloadData()
                } else {
                    self.loadingLabel.text = "Sorry, no vibes are available right now. Please try after sometime."
                }
            }
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        gradientLayer = CAGradientLayer()
        gradientLayer?.frame = view.bounds
        gradientLayer?.colors = gradientColors[tagSelected]
        bgView.layer.addSublayer(gradientLayer!)
        loadingLabel.text = "Loading ...."
        loadingLabel.textColor = UIColor.white
        loadingLabel.font = UIFont.systemFont(ofSize: 26)
        loadingLabel.frame = publicVibesTableView.frame
        loadingLabel.textAlignment = .center
        publicVibesTableView.backgroundView = loadingLabel
    }

    @IBAction func backPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        gradientLayer?.removeFromSuperlayer()
    }
}

extension PublicVibesChoiceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allVibes != nil ? allVibes!.count : 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("VibeChoiceTableViewCell", owner: self, options: nil)?.first as! VibeChoiceTableViewCell
        cell.profileImage.image = UIImage(named: "profile-default")
        let vibe = allVibes![indexPath.row]
//        let profile = allProfiles![(vibe.from?.getId())!]
//        cell.usernameLabel.text = profile?.getUsername() != nil ? profile?.getUsername() : "None"
        switch viewHeight {
            case DeviceConstants.IPHONE7_HEIGHT:
                cell.usernameLabel.font = UIFont(name: "Helvetica Neue", size: 17)
                cell.vibeNameLabel.font = UIFont(name: "Helvetica Neue", size: 17)
                break
            case DeviceConstants.IPHONE7PLUS_HEIGHT:
                cell.usernameLabel.font = UIFont(name: "Helvetica Neue", size: 17)
                cell.vibeNameLabel.font = UIFont(name: "Helvetica Neue", size: 17)
                break
            case DeviceConstants.IPHONEX_HEIGHT:
                cell.usernameLabel.font = UIFont(name: "Helvetica Neue", size: 17)
                cell.vibeNameLabel.font = UIFont(name: "Helvetica Neue", size: 17)
                break
            case DeviceConstants.IPHONEXR_HEIGHT:
                cell.usernameLabel.font = UIFont(name: "Helvetica Neue", size: 19)
                cell.vibeNameLabel.font = UIFont(name: "Helvetica Neue", size: 19)
                break
            default:
                cell.usernameLabel.font = UIFont(name: "Helvetica Neue", size: 17)
                cell.vibeNameLabel.font = UIFont(name: "Helvetica Neue", size: 17)
                break
        }
        cell.usernameLabel.text = "kanhai.agarwal"
        cell.vibeNameLabel.text = vibe.vibeName
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let vibe = allVibes![indexPath.row]
        let spinnerView = APPUtilites.displayLoadingSpinner(onView: view)
        if !vibe.isLetterPresent && !vibe.isPhotosPresent {
            APPUtilites.displayErrorSnackbar(message: "No data present in the vibe. Please try again")
        }
        if !vibe.isPhotosPresent {
            APPUtilites.removeLoadingSpinner(spinner: spinnerView)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vibeWelcomeVC = storyboard.instantiateViewController(withIdentifier: "VibeWelcomeViewController") as! VibeWelcomeViewController
            vibeWelcomeVC.vibeModel = vibe
            let presentingVC = self.presentingViewController!.presentingViewController!
            let homeVC = self.presentingViewController!.presentingViewController!
            presentingVC.dismiss(animated: true) {
                print("inside presentingVC.dismiss")
                homeVC.present(vibeWelcomeVC, animated: true, completion: {
                    print("inside homeVC.present")
                })
            }
        } else {
            var imagesToBeDownloaded = [String]()
            let allImages = vibe.images
            for i in 0 ..< vibe.getImages().count {
                if !FileManagerHelper.shared.doesFileExist(filePath: "/\(MediaHelper.shared.COMMON_FOLDER)/\(MediaHelper.shared.VIBE_IMAGES_FOLDER)/\(allImages[i].imageLink!)") {
                    imagesToBeDownloaded.append(allImages[i].imageLink!)
                }
            }
            if imagesToBeDownloaded.count == 0 {
                print("====> All images present in local.")
                for i in 0 ..< allImages.count {
                    vibe.images[i].image = UIImage(data: FileManagerHelper.shared.getImageDataFromPath(filePath: "/\(MediaHelper.shared.COMMON_FOLDER)/\(MediaHelper.shared.VIBE_IMAGES_FOLDER)/\(allImages[i].imageLink!)", isJpgExtensionRequired: false)!)
                }
                APPUtilites.removeLoadingSpinner(spinner: spinnerView)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vibeWelcomeVC = storyboard.instantiateViewController(withIdentifier: "VibeWelcomeViewController") as! VibeWelcomeViewController
                vibeWelcomeVC.vibeModel = vibe
                let presentingVC = self.presentingViewController!.presentingViewController!
                let homeVC = self.presentingViewController!.presentingViewController!.presentingViewController!
                presentingVC.dismiss(animated: true) {
                    print("inside presentingVC.dismiss")
                    self.dismiss(animated: false, completion: {
                        print("inside self.dismiss")
                        homeVC.present(vibeWelcomeVC, animated: true, completion: {
                            print("inside homeVC.present")
                        })
                    })
                }
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
                                vibe.images[i].image = UIImage(data: FileManagerHelper.shared.getImageDataFromPath(filePath: "/\(MediaHelper.shared.COMMON_FOLDER)/\(MediaHelper.shared.VIBE_IMAGES_FOLDER)/\(allImages[i].imageLink!)", isJpgExtensionRequired: false)!)
                            }
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            APPUtilites.removeLoadingSpinner(spinner: spinnerView)
                            let vibeWelcomeVC = storyboard.instantiateViewController(withIdentifier: "VibeWelcomeViewController") as! VibeWelcomeViewController
                            vibeWelcomeVC.vibeModel = vibe
                            let presentingVC = self.presentingViewController!.presentingViewController!
                            let homeVC = self.presentingViewController!.presentingViewController!.presentingViewController!
                            presentingVC.dismiss(animated: true) {
                                print("inside presentingVC.dismiss")
                                self.dismiss(animated: false, completion: {
                                    print("inside self.dismiss")
                                    homeVC.present(vibeWelcomeVC, animated: true, completion: {
                                        print("inside homeVC.present")
                                    })
                                })
                            }
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
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch viewHeight {
            case DeviceConstants.IPHONE7_HEIGHT: return view.frame.height / 6
            case DeviceConstants.IPHONE7PLUS_HEIGHT: return view.frame.height / 6
            case DeviceConstants.IPHONEX_HEIGHT: return view.frame.height / 7
            case DeviceConstants.IPHONEXR_HEIGHT: return view.frame.height / 7
            default: return view.frame.height / 6
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            cell.alpha = 1
        }, completion: nil)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
