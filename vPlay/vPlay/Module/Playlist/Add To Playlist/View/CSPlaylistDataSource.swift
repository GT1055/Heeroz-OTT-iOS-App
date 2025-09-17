/*
 * CSPlaylistDataSource.swift
 * This class is used act as a data source for playlist in table view
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit

class CSAddPlaylistDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    /// Playlist
    var playList = [CSPlayList]()
    /// Delegate
    weak var delegate: CSTableViewDelegate?
    /// MARK:- Table view Delegate functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            as? CSPlaylistTableCell else { return UITableViewCell() }
        cell.bindData(playList[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.tableviewDelegate(tableView, didSelectRowAt: indexPath)
    }
}
