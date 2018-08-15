//
//  PhotosInputViewController.swift
//  Kraiz
//
//  Created by Kumar Agarwal, Kanhai on 12/08/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//
//  Class to show all the selected images of the user for the Photo Section of the Vibe.

import UIKit

class PhotosInputViewController: UIViewController {

    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    
    let GRADIENT_TOP_COLOR = UIColor(displayP3Red: 230/255, green: 158/255, blue: 55/255, alpha: 1.0)
    let GRADIENT_BOTTOM_COLOR = UIColor(displayP3Red: 227/255, green: 121/255, blue: 11/255, alpha: 1.0)
    
    let CELL_IDENTIFIER = "photoCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        
        setupNextButton()
    }
    
    /// Sets up the next button
    func setupNextButton() {
        nextButton.layer.cornerRadius = 10
        nextButton.clipsToBounds = true
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = nextButton.bounds
        gradientLayer.colors = [GRADIENT_TOP_COLOR.cgColor, GRADIENT_BOTTOM_COLOR.cgColor]
        nextButton.layer.insertSublayer(gradientLayer, at: 1)
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        print("No Action To Perform Right Now")
    }
}

extension PhotosInputViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (photosCollectionView.frame.width - 20) / 3 - 1, height: (photosCollectionView.frame.height - 20) / 3 - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("*********************************************")
        print("inside didSelectItemAt")
        print("indexPath.row selected:  \(indexPath.row)")
        print("indexPath.section: \(indexPath.section)")
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photosCollectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER, for: indexPath) as! PhotoInputCollectionViewCell
        cell.photo.isHidden = true
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
