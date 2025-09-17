//
//  CSVideoDetailViewController+TrackApiExtension.swift
//  vPlay
//
//  Created by user on 18/07/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
extension CSVideoDetailViewController {
    func fetchVideoCount(_ getPercentage: Int) {
        let parameter: [String: Any] = [
            "transaction_id": transactionId as String,
            "complete_percentage": getPercentage]
         CSVideoDetailApiModel.viewCountApi(parentView: self, parameters: parameter) { response in
            if response.responseRequired != nil {
            if response.responseRequired.statusMessage == "Expired" {
                self.isExpired = true
                } }
        }
    }
    @objc func handleTapSeason(_ sender: UITapGestureRecognizer? = nil) {
        if seasonDropDownList.count < 2 { return }
        CSOptionDropDown.seasonDropdown(
            label: showSeasonLabel,
            dataSource: seasonDropDownList,
            completionHandler: { index in
                self.relatedCurrentPage = 0; self.relatedLastPage = 0
                self.relatedVideo = [CSMovieData]()
                self.showSeasonView.tag = self.seasonList[index].seasonId
                self.webSeries()
        })
    }
    func setUpGestures() {
        seasonListTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapSeason(_:)))
        showSeasonView.addGestureRecognizer(seasonListTap)
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchHandler))
        self.playerView.addGestureRecognizer(self.pinchGesture)
        pinchGesture.isEnabled = false
    }
}
