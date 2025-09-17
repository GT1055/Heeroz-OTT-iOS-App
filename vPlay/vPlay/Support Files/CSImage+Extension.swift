//
//  CSImage+Extension.swift
//  vplay
//
//  Created by user on 29/05/18.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation
import AlamofireImage
import AVFoundation
extension UIImageView {
    /// image with Url
    ///
    /// - Parameter imageURl: set the image with url
    /// - Returns: return Uiimage
    func setImageWithUrl(_ imageURl: String!) {
        if isValidateNillAndEmpty(imageURl) {
            let imageString: String = imageURl.addingPercentEncoding(withAllowedCharacters:
                NSCharacterSet.urlQueryAllowed)!
            let url = URL(string: imageString)
            var request = URLRequest(url: url!)
            request.addValue(BASEURL, forHTTPHeaderField: "Referer")
            self.af_setImage(withURLRequest: request)
            self.contentMode = .scaleAspectFill
            return
        } else {
            self.contentMode = .scaleAspectFit
            self.image = nil
            return
        }
    }
    // Path
    func getThumbnailFrom(_ path: String) {
        if !path.isEmpty {
            do {
                let asset = AVURLAsset(url: URL.init(string: path)!, options: nil)
                let imgGenerator = AVAssetImageGenerator(asset: asset)
                imgGenerator.appliesPreferredTrackTransform = true
                let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
                let thumbnail = UIImage(cgImage: cgImage)
                self.image = thumbnail
            } catch _ {
                self.image = nil
            }
        }
    }
    /// image with Url
    ///
    /// - Parameter imageURl: set the image with url
    /// - Returns: return Uiimage
    func setBannerImageWithUrl(_ imageURl: String!) {
        if isValidateNillAndEmpty(imageURl) {
            let imageString: String = imageURl.addingPercentEncoding(withAllowedCharacters:
                NSCharacterSet.urlQueryAllowed)!
            let url = URL(string: imageString)
            var request = URLRequest(url: url!)
            request.addValue(BASEURL, forHTTPHeaderField: "Referer")
            self.af_setImage(withURLRequest: request)
            self.contentMode = .scaleToFill
            return
        } else {
            self.contentMode = .scaleAspectFit
            self.image = nil
            return
        }
    }
    /// is validating Image url is empty
    ///
    /// - Parameter string: image url
    /// - Returns: returns true
    func isValidateNillAndEmpty(_ string: String!) -> Bool {
        if (string != nil)&&(string != "") {
            return true
        } else {
            return false
        }
    }
    /// User Profile image with Url
    ///
    /// - Parameter imageURl: set the image with url
    /// - Returns: return Uiimage
    func setProfileImageWithUrl(_ imageURl: String!) {
        if isValidateNillAndEmpty(imageURl) {
            let imageString: String = imageURl.addingPercentEncoding(withAllowedCharacters:
                NSCharacterSet.urlQueryAllowed)!
            let url = URL(string: imageString)
            let filter = AspectScaledToFillSizeFilter(size: self.bounds.size)
            self.af_setImage(
                withURL: url!,
                placeholderImage: #imageLiteral(resourceName: "placeholder"),
                filter: filter,
                imageTransition: .crossDissolve(0.2)
            )
        } else {
            self.image = #imageLiteral(resourceName: "placeholder")
            return
        }
    }
}
