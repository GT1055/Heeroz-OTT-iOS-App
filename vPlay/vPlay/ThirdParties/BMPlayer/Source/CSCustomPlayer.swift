//
//  CSCustomPlayer.swift
//  vPlay
//
//  Created by user on 22/11/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import AVKit
import DropDown
import GoogleCast
class CSCustomPlayer: BMPlayerControlView {
    /// Play Back rate Button
    var playbackRateButton = UIButton(type: .custom)
    /// Set Play Back default Rate
    var playRate: Float = 1.0
    /// check player is playing
    var isplayerPlaying = false
    /// Check player state
    var playerLatestState: BMPlayerState!
    /// Player Rate set
    var rateArray = [0.5, 1.0, 1.25, 1.5, 2.0]
    /// Default Selected Rate
    var selectedRateIndex = 1
    /// Drop Down Declareing
    let rateDropDown = DropDown()
    /// player Definions
    var playerDefinion: String! = "Auto"
    /// Player Speed
    var playerSpeed: String = "Normal"
    /// Drop Down Declareing
    var listDropdown = DropDown()
    /// Play back definion
    var playbackDefinitionButton = UIButton(type: .custom)
    /// Play back Full Screen
    var playbackFullScreen = UIButton(type: .custom)
    /// Resolution Index
    var previousResoutionIndex = 0
    /// rotate button declaring
    var rotateButton = UIButton(type: .custom)
    /// Play Back rate Button
    var showOptionsButton = UIButton(type: .custom)
    ///  Override if need to customize UI components
    override func customizeUIComponents() {
        mainMaskView.backgroundColor   = UIColor.black.withAlphaComponent(0.4)
        mainMaskView.addGestureRecognizer(tapGesture)
        topMaskView.backgroundColor    = UIColor.black.withAlphaComponent(0.4)
        bottomMaskView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        timeSlider.setThumbImage(UIImage(named: "custom_slider_thumb"), for: .normal)
        chooseDefitionView.removeFromSuperview()
        topMaskView.addSubview(showOptionsButton)
        // castButton.isHidden = true
        queueButton.isHidden = true
        isOfflinePlayer = true
        showOptionsButton.tintColor = UIColor.convertHexStringToColor("D5D8D8")
        showOptionsButton.setImage(#imageLiteral(resourceName: "Settings"), for: .normal)
        showOptionsButton.addTarget(self, action: #selector(onShowOptionPressed), for: .touchUpInside)
        showOptionsButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(topMaskView.snp.trailing).offset(-20)
            make.centerY.equalTo(titleLabel)
            make.width.equalTo(42)
            make.height.equalTo(42)
        }
    }
    /// Update UI
    override func updateUI(_ isForFullScreen: Bool) {
        super.updateUI(isForFullScreen)
        titleLabel.isHidden = !isForFullScreen
        xrayButton.isHidden = true
        if UIScreen.main.nativeBounds.height == 2436 ||
            UIScreen.main.nativeBounds.height == 2688 ||
            UIScreen.main.nativeBounds.height == 1624 {
            self.showOptionsButton.snp.remakeConstraints {
                let space = UIDevice.current.orientation.isLandscape ? -150 : -20
                $0.trailing.equalTo(self.topMaskView.snp.trailing).offset(space)
                $0.centerY.equalTo(self.titleLabel)
                $0.width.equalTo(42)
                $0.height.equalTo(42)
            }
        }
        setHideBackButtonViewForLive(isForFullScreen)
        self.layoutIfNeeded()
    }
    /// Animation for player
    override func controlViewAnimation(isShow: Bool) {
        self.isMaskShowing = isShow
        UIView.animate(withDuration: 0.24, animations: {
            if self.replayButton.isHidden {
                self.customPlayButton.isHidden = !isShow
            } else {
                self.customPlayButton.isHidden = true
            }
            self.topMaskView.snp.remakeConstraints {
                $0.top.equalTo(self.mainMaskView).offset(isShow ? 0 : -50)
                $0.left.right.equalTo(self.mainMaskView)
                $0.height.equalTo(50)
            }
            self.bottomMaskView.snp.remakeConstraints {
                $0.bottom.equalTo(self.mainMaskView).offset(isShow ? 0 : 50)
                $0.left.right.equalTo(self.mainMaskView)
                $0.height.equalTo(50)
            }
            self.layoutIfNeeded()
        }, completion: { _ in
            self.autoFadeOutControlViewWithAnimation()
        })
    }
    override func playerStateDidChange(state: BMPlayerState) {
        super.playerStateDidChange(state: state)
        if state == .playedToTheEnd {
            playButton.isUserInteractionEnabled = false
        } else if state == .buffering {
            playButton.isUserInteractionEnabled = GCKCastContext.sharedInstance().sessionManager.hasConnectedCastSession()
        } else if state == .bufferFinished {
            playButton.isUserInteractionEnabled = true
        }
        self.changeIcon()
    }
    func setHideBackButtonViewForLive(_ isFullscreen: Bool) {
        backButtonWidthConstant = 35
        backButtonView.snp.removeConstraints()
        backButtonView.snp.remakeConstraints { (make) in
            make.width.height.equalTo(backButtonWidthConstant)
            make.centerY.equalTo(topMaskView)
            make.leading.equalTo(10)
        }
    }
    override func onTapGestureTapped(_ gesture: UITapGestureRecognizer) {
        controlViewAnimation(isShow: !isMaskShowing)
    }
    /// Set Up speed of play
    func changeIcon() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: {
            if self.player!.isPlaying {
                self.delegate?.controlView?(controlView: self, didChangeVideoPlaybackRate: self.playRate)
            }
        })
    }
    override func playStateDidChange(isPlaying: Bool) {
        super.playStateDidChange(isPlaying: isPlaying)
        isplayerPlaying = isPlaying
        if (self.player?.isPlaying)! {
            self.replayButton.isHidden = true
        }
        changeIcon()
    }
    @objc func playPauseButtonAction() {
        if (self.player?.isPlaying)! {
            self.player?.pause()
        } else {
            self.player?.play()
        }
    }
    @objc func onShowOptionPressed() {
        autoFadeOutControlViewWithAnimation()
        let speedString = NSLocalizedString("Speed", comment: "Speed")
        listDropdown.dataSource = ["\(speedString): \(playerSpeed)"]
        listDropdown.anchorView =  self.showOptionsButton
        listDropdown.direction = .any
        listDropdown.width = 120
        listDropdown.cellHeight  = 35
        listDropdown.cellNib = UINib(nibName: "CSCustomPlayerOption", bundle: nil)
        listDropdown.customCellConfiguration = { index, item, cell -> Void in
            guard let cell = cell as? CSCustomPlayerOption else { return }
            cell.displayLabel.text = item
        }
        listDropdown.show()
        // Action triggered on selection
        listDropdown.selectionAction = { [unowned self] (index, item) in
            self.onPlaybackRateButtonPressed()
        }
    }
    @objc func onPlaybackRateButtonPressed() {
        autoFadeOutControlViewWithAnimation()
        rateDropDown.dataSource = ["0.5x", "Normal", "1.25x", "1.5x", "2.0x"]
        rateDropDown.anchorView =  self.showOptionsButton
        rateDropDown.direction = .any
        rateDropDown.width = 75
        rateDropDown.cellHeight  = 35
        rateDropDown.show()
        rateDropDown.selectRow(at: selectedRateIndex)
        // Action triggered on selection
        rateDropDown.selectionAction = { [unowned self] (index, item) in
            self.playRate = Float(self.rateArray[index])
            self.playerSpeed = item
            self.playbackRateButton.setTitle(" \(self.playRate)  ", for: .normal)
            self.selectedRateIndex = index
            self.rateDropDown.selectRow(at: self.selectedRateIndex)
            self.changeIcon()
            self.rateDropDown.hide()
        }
    }
}
