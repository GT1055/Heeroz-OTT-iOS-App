//
//  CSDownloadListDataSources.swift
//  LearningSpaces
//
//  Created by user on 26/06/18.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation
import UIKit
class DownloadListDataSources: NSObject, UITableViewDataSource, UITableViewDelegate {
    weak var delegate: CSTableViewDelegate?
    /// MARK:- Table view Delegate functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CSDownloadManager.shared.activeTracks.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 90
        } else {
            return 80
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            as? CSDownloadingTableCell else { return UITableViewCell() }
        let track = CSDownloadManager.shared.activeTracks[indexPath.row]
        cell.stopAndStartDownload.tag = indexPath.row
        cell.deleteButton.tag = indexPath.row
        cell.configure(track: track,
                       download: CSDownloadManager.shared.activeDownloads[track.previewURL])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       delegate?.tableviewDelegate(tableView, didSelectRowAt: indexPath)
    }
}
