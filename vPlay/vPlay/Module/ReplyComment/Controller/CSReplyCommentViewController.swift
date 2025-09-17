/*
 * CSReplyCommentViewController.swift
 * This View Controller is used to display all Reply Comment
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import UIKit

protocol CSReplyCommentDelegate: class {
    func closeCommentView(_ controller: UIViewController)
    func replyCommentAddedView(_ replyCommentCount: Int, commentTime: String, commentId: String)
}
class CSReplyCommentViewController: CSParentViewController {
    /// Reply Table View
    @IBOutlet var replyTableView: UITableView!
    /// Reply Table View
    @IBOutlet var replyTableViewHeightConstant: NSLayoutConstraint!
    /// Reply Scroll Table View
    @IBOutlet var replyScroll: UIScrollView!
    /// Comment Table For Reply View
    @IBOutlet var commentTableDataSource: CSCommentTableDataSource!
    /// Comment Place Holder
    @IBOutlet var commentPlaceHolder: UILabel!
    /// Comment Time
    @IBOutlet var commentTime: UILabel!
    /// Commented Label Text
    @IBOutlet var commentLabel: UILabel!
    /// Commented View
    @IBOutlet var commentView: UIView!
    ///  Current User Image
    @IBOutlet var currentUser: UIImageView!
    ///  Comment Image 
    @IBOutlet var commentImage: UIImageView!
    /// Commented Name Text
    @IBOutlet var commentName: UILabel!
    /// Comment Text View
    @IBOutlet var commentTextView: CSDoneTextView!
    /// Reply label
    @IBOutlet weak var replyLabel: UILabel!
    /// Reply Header
    @IBOutlet weak var replyHeader: UIView!
    /// User comment view
    @IBOutlet weak var userCommentView: UIView!
    /// Comment section
    @IBOutlet weak var commentSection: UIView!
    /// close imageview
    @IBOutlet var closeImage: UIImageView!
    /// Text Field View height Constant
    @IBOutlet var heightConstantTextField: NSLayoutConstraint!
    /// Pull to refresh declaration
    fileprivate var refreshManager: PullToRefreshManager!
    /// Pagination manger declaration
    fileprivate var paginatioManager: PaginationManager!
    /// Comment Data
    var commentData: CommentsList!
    /// Reply Delegate
    weak var replyDelegate: CSReplyCommentDelegate?
    // current video detail
    var currentPage = Int()
    // last Page
    var lastPage = Int()
    /// Reply Comment List
    var replyCommentList = [CommentsList]()
    /// Video Id
    var videoId = Int()
    /// Like To PLayBack
    var tableContentSize: NSKeyValueObservation?
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindDataComment()
        addGradientBackGround()
        setDarkModeNeeds()
        registerRefreshIndicator()
        callApi()
        commentTextView.textDelegate = self
        tableContentSize = replyTableView.observe(
            \UITableView.contentSize,
            options: [.new],
            changeHandler: { _, value  in
                if let contentSize = value.newValue {
                    self.replyTableViewHeightConstant.constant = contentSize.height
                }
        })
    }
    deinit {
        tableContentSize?.invalidate()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func callApi() {
        currentPage = 1
        replyCommentList = [CommentsList]()
        fetchReplyCommentApi()
    }
}
// MARK: - Button Action
extension CSReplyCommentViewController {
    /// Post Reply Comment Action
    @IBAction func postReplyAction(_ sender: UIButton) {
        // self.view.endEditing(true)
        commentTextView.resignFirstResponder()
        if (commentTextView.text?.isEmpty)! {
            self.showToastMessageTop(message: NSLocalizedString("Please write a reply to post",
                                                                comment: "Video Detail"))
            return
        }
        addReplyCommentApi(sender)
    }
    /// Close Button Action
    @IBAction func closeAction(_ sender: UIButton) {
        self.view.endEditing(true)
        replyDelegate?.closeCommentView(self)
    }
    /// Season Button Action
    @IBAction func deleteCommentSender(_ sender: UIButton) {
        self.deleteComment(sender)
    }
}
// MARK: - Private Method
extension CSReplyCommentViewController {
    // Bind Data Comment
    func bindDataComment() {
        currentUser.setProfileImageWithUrl(LibraryAPI.sharedInstance.getUserImageUrl())
        commentLabel.text = commentData.commentComments
        commentTime.text = commentData.commentCreatedAt
        if commentData.commentUserType == "admin" {
            self.setVplayImage("Heeroz")
        } else {
            if let customer = commentData.commentCustomer {
                commentName.text = customer.customerName.capitalizingFirstLetter()
                commentImage.setProfileImageWithUrl(customer.customerProfilePicture)
            } else {
                self.setVplayImage("Heeroz User")
            }
        }
    }
    /// vplay Image
    func setVplayImage(_ text: String) {
        commentName.text = NSLocalizedString(text, comment: "Comment").capitalizingFirstLetter()
        commentImage.image = #imageLiteral(resourceName: "placeholder")
    }
    // register Refresh controller adding
    func registerRefreshIndicator() {
        // If you want to use Pull To Refresh
        self.refreshManager = PullToRefreshManager(scrollView: self.replyScroll, delegate: self)
        self.refreshManager.updateActivityIndicatorStyle(.white)
        self.refreshManager.updateActivityIndicatorColor(UIColor.invertColor(true))
        // If you want to use Pagination
        self.paginatioManager = PaginationManager(scrollView: self.replyScroll, delegate: self)
        self.paginatioManager.updateActivityIndicatorColor(UIColor.invertColor(true))
    }
    /// Reload Data
    func reloadData() {
        commentTableDataSource.commentList = self.replyCommentList
        replyTableView.reloadData()
        replyTableView.layoutIfNeeded()
    }
    // Set Dark Mode 
    func setDarkModeNeeds() {
        commentName.textColor = .commenterNameColor
        replyLabel.textColor = .labelTextColor
        commentLabel.textColor = .commentDescriptionColor
        commentView.backgroundColor = .navigationBarColor
        commentTextView.textColor = .textFieldTextColor
        commentPlaceHolder.textColor = UIColor.disabledTextFieldTextColor
        closeImage.tintColor = UIColor.invertColor(true)
        userCommentView.backgroundColor = .navigationBarColor
    }
    // Colour For Label
    func setColorForLabel(_ arrayOfLabel: [UILabel]) {
        for currentLabel in arrayOfLabel {
            currentLabel.textColor = UIColor.white
        }
    }
}
// MARK: - Api Call
extension CSReplyCommentViewController {
    /// Fetch Reply Comment List
    func fetchReplyCommentApi() {
        let parameter = ["page": String(self.currentPage)]
        CSVideoDetailApiModel.addedReplyComment(
            parentView: self,
            parameters: parameter,
            commentId: commentData.commentId,
            isPageDisable: currentPage.checkPageNeed(),
            completionHandler: { responce in
                self.lastPage = responce.replyResponse.replyList.replyPage.commentLastPage
                self.currentPage = responce.replyResponse.replyList.replyPage.commentCurrentPage
                self.replyCommentList += responce.replyResponse.replyList.replyPage.commentDetailArray
                if self.replyDelegate != nil {
                self.replyDelegate?.replyCommentAddedView(
                    responce.replyResponse.replyList.replyPage.commentTotal,
                    commentTime: responce.replyResponse.replyList.createDate,
                    commentId: self.commentData.commentId)
                }
                self.commentTime.text = responce.replyResponse.replyList.createDate
                self.reloadData()
        })
    }
    // Add Reply Comment for api
    func addReplyCommentApi(_ sender: UIButton) {
        let paramet: [String: String] = ["video_id": String(videoId),
                                         "parent_id": commentData.commentId,
                                         "comment": commentTextView.text!]
        CSVideoDetailApiModel.viewAllCommentToVideo(
            parentView: self, parameters: paramet,
            isPageDisable: currentPage.checkPageNeed(),
            button: sender,
            completionHandler: { _ in
                self.commentTextView.text! = ""
                self.changePlaceHolderPostion()
                self.heightConstantTextField.constant = 30
                self.callApi()
        })
    }
    func deleteComment(_ sender: UIButton) {
        if self.replyCommentList.count < 1 { return }
        CSVideoDetailApiModel.deleteCommentAction(
            parentView: sender, commentId: self.replyCommentList[sender.tag].commentId,
            completionHandler: { [unowned self] _ in
                self.callApi()
        })
    }
}
// MARK: - Pull to Refresh
extension CSReplyCommentViewController: PullToRefreshManagerDelegate {
    /// Pull to refresh Manager start Method
    public func pullToRefreshManagerDidStartLoading(_ controller: PullToRefreshManager,
                                                    onCompletion: @escaping () -> Void) {
        let delayTime = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: delayTime) { () -> Void in
            onCompletion()
            self.callApi()
        }
    }
}
// MARK: - vertical pagenation for
extension CSReplyCommentViewController: PaginationManagerDelegate {
    /// Pagiantion Manager start loading
    public func paginationManagerDidStartLoading(_ controller: PaginationManager,
                                                 onCompletion: @escaping () -> Void) {
        let delayTime = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: delayTime) { () -> Void in
            onCompletion()
            self.fetchReplyCommentApi()
        }
    }
    /// Check is Pagination Needed
    public func paginationManagerShouldStartLoading(_ controller: PaginationManager) -> Bool {
        currentPage += 1
        if currentPage > self.lastPage {
            return false
        }
        return true
    }
}
// MARK: - Text View Delegate
extension CSReplyCommentViewController: UITextViewDelegate, CSTextViewDelegate {
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        registerKeyboardNotifications()
        if !UIApplication.isUserLoginInApplication() {
            self.view.endEditing(true)
            self.addLoginCloseIfUserNotLogin(self)
            return
        }
        if self.parent is CSVideoDetailViewController {
            let controller = self.parent as? CSVideoDetailViewController
            controller?.tapgesture.isEnabled = true
        }
        commentPlaceHolder.isHidden = true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.parent is CSVideoDetailViewController {
            let controller = self.parent as? CSVideoDetailViewController
            controller?.tapgesture.isEnabled = false
        }
        changePlaceHolderPostion()
        unregisterKeyboardNotifications()
    }
    func textViewDidChange(_ textView: UITextView) {
        var newFrame = textView.frame
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        heightConstantTextField.constant = newFrame.size.height
    }
}
// MARK: - Private Methods
extension CSReplyCommentViewController {
    /// Register Notification
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(CSReplyCommentViewController.keyboardDidShow(notification:)),
            name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(CSReplyCommentViewController.keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    /// Scrollview's ContentInset Change on Keyboard show
    @objc func keyboardDidShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        let keyboardSize = keyboardInfo?.cgRectValue.size
        self.replyScroll.contentInset = UIEdgeInsets(top: 0, left: 0,
                                                     bottom: (keyboardSize?.height)!, right: 0)
        DispatchQueue.main.async {
            self.replyScroll.scrollRectToVisible((self.currentUser.superview?.frame)!,
                                                 animated: true)
        }
    }
    /// Scrollview's ContentInset Change on Keyboard hide
    @objc func keyboardWillHide(notification: NSNotification) {
        self.replyScroll.contentInset = UIEdgeInsets(top: 0, left: 0,
                                                     bottom: 0, right: 0)
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
}
