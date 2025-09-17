//
//  BMPlayerControlView.swift
//  Pods
//
//  Created by BrikerMan on 16/4/29.
//
//

import UIKit
import NVActivityIndicatorView
import GoogleCast
import AVFoundation

@objc public protocol BMPlayerControlViewDelegate: class {
    /**
     call when control view choose a definition
     
     - parameter controlView: control view
     - parameter index:       index of definition
     */
    func controlView(controlView: BMPlayerControlView, didChooseDefition index: Int)
    
    func controlView(controlView: BMPlayerControlView, didChooseDefition index: Int, videoKey: Int64) 
    
    /**
     call when control view pressed an button
     
     - parameter controlView: control view
     - parameter button:      button type
     */
    func controlView(controlView: BMPlayerControlView, didPressButton button: UIButton)
    
    /**
     call when slider action trigged
     
     - parameter controlView: control view
     - parameter slider:      progress slider
     - parameter event:       action
     */
    func controlView(controlView: BMPlayerControlView, slider: UISlider, onSliderEvent event: UIControl.Event)
    
    /**
     call when needs to change playback rate
     
     - parameter controlView: control view
     - parameter rate:        playback rate
     */
    @objc optional func controlView(controlView: BMPlayerControlView, didChangeVideoPlaybackRate rate: Float)
    
    func controlView(controlView: BMPlayerControlView,coverViewIsHidden isShow: Bool)
}

open class BMPlayerControlView: UIView {
    
    open weak var delegate: BMPlayerControlViewDelegate?
    open weak var player: BMPlayer?
    // MARK: Variables
    open var resource: BMPlayerResource?
    
    open var selectedIndex = 0
    open var isFullscreen  = false
    open var isMaskShowing = true
    open var backButtonWidthConstant = 0
    open var totalDuration:TimeInterval = 0
    open var delayItem: DispatchWorkItem?
    
    var playerLastState: BMPlayerState = .notSetURL
    
    fileprivate var isSelectecDefitionViewOpened = false
    open var isSeeked = false
    open var isOfflinePlayer: Bool = false
    // MARK: UI Components
    /// main views which contains the topMaskView and bottom mask view
    open var mainMaskView    = UIView()
    open var topMaskView     = UIView()
    open var bottomMaskView  = UIView()
    
    /// Image view to show video cover
    open var maskImageView   = UIImageView()
    
    /// top views
    open var backButton         = UIButton(type : UIButton.ButtonType.custom)
    open var swipeLeftview      = UIView()
    open var swipeRightview     = UIView()
    open var swipeLeftLabel      = UILabel()
    open var swipeRightLabel     = UILabel()
    open var swipeLeftbutton    = UIButton(type : UIButton.ButtonType.custom)
    open var swipeRightbutton   = UIButton(type : UIButton.ButtonType.custom)
    open var titleLabel         = UILabel()
    open var chooseDefitionView = UIView()
    open var backButtonView     = UIView()
    open var queueButton        = UIButton(type : UIButton.ButtonType.custom)
    open var xrayButton        = UIButton.init()
    open var chatButton        = UIButton(type : UIButton.ButtonType.custom)
    // open var castButton         = GCKUICastButton()
    let rippleLayer              = RippleLayer()
    /// Audio Button
    var audioButton = UIButton.init(type: UIButton.ButtonType.custom)
    
    /// bottom view
    open var currentTimeLabel = UILabel()
    open var totalTimeLabel   = UILabel()
    
    /// Progress slider
    open var timeSlider       = BMTimeSlider()
    
    /// load progress view
    open var progressView     = UIProgressView()
    // seek time
    let seekDuration: Float64 = 10
    
    /* play button
     playButton.isSelected = player.isPlaying
     */
    open var playButton       = UIButton(type: UIButton.ButtonType.custom)
    
    /* fullScreen button
     fullScreenButton.isSelected = player.isFullscreen
     */
    open var fullscreenButton = UIButton(type: UIButton.ButtonType.custom)
    
    open var subtitleLabel    = UILabel()
    open var subtitleBackView = UIView()
    open var subtileAttrabute: [NSAttributedString.Key: Any]?
    
    /// Activty Indector for loading
    open var loadingIndector  = NVActivityIndicatorView(frame:  CGRect(x: 0, y: 0, width: 30, height: 30))
    
    open var seekToView       = UIView()
    open var seekToViewImage  = UIImageView()
    open var seekToLabel      = UILabel()
    open var animation        = CAKeyframeAnimation()
    
    open var replayButton     = UIButton(type: UIButton.ButtonType.custom)
    
    /// Preview thumbnail variables
    open var previewView = UIView()
    open var previewImageView = UIImageView()
    open var orginalSprite = UIImageView()
    open var isPreviewAvailable = false
    
