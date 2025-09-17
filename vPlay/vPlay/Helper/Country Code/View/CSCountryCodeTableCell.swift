/*
 * CSCountryCodeTableCell.swift
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit

class CSCountryCodeTableCell: UITableViewCell {
    /// Country Name
    @IBOutlet var countryName: UILabel!
    /// Country Code
    @IBOutlet var countryCode: UILabel!
    /// Country Image
    @IBOutlet var countryImage: UIImageView!
    /// Country Code
    func bindDataCountryCode(_ country: CSCountryList) {
        countryName.text = country.countryName + " " + country.countryCode
        countryCode.text = country.countryDialCode
        self.countryImage.image = UIImage.init(named: country.countryCode + ".png")
    }
    /// To change the ui needs in dark mode
    func changeViewByDarkMode() {
        countryName.textColor = UIColor.invertColor(true)
        countryCode.textColor = UIColor.invertColor(true)
        self.backgroundColor = (LibraryAPI.sharedInstance.isDarkMode()) ? UIColor.backgroundColor() : UIColor.white
    }
}
