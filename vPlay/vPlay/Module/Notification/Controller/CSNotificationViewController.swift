/*
 * CSNotificationViewController.swift
 * This class is used for showing notifications list
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit
class CSNotificationViewController: CSParentViewController {
    /// Header view
    @IBOutlet weak var headerView: UIView!
    /// Title label
    @IBOutlet weak var titleLabel: UILabel!
    /// Back Button
    @IBOutlet weak var backButton: UIButton!
    // Notification Table Data
    @IBOutlet var notifiationTable: UITableView!
    /// Notification Data Sources
    @IBOutlet var notifiationDataSources: CSNotificationDataSources!
    /// Pull to refresh declaration
    fileprivate var refreshManager: PullToRefreshManager!
    /// Pagination manger declaration
    fileprivate var paginatioManager: PaginationManager!
    // is Slide Menu
    var isSlideMenu = false
    // current Page
    var currentPage = 0
    // last Page
    var lastPage = 0
    /// Notification List
    var notificationList = [CSNotificationList]()
    // MARK: - UIView Controller Life Cycle
    override func viewDidLoad() {
        controllerTitle = NSLocalizedString("Notifications", comment: "Menu")
        super.viewDidLoad()
        registerRefreshIndicator()
        LibraryAPI.sharedInstance.setUserDefaults(key: "notificationCount", value: "0")
        if !UIApplication.isUserLoginInApplication() {
            self.addLoginIfUserNotLogin(self)
        } else {
            self.callApi()
        }
    }
    override func callApi() {
        currentPage = 1
        lastPage = 1
        notificationList = [CSNotificationList]()
        showNotificationList()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setModeBasedColor()
        chanageRefreshIndicator(refreshManager)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "videoDetail" {
            let controller = segue.destination as? CSVideoDetailViewController
            controller?.videoId = (sender as? Int)!
        } else {
            let controller = segue.destination as? CSSubscriptionViewController
            controller?.controllerTitle = NSLocalizedString("Pricing", comment: "Menu")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func setModeBasedColor() {
        headerView.backgroundColor = UIColor.navigationBarColor
        backButton.tintColor = UIColor.iconColor()
        titleLabel.textColor = UIColor.contentColor()
    }
}
// MARK: - Button Action
extension CSNotificationViewController {
    // Remove all notification
    @IBAction func clearAllNotification(_ sender: UIButton) {
        clearAllNotification()
    }
    // Remove Single all notification
    @IBAction func clearSingleNotification(_ sender: UIButton) {
        CSOptionDropDown.notificationDropdown(popUpButton: sender,
                                              completionHandler: { _ in
                                                self.clearSingleNotification(sender.tag)
        })
    }
}
// MARK: - Private Method
extension CSNotificationViewController {
    /// register Refresh controller adding
    func registerRefreshIndicator() {
        self.addGradientBackGround()
        // If you want to use Pull To Refresh
        self.refreshManager = PullToRefreshManager(scrollView: self.notifiationTable, delegate: self)
        self.refreshManager.updateActivityIndicatorStyle(.white)
        self.refreshManager.updateActivityIndicatorColor(UIColor.invertColor(true))
        // If you want to use Pagination
        self.paginatioManager = PaginationManager(scrollView: self.notifiationTable, delegate: self)
        self.paginatioManager.updateActivityIndicatorColor(UIColor.invertColor(true))
    }
    // It adds the notification bar.
    func setupNavigation() {
        addGradientBackGround()
        addLeftBarButton()
        addRightBarButton()
    }
    // load Data To Notification
    func loadDataToNotification() {
        if self.notificationList.count < 1 {
            self.addChildView(identifier: "CSNoNoification", storyBoard: alertStoryBoard)
            return
        }
        notifiationDataSources.delegate = self
        notifiationDataSources.notificationList = self.notificationList
        notifiationTable.reloadData()
    }
    /// Move To Specific Page
    func moveToSpecficPage(_ index: Int) {
        if notificationList[index].notificationType == "reply_comment" ||
           notificationList[index].notificationType == "video" {
            if let video = notificationList[index].video {
                self.performSegue(withIdentifier: "videoDetail", sender: video.movieId)
            }
        } else {
            self.performSegue(withIdentifier: "Subscription", sender: nil)
        }
    }
}
// MARK: - Delgate Methods
extension CSNotificationViewController: CSTableViewDelegate {
    func tableviewDelegate(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if notifiationDataSources.notificationList[indexPath.row].isRead.isEmpty {
            self.markAsRead(indexPath)
        } else {
            self.moveToSpecficPage(indexPath.row)
        }
    }
}
// MARK: - Api Call
extension CSNotificationViewController {
    /// Show Notification List
    func showNotificationList() {
        let paramter = ["page": String(currentPage)]
        CSNotificationApiModel.listAllNotification(
            parentView: self,
            isPageing: currentPage.checkPageNeed(),
            parameter: paramter,
            completionHandler: { responce in
                self.currentPage = responce.notificationPage.currentPage
                self.lastPage = responce.notificationPage.lastPage
                self.notificationList += responce.notificationPage.notificationList
                self.loadDataToNotification()
        })
    }
    // Set notification to Read Status
    func markAsRead(_ indexPath: IndexPath) {
        CSNotificationApiModel.markAsRead(
            parentView: self, notificationId: notifiationDataSources.notificationList[indexPath.row].dataId,
            parameter: nil,
            completionHandler: { _ in
                self.notifiationDataSources.notificationList[indexPath.row].isRead = "read"
                self.notificationList[indexPath.row].isRead = "read"
                if let cell = self.notifiationTable.cellForRow(at: indexPath) as?
                    NotificationTableViewCell {
                    cell.checkReadAndUnRead("read")
                }
                self.moveToSpecficPage(indexPath.row)
        })
    }
    // Clear Single Notification
    func clearSingleNotification(_ index: Int) {
        CSNotificationApiModel.deleteSingleNotification(
            parentView: self,
            notificationId: notifiationDataSources.notificationList[index].dataId,
            parameter: nil,
            completionHandler: { _ in
                self.notifiationDataSources.notificationList.remove(at: index)
                self.notificationList.remove(at: index)
                self.loadDataToNotification()
        })
    }
    // Clear All Notification
    func clearAllNotification() {
        CSNotificationApiModel.clearAllNotification(
            parentView: self,
            parameter: nil,
            completionHandler: { _ in
                self.notifiationDataSources.notificationList = [CSNotificationList]()
                self.notificationList = [CSNotificationList]()
                self.loadDataToNotification()
        })
    }
}
// MARK: - Pull to Refresh
extension CSNotificationViewController: PullToRefreshManagerDelegate {
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
extension CSNotificationViewController: PaginationManagerDelegate {
    public func paginationManagerDidStartLoading(_ controller: PaginationManager, onCompletion: @escaping () -> Void) {
        let delayTime = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: delayTime) { () -> Void in
            onCompletion()
            self.showNotificationList()
        }
    }
    public func paginationManagerShouldStartLoading(_ controller: PaginationManager) -> Bool {
        currentPage += 1
        if currentPage > self.lastPage {
            return false
        }
        return true
    }
}
