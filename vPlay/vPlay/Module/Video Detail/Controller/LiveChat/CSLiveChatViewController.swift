//
//  CSLiveChatViewController.swift
//  vPlay
//
//  Created by user on 23/08/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import IQKeyboardManagerSwift
class CSLiveChatViewController: UIViewController, UIGestureRecognizerDelegate {
    var ref: DatabaseReference!
    var messages: [DataSnapshot]! = []
    var msglength: NSNumber = 10
    fileprivate var _refHandle: DatabaseHandle?
    var storageRef: StorageReference!
    var remoteConfig: RemoteConfig!
    @IBOutlet weak var clientTable: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var profileImage: UIImageView?
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textView: UIView!
    var imageString: String?
    var observe: Bool!
    var loadobserve: Bool = false
    /// Video Id
    var videoId = Int()
    @IBOutlet weak private var bottomViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableviewBottomConstraint: NSLayoutConstraint!
    //Delegate
    weak var delegate = BMPlayerCustomControlView()
    override func viewDidLoad() {
        super.viewDidLoad()
        videoId = LibraryAPI.sharedInstance.getVideoId()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        observe = false
        tapGesture.delegate = self
        textView.addGestureRecognizer(tapGesture)
        clientTable.addGestureRecognizer(tapGesture)
        //configureDatabase(videoId: videoId)
        setupUIcomponents()
        configureStorage()
        configureRemoteConfig()
        fetchConfig()
    }
    func scrolltoBottom() {
        if messages.count > 0 {
            self.clientTable.scrollToRow(at: IndexPath.init(row: self.messages.count-1, section: 0), at: .bottom, animated: true)
        }
    }
    func setupUIcomponents() {
        print(LibraryAPI.sharedInstance.getUserImageUrl())
        if LibraryAPI.sharedInstance.getUserImageUrl().isEmpty {
            profileImage?.image = UIImage.init(named: "placeholder")
        } else {
            profileImage?.setImageWithUrl(LibraryAPI.sharedInstance.getUserImageUrl())
        }
        profileImage?.layer.cornerRadius = (profileImage?.frame.size.width)! / 2
        profileImage?.clipsToBounds = true
        sendButton.isHidden = true
        textView.backgroundColor = UIColor.black
        setTextfieldSetup()
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        clientTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    func setTextfieldSetup() {
        textField.placeholder = LibraryAPI.sharedInstance.getUserName().isEmpty ? "Login to Enjoy Live Chat" : "Chat as \(LibraryAPI.sharedInstance.getUserName())"
        textField.placeHolderColor = UIColor.lightGray
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            scrolltoBottom()
        } else {
            self.view.endEditing(true)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        scrolltoBottom()
    }
    override func viewWillDisappear(_ animated: Bool) {
        unregisterKeyboardNotifications()
        self.ref.removeAllObservers()
        self.view.endEditing(true)
        textField.text = ""
        self.loadobserve = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configureDatabase(videoId: videoId)
    }
    func configureDatabase(videoId: Int) {
        ref = Database.database().reference()
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child("messages").child("video_id_\(videoId)").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
            guard let strongSelf = self else { return }
            if self?.observe == false {
            strongSelf.messages.append(snapshot)
            strongSelf.clientTable.insertRows(at: [IndexPath(row: strongSelf.messages.count-1, section: 0)], with: .automatic)
            if let controller = self {
                controller.clientTable.scrollToRow(at: IndexPath.init(row: controller.messages.count-1, section: 0), at: .bottom, animated: true)
                } }
            if self?.loadobserve == true {
                self?.observe = true }
        })
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == self.clientTable && keyPath == "contentSize" {
                if self.clientTable.frame.height < self.clientTable.contentSize.height {
                    self.clientTable.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
                } else {
                    let calculateHeight = self.clientTable.frame.height - self.clientTable.contentSize.height
                    self.clientTable.contentInset = UIEdgeInsets(top: calculateHeight, left: 0, bottom: 0, right: 0)
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
            setTextfieldSetup()
        }
    }
}
extension CSLiveChatViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "liveChatCell") as! LIveChatTableViewCell
        cell.configureCell(with: messages[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
}
extension CSLiveChatViewController: UITextFieldDelegate {
    // UITextViewDelegate protocol methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
        if text == "" || text.isEmpty || (text.trimmingCharacters(in: .whitespaces).isEmpty) {
            self.showToastMessageTop(message: "Comment should not be empty") } else {
            textField.text = ""
            view.endEditing(true)
            let data = ["text": text]
            sendMessage(withData: data)
            observe = false
            loadobserve = true
            } }
        return false
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
             }
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
extension CSLiveChatViewController {
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector:
            #selector(CSLiveChatViewController.keyboardDidShow(notification:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector:
            #selector(CSLiveChatViewController.keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    /// Scrollview's ContentInset Change on Keyboard show
    @objc func keyboardDidShow(notification: NSNotification) {
        let userInfo: NSDictionary = (notification.userInfo as NSDictionary?)!
        let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        if let keyboard = keyboardInfo {
            let keyboardHeight = keyboard.cgRectValue.size.height
         bottomViewBottomConstraint.constant = keyboardHeight
         tableviewBottomConstraint.constant = keyboardHeight + 70
        }
    }
    /// Scrollview's ContentInset Change on Keyboard hide
    @objc func keyboardWillHide(notification: NSNotification) {
        bottomViewBottomConstraint.constant = 5
        tableviewBottomConstraint.constant = 75
        unregisterKeyboardNotifications()
    }
    /// UnRegistering Notifications
    func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func handleTap() {
        self.view.endEditing(true)
    }
}
