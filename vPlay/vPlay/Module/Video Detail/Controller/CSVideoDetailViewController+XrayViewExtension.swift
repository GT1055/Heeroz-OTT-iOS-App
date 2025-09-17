//
//  CSVideoDetailViewController+XrayViewExtension.swift
//  vPlay
//
//  Created by user on 25/06/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
extension CSVideoDetailViewController {
    /// setup of xray tableview
    func setupXrayTableView() {
        playerView.addSubview(xrayTableView)
        xrayTapgesture = UITapGestureRecognizer(target: self, action: #selector(myviewTapped(_:)))
        xrayTapgesture.delegate = self
        xrayTableView.addGestureRecognizer(xrayTapgesture)
        xrayTableView.translatesAutoresizingMaskIntoConstraints = false
        xrayTableView.backgroundColor = UIColor.clear
        xrayTableView.delegate = self
        xrayTableView.alpha = 0
        xrayTableView.indicatorStyle = .white
        xrayTableView.separatorStyle = .none
        xrayTableView.dataSource = self
        xrayTableView.register(UINib.init(nibName: "XrayTableViewCell", bundle: nil), forCellReuseIdentifier: XrayTableViewCell.identifier)
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(setupXrayTableLayout), userInfo: nil, repeats: true)
        setupXrayTableLayout()
        xrayTableView.reloadData()
    }
    @objc func myviewTapped(_ sender: UITapGestureRecognizer) {
        if let playerViewable = (playerView.customControlView as? BMPlayerCustomControlView) {
            playerViewable.controlViewAnimation(isShow: true)
        }
    }
    /// Updating the xraytableview layout to sync with mask views
    @objc func setupXrayTableLayout() {
        xrayTableView.snp.removeConstraints()
        let isMaskShowing = playerView.customControlView?.isMaskShowing ?? false
            xrayTableView.snp.makeConstraints { (view) in
                view.trailing.equalTo(playerView.snp.trailing)
                view.top.equalTo(playerView.snp.top).offset(isMaskShowing ? 50 : 0)
                view.bottom.equalTo(playerView.snp.bottom).offset(isMaskShowing ? -50 : 0)
                view.width.equalTo(playerView.snp.width).multipliedBy(0.65)
            }
        UIView.animate(withDuration: 0.2) { self.view.layoutIfNeeded() }
    }

    /// Method to show xray tableview
    func showXrayView() {
        UIView.animate(withDuration: 0.4) { self.xrayTableView.alpha = 1 }
    }
    /// Method to hide xray tableview
    func dismissXrayView() {
        UIView.animate(withDuration: 0.4) { self.xrayTableView.alpha = 0 }
    }
}
//MARK: Tableview delegate and datasource
extension CSVideoDetailViewController: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.xrayCastInfos.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: XrayTableViewCell.identifier) as! XrayTableViewCell
        cell.configiureCell(with: self.xrayCastInfos[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let param = ["row": indexPath.row]
        self.performSegue(withIdentifier: "xrayDetail", sender: param)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
extension CSVideoDetailViewController {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view! .isKind(of: UITableView.self) {
            return true
        } else {
            return false
        }
    }
}
