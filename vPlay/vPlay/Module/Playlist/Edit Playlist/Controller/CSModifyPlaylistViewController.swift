/*
 * CSModifyPlaylistViewController.swift
 * This class is used to modfiy the playlist name
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit
protocol CSRenamePlaylist: class {
    func renamedPlaylist(playlistName: String, playlistId: String)
}
class CSModifyPlaylistViewController: CSParentViewController {
    /// UIScroll View
    @IBOutlet var scrollView: UIScrollView!
    /// Title Label
    @IBOutlet var titleLabel: UILabel!
    /// Name Label
    @IBOutlet var playlistName: UITextField!
    // playlist Video
    var playlist: CSPlayList!
    /// Delegate
    weak var delegate: CSRenamePlaylist?
    // MARK: - UIView Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        callApi()
        // Do any additional setup after loading the view.
    }
    override func callApi() {
        if LibraryAPI.sharedInstance.getUserId().isEmpty {
            self.dismiss(animated: true, completion: nil)
            return
        }
        playlistName.text = playlist.playListName
    }
    override func viewDidAppear(_ animated: Bool) {
        registerKeyboardNotifications()
    }
    override func viewDidDisappear(_ animated: Bool) {
        unregisterKeyboardNotifications()
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
// MARK: - Button Action
extension CSModifyPlaylistViewController {
    /// Cancel action of playlistName Modification
    @IBAction func cancelAction(_ sender: UIButton) {
        playlistName.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    /// Save action of playlist Modification
    @IBAction func saveAction(_ sender: UIButton) {
        if playlist.playListName == playlistName.text {
            self.showToastMessageTop(message: NSLocalizedString("Current playlist name is not change",
                                                                comment: "playlist"))
            return
        } else if !CSUserValidation.validatePlayList(textField: playlistName, viewController: self) { return }
        renamePlaylist()
    }
}
// MARK: - Delegate For Text Field Method
extension CSModifyPlaylistViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
// MARK: - Api Request
extension CSModifyPlaylistViewController {
    /// Remove From Playlist
    func renamePlaylist() {
        let paramete: [String: String] = ["name": playlistName.text!,
                                          "id": playlist.playListId]
        CSPlayListApiModel.createEditAndAddPlayListVideo(
            parentView: self,
            parameters: paramete,
            completionHandler: { _ in
                self.delegate?.renamedPlaylist(playlistName: self.playlistName.text!,
                                               playlistId: self.playlist.playListId)
                self.dismiss(animated: true, completion: nil)
        })
    }
}
// MARK: - Key board Method
extension CSModifyPlaylistViewController {
    /// Register Notification
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector:
            #selector(CSModifyPlaylistViewController.keyboardDidShow(notification:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector:
            #selector(CSModifyPlaylistViewController.keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    /// Scrollview's ContentInset Change on Keyboard show
    @objc func keyboardDidShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        let keyboardSize = keyboardInfo?.cgRectValue.size
        self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0,
                                                    bottom: (keyboardSize?.height)!, right: 0)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2, execute: {
            self.scrollView.isScrollEnabled = false
        })
    }
    /// Scrollview's ContentInset Change on Keyboard hide
    @objc func keyboardWillHide(notification: NSNotification) {
        self.scrollView.isScrollEnabled = true
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2, execute: {
            self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0,
                                                        bottom: 0, right: 0)
        })
    }
    /// UnRegistering Notifications
    func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}
