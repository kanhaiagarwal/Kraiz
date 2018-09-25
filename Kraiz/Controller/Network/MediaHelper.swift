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
    
    func setMediaHelper() {
        let config = CLDConfiguration(cloudinaryUrl: MediaHelperConstants.CLOUDINARY_URL + "?secure=true")
        MediaHelper.shared.client = CLDCloudinary(configuration: config!)
        MediaHelper.shared.client?.cachePolicy = .disk
        MediaHelper.shared.client?.cacheMaxDiskCapacity = 100 * 1024 * 1024 // in Bytes
    }
    
    func getMediaHelper() -> CLDCloudinary? {
        return MediaHelper.shared.client
    }
    
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
                success((result?.publicId)!)
            }
        })
    }
    
    func downloadProfileImage(publicId: String, success: @escaping (UIImage) -> Void, failure: @escaping (NSError) -> Void) {
        if client == nil {
            setMediaHelper()
        }
        
        let imageUrl = client?.createUrl().generate(publicId, signUrl: true)
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
