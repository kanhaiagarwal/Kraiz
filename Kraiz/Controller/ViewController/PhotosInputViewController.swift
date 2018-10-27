//
//  PhotosInputViewController.swift
//  Kraiz
//
//  Created by Kumar Agarwal, Kanhai on 12/08/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//
//  Class to show all the selected images of the user for the Photo Section of the Vibe.

import UIKit
import BSImagePicker
import CropViewController
import Photos

enum CROP_STATES {
    public typealias RawValue = String
    case APPEND_AT_THE_END
    case EDIT_PRESENT
    case UNKNOWN

    public init?(rawValue: RawValue) {
        switch rawValue {
            case "appendAtTheEnd": self = .APPEND_AT_THE_END
            case "editPresent": self = .EDIT_PRESENT
            default: self = .UNKNOWN
        }
    }
}

struct PhotoEntity {
    var image: UIImage?
    var caption: String?
    
    init() {
        image = nil
        caption = nil
    }

    init(image: UIImage) {
        self.image = image
        self.caption = nil
    }

    init(image: UIImage, caption: String) {
        self.image = image
        self.caption = caption
    }
}

protocol PhotosInputProtocol {
    func photosInput(photos: [PhotoEntity])
}

class PhotosInputViewController: UIViewController, CropViewControllerDelegate {

    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!

    let GRADIENT_TOP_COLOR = UIColor(displayP3Red: 230/255, green: 158/255, blue: 55/255, alpha: 1.0)
    let GRADIENT_BOTTOM_COLOR = UIColor(displayP3Red: 227/255, green: 121/255, blue: 11/255, alpha: 1.0)

    let CELL_IDENTIFIER = "photoCell"
    let DEFAULT_CELL_CAPTION = "No Caption"
    let NUMBER_OF_PHOTOS_IN_ROW = 3
    let MAX_IMAGES = 9

    var delegate: PhotosInputProtocol?

    var numberOfImagesSelected = 0
    var selectedImages : [PhotoEntity] = []
    var presentCropState : CROP_STATES = .APPEND_AT_THE_END
    var presentImageToBeCroppped : Int = -1
    var updateImageInGrid = false
    var imagesToBeCropped = [PHAsset]()
    var currentCropIndex : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("selectedImages.count: \(selectedImages.count)")

        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        photosCollectionView.isScrollEnabled = false

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        photosCollectionView!.collectionViewLayout = layout

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
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func doneButtonPressed(_ sender: UIButton) {
        print("No Action to perform right now")
    }

