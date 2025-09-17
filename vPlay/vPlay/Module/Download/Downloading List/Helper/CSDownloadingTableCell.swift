//
//  CSDownloadingTableCell.swift
//  LearningSpaces
//
//  Created by user on 26/06/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
class CSDownloadingTableCell: UITableViewCell {
    // progress Bar to show download
    @IBOutlet var progressBar: UIProgressView!
    // Download Title
    @IBOutlet var downloadTitle: UILabel!
    // Download Percentage
    @IBOutlet var downloadPercentage: UILabel!
    // Download Type
    @IBOutlet var downloadType: UILabel!
    // Download Image
    @IBOutlet var downloadImage: UIImageView!
    // Stop And Start Download
    @IBOutlet var stopAndStartDownload: UIButton!
    // Stop And Start Download
    @IBOutlet var deleteButton: UIButton!
    /// Initialization code
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setDarkModeNeeds()
    }
    /// To set default things for the dark mode
    func setDarkModeNeeds() {
        downloadImage.superview?.backgroundColor = UIColor.navigationColor()
        downloadTitle.textColor = UIColor.invertColor(true)
        downloadType.textColor = UIColor.invertColor(true)
        downloadPercentage.textColor = UIColor.invertColor(true)
        deleteButton.tintColor = UIColor.iconColor()
    }
    // Download Status indicator
    func changeDownloadProgress(download: CSDownload) {
        downloadPercentage.text = String(format: "%.2f", (download.progress * 100)) + "%"
        progressBar.progress = download.progress
        downloadType.text = download.downloadedFile + "/" + download.file
        progressBar.progress = download.progress
    }
    /// Configure of Download is Pause or resume
    func configure(track: CSTrack, download: CSDownload?) {
        progressBar.progress = 0.0
        if let download = download {
            let title = download.isDownloading ?
                NSLocalizedString("Pause", comment: "Download") : NSLocalizedString("Resume", comment: "Download")
            stopAndStartDownload.setTitle(title, for: .normal)
            downloadType.text = download.downloadedFile + "/" + download.file
            downloadPercentage.text = String(format: "%.2f", (download.progress * 100)) + "%"
            progressBar.progress = download.progress
        }
        downloadTitle.text = track.downloadData.title
        let dataDecoded: Data = Data(base64Encoded: track.downloadData.thumbNail,
                                     options: .ignoreUnknownCharacters)!
        let decodedimage = UIImage(data: dataDecoded)
        downloadImage.image = decodedimage
        downloadImage.contentMode = .scaleAspectFill
        downloadImage.layer.masksToBounds = true
    }
    /// Configure of Download is Pause or resume
    func changeDownloadStatus(downloaded: Bool ) {
            let title = downloaded ?
                NSLocalizedString("Pause", comment: "Download") : NSLocalizedString("Resume", comment: "Download")
            stopAndStartDownload.setTitle(title, for: .normal)
    }
}
