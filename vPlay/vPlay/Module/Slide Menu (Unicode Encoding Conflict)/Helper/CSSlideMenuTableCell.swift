/*
 * CSSiledMenuTableCell.swift
 * This class used to create the Account information data to bind Data
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit

class CSSlideMenuTableCell: UITableViewCell {
    // An outlet to display the Name
    @IBOutlet var menuTitle: UILabel!
    // An outlet to display the Notification Image
    @IBOutlet var menuImage: UIImageView!
    // outlet of the line between menus
    @IBOutlet weak var lineView: UIView!
    /// LIFE CYCLE METHODS
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    /// To set color based on dark mode
    func setModeBaseColor() {
        lineView.backgroundColor = .separatorColor
        menuTitle.textColor = .menuListIcon
        menuImage.tintColor = .menuListTitle
    }
}
