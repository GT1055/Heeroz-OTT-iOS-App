//
//  CSWebseriesTableviewCell.swift
//  vPlay
//
//  Created by user on 07/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import UIKit
protocol pushToViewDelegate {
    func clickImageView(_ cell: AnyObject)
}
class CSWebseriesTableviewCell: UITableViewCell {
    @IBOutlet var posterImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var topDescription: UILabel!
    @IBOutlet var backView: UIView!
    @IBOutlet var subView: UIView!
    @IBOutlet var customView: UIView!
    @IBOutlet var dynamicTextLabel: [UILabel]?
    var customDelegate: pushToViewDelegate!
    /// Parameter
    var parmeter = [String: String]()
    /// Option Button
    @IBOutlet var openOptionButton: UIButton!
    /// Initialization code
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.backgroundColor = .navigationBarColor
        self.backView.backgroundColor = .navigationBarColor
        self.subView.backgroundColor = .navigationBarColor
        dynamicTextLabel?.forEach({$0.textColor = .labelTextColor})
    }
    func configiureCell(with data: CSMovieData) {
        titleLabel.text = data.title
        subTitleLabel.text = data.title
        descriptionLabel.text = data.description
        topDescription.text = data.description
        posterImage.setImageWithUrl(data.posterImage)
        self.posterImage.contentMode = .scaleAspectFill
        self.parmeter = [
            "videoSlug": data.slug,
            "videoId": String(data.movieId),
            "videoImage": data.posterImage,
            "videoTitle": data.title,
            "videoDescription": data.description]
    }
    func bindCellData(_ data: WebSeriesData) {
        self.titleLabel.text = data.title
        self.subTitleLabel.text = data.title
        self.descriptionLabel.text = data.description
        self.topDescription.text = data.description
        self.posterImage.setImageWithUrl(data.posterImage)
        self.posterImage.contentMode = .scaleAspectFill
        self.parmeter = [
            "videoSlug": data.slug,
            "videoId": String(data.id),
            "videoImage": data.thumbnail,
            "videoTitle": data.title,
            "videoDescription": data.description]
    }
    @IBAction func clickImageAction(_ sender: AnyObject) {
        customDelegate.clickImageView(self)
    }
    /// Open Option Button
    @IBAction func openOptionButton(_ sender: UIButton) {
        CSOptionDropDown.dropDownMenu(popUpButton: openOptionButton,
                                      controller: LibraryAPI.sharedInstance.currentController,
                                      parametr: self.parmeter)
    }
}
