//
//  VibeImagesGameCaptionsViewController.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 03/01/19.
//  Copyright © 2019 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit

class VibeImagesGameCaptionsViewController: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var captionsTable: UITableView!
    @IBOutlet weak var numberOfCaptionsLabel: UILabel!
    var maxSelectionsCount = 0
    var currentSelectionsCount = 0
    var vibeModel: VibeModel?
    var isPreview = false

    var captionsSelected = [Int : Bool]()

    let CONSTANT_TEXT = "The number of captions you can pick is"

    var gradientLayer: CAGradientLayer?

    override func viewDidLoad() {
//        createVibeModel()
        maxSelectionsCount = 2 * vibeModel!.getImages().count / 3
        super.viewDidLoad()
        captionsTable.backgroundColor = UIColor.clear
        captionsTable.layer.backgroundColor = UIColor.clear.cgColor
        numberOfCaptionsLabel.text = "\(CONSTANT_TEXT) \(maxSelectionsCount)"
        for i in 0 ..< vibeModel!.getImages().count {
            captionsSelected[i] = false
        }
    }

    @IBAction func closePressed(_ sender: Any) {
        if vibeModel!.isLetterPresent {
            let presentingVC = self.presentingViewController!.presentingViewController!.presentingViewController!
            presentingVC.dismiss(animated: true) {
                self.dismiss(animated: false, completion: nil)
            }
        } else {
            let presentingVC = self.presentingViewController!.presentingViewController!
            presentingVC.dismiss(animated: true) {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    @IBAction func nextPressed(_ sender: Any) {
        var atleastOneImageSelected = false
        for i in 0 ..< vibeModel!.getImages().count {
            if captionsSelected[i]! {
                atleastOneImageSelected = true
                break
            }
        }
        if !atleastOneImageSelected {
            APPUtilites.displayErrorSnackbar(message: "Please select atleast one caption")
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let imagesVC = storyboard.instantiateViewController(withIdentifier: "VibeImagesGameImagesViewController") as! VibeImagesGameImagesViewController
        imagesVC.vibeModel = vibeModel
        imagesVC.captionsSelected = captionsSelected
        imagesVC.isPreview = true
        self.present(imagesVC, animated: true, completion: nil)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradientLayer = CAGradientLayer()
        gradientLayer!.frame = bgView.bounds
        gradientLayer!.colors = [UIColor(displayP3Red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0).cgColor, UIColor(displayP3Red: 253/255, green: 116/255, blue: 108/255, alpha: 1.0).cgColor]
        bgView.layer.addSublayer(gradientLayer!)
    }
}

extension VibeImagesGameCaptionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vibeModel?.getImages().count ?? 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return captionsTable.frame.height / 8
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("VibeImageGameCaptionsTableViewCell", owner: self, options: nil)?.first as! VibeImageGameCaptionsTableViewCell
        
        cell.backgroundColor = UIColor.clear
        cell.captionLabel.text = vibeModel!.getImages()[indexPath.row].caption != nil && vibeModel!.getImages()[indexPath.row].caption != "" ? vibeModel!.getImages()[indexPath.row].caption : "No Caption here, but you can still select it."
        cell.layer.backgroundColor = UIColor.clear.cgColor
        if captionsSelected[indexPath.row]! {
            cell.selectImage.isHidden = false
        } else {
            cell.selectImage.isHidden = true
        }
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let cell = tableView.cellForRow(at: indexPath) as! VibeImageGameCaptionsTableViewCell
        if cell.selectImage.isHidden {
            if currentSelectionsCount < maxSelectionsCount {
                cell.selectImage.isHidden = false
                currentSelectionsCount = currentSelectionsCount + 1
                captionsSelected[indexPath.row] = true
            } else {
                APPUtilites.displayErrorSnackbar(message: "You can select only \(maxSelectionsCount) captions")
            }
        } else {
            cell.selectImage.isHidden = true
            currentSelectionsCount = currentSelectionsCount > 0 ? currentSelectionsCount - 1 : 0
            captionsSelected[indexPath.row] = false
        }
        
        print("captionsSelected: \(captionsSelected)")
    }

    func createVibeModel() {
        vibeModel = VibeModel()

        var photos = [PhotoEntity]()
        for i in 0 ..< 9 {
            if i % 2 == 0 {
                photos.append(PhotoEntity(image: UIImage(named: "profile-default")!, caption: "This is caption \(i + 1)"))
            } else {
                photos.append(PhotoEntity(image: UIImage(named: "profile-default")!, caption: ""))
            }
        }
        vibeModel!.setImages(photos: photos)
    }
}