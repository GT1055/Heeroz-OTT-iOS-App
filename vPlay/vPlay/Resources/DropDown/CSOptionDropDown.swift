/*
 * CSOptionDropDown.swift
 * This class  is used To Create A menu Drop Down
 * @category   Vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2018 Contus. All rights reserved.
 */

import UIKit
import DropDown
class CSOptionDropDown: NSObject {
    /// Drop Down Menu Creation
    class func dropDownMenu(dropDown: DropDown! = DropDown.init(),
                            popUpButton: AnyObject,
                            controller: AnyObject,
                            parametr: [String: String]) {
        let addtoPlaylist = NSLocalizedString("Add to playlist", comment: "Add to playlist")
        let share = NSLocalizedString("Share", comment: "Share")
        let dataSource = [addtoPlaylist, share]
        let data = CSSharedObject.init(videoId: parametr["videoId"]!,
                                       videoSlug: parametr["videoSlug"]!,
                                       thumbNail: parametr["videoImage"]!,
                                       videoTitle: parametr["videoTitle"]!,
                                       videoDescription: parametr["videoDescription"]!)
        let parentController = controller as? CSParentViewController
        let dropDownButton = popUpButton as? UIButton
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = dataSource
        // Top of drop down will be below the anchorView
        dropDown.direction = .top
        // When drop down is displayed with `Direction.top`, it will be above the anchorView
        // dropDown.topOffset = CGPoint(x: 0, y: 60.0)
        /// Dismiss on Tab
        dropDown.dismissMode = .onTap
        dropDown.backgroundColor = .white
        dropDown.cellHeight = 35
        // The view to which the drop down will appear on
        dropDown.anchorView = dropDownButton
        /// Show Drop Down
        dropDown.show()
        // Action triggered on selection
        dropDown.selectionAction = {(index: Int, item: String) in
            dropDown.hide()
            if index == 0 {
                if !UIApplication.isUserLoginInApplication() {
                    parentController?.addLoginCloseIfUserNotLogin(parentController!)
                    return
                }
                let addPlaylist = playListAndLatestStoryBoard.instantiateViewController(
                    withIdentifier: "CSAddToPlaylistViewController") as? CSAddToPlaylistViewController
                addPlaylist?.videoId = Int(parametr["videoId"]!)!
                addPlaylist?.modalPresentationStyle = .overCurrentContext
                addPlaylist?.modalTransitionStyle = .crossDissolve
                parentController?.navigationController?.present(addPlaylist!, animated: true, completion: nil)
            } else {
                parentController?.deepLinkShare(data, sender: dropDownButton ?? UIButton())
            }
        }
        // Will set a custom width instead of the anchor view width
        dropDown.width = 130
    }
    /// Myfavourites Dropdown Menu
    class func myFavouriteDropDownMenu(dropDown: DropDown! = DropDown.init(),
                                       popUpButton: AnyObject,
                                       controller: AnyObject,
                                       parametr: [String: String]) {
        let addtoPlaylist = NSLocalizedString("Add to playlist", comment: "Add to playlist")
        let unfavourite = NSLocalizedString("Unfavourite", comment: "Unfavourite")
        let share = NSLocalizedString("Share", comment: "Share")
        let dataSource = [addtoPlaylist, unfavourite, share]
        let data = CSSharedObject.init(videoId: parametr["videoId"]!,
                                       videoSlug: parametr["videoSlug"]!,
                                       thumbNail: parametr["videoImage"]!,
                                       videoTitle: parametr["videoTitle"]!,
                                       videoDescription: parametr["videoDescription"]!)
        let parentController = controller as? CSParentViewController
        let dropDownButton = popUpButton as? UIButton
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = dataSource
        // Top of drop down will be below the anchorView
        dropDown.direction = .top
        // When drop down is displayed with `Direction.top`, it will be above the anchorView
        // dropDown.topOffset = CGPoint(x: 0, y: 60.0)
        /// Dismiss on Tab
        dropDown.dismissMode = .onTap
        dropDown.backgroundColor = .white
        dropDown.cellHeight = 35
        // The view to which the drop down will appear on
        dropDown.anchorView = dropDownButton
        /// Show Drop Down
        dropDown.show()
        // Action triggered on selection
        dropDown.selectionAction = {(index: Int, item: String) in
            dropDown.hide()
            if index == 0 {
                if !UIApplication.isUserLoginInApplication() {
                    parentController?.addLoginCloseIfUserNotLogin(parentController!)
                    return
                }
                let addPlaylist = playListAndLatestStoryBoard.instantiateViewController(
                    withIdentifier: "CSAddToPlaylistViewController") as? CSAddToPlaylistViewController
                addPlaylist?.videoId = Int(parametr["videoId"]!)!
                addPlaylist?.modalPresentationStyle = .overCurrentContext
                addPlaylist?.modalTransitionStyle = .crossDissolve
                parentController?.navigationController?.present(addPlaylist!, animated: true, completion: nil)
            } else if index == 1 {
                let favController = parentController as? CSFavoutritesViewController
                favController?.removeFromFavouriteVideo(videoId: data.videoId)
                // unfavourite section
            } else {
                parentController?.deepLinkShare(data, sender: dropDownButton ?? UIButton())
            }
        }
        // Will set a custom width instead of the anchor view width
        dropDown.width = 130
    }
    /// Drop Down Menu Creation
    class func playlistDropdown(dropDown: DropDown! = DropDown.init(),
                                popUpButton: AnyObject,
                                controller: AnyObject,
                                parametr: [String: String]) {
        let dataSource = [NSLocalizedString("Delete Playlist", comment: "Delete Playlist"),
                          NSLocalizedString("Edit Title", comment: "Edit Title")]
        let parentController = controller as? CSSavedPlaylistViewController
        let dropDownButton = popUpButton as? UIButton
        // Top of drop down will be below the anchorView
        dropDown.direction = .any
        // When drop down is displayed with `Direction.top`, it will be above the anchorView
        // dropDown.topOffset = CGPoint(x: 0, y: 60.0)
        /// Dismiss on Tab
        dropDown.dismissMode = .onTap
        dropDown.backgroundColor = .white
        dropDown.cellHeight = 35
        // The view to which the drop down will appear on
        dropDown.anchorView = dropDownButton
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = dataSource
        dropDown.show()
        // Action triggered on selection
        dropDown.selectionAction = {(index: Int, item: String) in
            dropDown.hide()
            if !UIApplication.isUserLoginInApplication() {
                parentController!.addLoginCloseIfUserNotLogin(parentController!)
                return
            }
            if index == 0 {
                parentController?.removePlaylist((dropDownButton?.tag)!)
            } else {
                parentController?.performSegue(withIdentifier: "CSModifyPlaylistViewController",
                                               sender: dropDownButton?.tag)
            }
        }
        // Will set a custom width instead of the anchor view width
        dropDown.width = 130
    }
    /// Drop Down Menu Creation
    class func playlistVideoDropdown(dropDown: DropDown! = DropDown.init(),
                                     popUpButton: AnyObject,
                                     controller: AnyObject,
                                     parametr: [String: String]) {
        let dataSource = [NSLocalizedString("Remove from playlist", comment: "Remove from playlist"),
                          NSLocalizedString("Share", comment: "Share")]
        let parentController = controller as? CSPlaylistVideoListViewController
        let data = CSSharedObject.init(videoId: parametr["videoId"]!,
                                       videoSlug: parametr["videoSlug"]!,
                                       thumbNail: parametr["videoImage"]!,
                                       videoTitle: parametr["videoTitle"]!,
                                       videoDescription: parametr["videoDescription"]!)
        let dropDownButton = popUpButton as? UIButton
        // Top of drop down will be below the anchorView
        dropDown.direction = .any
        // When drop down is displayed with `Direction.top`, it will be above the anchorView
        // dropDown.topOffset = CGPoint(x: 0, y: 60.0)
        /// Dismiss on Tab
        dropDown.dismissMode = .onTap
        dropDown.backgroundColor = .white
        dropDown.cellHeight = 35
        // The view to which the drop down will appear on
        dropDown.anchorView = dropDownButton
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = dataSource
        dropDown.show()
        // Action triggered on selection
        dropDown.selectionAction = {(index: Int, item: String) in
            dropDown.hide()
            if index == 1 {
                parentController?.deepLinkShare(data, sender: dropDownButton ?? UIButton())
            } else {
                if !UIApplication.isUserLoginInApplication() {
                    parentController!.addLoginCloseIfUserNotLogin(parentController!)
                    return
                }
                parentController?.deletePlayListVideoApi((dropDownButton?.tag)!)
            }
        }
        // Will set a custom width instead of the anchor view width
        dropDown.width = 165
    }
}
extension CSOptionDropDown {
    /// Drop Down Menu Creation
    class func notificationDropdown(dropDown: DropDown! = DropDown.init(),
                                    popUpButton: AnyObject,
                                    completionHandler: @escaping(_ responce: Int) -> Void) {
        let dataSource = [NSLocalizedString("Remove Notification", comment: "Delete Notification")]
        let dropDownButton = popUpButton as? UIButton
        // Top of drop down will be below the anchorView
        dropDown.direction = .any
        // When drop down is displayed with `Direction.top`, it will be above the anchorView
        dropDown.topOffset = CGPoint(x: 10, y: 60.0)
        /// Dismiss on Tab
        dropDown.dismissMode = .onTap
        dropDown.backgroundColor = .white
        dropDown.cellHeight = 35
        // The view to which the drop down will appear on
        dropDown.anchorView = dropDownButton
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = dataSource
        dropDown.show()
        // Action triggered on selection
        dropDown.selectionAction = {(index: Int, item: String) in
            dropDown.hide()
            completionHandler(index)
        }
        // Will set a custom width instead of the anchor view width
        dropDown.width = 155
    }
    /// Bank Drop Down Menu Creation
    class func bankListingDropdown(dropDown: DropDown! = DropDown.init(),
                                   label: AnyObject,
                                   completionHandler: @escaping(_ responce: Int) -> Void) {
        let dataSource = [NSLocalizedString("HDFC Bank", comment: "Banking"),
                          NSLocalizedString("Axis Bank", comment: "Banking"),
                          NSLocalizedString("HSBC Bank", comment: "Banking"),
                          NSLocalizedString("SBI", comment: "Banking"),
                          NSLocalizedString("ICICI Bank", comment: "Banking")]
        let dropDownLabel = label as? UILabel
        // Top of drop down will be below the anchorView
        dropDown.direction = .bottom
        // When drop down is displayed with `Direction.top`, it will be above the anchorView
        dropDown.topOffset = CGPoint(x: 10, y: 60.0)
        /// Dismiss on Tab
        dropDown.dismissMode = .onTap
        dropDown.backgroundColor = .white
        dropDown.cellHeight = 35
        // The view to which the drop down will appear on
        dropDown.anchorView = dropDownLabel
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = dataSource
        dropDown.show()
        // Action triggered on selection
        dropDown.selectionAction = {(index: Int, item: String) in
            dropDown.hide()
            dropDownLabel?.text = dataSource[index]
            completionHandler(index)
        }
        // Will set a custom width instead of the anchor view width
        dropDown.width = dropDownLabel?.frame.size.width
    }
    /// Season Drop Down List Creation
    class func seasonDropdown(dropDown: DropDown! = DropDown.init(),
                              label: AnyObject,
                              dataSource: [String],
                              completionHandler: @escaping(_ responce: Int) -> Void) {
        var size = CGSize()
        let dropDownLabel = label as? UILabel
        if let max = dataSource.max(by: {$1.count > $0.count}) {
            let font: UIFont = dropDownLabel!.font
            let fontAttributes: [NSAttributedString.Key: Any]  = [.font: font]
            size = (max as NSString).size(withAttributes: fontAttributes)
        }
        // Top of drop down will be below the anchorView
        dropDown.direction = .bottom
        // When drop down is displayed with `Direction.top`, it will be above the anchorView
        dropDown.topOffset = CGPoint(x: 10, y: 60.0)
        /// Dismiss on Tab
        dropDown.dismissMode = .onTap
        dropDown.backgroundColor = .white
        dropDown.cellHeight = 35
        dropDown.textFont = UIFont.systemFont(ofSize: 11, weight: .regular)
        // The view to which the drop down will appear on
        dropDown.anchorView = dropDownLabel
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = dataSource
        dropDown.show()
        if let index = dataSource.firstIndex(where: {$0.lowercased() == (label.text).lowercased()}) {
            dropDown.selectRow(index)
        }
        dropDown.selectionBackgroundColor = .lightGray
        // Action triggered on selection
        dropDown.selectionAction = {(index: Int, item: String) in
            dropDown.hide()
            dropDownLabel?.text = dataSource[index]
            completionHandler(index)
        }
        // Will set a custom width instead of the anchor view width
        dropDown.width = size.width > 150 ? 165 : (size.width + 15)
    }
    /// langauge Drop down
    class func langaugeListingDropdown(dropDown: DropDown! = DropDown.init(),
                                       button: AnyObject,
                                       completionHandler: @escaping(_ responce: Int) -> Void) {
        let dataSource = ["English", "Punjabi"]// NSLocalizedString("Punjabi", comment: "langauge")]
        let dropDownButton = button as? UIButton
        // Top of drop down will be below the anchorView
        dropDown.direction = .bottom
        // When drop down is displayed with `Direction.top`, it will be above the anchorView
        dropDown.topOffset = CGPoint(x: 10, y: 60.0)
        /// Dismiss on Tab
        dropDown.dismissMode = .onTap
        dropDown.backgroundColor = .white
        dropDown.cellHeight = 35
        // The view to which the drop down will appear on
        dropDown.anchorView = dropDownButton
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = dataSource
        dropDown.show()
        // Action triggered on selection
        dropDown.selectionAction = {(index: Int, item: String) in
            dropDown.hide()
            dropDownButton?.setTitle(dataSource[index], for: .normal)
            dropDownButton?.titleLabel?.textAlignment = .center
            completionHandler(index)
        }
        // Will set a custom width instead of the anchor view width
        dropDown.width = dropDownButton?.frame.size.width
    }
    class func showDropDown(with data: [String], anchor: UIView,  selectionHandler: @escaping (Int, String) -> ()) {
        let dropDown = DropDown.init()
        dropDown.dataSource = data
        dropDown.anchorView = anchor
        dropDown.direction = .any
        dropDown.bottomOffset = CGPoint.init(x: 0, y: anchor.frame.height)
        dropDown.width = anchor.frame.width
        dropDown.cellHeight = 35
        dropDown.show()
        dropDown.selectionAction = { (index, item) in
            dropDown.hide()
            selectionHandler(index,item)
        }
    }
}