    /// Gesture used to show / hide control view
    open var tapGesture: UITapGestureRecognizer!
    
    /// PlayButton button declaration
    open var customPlayButton = UIButton(type: .custom)
    
    // MARK: - handle player state change
    /**
     call on when play time changed, update duration here
     
     - parameter currentTime: current play time
     - parameter totalTime:   total duration
     */
    open func playTimeDidChange(currentTime: TimeInterval, totalTime: TimeInterval) {
        // there isa a delay in changing player state so here used isselected flag and slider value condition for backward moving slider when updating value
        self.swipeLeftview.isHidden = isMaskShowing ? false : true
        self.swipeRightview.isHidden = isMaskShowing ? false : true
        if currentTime < 9 {
            self.swipeLeftview.isHidden = true
        }
        if (totalTime - currentTime) < 9 {
            self.swipeRightview.isHidden = true
        }
        if self.player?.playerLayer?.player?.timeControlStatus == .playing {
            self.isSeeked = false
        }
        if !isSeeked {
            totalTimeLabel.text   = BMPlayer.formatSecondsToString(totalTime)
            currentTimeLabel.text = BMPlayer.formatSecondsToString(currentTime)
            timeSlider.value = Float(currentTime) / Float(totalTime)
        }
        if  isOfflinePlayer {
            currentTimeLabel.text = BMPlayer.formatSecondsToString(currentTime)
            timeSlider.value = Float(currentTime) / Float(totalTime)
        }
        if let subtitle = resource?.subtitle {
            showSubtile(from: subtitle, at: currentTime)
        } else {
            subtitleBackView.isHidden = true
        }
    }
    
    /**
     call on load duration changed, update load progressView here
     
     - parameter loadedDuration: loaded duration
     - parameter totalDuration:  total duration
     */
    open func loadedTimeDidChange(loadedDuration: TimeInterval , totalDuration: TimeInterval) {
        progressView.setProgress(Float(loadedDuration)/Float(totalDuration), animated: true)
    }
    
    open func playerStateDidChange(state: BMPlayerState) {
        switch state {
        case .readyToPlay:
            hideLoader()
            
        case .buffering:
            showLoader()
            
        case .bufferFinished:
            hideLoader()
            
        case .playedToTheEnd:
            playButton.isSelected = false
            customPlayButton.isSelected = false
            showPlayToTheEndView()
            controlViewAnimation(isShow: true)
            swipeRightview.isHidden = true
            cancelAutoFadeOutAnimation()
            
        default:
            break
        }
        playerLastState = state
    }
    
    /**
     Call when User use the slide to seek function
     
     - parameter toSecound:     target time
     - parameter totalDuration: total duration of the video
     - parameter isAdd:         isAdd
     */
    open func showSeekToView(to toSecound: TimeInterval, total totalDuration:TimeInterval, isAdd: Bool) {
        seekToView.isHidden   = false
        seekToLabel.text    = BMPlayer.formatSecondsToString(toSecound)
        
        let rotate = isAdd ? 0 : CGFloat(Double.pi)
        seekToViewImage.transform = CGAffineTransform(rotationAngle: rotate)
        
        let targetTime      = BMPlayer.formatSecondsToString(toSecound)
        timeSlider.value      = Float(toSecound / totalDuration)
        currentTimeLabel.text = targetTime
    }
    
    // MARK: - UI update related function
    /**
     Update UI details when player set with the resource
     
     - parameter resource: video resouce
     - parameter index:    defualt definition's index
     */
    open func prepareUI(for resource: BMPlayerResource, selectedIndex index: Int) {
        self.resource = resource
        self.selectedIndex = index
        titleLabel.text = resource.name
        prepareChooseDefinitionView()
        autoFadeOutControlViewWithAnimation()
    }
    
    open func playStateDidChange(isPlaying: Bool) {
        autoFadeOutControlViewWithAnimation()
        playButton.isSelected = isPlaying
        customPlayButton.isSelected = isPlaying
    }
    
    /**
     auto fade out controll view with animtion
     */
    open func autoFadeOutControlViewWithAnimation() {
        if !GCKCastContext.sharedInstance().sessionManager.hasConnectedSession() {
            cancelAutoFadeOutAnimation()
            delayItem = DispatchWorkItem { [weak self] in
                self?.controlViewAnimation(isShow: false)
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + BMPlayerConf.animateDelayTimeInterval,
                                          execute: delayItem!)
        } }
    
    /**
     cancel auto fade out controll view with animtion
     */
    open func cancelAutoFadeOutAnimation() {
        if !GCKCastContext.sharedInstance().sessionManager.hasConnectedSession() {
            delayItem?.cancel() }
    }
    
