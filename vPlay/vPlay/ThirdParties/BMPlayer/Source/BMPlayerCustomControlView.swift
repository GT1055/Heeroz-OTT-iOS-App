//
//  BMPlayerCustomControlView.swift
//  BMPlayer
//
//  Created by BrikerMan on 2017/4/4.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//
import UIKit
import AVKit
import DropDown
import GoogleCast
//import GoogleInteractiveMediaAds
@objc protocol ControlViewDelegate: class {
    func didTapqueue()
    func didtapXray(_ sender: UIButton)
    func didtapXrayViewAll(_ sender: UIButton)
    @objc optional func didtapChatbutton(_ sender: UIButton)
    @objc optional func closeChatview()
}
class BMPlayerCustomControlView: BMPlayerControlView {
    //Queue Action delegate
    weak var customDelegate: ControlViewDelegate!
    fileprivate var urlAsset: AVURLAsset?
    /// Play Back rate Button
    var playbackRateButton = UIButton(type: .custom)
    /// Cue Point
    var cuePoint: [Any]?
    /// Set Play Back default Rate
    var playRate: Float = 1.0
    /// check player is playing
    var isplayerPlaying = false
    /// Check player state
    var playerLatestState: BMPlayerState!
    /// Player Rate set
    var rateArray = [0.5, 1.0, 1.25, 1.5, 2.0]
    /// Sub Titles Object
    var currentSubTitles: CSSubTitle?
    /// audio resources
    var audioOptions: [VSAudioModel]?
    var audioSelectedIndex = 0
    /// Default Selected Rate
    var selectedRateIndex = 1
    /// Default Selected Sub
    var selectedSubIndex = 0
    /// Rate Drop down declaration
    let rateDropDown = DropDown()
    /// Auto Drop down declaration
    let autoDropDown = DropDown()
    /// Subtitle Drop down declaration
    let subTitleDown = DropDown()
    /// Audio dropdown
    let audioDropdown = DropDown()
    /// player Definions
    var playerDefinion = NSLocalizedString("Auto", comment: "Auto")
    /// selected subtitles
    var selectedSub: String! = NSLocalizedString("Off", comment: "Off")
    /// Drop Down declaration
    var listDropdown = DropDown()
    /// Play back definion
    var playbackDefinitionButton = UIButton(type: .custom)
    /// Live Label
    var liveLabel = UILabel()
    /// Play back Full Screen
    var playbackFullScreen = UIButton(type: .custom)
    /// Resolution Index
    var previousResoutionIndex = 0
    /// rotate button declaration
    var rotateButton = UIButton(type: .custom)
    /// rotate count
    var rotateCount: CGFloat = 0
    /// Is Live Video
    var isLive = false
    /// Is Live View Controller
    var isLiveController = false
    /// Play Back rate Button
    var showOptionsButton = UIButton(type: .custom)
    ///  Override if need to customize UI components
    //session manager
    var sessionManager: GCKSessionManager!
    override func customizeUIComponents() {
        queueButton.addTarget(self, action: #selector(queueButtonPressed(_:)), for: .touchUpInside)
        xrayButton.addTarget(self, action: #selector(xRayButtonPressed(_:)), for: .touchUpInside)
        chatButton.addTarget(self, action: #selector(onChatButtonPressed(_:)), for: .touchUpInside)
        self.sessionManager = GCKCastContext.sharedInstance().sessionManager
        self.sessionManager.add(self)
        if self.sessionManager.hasConnectedCastSession() == false {
            queueButton.isHidden = true
        }
        chatButton.isHidden = true
        mainMaskView.backgroundColor   = UIColor.black.withAlphaComponent(0.4)
        mainMaskView.addGestureRecognizer(tapGesture)
        topMaskView.backgroundColor    = UIColor.black.withAlphaComponent(0.4)
        bottomMaskView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        timeSlider.setThumbImage(UIImage(named: "custom_slider_thumb"), for: .normal)
        chooseDefitionView.removeFromSuperview()
        topMaskView.addSubview(backButtonView)
        topMaskView.addSubview(showOptionsButton)
        bottomMaskView.addSubview(liveLabel)
        liveLabel.textColor  = UIColor.white
        liveLabel.font       = UIFont.systemFont(ofSize: 12)
        liveLabel.attributedText = setLiveForLabel()
        liveLabel.textAlignment = NSTextAlignment.center
        //audioButton.setImage(UIImage.init(named: "multiple-audio"), for: .normal)
        //audioButton.addTarget(self, action: #selector(audioSelection(_:)), for: .touchUpInside)
        showOptionsButton.setImage(#imageLiteral(resourceName: "Settings"), for: .normal)
        showOptionsButton.tintColor = UIColor.convertHexStringToColor("D5D8D8")
        showOptionsButton.addTarget(self, action: #selector(onShowOptionPressed), for: .touchUpInside)
        showOptionsButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(topMaskView.snp.trailing).offset(-20)
            make.centerY.equalTo(titleLabel)
            make.width.equalTo(42)
            make.height.equalTo(42)
        }
        liveLabel.snp.makeConstraints { (make) in
            make.left.equalTo(playButton.snp.right)
            make.centerY.equalTo(playButton)
        }
        setHideViewForLive()
    }
    func setHideViewForLive() {
        if isLive {
            titleLabel.isHidden = false
            xrayButton.isHidden = true
        }
        //chatButton.isHidden = isLive ? false : true
        //backButtonWidthConstant = isLive ? 0 : 35
        self.setHideBackButtonViewForLive(backButtonWidthConstant)
        progressView.isHidden = isLive; timeSlider.isHidden = isLive
        showOptionsButton.isHidden = false; currentTimeLabel.isHidden = isLive
        liveLabel.isHidden = !isLive; totalTimeLabel.isHidden = isLive
    }
    func setHideBackButtonViewForLive(_ constant: Int) {
        if isLiveController && !isFullscreen {
            backButtonWidthConstant = 0
        } else if isLiveController && isFullscreen {
            backButtonWidthConstant = 35
        } else if !isLiveController && !isFullscreen {
            backButtonWidthConstant = 35
        }
        backButtonView.snp.removeConstraints()
        backButtonView.snp.remakeConstraints { (make) in
            make.width.height.equalTo(backButtonWidthConstant)
            make.centerY.equalTo(topMaskView)
            make.leading.equalTo(10)
        }
    }
    func setLiveForLabel() -> NSAttributedString {
        let font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        let partOne = NSMutableAttributedString(
            string: "\u{2022}", attributes: [NSAttributedString.Key.font: font,
                                             NSAttributedString.Key.foregroundColor: UIColor.red])
        let partTwo = NSMutableAttributedString(
            string: " Live", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
                                          NSAttributedString.Key.foregroundColor: UIColor.white])
        let attrib = NSMutableAttributedString(); attrib.append(partOne); attrib.append(partTwo)
        return attrib
    }
    @objc fileprivate func queueButtonPressed(_ button: UIButton) {
        customDelegate.didTapqueue()
    }
    @objc fileprivate func xRayButtonPressed(_ button: UIButton) {
        customDelegate.didtapXray(button)
    }
    @objc fileprivate func onChatButtonPressed(_ button: UIButton) {
        customDelegate.didtapChatbutton?(button)
    }
    /// Update UI
    override func updateUI(_ isForFullScreen: Bool) {
        if checkAndCloseUI(isForFullScreen) { return }
        super.updateUI(isForFullScreen)
        titleLabel.isHidden = !isForFullScreen
        setHideViewForLive()
        //        if isForFullScreen {
        //            backButtonView.snp.remakeConstraints { (make) in
        //                make.width.height.equalTo(0)
        //                make.centerY.equalTo(topMaskView)
        //                make.leading.equalTo(10)
        //            }
        //        } else {
        //            backButtonView.snp.remakeConstraints { (make) in
        //                make.width.height.equalTo(backButtonWidthConstant)
        //                make.centerY.equalTo(topMaskView)
        //                make.leading.equalTo(10)
        //            }
        //        }
        if UIScreen.main.nativeBounds.height == 2436 ||
            UIScreen.main.nativeBounds.height == 2688 ||
            UIScreen.main.nativeBounds.height == 1624 {
//            self.castButton.snp.remakeConstraints {
//                $0.trailing.equalTo(self.showOptionsButton.snp.leading).offset(4)
//                $0.centerY.equalTo(self.titleLabel)
//                $0.width.equalTo(42)
//                $0.height.equalTo(42)
//            }
            self.showOptionsButton.snp.remakeConstraints {
                let space = UIDevice.current.orientation.isLandscape ? -170 : -20
                $0.trailing.equalTo(self.topMaskView.snp.trailing).offset(space)
                $0.centerY.equalTo(self.titleLabel)
                $0.width.equalTo(42)
                $0.height.equalTo(42)
            }
        }
        self.bottomMaskView.isHidden = GCKCastContext.sharedInstance().sessionManager.hasConnectedCastSession()
        self.showOptionsButton.isUserInteractionEnabled = GCKCastContext.sharedInstance().sessionManager.hasConnectedCastSession() ? false : true
        self.layoutIfNeeded()
    }
    func checkAndCloseUI(_ isForFullScreen: Bool) -> Bool {
        if isForFullScreen {
            customDelegate.closeChatview?()
            return true
        } else {
            return false
        }
    }
    /// Animation for player
    override func controlViewAnimation(isShow: Bool) {
        self.isMaskShowing = isShow
        self.swipeLeftview.isHidden = isMaskShowing ? false : true
        self.swipeRightview.isHidden = isMaskShowing ? false : true
        showHideStatus()
        self.bottomMaskView.isHidden = GCKCastContext.sharedInstance().sessionManager.hasConnectedCastSession()
        self.showOptionsButton.isUserInteractionEnabled = GCKCastContext.sharedInstance().sessionManager.hasConnectedCastSession() ? false : true
//        playerDefinion = NSLocalizedString("Auto", comment: "Auto")
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
            self.rateDropDown.hide()
            self.autoDropDown.hide()
            self.subTitleDown.hide()
            self.listDropdown.hide()
            self.audioDropdown.hide()
            self.autoFadeOutControlViewWithAnimation()
        })
    }
    // Show and hide buttons
    func showHideStatus() {
        if let playerCurrentTime = player?.playerLayer?.player?.currentTime().seconds {
            if playerCurrentTime < 9 {
                self.swipeLeftview.isHidden = true
            }
        }
        if let duration = player?.avPlayer?.currentItem?.asset.duration.seconds
        {
            if let playerCurrentTime = player?.playerLayer?.player?.currentTime().seconds {
                if (duration - playerCurrentTime) < 9 {
                    self.swipeRightview.isHidden = true
                } }
        }
    }
    /// Ads Cue Point
    func addCuePointView() {
        guard let duration = player?.avPlayer?.currentItem?.asset.duration.seconds else { return }
        self.timeSlider.removeCuePoint()
        self.progressView.removeCuePoint()
        for cue in (cuePoint ?? [Any]()) {
            if let data: Double = cue as? Double {
                if data != -1 {
                    let percentage = CGFloat(data / duration)
                    if !percentage.isNaN {
                    self.timeSlider.addCuePointSubview(percentage)
                    self.progressView.addCuePointSubview(percentage) }
                } else {
                    let percentage = CGFloat(totalDuration / duration)
                    self.timeSlider.addCuePointSubview(percentage)
                    self.progressView.addCuePointSubview(percentage)
                }
            }
        }
    }
    /// Remove Ads Cue Point
    func removeCuePoint() {
        self.timeSlider.removeCuePoint()
        self.progressView.removeCuePoint()
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
    override func onTapGestureTapped(_ gesture: UITapGestureRecognizer) {
        controlViewAnimation(isShow: !isMaskShowing)
        if isLive {
            self.swipeRightview.isHidden = true
            self.swipeLeftview.isHidden = true
        }
    }
    /// Set Up speed of play
    func changeIcon() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
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
    func setQueueButtonVisible(_ visible: Bool) {
        if visible {
            queueButton.isHidden = false
        } else {
            queueButton.isHidden = true
        }
    }
}
extension BMPlayerCustomControlView {
    @objc func onShowOptionPressed() {
        autoFadeOutControlViewWithAnimation()
        let someValue = self.player?.avPlayer?.currentItem?.presentationSize
        let layerHeight = someValue?.height ?? 0; let calQualtiy = Int(layerHeight)
        let auto = NSLocalizedString("Auto", comment: "auto")
        let speed = NSLocalizedString("Speed", comment: "Speed")
        let normal = NSLocalizedString("Normal", comment: "Speed")
        let sub = NSLocalizedString("Subtitles", comment: "Speed"); var quality = String()
        if (playerDefinion == auto) {
            quality = (calQualtiy == 0) ? "\(auto)" : " \(auto) \(calQualtiy)p"
        } else {
            quality = "\(auto)" + " \(NSLocalizedString(playerDefinion, comment: "auto"))"
        }
        quality = NSLocalizedString("Quality", comment: "auto") + ": " + quality
        var dataSource = [String]()
        let rateString = (playRate == 1.0) ? "\(speed): \(normal)" : "\(speed): " + String(playRate)
        if let current = currentSubTitles, current.subList.count > 0 {
            let subString = ("\(sub): " + selectedSub)
            dataSource = [rateString, quality, subString]
        } else { dataSource = [rateString, quality] }
        if isLive { dataSource.remove(at: 0) }
        listDropdown.dataSource = dataSource; listDropdown.direction = .any
        listDropdown.anchorView =  self.showOptionsButton; listDropdown.cellHeight  = 35
        listDropdown.cellNib = UINib(nibName: "CSCustomPlayerOption", bundle: nil)
        listDropdown.customCellConfiguration = { index, item, cell -> Void in
            guard let cell = cell as? CSCustomPlayerOption else { return }
            cell.displayLabel.text = item
            if let data = cell.displayLabel.text, data.contains(NSLocalizedString("Quality", comment: "auto")) {
                let displayString = NSMutableAttributedString(string: item)
                let normalAttribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
                let boldAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)]
                if displayString.length > 13 && item.contains(auto) {
                    displayString.setAttributes(normalAttribute, range: NSRange(location: 0, length: 13))
                    displayString.setAttributes(boldAttribute, range: NSRange(location: 14, length: displayString.length - 14))
                    cell.displayLabel.attributedText = displayString
                }
            }
        }; listDropdown.show()
        listDropdown.selectionAction = { [unowned self] (index, item) in
            if dataSource[index].contains(NSLocalizedString("Quality", comment: "auto")) {
                self.onPlayerDefitionButton()
            } else if dataSource[index].contains(NSLocalizedString("Speed", comment: "auto")) {
                self.onPlaybackRateButtonPressed() } else { self.onSubtitlesPresed() }
        }
    }
    @objc func onPlayerDefitionButton() {
        autoFadeOutControlViewWithAnimation()
        var resoutionArray = [String]()
        let reasolutionCount: Int = (resource?.definitions.count)!
        for resoultion in 0..<reasolutionCount {
            resoutionArray.append((resource?.definitions[resoultion].definition)!)
        }
        autoDropDown.dataSource = resoutionArray
        autoDropDown.anchorView = self.showOptionsButton; autoDropDown.direction = .any
        autoDropDown.width = 80; autoDropDown.cellHeight = 35; autoDropDown.show()
        autoDropDown.selectRow(at: previousResoutionIndex)
        // Action triggered on selection
        autoDropDown.selectionAction = { [unowned self] (index, item) in
            if LibraryAPI.sharedInstance.currentController is CSVideoDetailViewController {
                let controller = (LibraryAPI.sharedInstance.currentController as? CSVideoDetailViewController)!
                self.playerDefinion = String(resoutionArray[index])
                self.playbackDefinitionButton.setTitle(self.playerDefinion, for: .normal)
                self.delegate?.controlView(controlView: self, didChooseDefition: index,
                                           videoKey: controller.videoKey)
                if self.audioOptions?.count != 0 {
                    self.setPreferredAudio()
                }
                self.previousResoutionIndex = index
                self.autoDropDown.selectRow(at: self.previousResoutionIndex)
            }; self.autoDropDown.hide()
        }
    }
    @objc func onPlaybackRateButtonPressed() {
        autoFadeOutControlViewWithAnimation()
        rateDropDown.dataSource = ["0.5x", NSLocalizedString("Normal", comment: "Menu"),
                                   "1.25x", "1.5x", "2.0x"]
        rateDropDown.anchorView = self.showOptionsButton
        rateDropDown.direction = .any; rateDropDown.width = 75
        rateDropDown.cellHeight = 35; rateDropDown.show()
        rateDropDown.selectRow(at: selectedRateIndex)
        // Action triggered on selection
        rateDropDown.selectionAction = { [unowned self] (index, item) in
            self.playRate = Float(self.rateArray[index])
            self.playbackRateButton.setTitle("  rate \(self.playRate)  ", for: .normal)
            self.selectedRateIndex = index
            self.rateDropDown.selectRow(at: self.selectedRateIndex)
            self.changeIcon(); self.rateDropDown.hide()
        }
    }
    @objc func onSubtitlesPresed() {
        autoFadeOutControlViewWithAnimation()
        if let currentSub = currentSubTitles {
            if currentSub.subList.count > 0 {
                var listArray = ["Off"]
                for lists in currentSub.subList {
                    listArray.append(lists.language)
                }
                subTitleDown.dataSource = listArray
                subTitleDown.anchorView = self.showOptionsButton
                subTitleDown.direction = .any;
                subTitleDown.cellHeight = 35; subTitleDown.selectRow(selectedSubIndex)
                subTitleDown.show()
                subTitleDown.selectionAction = { [unowned self] (index, item) in
                    self.selectedSub = item; self.selectedSubIndex = index
                    self.setSelectedSubTitle(index); self.subTitleDown.hide()
                }
            }
        }
    }
    // Sender is the Setting Button
    @objc func audioSelection(_ sender: UIButton) {
        autoFadeOutControlViewWithAnimation()
        guard let options = self.audioOptions else { return }
        var audio = [String]()
        for option in options {
            audio.append(option.title)
        }
        audioDropdown.dataSource = audio
        audioDropdown.anchorView =  sender
        audioDropdown.bottomOffset = CGPoint(x: -40.0,y: (audioDropdown.anchorView?.plainView.bounds.height)! - 5)
        audioDropdown.direction = .any
        audioDropdown.cellNib = UINib(nibName: "AudioDropDown", bundle: nil)
        audioDropdown.dismissMode = .automatic
        audioDropdown.cellHeight = 35
        audioDropdown.show()
        audioDropdown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? AudioDropDownCell else { return }
            if let isSelected = self.audioOptions?[index].isSelected {
                cell.tickImageView.isHidden = !isSelected
            }
        }
        // Action triggered on selection
        audioDropdown.selectionAction = { [unowned self] (index, item) in
            self.audioDropdown.hide()
            if let mediaGroup = self.player?.avPlayer?.currentItem?.asset.mediaSelectionGroup(forMediaCharacteristic: .audible),
                let selectionOption = self.audioOptions?[index].audioOptions
            {
                self.audioOptions?.forEach({$0.isSelected = false})
                self.audioOptions?[index].isSelected = true
                self.audioSelectedIndex = index
                self.player?.avPlayer?.currentItem?.select(selectionOption, in: mediaGroup)
            }
        }
        audioDropdown.cancelAction = { [unowned self] in
            self.controlViewAnimation(isShow: false)
        }
    }
    func setPreferredAudio() {
        if let mediaGroup = self.player?.avPlayer?.currentItem?.asset.mediaSelectionGroup(forMediaCharacteristic: .audible),
            let selectionOption = self.audioOptions?[audioSelectedIndex].audioOptions {
            self.player?.avPlayer?.currentItem?.select(selectionOption, in: mediaGroup)
        }
    }
    /// To set subtitle to the current asset
    func setSelectedSubTitle(_ index: Int) {
        if player?.currentResource != nil {
            var sub: BMSubtitles?
            if index == 0 {  sub = nil
            } else {
                if let currentSub = currentSubTitles {
                    let selected = currentSub.subList[index - 1]
                    let fullURL = currentSub.baseURL + selected.listURL
                    sub = BMSubtitles.init(vttUrl:
                        URL.init(string: fullURL)!)
                }
            }; self.player?.currentResource?.subtitle = sub
            self.player?.forceReloadSubtile()
        }
    }
    /// fetch the audio from player asset
    public func fetchAudio(with assest: AVURLAsset) {
        if LibraryAPI.sharedInstance.currentController is CSVideoDetailViewController {
            let controller = (LibraryAPI.sharedInstance.currentController as? CSVideoDetailViewController)!
        let header = ["Referer": REFERER,
                      "Title": ("vplayed/" + String(controller.videoKey)).aesDoubleEncryptedString(),
                      "User-Agent": Bundle.main.bundleIdentifier,
                      "Content-Type": "application/x-www-form-urlencoded",
                      "X-REQUEST-TYPE": "mobile",
                      "X-DEVICE-TYPE": "iOS",
                      "X-USER-ID": LibraryAPI.sharedInstance.getUserId(),
                      "X-ACCESS-TOKEN": LibraryAPI.sharedInstance.getAccessToken()]
        let options = ["AVURLAssetHTTPHeaderFieldsKey": header]
        urlAsset = AVURLAsset(url: assest.url, options: options)
        let mediaSelectionGroup = urlAsset?.mediaSelectionGroup(forMediaCharacteristic: .audible)
        self.audioOptions = [VSAudioModel]()
        if let mediaOptions = mediaSelectionGroup?.options {
            for option in mediaOptions {
                if let title = option.value(forKey: "title") as? String{
                    let audioOptions = VSAudioModel.init(title: title, audioOptions: option)
                    if mediaSelectionGroup?.defaultOption == option {
                        audioOptions.isSelected = true
                    }
                    self.audioOptions?.append(audioOptions)
                    self.audioOptions?.reverse()
                }
            }
        }
        if self.audioOptions?.count == 0 || self.audioOptions?.count == 1 {
            self.audioButton.isHidden = true
        }
        } }
}
// GCKSessionManagerListener Controls
extension BMPlayerCustomControlView: GCKSessionManagerListener {
    func sessionManager(_ sessionManager: GCKSessionManager, didStart session: GCKSession) {
        self.setQueueButtonVisible(true)
    }
    func sessionManager(_ sessionManager: GCKSessionManager, didResumeSession session: GCKSession) {
        self.setQueueButtonVisible(true)
    }
    func sessionManager(_ sessionManager: GCKSessionManager, didEnd session: GCKSession, withError error: Error?) {
        self.setQueueButtonVisible(false)
    }
    func sessionManager(_ sessionManager: GCKSessionManager, didFailToStartSessionWithError error: Error?) {
        self.setQueueButtonVisible(false)
    }
    func sessionManager(_ sessionManager: GCKSessionManager,
                        didFailToResumeSession session: GCKSession, withError error: Error?) {
        self.setQueueButtonVisible(false)
    }
}
open class VSAudioModel {
    var title: String
    var audioOptions: AVMediaSelectionOption
    var isSelected = false
    required public init(title: String, audioOptions:AVMediaSelectionOption) {
        self.title = title
        self.audioOptions = audioOptions
    }
}
