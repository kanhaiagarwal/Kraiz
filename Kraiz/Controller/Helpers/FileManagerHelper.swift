//
//  FileManagerHelper.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 23/12/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import Foundation
import UIKit
import Photos

class FileManagerHelper {
    static public let shared = FileManagerHelper()

    private init() {}

    /// Returns a URL for a file name and the folder.
    /// - Parameters:
    ///     - fileName: Name of the file.
    ///     - folder: (Optional) Name of the folder.
    /// - Returns: File URL.
    public func getFileUrl(fileName: String, folder: String?) -> URL {
        if folder != nil {
            return URL(fileURLWithPath: NSHomeDirectory().appending("/\(folder!)").appending("/\(fileName)"))
        } else {
            return URL(fileURLWithPath: NSHomeDirectory().appending("/\(fileName)"))
        }
    }

    /// Stores the image in a particular folder. Creates a folder if it does not exists. Returns the file path.
    /// - Parameters:
    ///     - image: Image to be saved.
    ///     - folder: Folder in which the image needs to be saved.
    ///     - fileName: (Optional) Name of the file if it is chosen by the user.
    /// - Returns: File Path
    public func storeImageInFolder(image: UIImage, folder: String, fileName: String?) -> String {
        print("inside storeImageInFolder for folder: \(folder) and filename: \(fileName)")
        let filePath = fileName != nil ? "/\(folder)".appending("/\(fileName!)") : "/\(folder)".appending("/IMG_\(UUID().uuidString)").appending(".jpg")
        let directoryPath = NSHomeDirectory().appending("/\(folder)")
        if !FileManager.default.fileExists(atPath: directoryPath) {
            do {
                try FileManager.default.createDirectory(at: NSURL.fileURL(withPath: directoryPath), withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }

        let url = URL(fileURLWithPath: NSHomeDirectory().appending(filePath))
        do {
            try image.jpegData(compressionQuality: 1.0)?.write(to: url)
        } catch {
            print(error)
            print("file cant not be save at path \(filePath), with error : \(error)");
        }
        return filePath
    }

    /// Returns the Image Data present in the file path.
    /// - Parameters:
    ///     - filePath: Path of the file. Includes the name of the file and extension.
    /// - Returns: Image Data.
    public func getImageDataFromPath(filePath: String, isJpgExtensionRequired: Bool) -> Data? {
        let imageUrl = isJpgExtensionRequired ? URL(fileURLWithPath: NSHomeDirectory().appending(filePath).appending(".jpg")) : URL(fileURLWithPath: NSHomeDirectory().appending(filePath))

        do {
            let data = try Data(contentsOf: imageUrl)
            return data
        } catch {
            print("cannot convert the data: \(error)")
        }
        return nil
    }

    /// Checks if the file exists at the file path.
    /// - Parameters:
    ///     - filePath: File Path.
    /// - Returns: File Existence.
    public func doesFileExist(filePath: String) -> Bool {
        return FileManager.default.fileExists(atPath: NSHomeDirectory().appending(filePath))
    }

    /// Creates a custom album in the Photos.
    /// - Parameters:
    ///     - withTitle: Album Name.
    ///     - completionHandler: Completion Handler.
    func createAlbum(withTitle title: String, completionHandler: @escaping (PHAssetCollection?) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            var placeholder: PHObjectPlaceholder?
            
            PHPhotoLibrary.shared().performChanges({
                let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: title)
                placeholder = createAlbumRequest.placeholderForCreatedAssetCollection
            }, completionHandler: { (created, error) in
                var album: PHAssetCollection?
                if created {
                    let collectionFetchResult = placeholder.map { PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [$0.localIdentifier], options: nil) }
                    album = collectionFetchResult?.firstObject
                }
                
                completionHandler(album)
            })
        }
    }

    /// Gets the album from the Photos Library. If the album does not exists, it triggers the creation of the album.
    /// - Parameters:
    ///     - title: Name of the Album.
    ///     - completionHandler: Completion Handler.
    func getAlbum(title: String, completionHandler: @escaping (PHAssetCollection?) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "title = %@", title)
            let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
            
            if let album = collections.firstObject {
                completionHandler(album)
            } else {
                self?.createAlbum(withTitle: title, completionHandler: { (album) in
                    completionHandler(album)
                })
            }
        }
    }

    /// Saves the image to a custom Album.
    /// - Parameters:
    ///     - photo: Photo.
    ///     - toAlbum: Name of the Album.
    ///     - completionHandler: Completion Handler.
    func saveToAlbum(photo: UIImage, toAlbum titled: String, completionHandler: @escaping (Bool, Error?) -> ()) {
        getAlbum(title: titled) { (album) in
            DispatchQueue.global(qos: .background).async {
                PHPhotoLibrary.shared().performChanges({
                    let assetRequest = PHAssetChangeRequest.creationRequestForAsset(from: photo)
                    let assets = assetRequest.placeholderForCreatedAsset
                        .map { [$0] as NSArray } ?? NSArray()
                    let albumChangeRequest = album.flatMap { PHAssetCollectionChangeRequest(for: $0) }
                    albumChangeRequest?.addAssets(assets)
                }, completionHandler: { (success, error) in
                    completionHandler(success, error)
                })
            }
        }
    }
}
