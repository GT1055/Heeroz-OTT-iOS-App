/*
 * CSCommentTableDataSource.swift
 * This is data source is used to display the comment listing section
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit
class CSCommentTableDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    /// Video Detail
    var commentList = [CommentsList]()
    /// Delegate
    weak var delegate: CSTableViewDelegate?
    /// MARK:- Table view Delegate functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VideoQ&ACell", for: indexPath)
            as? CSVideoQAndATableViewCell else { return UITableViewCell() }
        cell.bindDataComment(commentList[indexPath.row])
        cell.setDarkModeNeeds()
        if tableView.tag != 1 {
            cell.showReplyCount(commentList[indexPath.row].commentReplyComment.commentTotal)
            cell.viewReplyComment.tag = indexPath.row
            cell.replyComment.tag = indexPath.row
        }
        cell.deleteComment.tag = indexPath.row
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.tableviewDelegate(tableView, didSelectRowAt: indexPath)
    }
}
