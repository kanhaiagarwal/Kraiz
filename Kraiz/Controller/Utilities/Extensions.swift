//
//  Extensions.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 22/12/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func saveImageToLibraryDirectory() -> String? {
        let directoryPath =  NSHomeDirectory().appending("/Library/")
        if !FileManager.default.fileExists(atPath: directoryPath) {
            do {
                try FileManager.default.createDirectory(at: NSURL.fileURL(withPath: directoryPath), withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }
        let filename = "IMG_" + UUID.init().uuidString + ".jpg"
        let filepath = directoryPath.appending(filename)
        let url = NSURL.fileURL(withPath: filepath)
        do {
            try self.jpegData(compressionQuality: 1.0)?.write(to: url)
            return String.init("/Library/\(filename)")
            
        } catch {
            print(error)
            print("file cant not be save at path \(filepath), with error : \(error)");
            return filepath
        }
    }
}

class UnderlinedLabel: UILabel {
    
    override var text: String? {
        didSet {
            guard let text = text else { return }
            let textRange = NSMakeRange(0, text.count)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single, range: textRange)
            // Add other attributes if needed
            self.attributedText = attributedText
        }
    }
}