    /**
     Implement of the control view animation, override if need's custom animation
     
     - parameter isShow: is to show the controlview
     */
    open func controlViewAnimation(isShow: Bool) {
        let alpha: CGFloat = isShow ? 1.0 : 0.0
        self.isMaskShowing = isShow
        UIView.animate(withDuration: 0.3, animations: {
            self.topMaskView.alpha    = alpha
            self.bottomMaskView.alpha = alpha
            self.mainMaskView.backgroundColor = UIColor ( red: 0.0, green: 0.0, blue: 0.0, alpha: isShow ? 0.4 : 0.0)
            
            if isShow {
                if self.isFullscreen { self.chooseDefitionView.alpha = 1.0 }
            } else {
                self.replayButton.isHidden = true
                self.chooseDefitionView.snp.updateConstraints { (make) in
                    make.height.equalTo(35)
                }
                self.chooseDefitionView.alpha = 0.0
            }
            self.layoutIfNeeded()
        }) { (_) in
            if isShow {
                self.autoFadeOutControlViewWithAnimation()
            }
        }
    }
    
    /**
     Implement of the UI update when screen orient changed
     
     - parameter isForFullScreen: is for full screen
     */
    open func updateUI(_ isForFullScreen: Bool) {
        isFullscreen = isForFullScreen
        fullscreenButton.isSelected = isForFullScreen
        chooseDefitionView.isHidden = !isForFullScreen
        if isForFullScreen {
            if BMPlayerConf.topBarShowInCase.rawValue == 2 {
                topMaskView.isHidden = true
            } else {
                topMaskView.isHidden = false
            }
        } else {
            if BMPlayerConf.topBarShowInCase.rawValue >= 1 {
                topMaskView.isHidden = true
            } else {
                topMaskView.isHidden = false
            }
        }
    }
    /**
     Call when video play's to the end, override if you need custom UI or animation when played to the end
     */
    open func showPlayToTheEndView() {
        replayButton.isHidden = false
        self.customPlayButton.isHidden = true
    }
    open func hidePlayToTheEndView() {
        replayButton.isHidden = true
        customPlayButton.isHidden = false
    }
    
    open func showLoader() {
        loadingIndector.isHidden = false
        customPlayButton.isHidden = true
        loadingIndector.startAnimating()
    }
    
    open func hideLoader() {
        loadingIndector.isHidden = true
        if playerLastState != .playedToTheEnd {
            customPlayButton.isHidden = false
        }
    }
    
    open func hideSeekToView() {
        seekToView.isHidden = true
    }
    
    open func showCoverWithLink(_ cover:String) {
        self.showCover(url: URL(string: cover))
    }
    
    open func showCover(url: URL?) {
        if let url = url {
            DispatchQueue.global(qos: .default).async {
                let data = try? Data(contentsOf: url)
                DispatchQueue.main.async(execute: {
                    if let data = data {
                        self.maskImageView.image = UIImage(data: data)
                    } else {
                        self.maskImageView.image = nil
                    }
                    self.hideLoader()
                });
            }
        }
    }
    
    open func hideCoverImageView() {
        self.maskImageView.isHidden = true
    }
    
