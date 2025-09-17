/*
 * CSPlaylistTableCell.swift
 * This class is used bind data in playlist
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit

class CSPlaylistTableCell: UITableViewCell {
    /// playlist name text
    @IBOutlet var nameText: UILabel!
    /// playlist image View
    @IBOutlet var imageData: UIImageView!
    /// Bind Data
    func bindData(_ data: CSPlayList) {
        nameText.text = data.playListName
        checkIsExist(data.isExist)
    }
    /// Check Is Exit
    func checkIsExist(_ isExist: Int) {
        if isExist == 1 {
            imageData.image = #imageLiteral(resourceName: "Chech-Box-Select")
        } else {
            imageData.image = #imageLiteral(resourceName: "Chech-Box")
        }
    }
}
