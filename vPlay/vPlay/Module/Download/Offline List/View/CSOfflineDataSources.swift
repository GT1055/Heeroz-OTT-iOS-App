//
//  CSOfflineDataSources.swift
//  vPlay
//
//  Created by user on 19/11/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import SkeletonView
import GoogleCast
class CSOfflineDataSources: NSObject, UITableViewDataSource, UITableViewDelegate {
    /// assert Data
    var assertList = [AssertDetails]()
    /// Table Delgate
    weak var delegate: CSTableViewDelegate?
    /// MARK:- Table view Delegate functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assertList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 90
        } else {
            return 80
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "offlineCell", for: indexPath)
            as? VSOfflienTableViewCell else { return UITableViewCell() }
        if GCKCastContext.sharedInstance().sessionManager.hasConnectedSession() && UserDefaults.standard.string(forKey: "Queue") == "Queue List" {
            let castContext = GCKCastContext.sharedInstance().sessionManager.currentSession?.remoteMediaClient
            let item: GCKMediaQueueItem? = castContext?.mediaStatus?.queueItem(at: UInt(indexPath.row))
            let title: String? = item?.mediaInformation.metadata?.string(forKey: kGCKMetadataKeyTitle)
            var artist: String? = item?.mediaInformation.metadata?.string(forKey: kGCKMetadataKeyArtist)
            if artist == nil {
                artist = item?.mediaInformation.metadata?.string(forKey: kGCKMetadataKeyStudio)
            }
            DispatchQueue.main.async {
                cell.videoTitle.text = title
                cell.deleteButton.tag = indexPath.row
                if let images = item?.mediaInformation.metadata?.images(), images.count > 0 {
                    let image = images[0] as? GCKImage
                    GCKCastContext.sharedInstance().imageCache?.fetchImage(for:
                        (image?.url)!, completion: { (_ image: UIImage?) -> Void in
                            cell.videoDetailImage.image = image
                            cell.videoDetailImage.contentMode = .scaleAspectFit
                    })
                }
            }
        } else {
            cell.bindDataToAssert(assertList[indexPath.row])
            cell.deleteButton.tag = indexPath.row }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.tableviewDelegate(tableView, didSelectRowAt: indexPath)
    }
}
