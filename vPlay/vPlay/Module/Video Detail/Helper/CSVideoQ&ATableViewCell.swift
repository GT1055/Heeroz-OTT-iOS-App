/*
 * CSVideoQAndATableViewCell
 * This controller is used to display the video view controller view
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import UIKit

class CSVideoQAndATableViewCell: UITableViewCell {
    //Oultets
    // comment Text
    @IBOutlet var commentLabel: UILabel!
    // user Image
    @IBOutlet var cellProfileImage: UIImageView!
    // user Name
    @IBOutlet weak var cellProfileName: UILabel!
    // comment Time
    @IBOutlet weak var cellCommentsTime: UILabel!
    /// An Outlet for cell Image height
    @IBOutlet weak var viewReplyComment: UIButton!
    /// An Outlet for cell Image height
    @IBOutlet weak var replyComment: UIButton!
    /// Delete Comment Button
    @IBOutlet weak var deleteComment: UIButton!
    /// Delete Comment Constant
    @IBOutlet weak var deleteCommentConstant: NSLayoutConstraint!
    /// Comment Separator Color
    @IBOutlet weak var separatorView: UIView!
    // Bind Data Comment
    func bindDataComment(_ commentDetails: CommentsList) {
        commentLabel.text = commentDetails.commentComments
        cellCommentsTime.text = commentDetails.commentCreatedAt
        if commentDetails.commentUserType == "admin" {
            self.setVplayImage("Heeroz")
            self.showdeleteComment()
        } else {
            if let customer = commentDetails.commentCustomer {
                cellProfileName.text = customer.customerName.capitalizingFirstLetter()
                cellProfileImage.setProfileImageWithUrl(customer.customerProfilePicture)
                self.showdeleteComment(customer.customerId)
            } else {
                self.setVplayImage("Heeroz User")
                self.showdeleteComment()
            }
        }
    }
    func setDarkModeNeeds() {
        commentLabel.textColor = .commentDescriptionColor
        cellProfileName.textColor = .commenterNameColor
        separatorView.backgroundColor = .separatorColor
    }
    /// vplay Image
    func setVplayImage(_ text: String) {
        cellProfileName.text = NSLocalizedString(text, comment: "Comment").capitalizingFirstLetter()
        cellProfileImage.image = #imageLiteral(resourceName: "placeholder")
    }
    /// Show Reply Comment
    func showReplyCount(_ count: Int) {
        if count > 1 {
            let comment = NSLocalizedString("View ", comment: "Reply") + String(count) +
                NSLocalizedString(" Replies", comment: "Reply")
            viewReplyComment.setTitle(comment, for: .normal)
            replyComment.isHidden = false
        } else if count > 0 {
            let comment = NSLocalizedString("View ", comment: "Reply") + String(count) +
                NSLocalizedString(" Reply", comment: "Reply")
            viewReplyComment.setTitle(comment, for: .normal)
            replyComment.isHidden = false
        } else {
            viewReplyComment.setTitle(NSLocalizedString(" Reply", comment: "Reply"), for: .normal)
            replyComment.isHidden = true
        }
    }
    func showdeleteComment(_ customerId: Int = Int()) {
        let isShow = LibraryAPI.sharedInstance.getUserId() == String(customerId) ? false : true
        print(isShow)
        self.deleteComment.isHidden = isShow
        let height: CGFloat = LibraryAPI.sharedInstance.getUserId() == String(customerId) ? 30 : 0
        if self.deleteCommentConstant != nil {
            self.deleteCommentConstant.constant = height
        }
    }
}
