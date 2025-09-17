//
//  CSVideoDetailViewController+LiveChatViewExtension.swift
//  vPlay
//
//  Created by user on 23/08/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import UIKit
import SnapKit


extension CSVideoDetailViewController {
    
    func setupLiveChatView() {
        self.liveChatTapGesture = UITapGestureRecognizer(target: self, action: #selector(myviewTapped(_:)))
        liveChatTapGesture.delegate = self
        liveChatView.addGestureRecognizer(liveChatTapGesture)
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(setupLiveChatLayout), userInfo: nil, repeats: true)
        setupLiveChatLayout()
    }
    @objc func setupLiveChatLayout() {
        let isMaskShowing = playerView.customControlView?.isMaskShowing ?? false
        liveChatViewTop.constant = isMaskShowing ? 50 : 0
        liveChatViewBottom.constant = isMaskShowing ? -50 : 0
        UIView.animate(withDuration: 0.2) { self.view.layoutIfNeeded() }
    }
    /// Method to show xray tableview
    func showLiveChatView() {
        UIView.animate(withDuration: 0.4) { self.liveChatView.alpha = 1 }
    }
    /// Method to hide xray tableview
    func dismissLiveChatView() {
        UIView.animate(withDuration: 0.4) { self.liveChatView.alpha = 0 }
    }
}
