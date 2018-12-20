//
//  MediaHelper.swift
//  Kraiz
//
//  Created by Kumar Agarwal, Kanhai on 15/09/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import Foundation
import Cloudinary
import RxSwift

class MediaHelper {
    static let shared = MediaHelper()
    private var client: CLDCloudinary?
    
    private let PROFILE_PIC_FOLDER = "profile"
    
    private init() {
    }
    
    /// Sets the media helper
    func setMediaHelper() {
        let config = CLDConfiguration(cloudinaryUrl: MediaHelperConstants.CLOUDINARY_URL + "?secure=true")
        MediaHelper.shared.client = CLDCloudinary(configuration: config!)
        MediaHelper.shared.client?.cachePolicy = .disk
        MediaHelper.shared.client?.cacheMaxDiskCapacity = 100 * 1024 * 1024 // in Bytes
    }
    
    /// Gets the media helper
    func getMediaHelper() -> CLDCloudinary? {
        return MediaHelper.shared.client
    }
    
    /// Uploads the Profile Image.
    /// - Parameters:
    ///     - fileData: Image Data in the form of NSData.
    ///     - success: Success Closure which will be invoked if the image upload succeeds.
    ///     - failure: Failure Closure which will be invoked if the image upload fails.
    func uploadProfileImage(fileData: Data, success: @escaping (String) -> Void, failure: @escaping (NSError) -> Void) {
        if client == nil {
            setMediaHelper()
        }
    
        let params = CLDUploadRequestParams().setFolder(PROFILE_PIC_FOLDER)
        self.client?.createUploader().signedUpload(data: fileData, params: params, progress: { (progress) in
            print("Upload Progress")
            print(progress.completedUnitCount)
        }, completionHandler: { (result, error) in
            if error != nil {
                failure(error!)
            } else {
                print("=======> publicId: \(result?.publicId)")
                var id = result?.publicId?.split(separator: "/")
                print("id:\(id![1])")
                success(String(id![1]))
            }
        })
    }
    
    /// Uploads the Images in the background.
    /// Keeps sending the updates to the counter whoever has subscribed to the counter.
    /// - Parameters:
    ///     - images: Images to be uploaded.
    ///     - folder: Remote Folder Name in which the images need to be uploaded.
    ///     - counter: Observable counter which will be observed by the requester.
    func uploadImagesAsync(images: [PhotoEntity], folder: String, counter: Variable<Int>) {
        if client == nil {
            setMediaHelper()
        }
        for i in 0 ..< images.count {
            DispatchQueue.global(qos: .utility).async {
                let params = CLDUploadRequestParams().setFolder(folder).setPublicId(images[i].imageLink!)
                self.client?.createUploader().signedUpload(data: images[i].image!.jpegData(compressionQuality: 0.5)!, params: params, progress: { (progress) in
                }, completionHandler: { (result, error) in
                    if error != nil {
                        print(error)
                    } else {
                        print("Upload done for the image \(images[i].imageLink!)")
                        counter.value = 1
                    }
                })
            }
        }
    }
    
    /// Downloads the image from the Media Store.
    /// - Parameters:
    ///     - publicId: Public ID of the image.
    ///     - success: Success Closure which will be invoked if the image download succeeds.
    ///     - counter: Failure Closure which will be invoked if the image download fails.
    func downloadProfileImage(publicId: String, success: @escaping (UIImage) -> Void, failure: @escaping (NSError) -> Void) {
        if client == nil {
            setMediaHelper()
        }

        let id = "\(PROFILE_PIC_FOLDER)/\(publicId)"
        let imageUrl = client?.createUrl().generate(id, signUrl: true)
        print("imageUrl generated in downloadProfileImage: \(imageUrl)")
        client?.createDownloader().fetchImage(imageUrl!, { (progress) in
            print("Progress: \(progress.fractionCompleted)")
        }, completionHandler: { (image, error) in
            if let e = error {
                print("Error: \(e)")
                failure(e)
            } else {
                print("Image Downloaded")
                success(image!)
            }
        })
    }
}
