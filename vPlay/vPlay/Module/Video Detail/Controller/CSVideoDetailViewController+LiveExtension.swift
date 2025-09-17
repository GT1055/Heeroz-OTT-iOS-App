/*
 * CSVideoDetailViewController+LiveExtension.swift
 * This is a Controller class is used for Video Detail Data To Handel the functionality
 * Happen in live When user navigate from live page to video Detail page
 * Which controll the Functionality of Video Detail Data
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit
extension CSVideoDetailViewController {
    /// Live View
    func showLiveView() {
        if isLive {
            LibraryAPI.sharedInstance.setUserDefaults(key: "videoId", value: String(videoId))
            setupLivechat()
            liveWidthConstraint.constant = 50
            self.dowwnloadLabel.superview?.superview?.isHidden = true
            self.playListFollowButton.isHidden = true
            self.playListFollowImage.superview?.superview?.isHidden = true
            self.commentView.isHidden = true
            self.commentTable.isHidden = true
            self.commenterView.isHidden = true
            self.commentCount.isHidden = true
            playerView.customControlView?.swipeLeftview.isHidden = true
            playerView.customControlView?.swipeRightview.isHidden = true
            self.chatButton.superview?.superview?.isHidden = false
            let controller = videoDetailStoryBoard.instantiateViewController(withIdentifier:
                "CSLiveChatTableView") as? CSLiveChatTableView
            controller?.chatDelegate = self
            controller?.videoId = videoId
            controller?.titleName = titleLabel.text
            controller?.view.frame = self.replyCommentBaseView.bounds
            controller?.willMove(toParent: self)
            self.replyCommentBaseView.addSubview((controller?.view)!)
            self.addChild(controller!)
            controller?.didMove(toParent: self)
            self.replyCommentBaseView.isHidden = true
            replyCommentBaseView.tag = 1
            LibraryAPI.sharedInstance.currentController = self
        } else {
            liveWidthConstraint.constant = 0
            self.chatButton.superview?.isHidden = true
            self.dowwnloadLabel.superview?.superview?.isHidden = false
            self.playListFollowButton.isHidden = false
            self.liveChatbuttonView.isHidden = true
            self.playListFollowImage.superview?.superview?.isHidden = false
        }
    }
    func setupLivechat() {
        if LibraryAPI.sharedInstance.getUserImageUrl().isEmpty {
            profileImage?.image = UIImage.init(named: "placeholder")
        } else {
            let imgUrl = LibraryAPI.sharedInstance.getUserImageUrl()
            liveChatController?.profileImage?.setImageWithUrl(imgUrl)
        }
        liveChatController?.textField.placeholder = LibraryAPI.sharedInstance.getUserName().isEmpty ? "Login to Enjoy Live Chat" : "Chat as \(LibraryAPI.sharedInstance.getUserName())"
        liveChatController?.textField.placeHolderColor = UIColor.lightGray
    }
    /// Get Start Timer
    func getStartTimer(_ startDateAndTime: String) {
        if startDateAndTime.isEmpty { return }
        if isLive {
            timerVideo?.invalidate()
            timerVideo = nil
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.string(from: Date())
            let currentDate: Date = dateFormatter.date(from: date)!
            let diff = dateFormatter.date(from: startDateAndTime)!.timeIntervalSince(currentDate)
            if diff < 0 {
                isScheduledLiveVideo = false
                self.hideTimerView()
                return
            } else {
                isScheduledLiveVideo = true
            }
            self.showCountDownView(dateFormatter.date(from: startDateAndTime)!)
            timerVideo = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in
                self.showCountDownView(dateFormatter.date(from: startDateAndTime)!)
            })
        } else {
            self.hideTimerView()
        }
    }
    /// Show Count Down View by take the Genrated Date
    func showCountDownView(_ generateDate: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.string(from: Date())
        let currentDate: Date = dateFormatter.date(from: date)!
        let diff = generateDate.timeIntervalSince(currentDate)
        let difference = Calendar.current.dateComponents([.day, .hour, .minute, .second],
                                                         from: currentDate,
                                                         to: generateDate)
        self.days.text = self.doubledigit(difference.day ?? 0)
        if difference.day == 0 {
            self.days.superview?.superview?.isHidden = true
        } else {
            self.days.superview?.superview?.isHidden = false
        }
        self.hours.text = self.doubledigit(difference.hour ?? 0)
        if difference.hour == 0 && difference.day == 0 {
            self.hours.superview?.superview?.isHidden = true
        } else {
            self.hours.superview?.superview?.isHidden = false
        }
        self.minutes.text = self.doubledigit(difference.minute ?? 0)
        if difference.hour == 0 && difference.day == 0 && difference.minute == 0 {
            self.minutes.superview?.superview?.isHidden = true
        } else {
            self.minutes.superview?.superview?.isHidden = false
        }
        self.seconds.text = self.doubledigit(difference.second ?? 0)
        if difference.hour == 0 && difference.day == 0 && difference.minute == 0 && difference.second == 0 {
            self.seconds.superview?.superview?.isHidden = true
        } else {
            self.seconds.superview?.superview?.isHidden = false
        }
        if diff < 0 {
            self.timerVideo?.invalidate()
            self.hideTimerView()
        } else {
            self.showTimerView()
        }
    }
    /// Hide Timer View
    func hideTimerView() {
        stackViewWidth.constant = 0
        stackViewSuper.isHidden = true
        self.stackViewSuper.superview?.isHidden = true
        self.playVideoButton.isHidden = false
    }
    /// Show Timer View
    func showTimerView() {
        self.stackViewWidth.constant = 70*4
        self.stackViewSuper.isHidden = false
        self.stackViewSuper.superview?.isHidden = false
        self.playVideoButton.isHidden = true
    }
    /// adding Double Digit
    /// - Parameter get: timer value
    /// - Returns: string value
    func doubledigit(_ get: Int) -> String {
        var doubleString: String! = ""
        if get < 10 {
            doubleString = "0"+"\(get)"
        } else {
            doubleString = "\(get)"
        }
        return doubleString
    }
}
// MARK: - Web series Set
extension CSVideoDetailViewController {
    /// Set up Web series View
    func setUpWebseries(_ isWebseries: Int, categoryName: String) {
        if isWebseries == 0 {
            publishedDateHeight.constant = 17
            showSeasonView.isHidden = true
            videoDuration.superview?.isHidden = true
            relatedTitle.text = NSLocalizedString("Related Videos", comment: "VideoDetail")
        } else {
            publishedDateHeight.constant = 42
            relatedTitle.text = categoryName
            showSeasonView.isHidden = false
            videoDuration.superview?.isHidden = false
        }
    }
}