    @IBAction func nextButtonPressed(_ sender: UIButton) {
        print("inside nextButtonPressed")
        if selectedImages.count == 0 {
            print("selectedImages count is 0")
            let action = UIAlertAction(title: "Okay", style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            })
            let alertController = UIAlertController(title: "No Images in the Vibe", message: "Please add minimum one image in the Vibe", preferredStyle: .alert)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        } else {
            print("selectedImages count is greater than 0")
            delegate?.photosInput(photos: selectedImages)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension PhotosInputViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (photosCollectionView.frame.width - 20) / 3 - 1, height: (photosCollectionView.frame.height - 20) / 3 - 1)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photosCollectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER, for: indexPath) as! PhotoInputCollectionViewCell
        if selectedImages.count > indexPath.row {
            cell.photo.isHidden = false
            cell.photo.image = selectedImages[indexPath.row].image!
            cell.caption.isHidden = false
            cell.caption.text = selectedImages[indexPath.row].caption == nil ? DEFAULT_CELL_CAPTION : selectedImages[indexPath.row].caption!
            cell.crossButton.isHidden = false
        } else {
            cell.photo.isHidden = true
            cell.caption.isHidden = true
            cell.crossButton.isHidden = true
        }
        
        cell.crossButton.tag = indexPath.section * NUMBER_OF_PHOTOS_IN_ROW + indexPath.row
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor

        // Add a remove image tap gesture to the cross button
        let removeImageGesture = UITapGestureRecognizer(target: self, action: #selector(removeImageButtonTapped))
        cell.crossButton.addGestureRecognizer(removeImageGesture)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imagePickerVC = BSImagePickerViewController()
        let cellSelected = indexPath.row

        if numberOfImagesSelected == 0 {
            // The user is selecting the image for the first time.
            // Or there are no images in the image grid.
            
            imagePickerVC.maxNumberOfSelections = MAX_IMAGES
            bs_presentImagePickerController(imagePickerVC, animated: true, select: nil, deselect: nil, cancel: nil, finish: { (assets) in
                self.presentCropState = .APPEND_AT_THE_END
                DispatchQueue.main.async {
                    self.imagesToBeCropped = assets
                    self.currentCropIndex = 0
                    self.cropAndUpdateImagesInGrid(assets: assets, currentImageIndex: self.currentCropIndex)
                }
            }, completion: nil, selectLimitReached: { (maxImages) in
                DispatchQueue.main.async {
                    APPUtilites.displayErrorSnackbar(message: "You can only select \(maxImages) images")
                }
            })
            
        } else if cellSelected > self.numberOfImagesSelected - 1 {
            // The images are present. But we are selecting the cell where the image is not loaded, and we want to populate a single image in the next empty cell.
            
            imagePickerVC.maxNumberOfSelections = MAX_IMAGES - selectedImages.count
            bs_presentImagePickerController(imagePickerVC, animated: true, select: nil, deselect: nil, cancel: nil, finish: { (assets) in
                self.presentCropState = .APPEND_AT_THE_END
                DispatchQueue.main.async {
                    self.imagesToBeCropped = assets
                    self.currentCropIndex = 0
                    self.cropAndUpdateImagesInGrid(assets: assets, currentImageIndex: self.currentCropIndex)
                }
            }, completion: nil, selectLimitReached: { (maxImages) in
                DispatchQueue.main.async {
                    APPUtilites.displayErrorSnackbar(message: "You can only select \(maxImages) image")
                }
            })
        } else {
            // Cell selected is the cell in between of the selected images.

            let replaceImageAction = UIAlertAction(title: "Replace Image", style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
                imagePickerVC.maxNumberOfSelections = 1
                DispatchQueue.main.async {
                    self.bs_presentImagePickerController(imagePickerVC, animated: true, select: nil, deselect: nil, cancel: nil, finish: { (assets) in
                        self.presentImageToBeCroppped = cellSelected
                        self.presentCropState = .EDIT_PRESENT
                        DispatchQueue.main.async {
                            self.imagesToBeCropped = assets
                            self.currentCropIndex = 0
                            self.cropAndUpdateImagesInGrid(assets: assets, currentImageIndex: self.currentCropIndex)
                        }
                    }, completion: nil, selectLimitReached: { (maxImages) in
                        DispatchQueue.main.async {
                            APPUtilites.displayErrorSnackbar(message: "You can only select \(maxImages) image")
                        }
                    })
                }
            }
            let captionAction = UIAlertAction(title: "Add / Edit Caption", style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            let alertController = UIAlertController(title: "Edit Vibe Images", message: "Choose an action from below", preferredStyle: .actionSheet)
            alertController.addAction(replaceImageAction)
            alertController.addAction(captionAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        DispatchQueue.main.async {
            if self.presentCropState == .APPEND_AT_THE_END {
                self.numberOfImagesSelected = self.numberOfImagesSelected + 1
                let photoEntity = PhotoEntity(image: image)
                self.selectedImages.append(photoEntity)
                self.presentImageToBeCroppped = self.numberOfImagesSelected - 1
                let cell = self.photosCollectionView.cellForItem(at: IndexPath(row: self.presentImageToBeCroppped, section: 0)) as!PhotoInputCollectionViewCell
                cell.photo.isHidden = false
                cell.caption.isHidden = false
                cell.caption.text = (photoEntity.caption != nil) ? photoEntity.caption : self.DEFAULT_CELL_CAPTION
                cell.crossButton.isHidden = false
                cell.photo.image = self.selectedImages[self.presentImageToBeCroppped].image!
                self.currentCropIndex = self.currentCropIndex + 1
                cropViewController.dismiss(animated: true, completion: {
                    self.cropAndUpdateImagesInGrid(assets: self.imagesToBeCropped, currentImageIndex: self.currentCropIndex)
                })
            } else if self.presentCropState == .EDIT_PRESENT {
                self.selectedImages[self.presentImageToBeCroppped].image = image
                self.selectedImages[self.presentImageToBeCroppped].caption = nil
                let photoEntity = self.selectedImages[self.presentImageToBeCroppped]
                let cell = self.photosCollectionView.cellForItem(at: IndexPath(row: self.presentImageToBeCroppped, section: 0)) as!PhotoInputCollectionViewCell
                cell.photo.isHidden = false
                cell.caption.isHidden = false
                cell.caption.text = (photoEntity.caption != nil) ? photoEntity.caption : self.DEFAULT_CELL_CAPTION
                cell.crossButton.isHidden = false
                cell.photo.image = self.selectedImages[self.presentImageToBeCroppped].image
                cropViewController.dismiss(animated: true, completion: nil)
            }
        }
    }

    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        switch self.presentCropState {
            case .APPEND_AT_THE_END:
                self.currentCropIndex = self.currentCropIndex + 1
                cropViewController.dismiss(animated: true) {
                    self.cropAndUpdateImagesInGrid(assets: self.imagesToBeCropped, currentImageIndex: self.currentCropIndex)
            }
            case .EDIT_PRESENT: cropViewController.dismiss(animated: true, completion: nil)
            default: cropViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func cropAndUpdateImagesInGrid(assets: [PHAsset], currentImageIndex: Int) {
        if currentImageIndex < assets.count {
            DispatchQueue.main.async {
                let selectedImage = APPUtilites.getUIImage(asset: assets[currentImageIndex])
                
                // If there is an error in fetching the selected image from the gallery, move to the next image.
                if selectedImage == nil {
                    self.cropAndUpdateImagesInGrid(assets: assets, currentImageIndex: currentImageIndex + 1)
                } else {
                    let cropVC = CropViewController(croppingStyle: .default, image: selectedImage!)
                    cropVC.delegate = self
                    cropVC.aspectRatioLockEnabled = true
                    cropVC.aspectRatioPickerButtonHidden = true
                    cropVC.aspectRatioPreset = .presetSquare
                    cropVC.resetAspectRatioEnabled = false
                    self.present(cropVC, animated: true, completion: nil)
                }
            }
        }
        return
    }

    @objc func removeImageButtonTapped(recognizer: UIGestureRecognizer) {
        let removeAction = UIAlertAction(title: "Remove", style: .default) { (action) in
            let recognizerView = recognizer.view
            let cellIndex = recognizerView?.tag
            
            self.numberOfImagesSelected = self.numberOfImagesSelected - 1
            self.selectedImages.remove(at: cellIndex!)
            
            if cellIndex! == self.numberOfImagesSelected {
                // We have removed the last image in the grid.
                
                let cell = self.photosCollectionView.cellForItem(at: IndexPath(row: self.numberOfImagesSelected, section: 0)) as! PhotoInputCollectionViewCell
                cell.photo.isHidden = true
                cell.caption.isHidden = true
                cell.crossButton.isHidden = true
            } else if self.numberOfImagesSelected > cellIndex! {
                // We have removed an image from in between the image grid. We need to shift all the cell contents to its previous cell.
                for i in cellIndex!..<self.numberOfImagesSelected {
                    let presentCell = self.photosCollectionView.cellForItem(at: IndexPath(row: i, section: 0)) as! PhotoInputCollectionViewCell
                    let nextCell = self.photosCollectionView.cellForItem(at: IndexPath(row: i + 1, section: 0)) as! PhotoInputCollectionViewCell
                    presentCell.photo.image = nextCell.photo.image
                    presentCell.caption.text = nextCell.caption.text
                }
                let presentCell = self.photosCollectionView.cellForItem(at: IndexPath(row: self.numberOfImagesSelected, section: 0)) as! PhotoInputCollectionViewCell
                presentCell.photo.isHidden = true
                presentCell.caption.isHidden = true
                presentCell.crossButton.isHidden = true
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        let alertController = UIAlertController(title: "Remove Image", message: "Do you want to remove the image from the Vibe?", preferredStyle: .alert)
        alertController.addAction(removeAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
