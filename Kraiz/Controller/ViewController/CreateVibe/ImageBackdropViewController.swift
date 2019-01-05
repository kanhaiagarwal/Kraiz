//
//  ImageBackdropViewController.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 25/11/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit

protocol ImagesBackdropSelection {
    func imageBackdropSelected(backdropSelected: Int)
}

class ImageBackdropViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let backdropList = ["Polaroid Photos", "Tuner"]
    let backdropImages = ["letter-ancient", "letter-love"]
    var backdropSelected: Int?
    var isSourceCreateVibe = false
    var delegate: ImagesBackdropSelection?

    @IBOutlet weak var backdropTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        backdropTable.delegate = self
        backdropTable.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        if backdropSelected != nil {
            let cell = backdropTable.cellForRow(at: IndexPath(row: backdropSelected!, section: 0)) as! ImageBackdropTableViewCell
            cell.backdropCheckbox.isHidden = false
            cell.isBackdropSelected = true
            performTickAnimation(checkbox: cell.backdropCheckbox, isSelected: true)
        }
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func donePressed(_ sender: UIButton) {
        if backdropSelected == nil {
            APPUtilites.displayErrorSnackbar(message: "Please select a backdrop")
            return
        }
        if isSourceCreateVibe {
            let presentingVC = self.presentingViewController
            let photosInputVC = self.storyboard?.instantiateViewController(withIdentifier: "PhotosInputViewController") as! PhotosInputViewController
            photosInputVC.backdropSelected = backdropSelected!
            photosInputVC.numberOfImagesSelected = 0
            photosInputVC.selectedImages = [PhotoEntity]()
            photosInputVC.delegate = self.presentingViewController as! CreateVibeViewController
            self.dismiss(animated: true) {
                presentingVC?.present(photosInputVC, animated: true, completion: nil)
            }
        } else {
            delegate!.imageBackdropSelected(backdropSelected: backdropSelected!)
            self.dismiss(animated: true, completion: nil)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return backdropList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("ImageBackdropTableViewCell", owner: self, options: nil)?.first as! ImageBackdropTableViewCell
        cell.backdropTitle.text = backdropList[indexPath.row]
        cell.backdropImage.image = UIImage(named: backdropImages[indexPath.row])
        
        cell.isBackdropSelected = false
        cell.backdropCheckbox.isHidden = true
        

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return backdropTable.frame.height / 2.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if backdropSelected != nil {
            if backdropSelected! == indexPath.row {
                return
            }
            let cell = tableView.cellForRow(at: IndexPath(row: backdropSelected!, section: 0)) as! ImageBackdropTableViewCell
            cell.isBackdropSelected = false
            cell.backdropCheckbox.isHidden = true
            performTickAnimation(checkbox: cell.backdropCheckbox, isSelected: false)
        }
        backdropSelected = indexPath.row
        
        let cell = tableView.cellForRow(at: indexPath) as! ImageBackdropTableViewCell
        cell.backdropCheckbox.isHidden = false
        performTickAnimation(checkbox: cell.backdropCheckbox, isSelected: true)
    }
}

extension ImageBackdropViewController {

    /// Performs the tick animation.
    /// Tick is displayed if the view is selected.
    /// - Parameters
    ///     - ckeckbox: The view in which the tick shape has to be drawn or removed.
    ///     - isSelected: If the View is in selection mode or not.
    func performTickAnimation(checkbox: UIView, isSelected: Bool) {
        
        if !isSelected {
            checkbox.layer.sublayers = nil
        } else {
            let checkboxWidth = checkbox.frame.width
            let checkboxHeight = checkbox.frame.height

            checkbox.layer.cornerRadius = checkbox.frame.height / 2
            let path = UIBezierPath()
            let layer = CAShapeLayer()
            
            path.move(to: CGPoint(x: checkboxWidth / 4, y: checkboxHeight / 2))
            path.addLine(to: CGPoint(x: checkboxWidth / 2.5, y: 2 * checkboxHeight / 3))
            path.addLine(to: CGPoint(x: 3 * checkboxWidth / 4, y: checkboxHeight / 3))
            path.stroke()
            
            layer.path = path.cgPath
            layer.strokeEnd = 0
            layer.lineWidth = 2
            layer.strokeColor = UIColor.white.cgColor
            layer.fillColor = UIColor.clear.cgColor
            
            checkbox.layer.addSublayer(layer)
            
            let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
            pathAnimation.toValue = 1
            pathAnimation.duration = 1.5 // in seconds
            pathAnimation.repeatCount = 1
            pathAnimation.fillMode = CAMediaTimingFillMode.forwards
            pathAnimation.isRemovedOnCompletion = false
            layer.add(pathAnimation, forKey: "pathanimation")
        }
    }
}