    open func prepareChooseDefinitionView() {
        guard let resource = resource else {
            return
        }
        for item in chooseDefitionView.subviews {
            item.removeFromSuperview()
        }
        
        for i in 0..<resource.definitions.count {
            let button = BMPlayerClearityChooseButton()
            
            if i == 0 {
                button.tag = selectedIndex
            } else if i <= selectedIndex {
                button.tag = i - 1
            } else {
                button.tag = i
            }
            
            button.setTitle("\(resource.definitions[button.tag].definition)", for: UIControl.State())
            chooseDefitionView.addSubview(button)
            button.addTarget(self, action: #selector(self.onDefinitionSelected(_:)), for: UIControl.Event.touchUpInside)
            button.snp.makeConstraints({ (make) in
                make.top.equalTo(chooseDefitionView.snp.top).offset(35 * i)
                make.width.equalTo(50)
                make.height.equalTo(25)
                make.centerX.equalTo(chooseDefitionView)
            })
            
            if resource.definitions.count == 1 {
                button.isEnabled = false
            }
        }
    }
    
    open func prepareToDealloc() {
        self.delayItem = nil
    }
    
    open func setSpriteImage(_ sprite: UIImageView) {
        self.orginalSprite = sprite
    }
    
    // MARK: - Action Response
    /**
     Call when some action button Pressed
     
     - parameter button: action Button
     */
    @objc open func onButtonPressed(_ button: UIButton) {
        autoFadeOutControlViewWithAnimation()
        if let type = ButtonType(rawValue: button.tag) {
            switch type {
            case .play, .replay:
                if playerLastState == .playedToTheEnd {
                    hidePlayToTheEndView()
                }
            case .fullscreen:
                button.isSelected = !button.isSelected
            default:
                break
            }
        }
        delegate?.controlView(controlView: self, didPressButton: button)
    }
    @objc open func onRightButtonPressed(_ button: UIButton) {
        guard let duration  = player?.playerLayer?.player?.currentItem?.duration else{
            return
        }
        let playerCurrentTime = CMTimeGetSeconds((player?.playerLayer?.player?.currentTime())!)
        let newTime = playerCurrentTime + seekDuration
        if newTime < CMTimeGetSeconds(duration) {
            let time2: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
            player?.playerLayer?.player?.seek(to: time2)
            currentTimeLabel.text = BMPlayer.formatSecondsToString(newTime)
            animateButton(button)
        }
    }
    @objc open func onLeftButtonPressed(_ button: UIButton) {
        let playerCurrentTime = CMTimeGetSeconds((player?.playerLayer?.player?.currentTime())!)
        var newTime = playerCurrentTime - seekDuration
        if newTime < 0 {
            newTime = 0
        }
        let time2: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
        player?.playerLayer?.player?.seek(to: time2)
        currentTimeLabel.text = BMPlayer.formatSecondsToString(newTime)
        animateButton(button)
    }
    func animateButton(_ sender: UIButton) {
        sender.layer.add(animation, forKey: "shake")
        rippleLayer.position = CGPoint(x: sender.layer.bounds.midX, y: sender.layer.bounds.midY);
        sender.layer.addSublayer(rippleLayer)
        rippleLayer.startAnimation()
    }
    @objc open func onCastPressed(_ button: UIButton) {
        if UIDevice.current.orientation.isLandscape {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }
    }
    /**
     Call when the tap gesture tapped
     
     - parameter gesture: tap gesture
     */
    @objc open func onTapGestureTapped(_ gesture: UITapGestureRecognizer) {
        if playerLastState == .playedToTheEnd {
            return
        }
        controlViewAnimation(isShow: !isMaskShowing)
    }
    // MARK: - handle UI slider actions
    @objc func progressSliderTouchBegan(_ sender: UISlider)  {
        delegate?.controlView(controlView: self, slider: sender, onSliderEvent: .touchDown)
    }
    
    @objc func progressSliderValueChanged(_ sender: UISlider)  {
        hidePlayToTheEndView()
        cancelAutoFadeOutAnimation()
        let currentTime = Double(sender.value) * totalDuration
        currentTimeLabel.text = BMPlayer.formatSecondsToString(currentTime)
        delegate?.controlView(controlView: self, slider: sender, onSliderEvent: .valueChanged)
        if isPreviewAvailable { moveThePreviewView(sender) }
    }
    
    @objc func progressSliderTouchEnded(_ sender: UISlider)  {
        autoFadeOutControlViewWithAnimation()
        delegate?.controlView(controlView: self, slider: sender, onSliderEvent: .touchUpInside)
        if isPreviewAvailable { previewView.isHidden = true }
    }
    //trying new type
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                print("Slider touch began")
                delegate?.controlView(controlView: self, slider: slider, onSliderEvent: .touchDown)
            // handle drag began
            case .moved:
                print("Slider touch Moved")
                hidePlayToTheEndView()
                cancelAutoFadeOutAnimation()
                let currentTime = Double(slider.value) * totalDuration
                currentTimeLabel.text = BMPlayer.formatSecondsToString(currentTime)
                delegate?.controlView(controlView: self, slider: slider, onSliderEvent: .valueChanged)
            // handle drag moved
            case .ended:
                print("Slider touch Ended")
            // handle drag ended
            case .cancelled:
                print("cancelled")
            case .stationary:
                print("stationary")
            default:
                break
            }
        }
    }
    
    // MARK: - preview functions
    // This moves the preview based on the slider value
    func moveThePreviewView(_ slider: UISlider) {
        let currentTime = Double(slider.value) * totalDuration
        let previewWidth = currentTime * 192 / Double(slider.maximumValue)
        let sliderWidth = slider.frame.width
        let progress = CGFloat(slider.value)
        var widthToMaintain = sliderWidth * progress / CGFloat(slider.maximumValue)
        updatePreviewImage(CGFloat(previewWidth))
        widthToMaintain = widthToMaintain + 47.5
        previewView.snp.updateConstraints({ (make) in
            make.left.equalTo(mainMaskView.snp.left).offset(widthToMaintain)
        })
        previewView.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.layoutIfNeeded()
        })
    }
    
    // This updates the image based on the preview point
    func updatePreviewImage(_ center: CGFloat) {
        // w - 192 h - 108
        let frame = CGRect(x: center, y: 0, width: 192, height: 108)
        let previewImage = orginalSprite.image?.crop(by: frame)
        previewImageView.image = nil
        previewImageView.image = previewImage
    }
    
    // MARK: - private functions
    fileprivate func showSubtile(from subtitle: BMSubtitles, at time: TimeInterval) {
        if let group = subtitle.search(for: time) {
            subtitleBackView.isHidden = false
            subtitleLabel.attributedText =
                NSAttributedString(string: group.text.removeHtmlFromString(), attributes: subtileAttrabute)
        } else {
            subtitleBackView.isHidden = true
        }
    }
    
    @objc fileprivate func onDefinitionSelected(_ button:UIButton) {
        let height = isSelectecDefitionViewOpened ? 35 : resource!.definitions.count * 40
        chooseDefitionView.snp.updateConstraints { (make) in
            make.height.equalTo(height)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
        })
        isSelectecDefitionViewOpened = !isSelectecDefitionViewOpened
        if selectedIndex != button.tag {
            selectedIndex = button.tag
            delegate?.controlView(controlView: self, didChooseDefition: button.tag)
        }
        prepareChooseDefinitionView()
    }
    
    @objc fileprivate func onReplyButtonPressed() {
        replayButton.isHidden = true
        customPlayButton.isHidden = false
    }
    
    // MARK: - Init
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupUIComponents()
        addSnapKitConstraint()
        customizeUIComponents()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUIComponents()
        addSnapKitConstraint()
        customizeUIComponents()
    }
    
    /// Add Customize functions here
    open func customizeUIComponents() {
        
    }
    
    func setupUIComponents() {
        // Add a gesture recognizer to the slider
        let tapGestureRecognizer =
            UITapGestureRecognizer(target: self, action: #selector(sliderTapped(gestureRecognizer:)))
        // Subtile view
        subtitleLabel.numberOfLines = 2
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = UIColor.white
        subtitleLabel.adjustsFontSizeToFitWidth = true
        subtitleLabel.minimumScaleFactor = 0.5
        subtitleLabel.font = UIFont.systemFont(ofSize: 13)
        
        subtitleBackView.layer.cornerRadius = 2
        subtitleBackView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        subtitleBackView.addSubview(subtitleLabel)
        subtitleBackView.isHidden = true
        
        addSubview(subtitleBackView)
        
        // Main mask view
        addSubview(mainMaskView)
        addSubview(swipeRightview)
        addSubview(swipeLeftview)
        mainMaskView.addSubview(customPlayButton)
        mainMaskView.addSubview(topMaskView)
        mainMaskView.addSubview(bottomMaskView)
        mainMaskView.addSubview(swipeRightview)
        mainMaskView.addSubview(swipeLeftview)
        swipeLeftview.addSubview(swipeLeftbutton)
        swipeLeftview.addSubview(swipeLeftLabel)
        swipeRightview.addSubview(swipeRightbutton)
        swipeRightview.addSubview(swipeRightLabel)
        mainMaskView.insertSubview(maskImageView, at: 0)
        mainMaskView.clipsToBounds = true
        mainMaskView.backgroundColor = UIColor ( red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4 )
        //castButton.addTarget(self, action: #selector(onCastPressed(_:)), for: .touchUpInside)
        // Top views
        topMaskView.addSubview(queueButton)
        // topMaskView.addSubview(castButton)
        topMaskView.addSubview(backButtonView)
        topMaskView.addSubview(audioButton)
        backButtonView.addSubview(backButton)
        topMaskView.addSubview(titleLabel)
        topMaskView.addSubview(xrayButton)
        topMaskView.addSubview(chatButton)
        addSubview(chooseDefitionView)
        
        backButton.tag = BMPlayerControlView.ButtonType.back.rawValue
        backButton.setImage(BMImageResourcePath("Pod_Asset_BMPlayer_back"), for: .normal)
        swipeRightbutton.setImage(BMImageResourcePath("Pod_Asset_BMPlayer_seek_to_image"), for: .normal)
        swipeLeftbutton.setImage(BMImageResourcePath("BMPlayer_seek_to_Rewind_image"), for: .normal)
        backButton.addTarget(self, action: #selector(onButtonPressed(_:)), for: .touchUpInside)
        swipeRightbutton.addTarget(self, action: #selector(onRightButtonPressed(_:)), for: .touchUpInside)
        swipeLeftbutton.addTarget(self, action: #selector(onLeftButtonPressed(_:)), for: .touchUpInside)
        
        queueButton.setImage(UIImage(named:"Playlist_Select"), for: .normal)
        chatButton.setImage(UIImage(named:"chat-hide"), for: .normal)
        chatButton.isHidden = true
        xrayButton.setTitleColor(UIColor.white, for: .normal)
        xrayButton.setTitle("X-Ray", for: .normal)
        xrayButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        xrayButton.layer.cornerRadius = 5
        titleLabel.numberOfLines = 2
        titleLabel.textColor = UIColor.white
        titleLabel.adjustsFontSizeToFitWidth = true
        subtitleLabel.minimumScaleFactor = 0.5
        titleLabel.text      = ""
        titleLabel.font      = UIFont.systemFont(ofSize: 13)
        
        chooseDefitionView.clipsToBounds = true
        
        // Bottom views
        bottomMaskView.addSubview(playButton)
        bottomMaskView.addSubview(currentTimeLabel)
        bottomMaskView.addSubview(totalTimeLabel)
        bottomMaskView.addSubview(progressView)
        bottomMaskView.addSubview(timeSlider)
        bottomMaskView.addSubview(fullscreenButton)
        
        playButton.tag = BMPlayerControlView.ButtonType.play.rawValue
        playButton.setImage(BMImageResourcePath("Pod_Asset_BMPlayer_play"),  for: .normal)
        playButton.setImage(BMImageResourcePath("Pod_Asset_BMPlayer_pause"), for: .selected)
        playButton.addTarget(self, action: #selector(onButtonPressed(_:)), for: .touchUpInside)
        
        
        customPlayButton.tag = BMPlayerControlView.ButtonType.play.rawValue
        customPlayButton.setImage(UIImage.init(named: "playButton"), for: .normal)
        customPlayButton.setImage(UIImage.init(named: "pause"), for: .selected)
        customPlayButton.addTarget(self, action: #selector(onButtonPressed(_:)), for: .touchUpInside)
        
        currentTimeLabel.textColor  = UIColor.white
        currentTimeLabel.font       = UIFont.systemFont(ofSize: 12)
        currentTimeLabel.text       = "00:00"
        currentTimeLabel.textAlignment = NSTextAlignment.center
        
        totalTimeLabel.textColor    = UIColor.white
        totalTimeLabel.font         = UIFont.systemFont(ofSize: 12)
        totalTimeLabel.text         = "00:00"
        totalTimeLabel.textAlignment   = NSTextAlignment.center
        
        swipeLeftLabel.textColor    = UIColor.white
        swipeLeftLabel.font         = UIFont.boldSystemFont(ofSize: 12)
        swipeLeftLabel.text         = "10 sec"
        swipeLeftLabel.textAlignment  = NSTextAlignment.center
        
        swipeRightLabel.textColor    = UIColor.white
        swipeRightLabel.font         = UIFont.boldSystemFont(ofSize: 12)
        swipeRightLabel.text         = "10 sec"
        swipeRightLabel.textAlignment = NSTextAlignment.center
        
        
        timeSlider.maximumValue = 1.0
        timeSlider.minimumValue = 0.0
        timeSlider.value        = 0.0
        timeSlider.setThumbImage(BMImageResourcePath("Pod_Asset_BMPlayer_slider_thumb"), for: .normal)
        timeSlider.addGestureRecognizer(tapGestureRecognizer)
        timeSlider.maximumTrackTintColor = UIColor.clear
        timeSlider.minimumTrackTintColor = BMPlayerConf.tintColor
        
        timeSlider.addTarget(self, action: #selector(progressSliderTouchBegan(_:)),
                             for: UIControl.Event.touchDown)

        timeSlider.addTarget(self, action: #selector(progressSliderValueChanged(_:)),
                             for: UIControl.Event.valueChanged)
//
        timeSlider.addTarget(self, action: #selector(progressSliderTouchEnded(_:)),
                             for: [UIControl.Event.touchUpInside,
                                   UIControl.Event.touchCancel,
                                   UIControl.Event.touchUpOutside])
//        timeSlider.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)

        progressView.tintColor      = UIColor ( red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6 )
        progressView.trackTintColor = UIColor ( red: 1.0, green: 1.0, blue: 1.0, alpha: 0.3 )
        
        fullscreenButton.tag = BMPlayerControlView.ButtonType.fullscreen.rawValue
        fullscreenButton.setImage(BMImageResourcePath("Pod_Asset_BMPlayer_fullscreen"),    for: .normal)
        fullscreenButton.setImage(BMImageResourcePath("Pod_Asset_BMPlayer_portialscreen"), for: .selected)
        fullscreenButton.addTarget(self, action: #selector(onButtonPressed(_:)), for: .touchUpInside)
        
        mainMaskView.addSubview(loadingIndector)
        
        loadingIndector.type             = BMPlayerConf.loaderType
        loadingIndector.color            = BMPlayerConf.tintColor
        
        // View to show when slide to seek
        addSubview(seekToView)
        seekToView.addSubview(seekToViewImage)
        seekToView.addSubview(seekToLabel)
        
        seekToLabel.font                = UIFont.systemFont(ofSize: 13)
        seekToLabel.textColor           = UIColor ( red: 0.9098, green: 0.9098, blue: 0.9098, alpha: 1.0 )
        seekToView.backgroundColor      = UIColor ( red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7 )
        seekToView.layer.cornerRadius   = 4
        seekToView.layer.masksToBounds  = true
        seekToView.isHidden               = true
        
        seekToViewImage.image = BMImageResourcePath("Pod_Asset_BMPlayer_seek_to_image")
        
        addSubview(replayButton)
        replayButton.isHidden = true
        replayButton.setImage(BMImageResourcePath("Pod_Asset_BMPlayer_replay"), for: .normal)
        replayButton.addTarget(self, action: #selector(onButtonPressed(_:)), for: .touchUpInside)
        replayButton.tag = ButtonType.replay.rawValue
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapGestureTapped(_:)))
        addGestureRecognizer(tapGesture)
        animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 1.0
        animation.values = [-5.0, 5.0, 0.0 ]
        swipeLeftview.isHidden = true
        previewView.isHidden = true
        previewView.backgroundColor = UIColor.white
        previewImageView.contentMode = .scaleAspectFill
        previewView.addSubview(previewImageView)
        addSubview(previewView)
    }
    @objc func sliderTapped(gestureRecognizer: UIGestureRecognizer) {
        let pointTapped: CGPoint = gestureRecognizer.location(in: self.bottomMaskView)
        let positionOfSlider: CGPoint = timeSlider.frame.origin
        let widthOfSlider: CGFloat = timeSlider.frame.size.width
        let newValue = ((pointTapped.x - positionOfSlider.x) * CGFloat(timeSlider.maximumValue) / widthOfSlider)
        timeSlider.setValue(Float(newValue), animated: true)
        let currentTime = Double(newValue) * totalDuration
        currentTimeLabel.text = BMPlayer.formatSecondsToString(currentTime)
        delegate?.controlView(controlView: self, slider: timeSlider, onSliderEvent: .touchUpInside)
    }
    func addSnapKitConstraint() {
        // Main mask view
        mainMaskView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        maskImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(mainMaskView)
        }
        topMaskView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(mainMaskView)
            make.height.equalTo(50)
        }
        
        bottomMaskView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(mainMaskView)
            make.height.equalTo(50)
        }
        
        // Top views
        backButtonView.backgroundColor = UIColor.themeColorButton()
        backButtonView.snp.makeConstraints { (make) in
            make.width.height.equalTo(backButtonWidthConstant)
            make.centerY.equalTo(topMaskView)
            make.leading.equalTo(10)
        }
        backButtonView.cornerRadius = 17.5
        backButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.center.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(backButtonView.snp.right).offset(10)
            make.centerY.equalTo(backButtonView)
        }
        
        chatButton.snp.makeConstraints { (make) in
            make.right.equalTo(xrayButton.snp.right).offset(-60)
            make.centerY.equalTo(topMaskView.snp.centerY)
            make.height.width.equalTo(40)
        }
        
        xrayButton.snp.makeConstraints { (make) in
            let space = UIDevice.current.orientation.isLandscape ? -80 : -40
            make.right.equalTo(audioButton.snp.right).offset(space)
            make.centerY.equalTo(topMaskView.snp.centerY)
            make.width.equalTo(55)
            make.height.equalTo(25)
        }
        
//        castButton.tintColor = UIColor.themeColorButton()
//        castButton.snp.makeConstraints { (make) in
//            make.trailing.equalTo(audioButton.snp.leading).offset(5)
//            make.centerY.equalTo(audioButton)
//            make.width.height.equalTo(40)
//        }
        
        audioButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(42)
            make.right.equalTo(topMaskView.snp.right).offset(-60)
            make.top.bottom.equalTo(backButtonView)
        }

        queueButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.right.equalTo(audioButton.snp.left).offset(4)
            make.top.bottom.equalTo(audioButton)
        }

        chooseDefitionView.snp.makeConstraints { (make) in
            make.right.equalTo(topMaskView.snp.right).offset(-20)
            make.top.equalTo(titleLabel.snp.top).offset(-4)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        
        // Bottom views
        playButton.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.left.bottom.equalTo(bottomMaskView)
        }
        
        currentTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(playButton.snp.right)
            make.centerY.equalTo(playButton)
            make.width.equalTo(50)
        }
        
        timeSlider.snp.makeConstraints { (make) in
            make.centerY.equalTo(currentTimeLabel)
            make.left.equalTo(currentTimeLabel.snp.right).offset(10).priority(750)
            make.height.equalTo(30)
        }
        
        progressView.snp.makeConstraints { (make) in
            make.centerY.left.right.equalTo(timeSlider)
            make.height.equalTo(2)
        }
        
        totalTimeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(currentTimeLabel)
            make.left.equalTo(timeSlider.snp.right).offset(5)
        }
        
        fullscreenButton.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.centerY.equalTo(currentTimeLabel)
            make.left.equalTo(totalTimeLabel.snp.right)
            make.right.equalTo(bottomMaskView.snp.right)
        }
        
        
        loadingIndector.snp.makeConstraints { (make) in
            make.centerX.equalTo(mainMaskView.snp.centerX).offset(0)
            make.centerY.equalTo(mainMaskView.snp.centerY).offset(0)
        }
        
        // View to show when slide to seek
        seekToView.snp.makeConstraints { (make) in
            make.center.equalTo(self.snp.center)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
        seekToViewImage.snp.makeConstraints { (make) in
            make.left.equalTo(seekToView.snp.left).offset(15)
            make.centerY.equalTo(seekToView.snp.centerY)
            make.height.equalTo(15)
            make.width.equalTo(25)
        }
        
        seekToLabel.snp.makeConstraints { (make) in
            make.left.equalTo(seekToViewImage.snp.right).offset(10)
            make.centerY.equalTo(seekToView.snp.centerY)
        }
        
        replayButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(mainMaskView.snp.centerX)
            make.centerY.equalTo(mainMaskView.snp.centerY)
            make.width.height.equalTo(50)
        }
        customPlayButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(mainMaskView.snp.centerX)
            make.centerY.equalTo(mainMaskView.snp.centerY)
            make.width.height.equalTo(50)
        }
        swipeRightview.snp.makeConstraints { (make) in
            make.centerY.equalTo(mainMaskView.snp.centerY).offset(10)
            make.left.equalTo(customPlayButton.snp.right).offset(40)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        swipeRightbutton.snp.makeConstraints{ (make) in
            make.top.left.right.edges.equalTo(swipeRightview)
            make.bottom.equalTo(swipeRightLabel.snp.top).offset(-10)
            make.width.height.equalTo(50)
        }
        swipeRightLabel.snp.makeConstraints{ (make) in
            make.bottom.left.right.edges.equalTo(swipeRightview)
            make.top.equalTo(swipeRightbutton.snp.bottom).offset(8)
            make.width.equalTo(50)
            make.height.equalTo(5)
        }
        swipeLeftview.snp.makeConstraints { (make) in
            make.centerY.equalTo(mainMaskView.snp.centerY).offset(10)
            make.right.equalTo(customPlayButton.snp.left).offset(-40)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        swipeLeftbutton.snp.makeConstraints{ (make) in
            make.top.left.right.edges.equalTo(swipeLeftview)
            make.bottom.equalTo(swipeLeftLabel.snp.top).offset(-10)
            make.width.height.equalTo(50)
        }
        swipeLeftLabel.snp.makeConstraints{ (make) in
            make.bottom.left.right.edges.equalTo(swipeLeftview)
            make.top.equalTo(swipeLeftbutton.snp.bottom).offset(8)
            make.width.equalTo(100)
            make.height.equalTo(5)
        }
        subtitleBackView.snp.makeConstraints {
            $0.left.right.equalTo(mainMaskView)
            $0.bottom.equalTo(bottomMaskView.snp.top).offset(-5)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.left.equalTo(subtitleBackView.snp.left).offset(10)
            $0.right.equalTo(subtitleBackView.snp.right).offset(-10)
            $0.top.equalTo(subtitleBackView.snp.top).offset(2)
            $0.bottom.equalTo(subtitleBackView.snp.bottom).offset(-2)
        }
        
        previewView.snp.makeConstraints { (make) in
            make.left.equalTo(mainMaskView.snp.left).offset(20)
            make.bottom.equalTo(bottomMaskView.snp.top).offset(-2)
            make.width.equalTo(95)
            make.height.equalTo(75)
        }
        
        previewImageView.snp.makeConstraints { (make) in
            make.bottom.top.left.right.equalTo(previewView)
        }
    }
    
    fileprivate func BMImageResourcePath(_ fileName: String) -> UIImage? {
        let bundle = Bundle(for: BMPlayer.self)
        let image  = UIImage(named: fileName, in: bundle, compatibleWith: nil)
        return image
    }
}
