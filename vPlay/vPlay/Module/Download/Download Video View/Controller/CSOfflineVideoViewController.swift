//
//  CSOfflineVideoViewController.swift
//  vPlay
//
//  Created by user on 19/11/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class CSOfflineVideoViewController: CSParentViewController {
    // Title of Download View
    @IBOutlet var titleLabel: UILabel!
    // Descritption Of download View
    @IBOutlet var descriptionLabel: UILabel!
    // cast crew Of download View
    @IBOutlet var castCrewlabel: UILabel!
    // starring text
    @IBOutlet var starringText: UILabel!
    // Thumb Image
    @IBOutlet var thumbImageView: UIImageView!
    /// BM Custom Player
    @IBOutlet var playerView: BMCustomOfflinePlayer!
    /// player Play Area
    @IBOutlet var player: UIView!
    // Video Description View
    var videoDescription: String!
    /// Download assert Data
    var assertData: AssertDetails!
    /// assert File Name
    var asserFileName: URL!
    // MARK: - UIView Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackGroundColor()
        self.setupNavigation()
        self.callApi()
    }
    override func callApi() {
        self.fetchFileData()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            self.view.endEditing(true)
            changeOrentation(true)
        } else {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            changeOrentation(false)
        }
    }
}
// MARK: - Get the Data of the Particular Video
extension CSOfflineVideoViewController {
    /// Set Back Ground Color
    func setBackGroundColor() {
        if !LibraryAPI.sharedInstance.isDarkMode() { return }
        titleLabel.textColor = .white
        starringText.textColor = .white
        descriptionLabel.textColor = .white
        castCrewlabel.textColor = .white
    }
    /// Bind Data
    func bindData() {
        let dataDecoded: Data = Data(base64Encoded: assertData.thumbnail ?? "",
                                     options: .ignoreUnknownCharacters)!
        thumbImageView.image = UIImage(data: dataDecoded)
        titleLabel.text = assertData.title
        videoDescription = assertData.desciption
        self.setDescription()
        starringText.text = ""
        if let starring = assertData.castCrew, !starring.isEmpty {
            starringText.text = NSLocalizedString("Starring", comment: "video Detail")
            castCrewlabel.text = starring
        }
    }
    // It adds the notification bar.
    func setupNavigation() {
        addGradientBackGround()
        addLeftBarButton()
        addRightBarButton()
    }
}
// MARK: - Fetch File Data
extension CSOfflineVideoViewController {
    /// file Data
    func fetchFileData() {
        FetchDataBaseData.fetchAssertFile(parentView: self,
                                          assertId: assertData.assertId!,
                                          completionHandler: { [unowned self] responce in
                                            self.findAssertFile(responce.fileUrl ?? "")
                                            self.bindData()
        })
    }
    /// load Pdf In Web View
    func findAssertFile(_ assertName: String) {
        let decryptFile = assertName.aesDecryptBase64String()
        let assertArray = decryptFile.components(separatedBy: ".")
        let assert = assertArray.first! + "." + assertData.type!
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                       .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent(assert) {
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: pathComponent.path) {
                self.asserFileName = pathComponent
            } else {
                self.showToastMessageTop(message: NSLocalizedString("Please load a valid file",
                                                                    comment: ""))
            }
        } else {
            self.showToastMessageTop(message: NSLocalizedString("Please load a valid file",
                                                                comment: ""))
        }
    }
}
// MARK: - Button Action
extension CSOfflineVideoViewController {
    /// Read More Read Less Button Action
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        let text = (descriptionLabel.text)!
        if text.contains(NSLocalizedString("Read More", comment: "Video Detail")) {
            readLess()
        } else if text.contains(NSLocalizedString("Read Less", comment: "Video Detail")) {
            readMore()
        }
    }
    /// Play Button Action
    @IBAction func playButtonAction(_ sender: UIButton) {
        self.setPlayerData()
    }
}
// MARK: - Read More And Read Less label
extension CSOfflineVideoViewController: UIGestureRecognizerDelegate {
    /// Set Description
    func setDescription() {
        let arr = self.videoDescription.components(separatedBy: " ")
        if arr.count < 20 {
            descriptionLabel.text = self.videoDescription
            return
        } else {
            self.readMore()
        }
    }
    /// Read Less text
    func readLess() {
        let textData = self.videoDescription + " " + NSLocalizedString("Read Less", comment: "Video Detail")
        descriptionLabel.attributedText =
            textData.attributeTextProperty(appendtext: NSLocalizedString("Read Less", comment: "Video Detail"),
                                           color: .readMoreReadLessColor(), font: UIFont.fontNewLight())
    }
    /// Read More text
    func readMore() {
        let arr = self.videoDescription.components(separatedBy: " ")
        if arr.count <= 20 {
            descriptionLabel.attributedText =
                self.videoDescription.attributeTextProperty(appendtext: "", color: .readMoreReadLessColor(),
                                                            font: UIFont.fontNewLight())
            return
        }
        let textData = arr[0..<20].joined(separator: " ") + "..." +
            NSLocalizedString("Read More", comment: "Video Detail")
        descriptionLabel.attributedText =
            textData.attributeTextProperty(appendtext: NSLocalizedString("Read More", comment: "Video Detail"),
                                           color: .readMoreReadLessColor(), font: UIFont.fontNewLight())
    }
}
extension CSOfflineVideoViewController {
    /// Add Player
    func setPlayerData() {
        addPlayer()
        self.preparePlayerItem()
        player.isHidden = false
    }
    // PLayer Item
    func preparePlayerItem() {
        /// Resolution protocol to pass the resolution
        var bitRateResource = [BMPlayerResourceDefinition]()
        let resource = BMPlayerResourceDefinition(url: asserFileName,
                                                  definition: NSLocalizedString("Offline", comment: "Download"),
                                                  options: nil)
        bitRateResource.append(resource)
        let asset = BMPlayerResource(name: self.titleLabel.text!,
                                     definitions: bitRateResource,
                                     cover: nil,
                                     subtitles: nil)
        playerView.setVideo(resource: asset)
    }
    /// Player Adding
    func addPlayer() {
        /// Player Delgate
        playerView.delegate = self
        playerView.backBlock = { [unowned self] (isFullScreen) in
            if !isFullScreen {
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
    /// Detect Change of Orientation
    func changeOrentation(_ isFullscreen: Bool) {
        playerView.snp.remakeConstraints { (make) in
            if !isFullscreen {
                if UIScreen.main.nativeBounds.height == 2436 ||
                    UIScreen.main.nativeBounds.height == 2688 ||
                    UIScreen.main.nativeBounds.height == 1624 {
                    make.top.equalTo(view.snp.top).offset(40)
                } else {
                    make.top.equalTo(view.snp.top).offset(20)
                }
            } else {
                make.top.equalTo(view.snp.top)
            }
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            if isFullscreen {
                make.bottom.equalTo(view.snp.bottom)
            } else {
                make.height.equalTo(view.snp.width).multipliedBy(9.0/16.0).priority(500)
            }
        }
    }
}
// MARK: - BMPlayerDelegate example
extension CSOfflineVideoViewController: BMPlayerDelegate {
    // Call when player orinet changed
    func bmPlayer(player: BMPlayer, playerOrientChanged isFullscreen: Bool) {
        changeOrentation(isFullscreen)
    }
    // Call back when playing state changed, use to detect is playing or not
    func bmPlayer(player: BMPlayer, playerIsPlaying playing: Bool) {
    }
    // Call back when playing state changed, use to detect specefic state like buffering, bufferfinished
    func bmPlayer(player: BMPlayer, playerStateDidChange state: BMPlayerState) {
    }
    // Call back when play time change
    func bmPlayer(player: BMPlayer, playTimeDidChange currentTime: TimeInterval,
                  totalTime: TimeInterval) {
    }
    // Call back when the video loaded duration changed
    func bmPlayer(player: BMPlayer, loadedTimeDidChange loadedDuration: TimeInterval,
                  totalDuration: TimeInterval) {
    }
}
extension String {
    func attributeTextProperty(appendtext: String, color: UIColor, font: UIFont) -> NSMutableAttributedString {
        let attrib = NSMutableAttributedString(string: self, attributes: [.font: font])
        let range1 = (self as NSString).range(of: appendtext)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1
        attrib.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle,
                            range: NSRange(location: 0, length: attrib.length))
        attrib.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range1)
        return attrib
    }
}
