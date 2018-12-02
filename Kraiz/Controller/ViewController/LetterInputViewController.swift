//
//  LetterInputViewController.swift
//  StoryFi
//
//  Created by Kumar Agarwal, Kanhai on 05/08/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//
// Class for Taking the Letter input from the user.

import UIKit

protocol LetterInputProtocol {
    func letterInput(backgroundImage: Int, text: String)
}

class LetterInputViewController: UIViewController {
    
    @IBOutlet weak var backgroundCollection: UICollectionView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var letterText: UITextView!
    
    var delegate: LetterInputProtocol?
    var letterFromVC : String = ""
    
    let backgroundImages = ["letter-love", "letter-royal", "letter-ancient", "letter-basic", "letter-starry"]
    let backgroundLabels = ["Love", "Royal", "Ancient", "Basic", "Starry"]
    let letterFont = ["Monotype Corsiva", "Freestyle Script", "French Script MT", "French Script MT", "Monotype Corsiva"]
    let fontColors : [UIColor] = [UIColor(displayP3Red: 0, green: 4/255, blue: 0, alpha: 1.0),
                                  UIColor(displayP3Red: 191/255, green: 134/255, blue: 52/255, alpha: 1.0),
                                  UIColor.black,
                                  UIColor(displayP3Red: 10/255, green: 9/255, blue: 22/255, alpha: 1.0),
                                  UIColor.white]
    
    var backgroundSelected = 0
    
    let COLLECTION_CELL_IDENTIFIER = "letter-background"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundCollection.delegate = self
        backgroundCollection.dataSource = self
        
        backgroundImage.image = UIImage(named: backgroundImages[backgroundSelected])
        letterText.text = letterFromVC
        setTextFont(backgroundIndex: backgroundSelected)
        letterText.textContainerInset = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        createToolbarForTextView(textView: letterText)
    }
    
    func createToolbarForTextView(textView: UITextView) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.dismissKeyboard))
        let flexButton1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let flexButton2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolbar.setItems([flexButton1, flexButton2, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        textView.inputAccessoryView = toolbar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func donePressed(_ sender: UIButton) {
        delegate?.letterInput(backgroundImage: backgroundSelected, text: letterText.text)
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closePressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add Letter to the Story", message: "Do you wish to stop editing the letter", preferredStyle: UIAlertController.Style.alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
//            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
    
}

extension LetterInputViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 5, height: backgroundCollection.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return backgroundImages.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = backgroundCollection.dequeueReusableCell(withReuseIdentifier: COLLECTION_CELL_IDENTIFIER, for: indexPath) as! LetterInputCollectionViewCell
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.black.cgColor
        cell.backgroundImage.image = UIImage(named: backgroundImages[indexPath.row])
        cell.backgroundLabel.text = backgroundLabels[indexPath.row]
        cell.tag = indexPath.row
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        backgroundImage.image = UIImage(named: backgroundImages[indexPath.row])
        backgroundSelected = indexPath.row
        setTextFont(backgroundIndex: indexPath.row)
    }
    
    func setTextFont(backgroundIndex: Int) {
        let viewHeight = view.frame.height
        
        switch viewHeight {
        case DeviceConstants.IPHONE7_HEIGHT:
            letterText.font = UIFont(name: VibeTextBackgrounds.TEXT_FONTS[backgroundIndex], size: 20)
            letterText.textColor = fontColors[backgroundIndex]
            break
        case DeviceConstants.IPHONE7PLUS_HEIGHT:
            letterText.font = UIFont(name: VibeTextBackgrounds.TEXT_FONTS[backgroundIndex], size: 24)
            letterText.textColor = fontColors[backgroundIndex]
        case DeviceConstants.IPHONEX_HEIGHT:
            letterText.font = UIFont(name: VibeTextBackgrounds.TEXT_FONTS[backgroundIndex], size: 24)
            letterText.textColor = fontColors[backgroundIndex]
        default:
            letterText.font = UIFont(name: VibeTextBackgrounds.TEXT_FONTS[backgroundIndex], size: 20)
            letterText.textColor = fontColors[backgroundIndex]
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
