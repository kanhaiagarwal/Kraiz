//
//  ImageCaptionsViewController.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 28/10/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit

protocol ImageCaptionsProtocol {
    func setImageCaptions(photosSelected: [PhotoEntity])
}

class ImageCaptionsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var photosScrollView: UIScrollView!
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var characterLimitLabel: UILabel!
    @IBOutlet weak var photosCollectionView: UICollectionView!

    let MAX_CAPTION_LIMIT = 80

    var delegate: ImageCaptionsProtocol?
    var selectedCell : Int = 0
    var captionFieldYIndex : CGFloat = 0
    var photosSelected : [PhotoEntity] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        photosScrollView.delegate = self
        photosCollectionView.isScrollEnabled = true
        
        createToolbarForTextField(textField: captionTextField)
        captionFieldYIndex = captionTextField.frame.origin.y
        captionTextField.delegate = self
        
        captionTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        setCaptionTextField(currentIndex: selectedCell)
    }

    func setCaptionTextField(currentIndex: Int) {
        captionTextField.text = photosSelected[currentIndex].caption
        if captionTextField.text != nil {
            characterLimitLabel.text = "\(MAX_CAPTION_LIMIT - captionTextField.text!.count)/\(MAX_CAPTION_LIMIT)"
        } else {
            characterLimitLabel.text = "\(MAX_CAPTION_LIMIT)/\(MAX_CAPTION_LIMIT)"
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        print("inside textFieldDidChange")
        var limitString = String(MAX_CAPTION_LIMIT) + "/" + String(MAX_CAPTION_LIMIT)
        if textField.text != nil {
            limitString = String(MAX_CAPTION_LIMIT - captionTextField.text!.count) + "/" + String(MAX_CAPTION_LIMIT)
        }
//        characterLimitLabel.text = limitString
        photosSelected[selectedCell].caption = textField.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return false
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupScrollView()
        setCollectionViewCellBorder(cellIndex: selectedCell)
        if selectedCell != 0 {
            photosScrollView.setContentOffset(CGPoint(x: photosScrollView.frame.width * CGFloat(selectedCell), y: 0), animated: false)
        }
    }

    func setupScrollView() {
        photosScrollView.layer.borderWidth = 1.0
        photosScrollView.layer.borderColor = UIColor.black.cgColor
        photosScrollView.showsVerticalScrollIndicator = false
        photosScrollView.contentSize = CGSize(width: photosScrollView.frame.width * CGFloat(photosSelected.count), height: photosScrollView.frame.height)
        for i in 0..<photosSelected.count {
            let imageView = UIImageView(frame: CGRect(x: photosScrollView.frame.width * CGFloat(i), y: 0, width: photosScrollView.frame.width, height: photosScrollView.frame.height))
            imageView.contentMode = .scaleAspectFill
            imageView.image = photosSelected[i].image!
            photosScrollView.addSubview(imageView)
        }

    }

    func setCollectionViewCellBorder(cellIndex: Int) {
        photosCollectionView.cellForItem(at: IndexPath(row: selectedCell, section: 0))?.layer.borderWidth = 0.0
        photosCollectionView.cellForItem(at: IndexPath(row: selectedCell, section: 0))?.layer.borderColor = UIColor.clear.cgColor
        photosCollectionView.cellForItem(at: IndexPath(row: cellIndex, section: 0))?.layer.borderWidth = 1.0
        photosCollectionView.cellForItem(at: IndexPath(row: cellIndex, section: 0))?.layer.borderColor = UIColor.blue.cgColor
    }

    @IBAction func backPressed(_ sender: UIButton) {
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        delegate?.setImageCaptions(photosSelected: photosSelected)
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }

    func createToolbarForTextField(textField: UITextField) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.dismissKeyboard))
        let flexButton1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let flexButton2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolbar.setItems([flexButton1, flexButton2, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        textField.inputAccessoryView = toolbar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        photosScrollView.isScrollEnabled = false
        animateViewMoving(field: textField, up: true, moveValue: 150)
        animateViewMoving(field: characterLimitLabel, up: true, moveValue: 150)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        photosScrollView.isScrollEnabled = true
        animateViewMoving(field: textField, up: false, moveValue: 150)
        animateViewMoving(field: characterLimitLabel, up: false, moveValue: 150)
    }

    func animateViewMoving (field: UIView, up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        
        UIView.beginAnimations("animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        
        field.frame = CGRect(x: field.frame.origin.x, y: field.frame.origin.y + movement, width: field.frame.width, height: field.frame.height)
        UIView.commitAnimations()
    }
}

extension ImageCaptionsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosSelected.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photosCollectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! ImageCaptionCollectionViewCell
        cell.imageView.image = photosSelected[indexPath.row].image!
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setCollectionViewCellBorder(cellIndex: indexPath.row)
        selectedCell = indexPath.row
        photosScrollView.setContentOffset(CGPoint(x: photosScrollView.frame.width * CGFloat(indexPath.row), y: 0), animated: false)
        setCaptionTextField(currentIndex: selectedCell)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        setCollectionViewCellBorder(cellIndex: indexPath.row)
        selectedCell = indexPath.row
        photosScrollView.setContentOffset(CGPoint(x: photosScrollView.frame.width * CGFloat(indexPath.row), y: 0), animated: false)
        setCaptionTextField(currentIndex: selectedCell)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollPoint = photosScrollView.contentOffset
        setCollectionViewCellBorder(cellIndex: Int(scrollPoint.x / photosScrollView.frame.width))
        selectedCell = Int(scrollPoint.x / photosScrollView.frame.width)
        photosCollectionView.scrollToItem(at: IndexPath(row: selectedCell, section: 0), at: .centeredVertically, animated: false)
    }
}
