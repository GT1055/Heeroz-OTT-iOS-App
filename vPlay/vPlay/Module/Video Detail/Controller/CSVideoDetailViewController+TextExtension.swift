/*
 * CSVideoDetailViewController+TextExtension.swift
 * This is a extenstion class for video Detail page which contain Player
 * method and Private method or user Definied Method
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit

// MARK: - Read More And Read Less label
extension CSVideoDetailViewController {
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
// MARK: - Text View Delegate
extension CSVideoDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        tapgesture.isEnabled = true
        registerKeyboardNotifications()
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if !UIApplication.isUserLoginInApplication() {
            self.playerView.pause()
            self.addLoginCloseIfUserNotLogin(self)
            return false
        }
        commentPlaceHolder.isHidden = true
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        tapgesture.isEnabled = false
         changePlaceHolderPostion()
        unregisterKeyboardNotifications()
    }
    func textViewDidChange(_ textView: UITextView) {
        var newFrame = textView.frame
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        heightConstantTextField.constant = newFrame.size.height
        
        if (isLive == false)
        {
            DispatchQueue.main.async {
                self.scrollView.scrollRectToVisible((self.profileImage.superview?.frame)!,
                                                    animated: true)
            }
        }
    }
}
// MARK: - Private Methods
extension CSVideoDetailViewController: CSTextViewDelegate {
    /// Register Notification
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector:
            #selector(CSVideoDetailViewController.keyboardDidShow(notification:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector:
            #selector(CSVideoDetailViewController.keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    /// Scrollview's ContentInset Change on Keyboard show
    @objc func keyboardDidShow(notification: NSNotification) {
        if LibraryAPI.sharedInstance.currentController is CSReplyCommentViewController {
            return
        }
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        let keyboardSize = keyboardInfo?.cgRectValue.size
        if isLive {
        } else {
            self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: (keyboardSize?.height)!, right: 0)
            DispatchQueue.main.async {
                self.scrollView.scrollRectToVisible((self.profileImage.superview?.frame)!,
                                                    animated: true)
            }
        }
    }
    /// Scrollview's ContentInset Change on Keyboard hide
    @objc func keyboardWillHide(notification: NSNotification) {
        if LibraryAPI.sharedInstance.currentController is CSReplyCommentViewController {
            return
        }
        if isLive {
        } else {
            self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) }
    }
    /// UnRegistering Notifications
    func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    func changePlaceHolderPostion() {
        if commentTextView.text.isEmpty {
            commentPlaceHolder.isHidden = false
        } else {
            commentPlaceHolder.isHidden = true
        }
    }
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        return true
    }
}
