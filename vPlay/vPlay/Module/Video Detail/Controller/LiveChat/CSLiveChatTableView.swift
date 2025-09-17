//
//  CSLiveChatTableView.swift
//  vPlay
//
//  Created by user on 17/09/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import IQKeyboardManagerSwift
protocol CSChatlistDelegate: class {
    func closeChat(_ controller: UIViewController)
}
class CSLiveChatTableView: CSParentViewController {
    weak var chatDelegate: CSChatlistDelegate?
    var ref: DatabaseReference!
    var messages: [DataSnapshot]! = []
    var msglength: NSNumber = 10
    fileprivate var _refHandle: DatabaseHandle?
    var storageRef: StorageReference!
    var remoteConfig: RemoteConfig!
    @IBOutlet weak var chatlistView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var titleLbel: UILabel!
    @IBOutlet weak private var bottomViewBottomConstraint: NSLayoutConstraint!
    /// Video Id
    var videoId = Int()
    /// Video Id
    var titleName: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        videoId = LibraryAPI.sharedInstance.getVideoId()
        setupUIcomponents()
        configureStorage()
        configureRemoteConfig()
        fetchConfig()
    }
    func scrolltoBottom() {
        if messages.count > 0 {
            self.chatlistView.scrollToRow(at: IndexPath.init(row: (self.messages.count)-1, section: 0), at: .bottom, animated: true)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //registerKeyboardNotifications()
        setTextfieldSetup()
    }
    override func viewDidAppear(_ animated: Bool) {
        textField.text = ""
        scrolltoBottom()
    }
    override func viewWillDisappear(_ animated: Bool) {
        unregisterKeyboardNotifications()
        self.view.endEditing(true)
    }
    func setTextfieldSetup() {
        textField.placeholder = LibraryAPI.sharedInstance.getUserName().isEmpty ? "Login to Enjoy Live Chat" : "Chat as \(LibraryAPI.sharedInstance.getUserName())"
        textField.placeHolderColor = UIColor.lightGray
    }
    func setupUIcomponents() {
        titleLbel.text = titleName
        topView.backgroundColor = .topviewMode
        bottomView.backgroundColor = .topviewMode
        chatlistView.backgroundColor = .middleCellColor
        titleLbel.textColor = .textFieldTextColor
        textField.textColor = .textFieldTextColor
        topView.layer.masksToBounds = false
        topView.layer.shadowRadius = 4
        topView.layer.shadowOpacity = 1
        topView.layer.shadowColor = LibraryAPI.sharedInstance.isDarkMode() ?  UIColor.black.cgColor : UIColor.lightGray.cgColor
        topView.layer.shadowOffset = CGSize(width: 0 , height:2)
        bottomView.layer.masksToBounds = false
        bottomView.layer.shadowRadius = 4
        bottomView.layer.shadowOpacity = 1
        bottomView.layer.shadowColor = LibraryAPI.sharedInstance.isDarkMode() ?  UIColor.black.cgColor : UIColor.lightGray.cgColor
        bottomView.layer.shadowOffset = CGSize(width: 0 , height: -2)
        if LibraryAPI.sharedInstance.getUserImageUrl().isEmpty {
            profileImage.image = UIImage.init(named: "placeholder")
        } else {
            profileImage.setImageWithUrl(LibraryAPI.sharedInstance.getUserImageUrl())
        }
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        sendButton.isHidden = true
        setTextfieldSetup()
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        chatlistView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        configureDatabase(videoId: videoId)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            bottomView.isHidden = true
        } else {
            bottomView.isHidden = false
            self.view.endEditing(true)
        }
    }
    func configureDatabase(videoId: Int) {
        ref = Database.database().reference()
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child("messages").child("video_id_\(videoId)").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
            guard let strongSelf = self else { return }
            strongSelf.messages.append(snapshot)
            strongSelf.chatlistView.insertRows(at: [IndexPath(row: strongSelf.messages.count-1, section: 0)], with: .automatic)
            if let controller = self {
                controller.chatlistView.scrollToRow(at: IndexPath.init(row: controller.messages.count-1, section: 0), at: .bottom, animated: true)
            }
        })
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == self.chatlistView && keyPath == "contentSize" {
                if self.chatlistView.frame.height < self.chatlistView.contentSize.height {
                    self.chatlistView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
                } else {
                    let calculateHeight = self.chatlistView.frame.height - self.chatlistView.contentSize.height
                    self.chatlistView.contentInset = UIEdgeInsets(top: calculateHeight, left: 0, bottom: 0, right: 0)
                }
            }
        }
    }
    func configureStorage() {
        storageRef = Storage.storage().reference()
    }
    func configureRemoteConfig() {
        remoteConfig = RemoteConfig.remoteConfig()
        // Create Remote Config Setting to enable developer mode.
        // Fetching configs from the server is normally limited to 5 requests per hour.
        // Enabling developer mode allows many more requests to be made per hour, so developers
        // can test different config values during development.
        let remoteConfigSettings = RemoteConfigSettings(developerModeEnabled: true)
        remoteConfig.configSettings = remoteConfigSettings
    }
    func fetchConfig() {
        var expirationDuration: Double = 3600
        // If in developer mode cacheExpiration is set to 0 so each fetch will retrieve values from
        // the server.
        if self.remoteConfig.configSettings.isDeveloperModeEnabled {
            expirationDuration = 0
        }
        
        // cacheExpirationSeconds is set to cacheExpiration here, indicating that any previously
        // fetched and cached config would be considered expired because it would have been fetched
        // more than cacheExpiration seconds ago. Thus the next fetch would go to the server unless
        // throttling is in progress. The default expiration duration is 43200 (12 hours).
        remoteConfig.fetch(withExpirationDuration: expirationDuration) { [weak self] (status, error) in
            if status == .success {
                print("Config fetched!")
                guard let strongSelf = self else { return }
                strongSelf.remoteConfig.activateFetched()
                let friendlyMsgLength = strongSelf.remoteConfig["friendly_msg_length"]
                if friendlyMsgLength.source != .static {
                    strongSelf.msglength = friendlyMsgLength.numberValue!
                    print("Friendly msg length config: \(strongSelf.msglength)")
                }
            } else {
                print("Config not fetched")
                if let error = error {
                    print("Error \(error)")
                }
            }
        }
    }
    func sendMessage(withData data: [String: String]) {
        var mdata = data
        let name = LibraryAPI.sharedInstance.getUserName()
        let imagrUrl = LibraryAPI.sharedInstance.getUserImageUrl()
        mdata["name"] = name != "" ? name : "Anonymous"
        mdata["photoUrl"] = imagrUrl
        mdata["time"] = getCurrentDate()
        // Push data to Firebase Database
        self.ref.child("messages").child("video_id_\(videoId)").childByAutoId().updateChildValues(mdata)
    }
    @IBAction func sendButtonAction(_ sender: UIButton) {
        sendButton.isHidden = true
        if Connectivity.isConnectedToInternet() {
            _ = textFieldShouldReturn(textField) } else {
            self.showToastMessageTop(message: "Unable to connect internet.Please check your internet and try again.")
            textField.text = ""
            textField.placeholder = LibraryAPI.sharedInstance.getUserName().isEmpty ? "Login to Enjoy Live Chat" : "Chat as \(LibraryAPI.sharedInstance.getUserName())"
            textField.placeHolderColor = UIColor.lightGray
        }
    }
}
extension CSLiveChatTableView: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "liveChatCell") as! LIveChatTableViewCell
        cell.configureCell(with: messages[indexPath.row])
        cell.backgroundcellView.backgroundColor = .clear
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
// UITextViewDelegate protocol methods
extension CSLiveChatTableView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return true }
        if text == "" || text.isEmpty || (text.trimmingCharacters(in: .whitespaces).isEmpty) {
            self.showToastMessageTop(message: "Comment should not be empty") } else {
            textField.text = ""
            view.endEditing(true)
            let data = ["text": text]
            sendMessage(withData: data) }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        registerKeyboardNotifications()
        if !UIApplication.isUserLoginInApplication() {
            self.showToastMessageTop(message: "Please login to continue")
            if UIDevice.current.orientation.isLandscape {
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation") }
            let login = mainStoryBoard.instantiateViewController(withIdentifier:
                "CSLoginViewController") as? CSLoginViewController
            self.navigationController?.pushViewController(login!, animated: true)
            return }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        setTextfieldSetup()
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text!.count > 0 {
            textField.placeholder = ""
            sendButton.isHidden = false
        } else {
            textField.placeholder = "Chat as \(LibraryAPI.sharedInstance.getUserName())"
            textField.placeHolderColor = UIColor.lightGray
            sendButton.isHidden = true
        }
    }
    /// Close Button Action
    @IBAction func closeAction(_ sender: UIButton) {
        self.view.endEditing(true)
        chatDelegate?.closeChat(self)
    }
    // String Extensions to get the current time
    func getCurrentDate() -> String {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let someDateTime = formatter.string(from: currentDate)
        return someDateTime
    }
}
// MARK: - Textfield Delegate
extension CSLiveChatTableView {
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector:
            #selector(CSLiveChatTableView.keyboardDidShow(notification:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector:
            #selector(CSLiveChatTableView.keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    /// Scrollview's ContentInset Change on Keyboard show
    @objc func keyboardDidShow(notification: NSNotification) {
        let userInfo: NSDictionary = (notification.userInfo as NSDictionary?)!
        let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        if let keyboard = keyboardInfo {
            let keyboardHeight = keyboard.cgRectValue.height
            bottomViewBottomConstraint.constant = keyboardHeight
        }
    }
    /// Scrollview's ContentInset Change on Keyboard hide
    @objc func keyboardWillHide(notification: NSNotification) {
        bottomViewBottomConstraint.constant = 0
        unregisterKeyboardNotifications()
    }
    /// UnRegistering Notifications
    func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }
}
